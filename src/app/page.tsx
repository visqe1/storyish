import Shelf from "@/components/Shelf";
import StickerCard from "@/components/StickerCard";
import InspoCard from "@/components/InspoCard";
import { getAllResources } from "@/lib/data/resources";
import { getAllInspo } from "@/lib/data/inspo";
import { stableShuffle } from "@/lib/shuffle";

export default async function Home() {
  const [resources, inspoExamples] = await Promise.all([getAllResources(), getAllInspo()]);
  const stickerPreview = stableShuffle(resources).slice(0, 8);
  const inspoPreview = inspoExamples;

  return (
    <div className="mx-auto w-full max-w-6xl px-6 pb-12.5">
      <section className="relative overflow-hidden pb-4 pt-14">
        <div className="hero-grid pointer-events-none absolute inset-0" />

        <div className="relative z-10 max-w-xl">
          <h1 className="text-[2.6rem] leading-[1.1] sm:text-[3.4rem]">
            curated stickers for your insta story.
          </h1>
          <p className="mt-3.5 max-w-[44ch] text-[1.02rem] leading-relaxed text-ink-muted">
            a growing library of cute png stickers, text snippets and symbols, plus curated
            story inspo you can copy piece by piece.
          </p>
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
