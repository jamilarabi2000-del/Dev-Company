-- Finding (downgraded to LOW, defense-in-depth): order_events audit trail.
-- Re-verified 2026-10: `authenticated` holds ONLY SELECT on order_events, so the
-- `order_events_admin` ALL policy cannot be used for UPDATE/DELETE from the API today.
-- Risk is latent: a future GRANT, or a SECURITY DEFINER function, could rewrite history.
--
-- REVISION NOTE: the first draft of this file (commit d8e38fd) would BREAK
-- admin_delete_order(): order_events.order_id is ON DELETE CASCADE, and the cascaded
-- delete runs with the admin's JWT, so `auth.uid() is null` is false and the trigger
-- raised. Likewise auth.users deletion does ON DELETE SET NULL on actor_id.
-- This version allows exactly those two FK side effects and nothing else.
--
-- STATUS: DRAFT, not applied. Owner approval required. Run the rolled-back test at
-- the bottom on a branch/staging DB before applying.

-- 1) Narrow the policy to what the API actually needs (read only).
drop policy if exists order_events_admin on public.order_events;
create policy order_events_admin_read on public.order_events
  for select to authenticated
  using ((select private.has_permission('orders.manage')));

-- 2) Append-only trigger, cascade-safe.
create or replace function private.prevent_order_event_mutation()
  returns trigger
  language plpgsql
  security definer
  set search_path to ''
as $$
begin
  -- Trusted server/migration writes have no end-user JWT.
  if (select auth.uid()) is null then
    return case when tg_op = 'DELETE' then old else new end;
  end if;

  -- FK cascade from deleting the parent order (admin_delete_order): parent is gone.
  if tg_op = 'DELETE'
     and not exists (select 1 from public.orders o where o.id = old.order_id) then
    return old;
  end if;

  -- FK ON DELETE SET NULL from auth.users: only actor_id changes, to NULL.
  if tg_op = 'UPDATE'
     and old.actor_id is not null and new.actor_id is null
     and (new.id, new.order_id, new.from_status, new.to_status, new.note,
          new.metadata, new.created_at, new.provider_event_id)
         is not distinct from
         (old.id, old.order_id, old.from_status, old.to_status, old.note,
          old.metadata, old.created_at, old.provider_event_id) then
    return new;
  end if;

  raise exception 'ORDER_EVENT_IMMUTABLE' using errcode = 'P0001';
end;
$$;

revoke all on function private.prevent_order_event_mutation() from public, anon, authenticated;

drop trigger if exists trg_order_events_immutable_update on public.order_events;
drop trigger if exists trg_order_events_immutable_delete on public.order_events;

create trigger trg_order_events_immutable_update
  before update on public.order_events
  for each row execute function private.prevent_order_event_mutation();

create trigger trg_order_events_immutable_delete
  before delete on public.order_events
  for each row execute function private.prevent_order_event_mutation();

-- Rolled-back acceptance test (run on staging/branch; needs one email-confirmed user):
--   begin;
--   select set_config('request.jwt.claims', json_build_object('sub',
--          (select id from auth.users where email_confirmed_at is not null limit 1),
--          'role','authenticated')::text, true);
--   select set_config('yalla.checkout_order_id','t-key', true);
--   insert into public.orders(user_id, payment_method, idempotency_key)
--     values ((select auth.uid()), (enum_range(null::public.payment_method))[1], 't-key')
--     returning id;                                   -- creates 1 order_event via trigger
--   update public.order_events set note='x';          -- EXPECT: ORDER_EVENT_IMMUTABLE
--   delete from public.orders where idempotency_key='t-key';  -- EXPECT: succeeds
--   rollback;
