-- Finding 4 (Medium): order_events audit trail is mutable by orders.manage holders.
-- order_events has an ALL policy for private.has_permission('orders.manage') and NO
-- immutability trigger, unlike admin_activities and inventory_ledger. A compromised
-- or malicious operations account could rewrite or delete the order audit trail.
--
-- Fix: make order_events append-only for any end-user/API session (JWT present),
-- mirroring private.prevent_admin_audit_mutation on admin_activities. INSERTs from
-- the record_order_event() trigger are unaffected; only UPDATE/DELETE are blocked.
-- Server/service-role writes (no JWT) are left alone for maintenance.
--
-- STATUS: DRAFT — not applied. Owner approval required.

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
  raise exception 'ORDER_EVENT_IMMUTABLE' using errcode = 'P0001';
end;
$$;

drop trigger if exists trg_order_events_immutable_update on public.order_events;
drop trigger if exists trg_order_events_immutable_delete on public.order_events;

create trigger trg_order_events_immutable_update
  before update on public.order_events
  for each row execute function private.prevent_order_event_mutation();

create trigger trg_order_events_immutable_delete
  before delete on public.order_events
  for each row execute function private.prevent_order_event_mutation();
