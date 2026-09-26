import { toneIndexForSlug } from "./palette";

/** Deterministic shuffle: looks randomized, but returns the same order every
 * time for the same set of items, since it's derived from each slug rather
 * than page-load randomness. */
export function stableShuffle<T extends { slug: string }>(items: T[]): T[] {
  return [...items].sort((a, b) => toneIndexForSlug(a.slug) - toneIndexForSlug(b.slug));
}
