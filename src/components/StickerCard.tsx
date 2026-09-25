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
      className={`group relative flex aspect-square w-full flex-col items-center justify-center gap-2.5 overflow-hidden bg-linen shadow-[0_6px_16px_rgba(107,86,70,0.14)] transition-transform hover:-translate-y-0.5 ${
        compact ? "rounded-2xl" : "rounded-[22px]"
      }`}
    >
      <span className="pointer-events-none absolute -left-4 -top-4 h-12 w-12 rounded-full bg-white/35" />
      {resource.imageUrl ? (
        <Image
          src={resource.imageUrl}
          alt={resource.label}
          width={compact ? 32 : 44}
          height={compact ? 32 : 44}
          className="object-contain"
        />
      ) : isTextGlyph ? (
        <span
          className={`flex min-h-[1.7rem] w-full items-center justify-center overflow-hidden text-ellipsis whitespace-nowrap px-2.5 font-display font-medium ${
            compact ? "text-[0.68rem]" : "text-[0.8rem]"
          }`}
        >
          {resource.glyph}
        </span>
      ) : isAsciiGlyph ? (
        <pre
          className={`whitespace-pre font-mono leading-[1.1] text-ink ${
            compact ? "text-[3.2px]" : "text-[5.5px]"
          }`}
        >
          {resource.glyph}
        </pre>
      ) : (
        <span className={compact ? "text-[1.5rem] leading-none" : "text-[1.9rem] leading-none"}>
          {resource.glyph}
        </span>
      )}
      <span className={`font-bold lowercase text-ink ${compact ? "text-[0.64rem]" : "text-[0.72rem]"}`}>
        {resource.label}
      </span>

      <span
        className={`pointer-events-none absolute bottom-3.5 left-1/2 flex -translate-x-1/2 items-center gap-1.5 rounded-full bg-ink px-3 py-1 text-[0.7rem] font-bold lowercase text-surface transition-all ${
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
