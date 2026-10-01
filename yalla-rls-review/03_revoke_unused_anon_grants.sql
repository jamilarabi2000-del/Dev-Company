-- Finding 9 (Low, defense-in-depth): anon holds table privileges that no RLS policy
-- actually uses. RLS blocks the rows today (verified: anon reads of coupons return 0),
-- so this is not a live exposure — but an unused grant is one accidental "permissive
-- policy" away from becoming a leak. Principle of least privilege: drop the grants the
-- anon role does not need.
--
-- Scope confirmed against the live grant table. Adjust the list if the frontend's
-- anon (publishable-key) client genuinely needs any of these.
--
--   coupons            : anon has SELECT, only policy is verified-admin ALL     -> revoke
--   discount_rules     : anon has SELECT, only policy is verified-admin ALL     -> revoke
--
-- KEEP (these ARE used by anon policies — do NOT revoke):
--   search_logs   INSERT (search_insert, public)
--   seller_applications INSERT (seller_apps_insert, public)
--   analytics_events INSERT (analytics_insert_public)
--   products/sellers/categories/regions/product_* SELECT (public storefront reads)
--
-- STATUS: DRAFT — not applied. Owner approval required.

revoke select on public.coupons        from anon;
revoke select on public.discount_rules from anon;
