"use client";

import Image from "next/image";
import { useRef, useState } from "react";
import type { Resource } from "@/lib/data/resources";

export default function StickerCard({
  resource,
  compact = false,
}: {
  resource: Resource;
  compact?: boolean;
}) {
  const [copied, setCopied] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  async function handleCopy() {
    try {
      if (resource.imageUrl) {
        // ClipboardItem must be constructed synchronously inside the click
        // handler for iOS Safari to accept the write — pass the fetch as a
        // pending promise rather than awaiting it first, so the "this is a
        // real user gesture" claim isn't lost while the image downloads.
        const imageUrl = resource.imageUrl;
        await navigator.clipboard.write([
          new ClipboardItem({
            "image/png": fetch(imageUrl).then((res) => res.blob()),
          }),
        ]);
      } else {
        await navigator.clipboard.writeText(resource.glyph);
      }
    } catch {
      // clipboard permission denied or unavailable — the toast still confirms
      // intent, and the user can save/copy the image or glyph manually.
    }
    setCopied(true);
    if (timeoutRef.current) clearTimeout(timeoutRef.current);
    timeoutRef.current = setTimeout(() => setCopied(false), 1100);
  }

  const isTextGlyph = resource.type === "text";
  const isAsciiGlyph = resource.type === "ascii";

  return (
    <button
      type="button"
      onClick={handleCopy}
      aria-label={`copy ${resource.label}`}
      className={`group relative flex aspect-square w-full flex-col overflow-hidden bg-linen shadow-[0_6px_16px_rgba(107,86,70,0.14)] transition-transform hover:-translate-y-0.5 ${
        compact ? "rounded-2xl" : "rounded-[22px]"
      }`}
    >
      <div className={`relative min-h-0 flex-1 ${compact ? "p-3.5" : "p-6"}`}>
        {resource.imageUrl ? (
          <Image src={resource.imageUrl} alt={resource.label} fill className="object-contain" />
        ) : isTextGlyph ? (
          <div
            className={`absolute inset-0 flex items-center justify-center px-2 text-center font-display font-medium leading-tight ${
              compact ? "text-[0.58rem]" : "text-[0.84rem]"
            }`}
          >
            {resource.glyph}
          </div>
        ) : isAsciiGlyph ? (
          <div className="absolute inset-0 flex items-center justify-center overflow-hidden">
            <pre
              className={`whitespace-pre font-mono leading-[1.1] text-ink ${
                compact ? "text-[3px]" : "text-[5px]"
              }`}
            >
              {resource.glyph}
            </pre>
          </div>
        ) : (
          <div
            className={`absolute inset-0 flex items-center justify-center leading-none ${
              compact ? "text-[1.5rem]" : "text-[2.1rem]"
            }`}
          >
            {resource.glyph}
          </div>
        )}
      </div>
      <span
        className={`shrink-0 text-center font-bold lowercase text-ink ${
          compact ? "pb-1 text-[0.6rem]" : "pb-1.5 text-[0.68rem]"
        }`}
      >
        {resource.label}
      </span>

      <span
        className={`pointer-events-none absolute bottom-6 left-1/2 flex -translate-x-1/2 items-center gap-1.5 rounded-full bg-ink px-3 py-1 text-[0.7rem] font-bold lowercase text-surface transition-all ${
          copied ? "translate-y-0 opacity-100" : "translate-y-1 opacity-0"
        }`}
      >
        <svg width="10" height="10" viewBox="0 0 24 24" className="stroke-surface" strokeWidth="3" fill="none">
          <path d="M4 12l5 5L20 6" />
        </svg>
        copied
      </span>
    </button>
  );
}
