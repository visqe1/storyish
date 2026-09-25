import { supabase } from "@/lib/supabase";
import type { Category } from "./categories";

export type ResourceType = "sticker" | "text" | "symbol" | "ascii";

export interface Resource {
  slug: string;
  type: ResourceType;
  /** The literal unicode content copied to the clipboard. */
  glyph: string;
  /** Public Storage URL for a real PNG sticker, if one has been uploaded yet. */
  imageUrl: string | null;
  label: string;
  /** A resource can be tagged with more than one mood at once. */
  categories: Category[];
}

interface ResourceRow {
  slug: string;
  type: ResourceType;
  glyph: string;
  image_url: string | null;
  label: string;
  categories: Category[];
}

function mapResource(row: ResourceRow): Resource {
  return {
    slug: row.slug,
    type: row.type,
    glyph: row.glyph,
    imageUrl: row.image_url,
    label: row.label,
    categories: row.categories,
  };
}

export async function getAllResources(): Promise<Resource[]> {
  const { data, error } = await supabase.from("resources").select("*").order("label");
  if (error) throw error;
  return (data ?? []).map(mapResource);
}

export async function getResource(slug: string): Promise<Resource | undefined> {
  const { data, error } = await supabase
    .from("resources")
    .select("*")
    .eq("slug", slug)
    .maybeSingle();
  if (error) throw error;
  return data ? mapResource(data) : undefined;
}

/** Fetches resources by slug and returns them in the same order the slugs were given. */
export async function getResourcesBySlugs(slugs: string[]): Promise<Resource[]> {
  if (slugs.length === 0) return [];
  const { data, error } = await supabase.from("resources").select("*").in("slug", slugs);
  if (error) throw error;
  const bySlug = new Map((data ?? []).map((row) => [row.slug, mapResource(row)]));
  return slugs.map((slug) => bySlug.get(slug)).filter((r): r is Resource => Boolean(r));
}
