"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

export default function SearchBox({
  basePath,
  initialQuery,
  category,
}: {
  basePath: string;
  initialQuery: string;
  category?: string;
}) {
  const router = useRouter();
  const [value, setValue] = useState(initialQuery);

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const params = new URLSearchParams();
    if (category) params.set("category", category);
    if (value.trim()) params.set("q", value.trim());
    const qs = params.toString();
    router.push(qs ? `${basePath}?${qs}` : basePath);
  }

  return (
    <form onSubmit={submit} className="mb-2 flex max-w-sm items-center gap-2 rounded-full border border-line bg-surface px-3.5 py-2 text-[0.85rem] text-ink-muted">
      <svg width="14" height="14" viewBox="0 0 24 24" className="shrink-0 opacity-70">
        <circle cx="11" cy="11" r="7" stroke="currentColor" strokeWidth="2" fill="none" />
        <line x1="21" y1="21" x2="16.6" y2="16.6" stroke="currentColor" strokeWidth="2" />
      </svg>
      <input
        type="text"
        placeholder="search stickers..."
        value={value}
        onChange={(e) => setValue(e.target.value)}
        className="w-full bg-transparent text-ink outline-none placeholder:text-ink-muted placeholder:lowercase"
      />
    </form>
  );
}
