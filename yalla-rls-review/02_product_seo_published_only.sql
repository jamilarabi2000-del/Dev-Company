-- Finding 5 (Low/Medium, latent): product_seo public-read policy exposes SEO rows
-- for UNPUBLISHED products. Current policy qual is simply `(noindex = false)` with no
-- check that the parent product is published. `noindex` defaults to false, so the
-- moment SEO rows are created for a draft/unreleased product, anon and any logged-in
-- user can read its seo_title / seo_description / keywords — leaking unreleased product
-- names and marketing copy. (Table is empty today, so this is latent, not yet live.)
--
-- Fix: require the parent product to be published, mirroring product_images_read.
--
-- STATUS: DRAFT — not applied. Owner approval required.
-- NOTE: confirm the real column name for the public flag on products is `is_published`
--       (verified in this review) before applying.

alter policy product_seo_public_read on public.product_seo
  using (
    noindex = false
    and exists (
      select 1 from public.products p
      where p.id = product_seo.product_id
        and p.is_published
    )
  );
