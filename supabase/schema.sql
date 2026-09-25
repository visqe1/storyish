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
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols']::text[]);

alter table inspo_examples drop constraint if exists inspo_examples_categories_check;
alter table inspo_examples add constraint inspo_examples_categories_check
  check (categories <@ array['aesthetic','minimal','birthday','cottagecore','summer','y2k','ascii','cool','symbols']::text[]);

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

-- Seed data — the starting catalog the app ships with.

insert into resources (slug, type, glyph, label, categories) values
  ('sparkle', 'sticker', '✨', 'sparkle', array['aesthetic']),
  ('blossom', 'sticker', '🌸', 'blossom', array['cottagecore']),
  ('butterfly', 'sticker', '🦋', 'butterfly', array['aesthetic']),
  ('moon', 'sticker', '🌙', 'moon', array['minimal']),
  ('bow', 'sticker', '🎀', 'bow', array['birthday']),
  ('heart', 'symbol', '♡', 'heart', array['birthday']),
  ('star', 'symbol', '★', 'star', array['minimal']),
  ('cloud', 'sticker', '☁️', 'cloud', array['aesthetic']),
  ('cake', 'sticker', '🎂', 'cake', array['birthday']),
  ('coffee', 'sticker', '☕', 'coffee', array['minimal']),
  ('wave', 'sticker', '🌊', 'wave', array['summer']),
  ('sun', 'sticker', '☀️', 'sun', array['summer']),
  ('shell', 'sticker', '🐚', 'shell', array['summer']),
  ('leaf', 'sticker', '🍃', 'leaf', array['cottagecore']),
  ('balloon', 'sticker', '🎈', 'balloon', array['birthday']),
  ('twinkle', 'symbol', '✧', 'twinkle', array['y2k']),
  ('good-vibes', 'text', 'good vibes', 'good vibes', array['aesthetic']),
  ('golden', 'text', 'golden', 'golden', array['minimal']),
  ('hbd', 'text', 'hbd!', 'hbd!', array['birthday']),
  ('focus', 'text', 'focus', 'focus', array['cottagecore']),
  ('morning', 'text', 'morning', 'morning', array['minimal']),
  ('salty-air', 'text', 'salty air', 'salty air', array['summer'])
on conflict (slug) do nothing;

insert into inspo_examples (slug, title, categories, motif) values
  ('soft-hours', 'soft hours', array['aesthetic'], '✨'),
  ('golden-hour', 'golden hour', array['minimal'], '🌙'),
  ('birthday-girl', 'birthday girl', array['birthday'], '🎀'),
  ('study-day', 'study day', array['cottagecore'], '🌸'),
  ('coffee-run', 'coffee run', array['minimal'], '☕'),
  ('beach-daze', 'beach daze', array['summer'], '🌊')
on conflict (slug) do nothing;

insert into inspo_resources (inspo_slug, resource_slug, position) values
  ('soft-hours', 'sparkle', 0), ('soft-hours', 'cloud', 1), ('soft-hours', 'heart', 2), ('soft-hours', 'good-vibes', 3),
  ('golden-hour', 'moon', 0), ('golden-hour', 'sparkle', 1), ('golden-hour', 'star', 2), ('golden-hour', 'golden', 3),
  ('birthday-girl', 'bow', 0), ('birthday-girl', 'cake', 1), ('birthday-girl', 'heart', 2), ('birthday-girl', 'hbd', 3),
  ('study-day', 'blossom', 0), ('study-day', 'leaf', 1), ('study-day', 'cloud', 2), ('study-day', 'focus', 3),
  ('coffee-run', 'coffee', 0), ('coffee-run', 'sparkle', 1), ('coffee-run', 'star', 2), ('coffee-run', 'morning', 3),
  ('beach-daze', 'wave', 0), ('beach-daze', 'sun', 1), ('beach-daze', 'shell', 2), ('beach-daze', 'salty-air', 3)
on conflict (inspo_slug, resource_slug) do nothing;

-- The ascii-art piece added after the initial seed.
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
