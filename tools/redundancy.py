#!/usr/bin/env python3
"""Lists near-identical sentence pairs across the parts of one or more documents.

This is the instrument for the third question in the 5S shine step: not *is this
said twice* and not *do these disagree*, but **is this the same thing said in
other words**. A literal copy is easy to see. Two wordings of one fact pass both
of the other readings, and then drift apart, at which point they are no longer
redundancy but contradiction (SYSTEM.md section 8).

It works because the prose here is controlled (section 3): one word, one meaning,
so one fact said twice now produces the same words twice.

**An instrument, not a judge.** Every pair is decided by a person, and the
verdict is written down so nobody litigates it again. A shared vocabulary with no
shared fact is the common false positive, and a rule plus a pointer to it is the
correct shape rather than a duplicate.

A part is a `## ` heading block. A file with no heading is one part. Pairs inside
the same part are skipped, because a paragraph restating its own opening is a
writing problem and not a structural one.

Usage:  python3 tools/redundancy.py SYSTEM.md system/*.md [threshold]

The stop list is English and Spanish. Prose in another language keeps its
function words as content words, which inflates every score. The scores stay
comparable to each other, so the ranking still works; the absolute number does
not mean what it means in the two languages listed.
"""
import re, sys, itertools, pathlib

# The output carries § and accented words, and a Windows console defaults to a
# codepage that cannot encode them. Without this the tool crashes on the first
# section label it prints, on the one platform where nobody would suspect the
# tool itself.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

STOP = set((
    # English
    "the a an of to in and or is are be it its this that for on with as by at from not no "
    "so if when then than which what where who whom whose but nor yet do does did done has have had "
    "will would can could may might must shall should there here them they their one two both "
    "every any all each other another same such only also just even more most less least own "
    # Spanish
    "el la los las un una unos unas de del al a en y o que se es son ser esta este esto estos estas "
    "por para con sin sobre entre como cuando donde quien cual cuyo pero sino ni ya no lo le les "
    "su sus mi mis tu tus nos nuestro hay ha han habia fue son eran mas menos muy tan todo toda "
    "todos todas otro otra otros otras mismo misma cada algo alguien nada nadie porque aunque"
).split())


def parts(path):
    """Yields (label, [(sentence, wordset)]) for each `## ` block in the file."""
    text = pathlib.Path(path).read_text(encoding="utf-8")
    text = re.sub(r"^---\n.*?\n---\n", " ", text, flags=re.S)   # frontmatter
    text = re.sub(r"```.*?```", " ", text, flags=re.S)          # code blocks
    text = re.sub(r"^\s*\|.*$", " ", text, flags=re.M)          # tables
    # A line wrapped whole in asterisks is a footer, and every leaf here carries
    # the same one. Left in, it scores 1.00 against every other leaf and buries
    # the findings under a convention working exactly as intended.
    text = re.sub(r"^\*[^\n]+\*\s*$", " ", text, flags=re.M)
    chunks = re.split(r"(?m)^(##+ .*)$", text)
    blocks = [(pathlib.Path(path).name, chunks[0])] if chunks[0].strip() else []
    for i in range(1, len(chunks), 2):
        head = chunks[i].lstrip("# ").strip()
        num = re.match(r"(\d+)\.", head)
        label = f"{pathlib.Path(path).name} §{num.group(1)}" if num else f"{pathlib.Path(path).name} · {head[:40]}"
        blocks.append((label, chunks[i + 1]))
    for label, body in blocks:
        sentences = []
        for s in re.split(r"(?<=[.!?])\s+", body):
            s = " ".join(s.split())
            words = {w for w in re.findall(r"[a-záéíóúñü']+", s.lower())
                     if w not in STOP and len(w) > 2}
            if len(words) >= 6:
                sentences.append((s, words))
        if sentences:
            yield label, sentences


def main():
    args = sys.argv[1:]
    threshold = 0.25
    if args and re.fullmatch(r"0?\.\d+|[01]", args[-1]):
        threshold = float(args.pop())
    paths = args or ["SYSTEM.md"]

    units = [u for p in paths for u in parts(p)]
    found = []
    for (la, A), (lb, B) in itertools.combinations(units, 2):
        for s1, w1 in A:
            for s2, w2 in B:
                score = len(w1 & w2) / len(w1 | w2)
                if score >= threshold:
                    found.append((score, la, lb, s1, s2))

    for score, la, lb, s1, s2 in sorted(found, reverse=True):
        print(f"\n[{score:.2f}] {la}  vs  {lb}\n  {la}: {s1}\n  {lb}: {s2}")
    print(f"\n{len(found)} pairs at threshold {threshold}, over {len(units)} parts "
          f"of {len(paths)} file(s). Each one is decided by a person.")


if __name__ == "__main__":
    main()
