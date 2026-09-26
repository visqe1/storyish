import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getInspo, getInspoResources } from "@/lib/data/inspo";
import StickerCard from "@/components/StickerCard";
import { cardTone, toneIndexForSlug } from "@/lib/palette";

// Content is curated directly in Supabase rather than redeployed, so this
// page always renders fresh instead of serving a stale build-time snapshot.
export const dynamic = "force-dynamic";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const example = await getInspo(slug);
  return { title: example ? `${example.title} — storyish` : "storyish" };
}

export default async function InspoDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const example = await getInspo(slug);
  if (!example) notFound();

  const resourceList = await getInspoResources(slug);

  return (
    <div className="mx-auto w-full max-w-3xl px-6 py-8 pb-15">
      <Link
        href="/inspo"
        className="mb-4.5 inline-flex items-center gap-1.5 text-[0.8rem] font-extrabold lowercase text-ink-muted hover:text-accent-strong"
      >
        &larr; all story inspo
      </Link>

      <div className="grid gap-0 overflow-hidden rounded-[26px] shadow-[0_16px_40px_rgba(107,86,70,0.18)] sm:grid-cols-[220px_1fr]">
        <div
          className={`relative flex aspect-9/16 w-full items-center justify-center text-[3rem] sm:w-[220px] sm:self-start ${cardTone(
            toneIndexForSlug(example.slug) + 1
          )}`}
        >
          {example.imageUrl ? (
            <Image
              src={example.imageUrl}
              alt={example.title}
              fill
              sizes="(min-width: 640px) 220px, 100vw"
              className="object-cover"
              priority
            />
          ) : (
            <span>{example.motif}</span>
          )}
        </div>
        <div className="bg-surface p-7.5">
          <h1 className="text-2xl lowercase">{example.title}</h1>
          <p className="mt-1 text-[0.78rem] font-extrabold lowercase text-ink-muted">
            {example.categories.join(" · ")}
          </p>
          <p className="mt-6.5 text-[0.78rem] font-extrabold tracking-[0.08em] text-ink-muted lowercase">
            what&rsquo;s inside
          </p>
          <div className="mt-3.5 flex flex-wrap gap-3">
            {resourceList.map((resource) => (
              <div key={resource.slug} className="w-21">
                <StickerCard resource={resource} compact />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
