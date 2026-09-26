export const categories = [
  "y2k",
  "cool",
  "cute",
  "food",
  "ascii",
  "symbols",
] as const;

export type Category = (typeof categories)[number];
