import Link from "next/link";
import Shelf from "@/components/Shelf";
import StickerCard from "@/components/StickerCard";
import InspoCard from "@/components/InspoCard";
import { getAllResources } from "@/lib/data/resources";
import { getAllInspo } from "@/lib/data/inspo";

export default async function Home() {
  const [resources, inspoExamples] = await Promise.all([getAllResources(), getAllInspo()]);
  const stickerPreview = resources.slice(0, 8);
  const inspoPreview = inspoExamples;

  return (
    <div className="mx-auto w-full max-w-6xl px-6 pb-12.5">
      <section className="relative overflow-hidden py-14">
        <div className="pointer-events-none absolute -right-15 -top-15 h-55 w-55 rounded-full bg-strawberry opacity-55 blur-[2px]" />
        <div className="pointer-events-none absolute right-57.5 bottom-7.5 h-35 w-35 rounded-full bg-peach opacity-55 blur-[2px]" />
        <div className="pointer-events-none absolute right-85 top-7.5 h-22.5 w-22.5 rounded-full bg-almond opacity-55 blur-[2px]" />

        <div className="relative z-10 max-w-xl">
          <p className="mb-2.5 text-[0.72rem] font-extrabold tracking-[0.14em] text-ink-muted lowercase">
            your story design toolkit
          </p>
          <h1 className="text-[2.6rem] leading-[1.1] sm:text-[3.4rem]">
            curated stickers for your insta story.
          </h1>
          <p className="mt-3.5 max-w-[44ch] text-[1.02rem] leading-relaxed text-ink-muted">
            a growing library of cute png stickers, text snippets and symbols, plus curated
            story inspo you can copy piece by piece.
          </p>
          <div className="mt-6.5 flex gap-3">
            <Link
              href="/stickers"
              className="rounded-full bg-accent-strong px-5 py-2.5 text-[0.85rem] font-extrabold lowercase text-surface transition-transform hover:-translate-y-px"
            >
              browse stickers
            </Link>
            <Link
              href="/inspo"
              className="rounded-full border border-line bg-surface px-5 py-2.5 text-[0.85rem] font-extrabold lowercase text-ink transition-transform hover:-translate-y-px"
            >
              see story inspo
            </Link>
          </div>
        </div>
      </section>

      <Shelf title="stickers" seeMoreHref="/stickers">
        {stickerPreview.map((resource) => (
          <div key={resource.slug} className="w-35 shrink-0">
            <StickerCard resource={resource} />
          </div>
        ))}
      </Shelf>

      <Shelf title="story inspo" seeMoreHref="/inspo">
        {inspoPreview.map((example, i) => (
          <div key={example.slug} className="w-43 shrink-0">
            <InspoCard example={example} index={i} />
          </div>
        ))}
      </Shelf>
    </div>
  );
}
