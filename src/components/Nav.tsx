"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useState } from "react";

const links = [
  { href: "/stickers", label: "stickers" },
  { href: "/inspo", label: "story inspo" },
];

export default function Nav() {
  const pathname = usePathname();
  const router = useRouter();
  const [query, setQuery] = useState("");

  function handleSearch(e: React.FormEvent) {
    e.preventDefault();
    const q = query.trim();
    router.push(q ? `/stickers?q=${encodeURIComponent(q)}` : "/stickers");
  }

  return (
    <nav className="sticky top-0 z-40 border-b border-line bg-bg/90 backdrop-blur-sm">
      <div className="mx-auto flex max-w-6xl flex-wrap items-center gap-x-5 gap-y-2 px-4 py-3 sm:gap-7 sm:px-6 sm:py-3.5">
        <Link href="/" className="mr-auto flex items-center gap-2 sm:gap-2.5">
          <span className="relative h-6 w-6 shrink-0 sm:h-[30px] sm:w-[30px]">
            <span className="absolute left-0 top-1.5 h-4 w-4 rounded-full bg-peach sm:top-2 sm:h-5 sm:w-5" />
            <span className="absolute left-2.5 top-0 h-3 w-3 rounded-full bg-strawberry sm:left-3 sm:h-[15px] sm:w-[15px]" />
            <span className="absolute left-[15px] top-2.5 h-2 w-2 rounded-full bg-almond sm:left-[19px] sm:top-3.5 sm:h-2.5 sm:w-2.5" />
          </span>
          <span className="font-display text-xl italic tracking-tight lowercase sm:text-2xl">storyish</span>
        </Link>

        <div className="flex gap-4 text-[0.8rem] font-bold lowercase sm:gap-5 sm:text-[0.85rem]">
          {links.map((link) => {
            const active = pathname === link.href;
            return (
              <Link
                key={link.href}
                href={link.href}
                className={`whitespace-nowrap border-b-2 pb-1 transition-colors ${
                  active
                    ? "border-accent-strong text-ink"
                    : "border-transparent text-ink-muted hover:border-accent hover:text-ink"
                }`}
              >
                {link.label}
              </Link>
            );
          })}
        </div>

        <form
          onSubmit={handleSearch}
          className="hidden w-56 items-center gap-2 rounded-full border border-line bg-surface px-3.5 py-2 text-[0.85rem] text-ink-muted sm:flex"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" className="shrink-0 opacity-70">
            <circle cx="11" cy="11" r="7" stroke="currentColor" strokeWidth="2" fill="none" />
            <line x1="21" y1="21" x2="16.6" y2="16.6" stroke="currentColor" strokeWidth="2" />
          </svg>
          <input
            type="text"
            placeholder="search storyish..."
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            className="w-full bg-transparent text-ink outline-none placeholder:text-ink-muted placeholder:lowercase"
          />
        </form>
      </div>
    </nav>
  );
}
