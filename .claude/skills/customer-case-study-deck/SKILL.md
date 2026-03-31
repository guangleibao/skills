---
name: customer-case-study-deck
description: Create a 3-slide customer case study deck from local source materials using the project template and good examples.
---

# Customer Case Study Deck Skill

Use this skill when asked to create a customer case study deck from materials under `assets/`.

This skill is tailored for this repository and must follow:
- Good examples are optionally in `assets/good-example/`
- Template in `assets/slides-template/TiDB_Customer_Case_Study_Template_16x9.pptx`
- Brand reference in `.claude/skills/tidb-branding/reference.md`

## When to use

- User asks to "create a customer case study deck", "study customer folder", or similar.
- User asks for a custom customer deck based on one or more source files.
- User asks to redo/fix a generated customer deck.

## Output location (project rule)

- Save generated decks to `stage/` only.
- Do not auto-write newly generated decks to `output/` unless user explicitly asks.

## Required deck format

- Exactly 3 slides, 16:9.
- Use `assets/slides-template/TiDB_Customer_Case_Study_Template_16x9.pptx` as base.
- Populate speaker notes for all slides.
- Include a detailed architecture transcript in Slide 3 notes.

## Style baseline from good examples

Observed common pattern:
- Slide 1: dark cover, 2 logos top-right, customer title + product + highlight + confidentiality footer.
- Slide 2: left "Challenges", right "Solution Overview", both as bullets.
- Slide 3: left "Quantified Results" bullets, right custom architecture diagram.

## Slide-by-slide rules

### Slide 1 (Cover)

- Fonts are `DM Sans`
- Replace placeholders:
  - `<customer_name>` to the actual customer name
  - `<TiDB_product_name>` to the actual TiDB product used
  - `Distributed SQL at scale with operational simplicity` to a highlight sentence that describes the primary reason why customer chosen TiDB or the outstanding result achieved by using TiDB.
- Keep confidential footer.
- Add two logos on top-right:
  - TiDB product logo + customer logo
  - Same height
  - Transparent customer logo preferred
  - No white box behind logo
  - TiDB product logos are under `assets/logos/` folder.
- Match good-example placement and fonts settings:
  - roughly 60px top/right margin
  - ~38px horizontal gap between logos
- No diagrams on this slide

### Slide 2 (Challenges + Solution Overview)

- Fonts are `DM Sans`
- Replace placeholder in the title:
  - `<one_sentence_summary_as_title>` to the actual workload scenario.
- Keep section headers:
  - `Challenges`
  - `Solution Overview`
- Body text must be explicit bullets (not plain paragraph).
- Keep non-chip body text dark.
- Keep text inside chip/softbox light.
- Keep template chip/softbox background colors unless user explicitly requests otherwise.
- No diagrams on this slide.
- Bold the quantified numbers under Challenges when possible.

### Slide 3 (Quantified Results + Architecture Diagram)

- Fonts are `DM Sans`
- Replace placeholder in the title:
  - `<one_sentence_summary_as_title>` to a highligy summary
- Keep section headers:
  - `Quantified Results`
  - `Architecture Diagram`
- Quantified results must be bullets.
- Emphasize key metrics (numbers/time/scale) with bold where practical.
- No need to point out which source the regional production industry context had been validated through
- Build a customer-specific architecture diagram (do not reuse unrelated diagram, based on the facts you learned from the provided materials).
- Diagram style:
  - rounded rectangles
  - right-angle or clean connectors
  - readable labels near connectors, no overlaps with boxes
  - include `TiDB Cluster` component.
  - Keep the softboxes background in dark color.
  - Keep diagram text within the softboxes in light color.
  - Keep diagram text that describes connector lines in dark color (because the slide is in light background).
- Append a detailed transcript to explain the reference architecture diagram.
- Bold the quantified numbers under Quantified Results when possible.

## Content construction workflow

1. Locate customer source files under `assets/customers/...`.
2. Extract factual inputs from decks/docs/web pages. Translate the content into English if the source is not English.
3. Build 3-part narrative:
   - Challenge context
   - Solution architecture and migration approach
   - Quantified outcomes
4. Normalize product naming to source reality (e.g., TiDB, TiDB Cloud, TiDB Cloud Starter, TiDB Cloud Dedicated).
5. Use customer name consistently.
6. Add slide notes:
   - Slide 1: source and context
   - Slide 2: challenge/solution summary
   - Slide 3: metrics + detailed architecture talk track

## Logo selection rules

- Prefer official customer logos from customer source materials or official brand pages.
- Do not use customer logos from pingcap website.
- Prefer transparent logos for dark cover.
- Validate visual compatibility on dark background.
- If a logo is uncertain/incorrect, replace with a verified official source.

## Quality gates before finishing

- Deck exists in `stage/`.
- 3 slides only.
- Slide 2 and Slide 3 contain bullet-formatted body content.
- Slide 1 has TiDB + customer logos correctly placed and visually clean.
- No leftover placeholder text from template.
- Notes exist for all slides; Slide 3 notes include architecture transcript.
- Open the generated deck for user review.

## File naming

- Use: `<Customer>_Customer_Case_Study_16x9.pptx`
- Save to `stage/`.
- If collision exists, append a safe suffix.

## Post creation tasks

- Open the generated deck locally.
