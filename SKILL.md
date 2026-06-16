---
name: biz-slides
description: Create sharp, data-forward HTML presentations for business, strategy, and analytics contexts. Use when the user wants to build a pitch deck, QBR, strategy review, or analyst-ready presentation — with or without existing data. Helps users discover their visual direction through preview samples rather than abstract style choices.
---

# Biz Slides

Create zero-dependency, business-grade HTML presentations that run entirely in the browser.  
Single HTML file. No npm. No build tools. Slide open, done.

---

## Core Principles

1. **Zero Dependencies** — One self-contained HTML file. Inline CSS + JS only.
2. **Show, Don't Tell** — Generate 3 real visual previews before the full deck. People pick what they see.
3. **Data-Forward** — Business presentations live or die on clarity of numbers. Prioritise scannable data, not decoration.
4. **No AI Slop** — No purple gradients, no Inter font, no generic corporate blue. Every deck should look like someone made a decision.
5. **Viewport-Locked (NON-NEGOTIABLE)** — Every slide fits 100vh exactly. Zero scrolling within slides. Content overflow = split into another slide.

---

## Viewport Fitting Rules

Apply to every `.slide` in every deck:

- `height: 100vh; height: 100dvh; overflow: hidden;`  
- All font sizes use `clamp(min, preferred, max)` — never fixed px  
- Images: `max-height: min(50vh, 400px)`  
- Breakpoints required for 700px, 600px, 500px viewport heights  
- `prefers-reduced-motion` support always included  
- **Never** use `-clamp()` or `-min()` directly — use `calc(-1 * clamp(...))`

### Content Density Limits Per Slide

| Slide Type     | Max Content                                         |
| -------------- | --------------------------------------------------- |
| Title          | 1 heading + subtitle + optional tagline             |
| Content        | 1 heading + 4–6 bullets OR 1 heading + 2 paragraphs |
| Metric Grid    | 1 heading + 4–6 KPI cards                           |
| Chart/Table    | 1 heading + 1 chart or table (max 8 rows)           |
| Quote          | 1 quote (max 3 lines) + attribution                 |
| Two-column     | 1 heading + 2 columns, 3 items each max             |

Exceeds limit? **Split into two slides. Never cram. Never scroll.**

---

## Phase 0: Detect Mode

- **Mode A: New Presentation** → start at Phase 1  
- **Mode B: Convert PPT/PDF** → go to Phase 4  
- **Mode C: Enhance Existing** → read it, apply modification rules below

### Mode C Modification Rules

Before editing existing slides:

1. Count existing elements vs density limits
2. Adding images: must use `max-height: min(50vh, 400px)` — split slide if already full
3. After any change: verify `overflow: hidden`, `clamp()` sizing, and content fits at 1280×720

---

## Phase 1: Content Discovery

Ask all of these in a single prompt — don't split into multiple questions:

**Purpose** — What is this for?  
Options: Pitch deck / QBR / Strategy review / Analyst brief / Board update / Team all-hands

**Length** — Approximately how many slides?  
Options: Short 5–10 / Medium 10–20 / Long 20+

**Content** — What do you have ready?  
Options: All content ready / Rough notes / Just the topic

**Editing** — Do you need to edit text in-browser after generation?  
- Yes → add inline edit mode (hover to activate, click to edit, Ctrl+S saves)  
- No → presentation only

**Data** — Does your presentation include numbers, metrics, or charts?  
Options: Yes, I'll provide data / Yes, use placeholder data / No data slides needed

If the user has content, ask them to paste or describe it now.

---

## Phase 2: Style Discovery

### Step 2.0: Style Path

Ask the user how they want to choose their visual direction:

- "Show me options" *(recommended)* → generate 3 previews based on mood → Step 2.1  
- "I know what I want" → show preset list from STYLE_PRESETS.md → skip to Phase 3

### Step 2.1: Mood Selection

Ask (multi-select, max 2):  
What feeling should the audience leave with?

- **Confident** — This team has command of the numbers
- **Strategic** — Big picture, long-term thinkers
- **Energised** — Moving fast, bold calls
- **Credible** — Rigorous, analyst-ready

### Step 2.2: Generate 3 Style Previews

Based on mood, generate 3 self-contained single-slide HTML previews (~60–100 lines each).  
Each preview should show: typography, colour palette, layout structure, and one animated reveal.

Read STYLE_PRESETS.md for full preset specs.

| Mood         | Suggested Presets                           |
| ------------ | ------------------------------------------- |
| Confident    | Signal Ink, Slate Command, Dark Data        |
| Strategic    | Chalk & Steel, Signal Ink, Swiss Command    |
| Energised    | Neon Sprint, Coral Drive, Split Bold        |
| Credible     | Ledger Light, Swiss Command, Dark Data      |

Save previews to `.claude-design/previews/` as style-a.html, style-b.html, style-c.html.  
Open all three automatically.

### Step 2.3: User Picks

Ask: Which style do you prefer?  
Options: Style A / Style B / Style C / Mix elements

If "Mix elements" → ask what to combine.

---

## Phase 3: Generate Presentation

Before generating, read:

- `STYLE_PRESETS.md` — full preset spec for chosen style  
- `viewport-base.css` — mandatory CSS (include **in full** in `<style>` block)  
- `html-template.md` — HTML architecture, keyboard nav, progress bar, edit mode  
- `animation-patterns.md` — animation reference for the chosen mood  

**Generation requirements:**

- Single self-contained HTML file, all CSS/JS inline  
- Full viewport-base.css included inside `<style>`  
- Fonts from Google Fonts only — never system fonts  
- Keyboard navigation: arrows, space bar, dot indicators  
- Comments: `/* === SECTION NAME === */` before every major block  
- If data slides requested: use CSS-only bar/metric layouts (no Chart.js dependency)

---

## Phase 4: PPT/PDF Conversion

1. Run `python scripts/extract-pptx.py <input.pptx> <output_dir>`  
   (install if needed: `pip install python-pptx`)
2. Present extracted content to user for confirmation
3. Proceed to Phase 2 for style selection
4. Generate HTML preserving text, images, and slide order

---

## Phase 5: Delivery

1. Delete `.claude-design/previews/` if it exists
2. Open with `open [filename].html`
3. Tell the user:
   - File location and slide count
   - Navigation: arrow keys, space bar, scroll/swipe, dot indicators
   - To customise: edit `:root` CSS variables for colours, swap the font `@import` link
   - If edit mode enabled: hover top-left or press E, click any text, Ctrl+S saves

---

## Phase 6: Share & Export (Optional)

After delivery, ask: *"Would you like to share this? I can deploy it to a live URL or export to PDF."*

Options:
- **Deploy to URL** (Vercel, free) → `bash scripts/deploy.sh ./my-deck.html`
- **Export to PDF** → `bash scripts/export-pdf.sh ./my-deck.html`
- **Both**
- **No thanks**

See full instructions in scripts/README.md.

---

## Supporting Files

| File                    | Purpose                                         | When to Read         |
| ----------------------- | ----------------------------------------------- | -------------------- |
| `STYLE_PRESETS.md`      | Visual presets: colours, fonts, signatures      | Phase 2              |
| `viewport-base.css`     | Mandatory responsive base CSS                   | Phase 3 (copy in)    |
| `html-template.md`      | HTML structure, JS, edit mode, nav patterns     | Phase 3              |
| `animation-patterns.md` | CSS/JS animation library for chosen mood        | Phase 3              |
| `scripts/extract-pptx.py` | PPT content extraction                        | Phase 4              |
| `scripts/deploy.sh`     | Deploy to Vercel                                | Phase 6              |
| `scripts/export-pdf.sh` | Export to PDF via Playwright                    | Phase 6              |
