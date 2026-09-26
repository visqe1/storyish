-- 1. Add "food" as a valid category.
alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols','cute','food']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols','cute','food']::text[]);

-- 2. Tag every resource from the last batch as "cute".
update resources set categories = array['cute']
where slug in (
  'blue-button', 'blue-pin', 'blue-star', 'blue-swirl-button', 'pancake',
  'pudding', 'rila-bread', 'rila', 'soda-poster', 'teal-music',
  'yellow-button', 'yellow-fish', 'yellow-note', 'yellow-star'
);

-- 3. The food-specific ones also get "food" on top of "cute".
update resources set categories = array['cute', 'food']
where slug in ('pudding', 'pancake', 'rila-bread', 'soda-poster');
