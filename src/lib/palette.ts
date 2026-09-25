const cardTones = ["bg-linen", "bg-strawberry", "bg-peach", "bg-almond"] as const;

export function cardTone(index: number): string {
  return cardTones[((index % cardTones.length) + cardTones.length) % cardTones.length];
}

/** Deterministic tone index derived from a slug, for contexts with no natural array position. */
export function toneIndexForSlug(slug: string): number {
  let hash = 0;
  for (let i = 0; i < slug.length; i++) {
    hash = (hash * 31 + slug.charCodeAt(i)) | 0;
  }
  return Math.abs(hash);
}
