-- Adds every uploaded image that doesn't have a resources row yet.
-- (barette, navy-star, and mp3 already exist, so they're skipped here.)
-- slug/label come from the filenames, categories are left empty for you
-- to fill in, glyph is a guessed emoji fallback (unused once image_url is set).

insert into resources (slug, type, glyph, label, categories, image_url) values
  ('blue-button', 'sticker', '🔘', 'blue button', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-button.PNG'),
  ('blue-pin', 'sticker', '📌', 'blue pin', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-pin.PNG'),
  ('blue-star', 'sticker', '⭐', 'blue star', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-star.PNG'),
  ('blue-swirl-button', 'sticker', '🔘', 'blue swirl button', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/blue-swirl-button.PNG'),
  ('pancake', 'sticker', '🥞', 'pancake', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/pancake.PNG'),
  ('pudding', 'sticker', '🍮', 'pudding', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/pudding.PNG'),
  ('rila-bread', 'sticker', '🍞', 'rila bread', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/rila-bread.PNG'),
  ('rila', 'sticker', '🐻', 'rila', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/rila.PNG'),
  ('soda-poster', 'sticker', '🥤', 'soda poster', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/soda-poster.JPG'),
  ('teal-music', 'sticker', '🎵', 'teal music', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/teal-music.PNG'),
  ('yellow-button', 'sticker', '🟡', 'yellow button', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-button.PNG'),
  ('yellow-fish', 'sticker', '🐟', 'yellow fish', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-fish.PNG'),
  ('yellow-note', 'sticker', '🎵', 'yellow note', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-note.PNG'),
  ('yellow-star', 'sticker', '⭐', 'yellow star', array[]::text[],
    'https://xqanikthifafbhofvukt.supabase.co/storage/v1/object/public/storyish-assets/yellow-star.PNG')
on conflict (slug) do update set
  type = excluded.type,
  glyph = excluded.glyph,
  label = excluded.label,
  categories = excluded.categories,
  image_url = excluded.image_url;
