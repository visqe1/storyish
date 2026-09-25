-- Links the resources shown in "what's inside" for navy-star-cool-music.

insert into inspo_resources (inspo_slug, resource_slug, position) values
  ('navy-star-cool-music', 'mp3', 0),
  ('navy-star-cool-music', 'navy-star', 1),
  ('navy-star-cool-music', 'star-swirl-combo', 2),
  ('navy-star-cool-music', 'multi-star', 3)
on conflict (inspo_slug, resource_slug) do update set position = excluded.position;
