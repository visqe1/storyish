-- Links resources to the baby-blue-rila inspo example.
-- "blue music" wasn't found as a resource — closest match is "teal-music".
-- Left out until confirmed; add a row for it below once you know the right slug.

insert into inspo_resources (inspo_slug, resource_slug, position) values
  ('baby-blue-rila', 'blue-pin', 0),
  ('baby-blue-rila', 'blue-barrette', 1),
  ('baby-blue-rila', 'yellow-button', 2),
  ('baby-blue-rila', 'rila-bread', 3),
  ('baby-blue-rila', 'yellow-fish', 4),
  ('baby-blue-rila', 'soda-poster', 5)
on conflict (inspo_slug, resource_slug) do update set position = excluded.position;
