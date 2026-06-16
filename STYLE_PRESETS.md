# Style Presets Reference

Visual systems for business, strategy, and analytics presentations.  
Every preset is a deliberate design decision — not a default. **No Inter. No purple gradients. No generic corporate blue.**

For mandatory base CSS, see `viewport-base.css`. Include in every presentation.

---

## Dark Themes

### 1. Signal Ink

**Vibe:** Authoritative, high-contrast, institutional weight

**Layout:** Full-bleed dark canvas. Title anchored bottom-left. Bold metric accent top-right.

**Typography:**
- Display: `Instrument Serif` (400 italic / 700)
- Body: `DM Mono` (400)

**Colors:**
```css
:root {
    --bg: #0e0e0e;
    --surface: #1a1a1a;
    --text-primary: #f0ede8;
    --text-secondary: #7a7672;
    --accent: #e8c547;       /* muted gold */
    --accent-dim: #3d3520;
}
```

**Signature Elements:**
- Gold metric callout — large monospaced number, small uppercase label
- Thin horizontal rule dividers
- Italic serif for headlines; mono for data
- Stagger-reveal animation: content slides up at 60ms intervals

---

### 2. Slate Command

**Vibe:** Clean authority, data-primary, enterprise-grade

**Layout:** Dark slate background. Split panel: content left, metric/chart area right.

**Typography:**
- Display: `Syne` (700/800)
- Body: `Jost` (300/400)
- Data: `Space Mono` (400)

**Colors:**
```css
:root {
    --bg: #13161c;
    --panel-left: #1c2028;
    --panel-right: #111318;
    --text-primary: #e4e6ea;
    --text-muted: #5a5f6b;
    --accent: #4fc4cf;       /* teal */
    --accent-warm: #e07a5f;  /* coral counter-accent */
}
```

**Signature Elements:**
- Vertical teal divider line between panels
- Monospaced data in teal; narrative text in light Jost
- Section label: uppercase, letter-spaced, muted
- Fade-in + slide from left for text; counter-animation from right for data

---

### 3. Dark Data

**Vibe:** Analytical, precise, terminal-adjacent but polished

**Layout:** Near-black background. Table or grid centred. Accent rows on key data.

**Typography:**
- Display: `Archivo Black` (900)
- Body: `IBM Plex Sans` (300/400)
- Data: `IBM Plex Mono` (400)

**Colors:**
```css
:root {
    --bg: #0a0c10;
    --surface: #141720;
    --row-alt: #1a1d25;
    --text-primary: #d8dce6;
    --text-muted: #4a4f5e;
    --accent: #6ee7b7;       /* emerald */
    --accent-highlight: #0d2c21;
}
```

**Signature Elements:**
- Hairline borders on table rows
- Emerald accent on key row / highlighted cell
- Uppercase compressed column headers
- Numbers right-aligned, mono; labels left-aligned, sans

---

## Light Themes

### 4. Chalk & Steel

**Vibe:** Executive, confident, print-quality

**Layout:** Off-white / warm paper background. Full-width layout. Steel-blue structural accents.

**Typography:**
- Display: `Cormorant` (600 italic / 700)
- Body: `Jost` (300/400)

**Colors:**
```css
:root {
    --bg: #f7f5f1;
    --surface: #ffffff;
    --text-primary: #1c1c1c;
    --text-muted: #888580;
    --accent: #2c4a6e;      /* steel blue */
    --accent-light: #dce6f0;
    --rule: #d8d4ce;
}
```

**Signature Elements:**
- Italic serif display headlines — confident, editorial
- Steel-blue left border on blockquote/callout slides
- Thin `<hr>` style dividers (1px, warm grey)
- Clean white data cards with hairline shadow

---

### 5. Ledger Light

**Vibe:** Rigorous, analyst-ready, financial-grade

**Layout:** Cream/white with a visible structure. Header stripe. Data-first layout.

**Typography:**
- Display: `Bricolage Grotesque` (700/800)
- Body: `Source Sans 3` (300/400)
- Data: `Space Mono` (400)

**Colors:**
```css
:root {
    --bg: #fafaf8;
    --header-stripe: #1a1a1a;
    --text-on-stripe: #f5f4f0;
    --text-primary: #1a1a1a;
    --text-muted: #7a7a78;
    --accent: #c0392b;      /* accounting red */
    --accent-positive: #1a7a4a;  /* accounting green */
    --border: #e0ddd8;
}
```

**Signature Elements:**
- Black header stripe with white title (ledger-book aesthetic)
- Red/green for negative/positive values only — never decorative
- Grid lines in data slides, very light
- Zero border-radius on cards — squared, rigorous

---

### 6. Swiss Command

**Vibe:** Minimal, precise, Bauhaus-adjacent — for ideas that stand on their own

**Layout:** Pure white. Black type. Single accent colour used exactly once per slide.

**Typography:**
- Display: `Barlow Condensed` (700/800 uppercase)
- Body: `Barlow` (300/400)

**Colors:**
```css
:root {
    --bg: #ffffff;
    --text-primary: #111111;
    --text-muted: #888888;
    --accent: #e84000;       /* vermilion — used sparingly */
    --rule: #e0e0e0;
}
```

**Signature Elements:**
- Condensed uppercase display — massive, fills width
- Vermilion used only for the single most important element per slide
- Grid-structure visible in layout (columns align to a clear system)
- No shadows. No gradients. No radius.

---

## Specialty Themes

### 7. Neon Sprint

**Vibe:** Fast-moving, startup energy, bold conviction

**Typography:** `Clash Display` (Fontshare) + `Satoshi` (Fontshare)

**Colors:** Deep navy (`#0a0f1c`), neon green (`#00ff88`), electric orange (`#ff5c00`)

**Signature:** Neon glow text-shadow on key metric; animated counter on numbers

---

### 8. Coral Drive

**Vibe:** Warm, modern, creative-commercial

**Typography:** `Fraunces` (700/900) + `DM Sans` (300/400)

**Colors:** Off-white (`#f9f6f1`), coral (`#e8644a`), deep charcoal (`#1c1c1c`)

**Signature:** Full-bleed coral panel on title + section slides; white type punches through

---

## Font Pairing Quick Reference

| Preset          | Display               | Body            | Source    |
| --------------- | --------------------- | --------------- | --------- |
| Signal Ink      | Instrument Serif      | DM Mono         | Google    |
| Slate Command   | Syne                  | Jost            | Google    |
| Dark Data       | Archivo Black         | IBM Plex Sans   | Google    |
| Chalk & Steel   | Cormorant             | Jost            | Google    |
| Ledger Light    | Bricolage Grotesque   | Source Sans 3   | Google    |
| Swiss Command   | Barlow Condensed      | Barlow          | Google    |
| Neon Sprint     | Clash Display         | Satoshi         | Fontshare |
| Coral Drive     | Fraunces              | DM Sans         | Google    |

---

## DO NOT USE

**Fonts:** Inter, Roboto, Arial, Helvetica Neue as display  
**Colors:** `#6366f1` (generic indigo), any purple-on-white gradient  
**Patterns:** centered-only layouts, card grids where everything is the same size  
**Data decoration:** pie charts for comparison (use bar charts), meaningless icons beside KPIs

---

## CSS Gotchas

Negating CSS functions: always wrap in `calc()`.

```css
/* WRONG — silently ignored */
right: -clamp(28px, 3.5vw, 44px);

/* CORRECT */
right: calc(-1 * clamp(28px, 3.5vw, 44px));
```
