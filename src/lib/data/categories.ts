export const categories = [
  "y2k",
  "cool",
  "aesthetic",
  "minimal",
  "birthday",
  "cottagecore",
  "summer",
  "ascii",
  "symbols",
] as const;

export type Category = (typeof categories)[number];
