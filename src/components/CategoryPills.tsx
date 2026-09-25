import Link from "next/link";
import { categories, type Category } from "@/lib/data/categories";

export default function CategoryPills({
  basePath,
  active,
  extraParams,
}: {
  basePath: string;
  active: Category | "all";
  extraParams?: Record<string, string | undefined>;
}) {
  const options: (Category | "all")[] = ["all", ...categories];

  function href(cat: Category | "all") {
    const params = new URLSearchParams();
    if (cat !== "all") params.set("category", cat);
    if (extraParams) {
      for (const [key, value] of Object.entries(extraParams)) {
        if (value) params.set(key, value);
      }
    }
    const qs = params.toString();
    return qs ? `${basePath}?${qs}` : basePath;
  }

  return (
    <div className="mb-6 flex gap-2.5 overflow-x-auto pb-1.5">
      {options.map((cat) => {
        const isActive = cat === active;
        return (
          <Link
            key={cat}
            href={href(cat)}
            className={`shrink-0 rounded-full border px-4.5 py-2 text-[0.8rem] font-bold lowercase transition-colors ${
              isActive
                ? "border-accent-strong bg-accent-strong text-surface"
                : "border-line bg-surface text-ink-muted hover:border-accent hover:text-ink"
            }`}
          >
            {cat}
          </Link>
        );
      })}
    </div>
  );
}
