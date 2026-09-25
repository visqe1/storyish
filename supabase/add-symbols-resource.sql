-- Adds "symbols" as a category, and inserts the new decorative symbol string.

alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_category_check;
alter table inspo_examples add constraint inspo_examples_category_check
  check (category in ('aesthetic', 'minimal', 'birthday', 'cottagecore', 'summer', 'y2k', 'ascii', 'cool', 'symbols'));

-- rename it if you already ran an earlier version of this file under the
-- old guessed slug, then upsert it under the right one.
update resources set slug = 'star-swirl-combo'
where slug = 'star-cluster'
  and not exists (select 1 from resources where slug = 'star-swirl-combo');

insert into resources (slug, type, glyph, label, categories) values (
  'star-swirl-combo',
  'symbol',
  '𖦹✶𓏲ּ꩜ .ᐟ',
  'star swirl combo',
  array['symbols', 'cool']
)
on conflict (slug) do update set
  type = excluded.type,
  glyph = excluded.glyph,
  label = excluded.label,
  categories = excluded.categories;
