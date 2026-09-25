-- Removes the original placeholder seed data, keeping only what you've
-- added since. inspo_resources rows cascade-delete automatically with
-- their parent example/resource, so nothing to clean up there separately.

delete from inspo_examples where slug in (
  'soft-hours', 'golden-hour', 'birthday-girl', 'study-day', 'coffee-run', 'beach-daze'
);

delete from resources where slug in (
  'sparkle', 'blossom', 'butterfly', 'moon', 'bow', 'heart', 'star', 'cloud',
  'cake', 'coffee', 'wave', 'sun', 'shell', 'leaf', 'balloon', 'twinkle',
  'good-vibes', 'golden', 'hbd', 'focus', 'morning', 'salty-air'
);
