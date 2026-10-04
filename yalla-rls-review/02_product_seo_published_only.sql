-- Finding (Low/Medium, latent): product_seo public-read policy is only `(noindex = false)`,
-- so SEO copy for draft/unpublished products would be readable by anon once rows exist.
-- (Table is empty today.) Clients hold SELECT only on product_seo; writes are server-side.
--
-- Validated 2026-10: product_seo.product_id -> products(id) ON DELETE CASCADE exists;
-- anon/authenticated have column SELECT on products.is_published.
--
-- REVISION: the EXISTS subquery runs as the caller, so products' own RLS applies
-- inside it. That means this also inherits "hide products of hidden category/seller"
-- and any future storefront visibility rule, not just is_published.
-- Admins are unaffected: product_seo_admin_write (ALL, products.manage) still covers them.
--
-- STATUS: DRAFT, not applied. Owner approval required.

alter policy product_seo_public_read on public.product_seo
  using (
    noindex = false
    and exists (
      select 1 from public.products p
      where p.id = product_seo.product_id
        and p.is_published
    )
  );
