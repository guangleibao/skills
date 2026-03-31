# TiDB Branding Reference (v1.1)

## Core Color Specifications (Primary Brand)

Use exact values; do not alter.

### Red Family

- Background Red: `#630D09` (RGB 99/13/9)
- Dark Red: `#87120C` (RGB 135/18/12)
- Brand Red: `#DC150B` (RGB 220/21/11)
- Light Red: `#F35048` (RGB 243/80/72)

### Violet Family

- Background Violet: `#3C174C` (RGB 60/23/76)
- Dark Violet: `#5D137D` (RGB 93/19/125)
- Medium Violet: `#9E4EC4` (RGB 158/78/196)
- Light Violet: `#C76FF2` (RGB 199/111/242)

### Blue Family

- Background Blue: `#0D3152` (RGB 13/49/82)
- Dark Blue: `#10487B` (RGB 16/72/123)
- Medium Blue: `#2C80CE` (RGB 44/128/206)
- Light Blue: `#509DEA` (RGB 80/157/234)

### Teal Family

- Background Teal: `#093434` (RGB 9/52/52)
- Dark Teal: `#0F5353` (RGB 15/83/83)
- Medium Teal: `#1AA8A8` (RGB 26/168/168)
- Light Teal: `#50DBD9` (RGB 80/219/217)

### Neutral

- Black: `#000000`
- White: `#FFFFFF`
- Carbon 100: `#E5E8EB` (digital only)
- Carbon 200: `#CBD1D7`
- Carbon 300: `#B9C2CA`
- Carbon 400: `#A2ADB9` (digital only)
- Carbon 500: `#8B96A2` (digital only)
- Carbon 600: `#74808B` (digital only)
- Carbon 700: `#5D6974` (digital only)
- Carbon 800: `#424D57` (digital only)

## Product-Only Palettes

Do not use these for marketing brand expression.

- Secondary palette: Linen, Peacock, Mango, Plum ramps.
- Expanded Carbon palette: Carbon 50 (`#F6F7F8`), 900 (`#28333E`), 1000 (`#051B2C`) plus Carbon 100-800.

## Approved Accessibility Pairing Patterns

Prefer these combinations from the guideline's WCAG section:

- On dark/background colors (Background Red/Violet/Blue/Teal, Dark Red/Violet/Blue/Teal, Carbon 800): use white text.
- On light/medium colors (Light Red/Violet/Blue/Teal, Carbon 100-400): use black text.
- Brand Red specifically: white text (AA).
- Medium Violet and Peacock-like mid tones require careful contrast checking before use.

## Typography Specifications

### Primary Brand Fonts

- `Moderat`:
  - Allowed for marketing: Regular, Medium, Bold (+ italics where appropriate)
  - Web/product-only weights: Thin, Light, Black (and italics)
- `Moderat Mono`:
  - Allowed for marketing: Regular, Medium, Bold
  - Web/product-only weights: Thin, Light, Black

### Fallback Fonts (Non-Marketing Docs Only)

Use only when Moderat fonts are unavailable (e.g., Microsoft Office, Google Workspace):

- `DM Sans`: Light, Regular, Medium, Bold (+ italics)
- `DM Mono`: Regular, Medium

### Typographic Use

- Large headlines: Moderat Bold or Medium (line spacing ~1.1-1.2x).
- Body/captions/legal: Moderat Regular (line spacing ~1.2-1.4x).
- Code snippets/small labels/eyebrows/sign-offs: Moderat Mono Regular.
- Standalone numerals: Moderat Mono Regular with slashed zero where available.
- Numeral style: prefer lining numerals (proportional for body, tabular for aligned lists/tables).

## High-Risk Violations Checklist

Reject and fix if any are present:

- Logo or symbol distortion, recolor, effects, rotation, skew.
- Logo used as running text or logotype alone.
- One-color positive logo used in full-color contexts.
- One-color reverse logo used on non-Brand-Red in full-color print.
- Logo/symbol placed on colors outside approved palette or on photography.
- Typography in brand colors (instead of black/white).
- Moderat Mono used for body text or oversized display headlines.
- Cornerstone with multiple hues, colored/solid grid lines, uncropped standalone usage.
- Icon sets mixing inconsistent stroke weights or using filled icon shapes.

## File Selection Notes (Asset Naming)

Typical naming pattern:

- `TiDB-Logo-[w-tagline]-[Full-Pos|Full-Rev|1c-Pos|1c-Rev]-[RGB|CMYK|PMS].[ext]`

Format guidance:

- RGB/Hex files for digital.
- CMYK/Pantone files for print.
- Vector (`.ai`, `.pdf`, `.svg`) preferred for scaling.
- Raster (`.png`) should not be upscaled beyond native resolution.

## Presentation Setup

- Widescreen by default: `16:9`.
- Apply TiDB presentation slide template.
