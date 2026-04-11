---
name: customer-case-study-deck
description: Create a 4-slide customer case study deck from local source materials using the project template and good examples.
---

# Customer Case Study Deck Skill

Use this skill when asked to create a customer case study deck from materials under `assets/`.

This skill is tailored for this repository and must follow:
- Good examples in `assets/good-example/v2/`
- Template in `assets/slides-template/v2/TiDB_Customer_Case_Study_Template_16x9.pptx`
- Brand reference in `.claude/skills/tidb-branding/reference.md`

## When to use

- User asks to "create a customer case study deck", "study customer folder", or similar.
- User asks for a custom customer deck based on one or more source files.
- User asks to redo/fix a generated customer deck.

## Output location (project rule)

- Save generated decks to `stage/` only.
- Do not auto-write newly generated decks to `output/` unless user explicitly asks.

## Required deck format

- Exactly 4 slides, 16:9.
- Use `assets/slides-template/v2/TiDB_Customer_Case_Study_Template_16x9.pptx` as base.
- Populate speaker notes for all slides.
- Include a detailed architecture transcript in Slide 4 notes.

## Style baseline from good examples

Reference style from:
- `assets/good-example/v2/` folder.

Observed common pattern:
- Slide 1: replace the placeholders, light cover, customer logo + customer title + TiDB product + highlight + confidentiality footer.
- Slide 2: reuse the slide 2 from the slide template. No change needed.
- Slide 3: left "Challenges", right "Solution Overview", both as bullets.
- Slide 4: left "Results" bullets, right "Architecture Diagram".

## Slide-by-slide rules

### Slide 1 (Cover)

- Replace the placeholders' texts in the slide 1 template and keep the style, font, and size intact:
  - `<customer_name>` to the actual customer name
  - `<tidb_product_name>` to the actual TiDB product used
  - `<case_highlight>` to a highlight sentence that describes the primary reason why customer chosen TiDB product or the outstanding result achieved by using TiDB, 13 words at maximum.
- Add one customer logo which is designed for being put on the top of light backgrounds.
  - Logo position is (left: 5.48 cm, top: 1.08 cm), size height: 1.27 cm (width scales proportionally)
  - Customer logo with a transparent background is preferred.
  - Do NOT search the customer logos from PingCAP or TiDB websites, use customer's own website as the source if there is no suitable logos under `assets/logos/` folder. Do NOT create the customer's logo by yourself.

### Slide 2 (Agenda)

- Reuse the slide 2 from the template. Do NOT do anything else.

### Slide 3 (Challenges + Solution Overview)

- Fonts are `DM Sans`
- Replace placeholder's text in the title:
  - `<one_short_sentence_summary_as_title>` to the actual workload scenario with 7 words at maximum.
- Keep section headers:
  - `Challenges`
  - `Solution Overview`
- Replace the bullet content in the template with actual case findings.
- Body text must be explicit native bullets (not plain paragraph). Slide 3 in the template already has this pattern.
- Keep non-chip body text dark.
- Keep text inside chip/softbox light.
- Keep template chip/softbox background colors unless user explicitly requests otherwise.
- No diagrams on this slide.
- Bold the quantified numbers under Challenges when possible.

### Slide 4 (Results + Architecture Diagram)

- Fonts are `DM Sans`
- Replace placeholder's text in the title, keep the style:
  - `<one_short_sentence_summary_as_title>` to the architecture characteristic with 7 words at maximum.
- Keep section headers:
  - `Results`
  - `Architecture Diagram`
- Quantified results must be bold.
- Emphasize key metrics (numbers/time/scale) with bold where practical.
- No need to point out which source the regional production industry context had been validated through.
- Replace the bullet content in the template with actual case findings.
- Body text must be explicit native bullets (not plain paragraph). Slide 4 in the template already has this pattern.
- Build a customer-specific architecture diagram (do not reuse unrelated diagram, based on the facts you learned from the provided materials).
- Diagram style:
  - Every computed position is should be wrapped in `int(round(...))` via a helper `emu()` function.
  - Rounded rectangles.
  - Right-angle or clean connectors.
  - Readable labels near connectors, no overlaps with boxes, no overlaps with the connector lines.
  - Include `TiDB Cluster` component. And, `PD`, `TiKV`, `TiDB`, `TiFlash` are subcomponents that already inside the `TiDB Cluster`, no need to draw these components.
  - Keep the softboxes background in dark color.
  - Keep diagram text within the softboxes in light color.
  - Keep diagram text that describes connector lines in dark color (because the slide is in light background).
  - The diagram components should not overlapped with the chip heads on the slide.
- Append a detailed transcript to explain the reference architecture diagram.
- Bold the quantified numbers under Quantified Results when possible.

## Content construction workflow

1. Locate customer source files under `assets/customers/...` and `input/` folders.
2. Skip the `output/` folder, it is NOT for your reference by any means.
3. Extract factual inputs from decks/docs/web pages. Translate the content into English if the source is not English.
4. Build 3-part narrative:
   - Challenge context
   - Solution architecture and migration approach
   - Quantified outcomes
5. Normalize product naming to source reality (e.g., TiDB, TiDB Cloud, TiDB Cloud Starter, TiDB Cloud Dedicated, TiDB Cloud Essential, TiDB Cloud Premium, or TiDB Cloud BYOC).
6. Use customer name consistently.
7. Add slide notes:
   - Slide 1: detailed source and context.
   - Slide 3: detailed challenge/solution descriptions.
   - Slide 4: metrics + detailed architecture talk track.

## Customer Logo selection rules

- Prefer official customer logos from customer source materials or official brand pages.
- Do not use customer logos from PingCAP nor TiDB websites.
- Validate visual compatibility on light background slide.
- If a logo is uncertain/incorrect, replace it with a verified one from customer's official websites.

## Quality gates before finishing

- Deck exists in `stage/`.
- 4 slides only.
- Slide 3 and Slide 4 contain native bullet-formatted body content.
- Slide 1 has customer logo correctly placed and visually clean.
- No leftover placeholder text from the template.
- Notes exist for all slides; Slide 4 notes include architecture transcript.

## File naming

- Use: `<Customer>_Customer_Case_Study_16x9_<YYYYMMDD>.pptx`, replace `<YYYYMMDD>` with the current date when the workflow runs.
- Save to `stage/`.
- If collision exists, append a safe suffix.

## Post creation tasks

- None
