import Link from "next/link";
import type { Metadata } from "next";
import { categories, type Category } from "@/lib/data/categories";
import { getAllResources } from "@/lib/data/resources";
import StickerCard from "@/components/StickerCard";
import CategoryPills from "@/components/CategoryPills";
import SearchBox from "@/components/SearchBox";
import { stableShuffle } from "@/lib/shuffle";

export const metadata: Metadata = { title: "all stickers — storyish" };

function isCategory(value: string | undefined): value is Category {
  return !!value && (categories as readonly string[]).includes(value);
}

export default async function StickersPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string; q?: string }>;
}) {
  const params = await searchParams;
  const activeCategory: Category | "all" = isCategory(params.category) ? params.category : "all";
  const q = params.q?.trim().toLowerCase() ?? "";

  const resources = stableShuffle(await getAllResources());
  const filtered = resources.filter((r) => {
    const matchesCategory = activeCategory === "all" || r.categories.includes(activeCategory);
    const matchesQuery = !q || r.label.toLowerCase().includes(q);
    return matchesCategory && matchesQuery;
  });

  return (
    <div className="mx-auto w-full max-w-6xl px-6 py-8 pb-15">
      <Link
        href="/"
        className="mb-4.5 inline-flex items-center gap-1.5 text-[0.8rem] font-extrabold lowercase text-ink-muted hover:text-accent-strong"
      >
        &larr; home
      </Link>
      <h1 className="text-2xl lowercase">all stickers</h1>
      <p className="mt-1 mb-3.5 text-[0.72rem] font-extrabold tracking-[0.14em] text-ink-muted lowercase">
        browse by mood
      </p>
      <CategoryPills basePath="/stickers" active={activeCategory} extraParams={{ q: params.q }} />
      <SearchBox basePath="/stickers" initialQuery={params.q ?? ""} category={params.category} />

      {filtered.length === 0 ? (
        <p className="mt-10 text-sm text-ink-muted">
          nothing matches &ldquo;{params.q}&rdquo; yet — try a different search or mood.
        </p>
      ) : (
        <div className="mt-6 grid grid-cols-2 gap-3.5 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
          {filtered.map((resource) => (
            <StickerCard key={resource.slug} resource={resource} />
          ))}
        </div>
      )}
    </div>
  );
}
