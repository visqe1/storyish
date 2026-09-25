import Image from "next/image";
import Link from "next/link";
import type { InspoExample } from "@/lib/data/inspo";
import { cardTone } from "@/lib/palette";

export default function InspoCard({
  example,
  index,
}: {
  example: InspoExample;
  index: number;
}) {
  return (
    <Link
      href={`/inspo/${example.slug}`}
      className={`group relative flex aspect-9/16 w-full flex-col justify-end overflow-hidden rounded-[22px] p-3.5 text-left shadow-[0_8px_20px_rgba(107,86,70,0.14)] transition-transform hover:-translate-y-0.5 ${cardTone(
        index + 1
      )}`}
    >
      {example.imageUrl ? (
        <>
          <Image
            src={example.imageUrl}
            alt={example.title}
            fill
            sizes="(min-width: 768px) 200px, 45vw"
            className="object-cover"
          />
          <div className="absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-ink/70 to-transparent" />
        </>
      ) : (
        <span className="absolute left-1/2 top-6 -translate-x-1/2 text-[2.1rem]">{example.motif}</span>
      )}
      <div className="relative">
        <h3 className={`text-[1rem] lowercase ${example.imageUrl ? "text-surface" : ""}`}>
          {example.title}
        </h3>
        <p
          className={`mt-0.5 text-[0.7rem] font-bold lowercase ${
            example.imageUrl ? "text-surface/80" : "text-ink-muted"
          }`}
        >
          {example.categories.join(" · ")}
        </p>
      </div>
    </Link>
  );
}
