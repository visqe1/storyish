"use client";

import Link from "next/link";
import { useRef, type ReactNode } from "react";

export default function Shelf({
  title,
  seeMoreHref,
  children,
}: {
  title: string;
  seeMoreHref: string;
  children: ReactNode;
}) {
  const trackRef = useRef<HTMLDivElement>(null);

  function scroll(dir: 1 | -1) {
    trackRef.current?.scrollBy({ left: dir * 320, behavior: "smooth" });
  }

  return (
    <section className="py-9">
      <div className="mb-4.5 flex items-baseline justify-between">
        <h2 className="text-2xl lowercase">{title}</h2>
        <Link
          href={seeMoreHref}
          className="text-[0.8rem] font-extrabold lowercase text-accent-strong hover:underline"
        >
          see more
        </Link>
      </div>
      <div className="relative">
        <button
          type="button"
          aria-label="scroll left"
          onClick={() => scroll(-1)}
          className="absolute -left-4.5 top-1/2 z-10 hidden h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full border border-line bg-surface opacity-85 shadow-md hover:opacity-100 md:flex"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
            <path d="M15 6l-6 6 6 6" />
          </svg>
        </button>
        <div ref={trackRef} className="shelf-track flex gap-4 overflow-x-auto pb-2.5">
          {children}
        </div>
        <button
          type="button"
          aria-label="scroll right"
          onClick={() => scroll(1)}
          className="absolute -right-4.5 top-1/2 z-10 hidden h-9 w-9 -translate-y-1/2 items-center justify-center rounded-full border border-line bg-surface opacity-85 shadow-md hover:opacity-100 md:flex"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round">
            <path d="M9 6l6 6-6 6" />
          </svg>
        </button>
      </div>
    </section>
  );
}
