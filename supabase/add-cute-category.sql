-- Adds "cute" as a valid category on both tables.

alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols','cute']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols','cute']::text[]);
