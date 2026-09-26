-- storyish content schema (current shape)
-- Safe to run on a fresh project, and safe to re-run on your existing one —
-- every statement either checks first or uses ON CONFLICT DO NOTHING.

-- Storage bucket for uploaded sticker/inspo images. Public so the site can
-- display them with no auth; you still upload via the dashboard's own
-- logged-in session, which doesn't go through this policy at all.
insert into storage.buckets (id, name, public)
values ('storyish-assets', 'storyish-assets', true)
on conflict (id) do nothing;

drop policy if exists "public can read storyish-assets" on storage.objects;
create policy "public can read storyish-assets"
on storage.objects for select
using (bucket_id = 'storyish-assets');

create table if not exists resources (
  slug text primary key,
  type text not null check (type in ('sticker', 'text', 'symbol', 'ascii')),
  glyph text not null,          -- emoji/symbol/text/ascii content, always used for copy-to-clipboard
  image_url text,               -- public Storage URL for a real PNG sticker, optional
  label text not null,
  categories text[] not null,   -- a resource can be tagged with more than one mood
  created_at timestamptz not null default now()
);

create table if not exists inspo_examples (
  slug text primary key,
  title text not null,
  categories text[] not null,   -- an example can be tagged with more than one mood
  motif text not null,          -- emoji placeholder shown on the card/detail image panel
  image_url text,               -- public Storage URL for the real story mockup image, optional
  created_at timestamptz not null default now()
);

create table if not exists inspo_resources (
  inspo_slug text not null references inspo_examples(slug) on delete cascade,
  resource_slug text not null references resources(slug) on delete cascade,
  position int not null default 0,
  primary key (inspo_slug, resource_slug)
);

alter table resources drop constraint if exists resources_categories_check;
alter table resources add constraint resources_categories_check
  check (categories <@ array['y2k','cool','cute','food','ascii','symbols']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['y2k','cool','cute','food','ascii','symbols']::text[]);

-- Row Level Security: the app reads with the public anon key, so allow
-- anyone to SELECT, but nobody can INSERT/UPDATE/DELETE through the API.
-- You still add/edit rows yourself via the Table Editor, which uses your
-- own logged-in Supabase session and bypasses these policies entirely.

alter table resources enable row level security;
alter table inspo_examples enable row level security;
alter table inspo_resources enable row level security;

drop policy if exists "public can read resources" on resources;
create policy "public can read resources" on resources
  for select using (true);

drop policy if exists "public can read inspo_examples" on inspo_examples;
create policy "public can read inspo_examples" on inspo_examples
  for select using (true);

drop policy if exists "public can read inspo_resources" on inspo_resources;
create policy "public can read inspo_resources" on inspo_resources
  for select using (true);

-- Catalog content — the ascii-art piece added first.
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

-- The decorative symbol string added after that.
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

-- An inspo example tagged with more than one mood.
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
  image_url = excluded.image_url,
  motif = excluded.motif;

insert into inspo_resources (inspo_slug, resource_slug, position) values
  ('navy-star-cool-music', 'mp3', 0),
  ('navy-star-cool-music', 'navy-star', 1),
  ('navy-star-cool-music', 'star-swirl-combo', 2),
  ('navy-star-cool-music', 'multi-star', 3)
on conflict (inspo_slug, resource_slug) do update set position = excluded.position;

-- A batch of real sticker PNGs, tagged cute (and food for the food ones).
insert into resources (slug, type, glyph, label, categories, image_url) values
  ('blue-button', 'sticker', '🔘', 'blue button', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-button.PNG'),
  ('blue-pin', 'sticker', '📌', 'blue pin', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-pin.PNG'),
  ('blue-star', 'sticker', '⭐', 'blue star', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-star.PNG'),
  ('blue-swirl-button', 'sticker', '🔘', 'blue swirl button', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-swirl-button.PNG'),
  ('pancake', 'sticker', '🥞', 'pancake', array['cute','food'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/pancake.PNG'),
  ('pudding', 'sticker', '🍮', 'pudding', array['cute','food'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/pudding.PNG'),
  ('rila-bread', 'sticker', '🍞', 'rila bread', array['cute','food'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/rila-bread.PNG'),
  ('rila', 'sticker', '🐻', 'rila', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/rila.PNG'),
  ('soda-poster', 'sticker', '🥤', 'soda poster', array['cute','food'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/soda-poster.JPG'),
  ('teal-music', 'sticker', '🎵', 'teal music', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/teal-music.PNG'),
  ('yellow-button', 'sticker', '🟡', 'yellow button', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-button.PNG'),
  ('yellow-fish', 'sticker', '🐟', 'yellow fish', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-fish.PNG'),
  ('yellow-note', 'sticker', '🎵', 'yellow note', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-note.PNG'),
  ('yellow-star', 'sticker', '⭐', 'yellow star', array['cute'],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-star.PNG')
on conflict (slug) do update set
  type = excluded.type,
  glyph = excluded.glyph,
  label = excluded.label,
  categories = excluded.categories,
  image_url = excluded.image_url;
