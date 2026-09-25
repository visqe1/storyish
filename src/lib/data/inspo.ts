import { supabase } from "@/lib/supabase";
import type { Category } from "./categories";
import { getResourcesBySlugs, type Resource } from "./resources";

export interface InspoExample {
  slug: string;
  title: string;
  /** An example can be tagged with more than one mood at once. */
  categories: Category[];
  /** Placeholder motif art shown until a real story mockup image is uploaded. */
  motif: string;
  /** Public Storage URL for the real story mockup image, if one has been uploaded yet. */
  imageUrl: string | null;
}

interface InspoRow {
  slug: string;
  title: string;
  categories: Category[];
  motif: string;
  image_url: string | null;
}

function mapInspo(row: InspoRow): InspoExample {
  return {
    slug: row.slug,
    title: row.title,
    categories: row.categories,
    motif: row.motif,
    imageUrl: row.image_url,
  };
}

export async function getAllInspo(): Promise<InspoExample[]> {
  const { data, error } = await supabase.from("inspo_examples").select("*").order("title");
  if (error) throw error;
  return (data ?? []).map(mapInspo);
}

export async function getInspo(slug: string): Promise<InspoExample | undefined> {
  const { data, error } = await supabase
    .from("inspo_examples")
    .select("*")
    .eq("slug", slug)
    .maybeSingle();
  if (error) throw error;
  return data ? mapInspo(data) : undefined;
}

export async function getInspoResources(slug: string): Promise<Resource[]> {
  const { data, error } = await supabase
    .from("inspo_resources")
    .select("resource_slug, position")
    .eq("inspo_slug", slug)
    .order("position");
  if (error) throw error;
  const slugs = (data ?? []).map((row) => row.resource_slug);
  return getResourcesBySlugs(slugs);
}
