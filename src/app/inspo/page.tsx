import Link from "next/link";
import type { Metadata } from "next";
import { categories, type Category } from "@/lib/data/categories";
import { getAllInspo } from "@/lib/data/inspo";
import InspoCard from "@/components/InspoCard";
import CategoryPills from "@/components/CategoryPills";

export const metadata: Metadata = { title: "all story inspo — storyish" };

// Content is curated directly in Supabase rather than redeployed, so this
// page always renders fresh instead of serving a stale build-time snapshot.
export const dynamic = "force-dynamic";

function isCategory(value: string | undefined): value is Category {
  return !!value && (categories as readonly string[]).includes(value);
}

export default async function InspoPage({
  searchParams,
}: {
  searchParams: Promise<{ category?: string }>;
}) {
  const params = await searchParams;
  const activeCategory: Category | "all" = isCategory(params.category) ? params.category : "all";

  const inspoExamples = await getAllInspo();
  const filtered = inspoExamples.filter(
    (e) => activeCategory === "all" || e.categories.includes(activeCategory)
  );

  return (
    <div className="mx-auto w-full max-w-6xl px-6 py-8 pb-15">
      <Link
        href="/"
        className="mb-4.5 inline-flex items-center gap-1.5 text-[0.8rem] font-extrabold lowercase text-ink-muted hover:text-accent-strong"
      >
        &larr; home
      </Link>
      <h1 className="text-2xl lowercase">all story inspo</h1>
      <p className="mt-1 mb-3.5 text-[0.72rem] font-extrabold tracking-[0.14em] text-ink-muted lowercase">
        browse by mood
      </p>
      <CategoryPills basePath="/inspo" active={activeCategory} />

      <div className="mt-6 grid grid-cols-2 gap-3.5 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6">
        {filtered.map((example, i) => (
          <InspoCard key={example.slug} example={example} index={i} />
        ))}
      </div>
    </div>
  );
}
