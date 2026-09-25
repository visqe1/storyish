-- Switches inspo_examples from a single category to a list, matching the
-- resources table. Safe to run regardless of current state.

alter table inspo_examples add column if not exists categories text[];

do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_name = 'inspo_examples' and column_name = 'category'
  ) then
    update inspo_examples set categories = array[category] where categories is null;
    alter table inspo_examples drop constraint if exists inspo_examples_category_check;
    alter table inspo_examples drop column category;
  end if;
end $$;

alter table inspo_examples alter column categories set not null;

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols']::text[]);

-- The failed insert attempt never made it into the table (the whole
-- statement rolled back), so there's nothing to clean up from that error —
-- just insert it fresh with the right shape.
insert into inspo_examples (slug, title, categories, motif, image_url) values (
  'navy-star-cool-music',
  'cool navy girl + stars',
  array['cool', 'y2k'],
  '🌌',
  'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/inspo1.png'
)
on conflict (slug) do update set
  title = excluded.title,
  categories = excluded.categories,
  motif = excluded.motif,
  image_url = excluded.image_url;
