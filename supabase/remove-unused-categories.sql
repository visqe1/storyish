-- Tightens the category constraint to match what's actually in use,
-- dropping the leftover placeholder categories (aesthetic, minimal,
-- birthday, cottagecore, summer) now that their seed content is gone.

alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['y2k','cool','cute','food','ascii','symbols']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['y2k','cool','cute','food','ascii','symbols']::text[]);
