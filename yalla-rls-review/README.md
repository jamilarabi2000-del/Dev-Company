# Yalla — RLS security review (verification + draft fixes)

Project: Supabase `yjmpjuskgbbshrvhgmys` (Yalla). Reviewed read-only; live tests run in
rolled-back transactions. **No schema or data was changed.** All SQL here is DRAFT and
awaits the owner's approval before it is applied.

## Verdict
The RLS design is strong. Two of my earlier speculative findings were **disproved by
live testing** (role escalation is blocked; password login is rate-limited + 2FA-gated).
What remains is a small set of latent / defense-in-depth gaps.

## Live tests run (all in rolled-back transactions)
- **Role escalation (customer → admin):** attempted `UPDATE profiles SET role='admin'`
  as a customer. Result: silently reverted by `protect_profile_role`; role stayed
  `customer`. **BLOCKED.**
- **anon surface:** anon is denied at the GRANT level (before RLS) on carts, orders,
  order_items, user_addresses, phone_registry, profiles, admin_activities,
  product_private, inventory_ledger, notifications, wishlists. Only storefront tables
  readable. **GOOD.**
- **Customer isolation:** customer A sees 1 profile (own), 0 foreign carts/wishlists/
  phones, 0 admin_activities, 0 product_private, 0 inventory_ledger. **GOOD.**
- **app_settings public read:** only the 2 whitelisted keys exist/are exposed. **GOOD.**

## Draft migrations in this folder
| File | Finding | Severity | Live today? |
|------|---------|----------|-------------|
| `01_order_events_immutable.sql` | order_events audit trail mutable by orders.manage holders | Medium | latent (0 rows) |
| `02_product_seo_published_only.sql` | product_seo public read leaks unpublished products' SEO | Low–Med | latent (0 rows) |
| `03_revoke_unused_anon_grants.sql` | anon has unused SELECT grants on coupons/discount_rules | Low | not exposed (RLS blocks) |

## Needs an owner decision (no migration written — confirm intent first)
- **Step-up (MFA) applies to the `admin` role only.** A non-admin holding
  `orders.manage` / `inventory.manage` / `notifications.manage` / `analytics.view` /
  `products.manage` is never asked for the 30-min TOTP step-up. No such accounts exist
  today. Decide whether privileged non-admins should also require step-up.
- **Sellers can read full orders** (incl. buyer shipping address + co-sellers' line
  context) for any order containing one of their products. Writes are well-contained by
  `protect_order_integrity` (forward-only status, no financial/PII edits). Decide whether
  sellers should see buyer PII or a redacted fulfilment view.

## Not a code change (Auth dashboard)
- Enable leaked-password protection (HaveIBeenPwned) in Auth settings.

## Residual low / informational
- `verify_login_password` returns distinct `no_account` vs `wrong` → account-enumeration
  oracle, but rate-limited (5/email/15min, 20/email/day, 30/caller/15min, advisory locks).
- `is_phone_available` allows phone enumeration, but is itself rate-limited (10/caller/
  10min, 200 global). Acceptable.
- Two SECURITY DEFINER funcs use `search_path=public, private` instead of `''`
  (`validate_publish_requirements`, `checkout_create_order`). Low; prefer `''`.
