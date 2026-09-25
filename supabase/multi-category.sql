-- Catch-up migration: safe to run no matter which of the earlier files
-- (add-ascii-type.sql, rename-and-add-ascii-category.sql) you already ran.
-- Ends with: ascii resource type allowed, categories as a multi-value list,
-- and the multi-star ascii piece tagged y2k + ascii + cool.

-- 1. Allow the "ascii" resource type.
alter table resources drop constraint if exists resources_type_check;
alter table resources add constraint resources_type_check
  check (type in ('sticker', 'text', 'symbol', 'ascii'));

-- 2. If the old single `category` column is still there, fold it into a
--    new `categories` array column, then drop it.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_name = 'resources' and column_name = 'category'
  ) then
    if not exists (
      select 1 from information_schema.columns
      where table_name = 'resources' and column_name = 'categories'
    ) then
      alter table resources add column categories text[];
    end if;
    update resources set categories = array[category] where categories is null;
    alter table resources drop constraint if exists resources_category_check;
    alter table resources drop column category;
  end if;
end $$;

alter table resources add column if not exists categories text[];
alter table resources alter column categories set not null;

alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool']::text[]);

-- 3. Rename the old "ship-braille" guess to "multi-star" if it's still
--    sitting under that slug.
update resources set slug = 'multi-star'
where slug = 'ship-braille'
  and not exists (select 1 from resources where slug = 'multi-star');

-- 4. Insert the multi-star ascii resource if missing, or correct it in
--    place if it's already there under any name/state.
insert into resources (slug, type, glyph, label, categories) values (
  'multi-star',
  'ascii',
  $art$⠀⠀⠀⢸⣦⡀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢸⣏⠻⣶⣤⡶⢾⡿⠁⠀⢠⣄⡀⢀⣴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⣀⣼⠷⠀⠀⠁⢀⣿⠃⠀⠀⢀⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠴⣾⣯⣅⣀⠀⠀⠀⠈⢻⣦⡀⠒⠻⠿⣿⡿⠿⠓⠂⠀⠀⢀⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠉⢻⡇⣤⣾⣿⣷⣿⣿⣤⠀⠀⣿⠁⠀⠀⠀⢀⣴⣿⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠸⣿⡿⠏⠀⢀⠀⠀⠿⣶⣤⣤⣤⣄⣀⣴⣿⡿⢻⣿⡆⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠟⠁⠀⢀⣼⠀⠀⠀⠹⣿⣟⠿⠿⠿⡿⠋⠀⠘⣿⣇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢳⣶⣶⣿⣿⣇⣀⠀⠀⠙⣿⣆⠀⠀⠀⠀⠀⠀⠛⠿⣿⣦⣤⣀⠀⠀
⠀⠀⠀⠀⠀⠀⣹⣿⣿⣿⣿⠿⠋⠁⠀⣹⣿⠳⠀⠀⠀⠀⠀⠀⢀⣠⣽⣿⡿⠟⠃
⠀⠀⠀⠀⠀⢰⠿⠛⠻⢿⡇⠀⠀⠀⣰⣿⠏⠀⠀⢀⠀⠀⠀⣾⣿⠟⠋⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠀⠀⣰⣿⣿⣾⣿⠿⢿⣷⣀⢀⣿⡇⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⠉⠁⠀⠀⠀⠀⠙⢿⣿⣿⠇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀$art$,
  'multi-star ascii',
  array['y2k', 'ascii', 'cool']
)
on conflict (slug) do update set
  type = excluded.type,
  glyph = excluded.glyph,
  label = excluded.label,
  categories = excluded.categories;
