# biz-slides

A coding-agent skill for creating sharp, data-forward HTML presentations — for business, strategy, and analytics contexts. Built for Claude Code and compatible with any agent that can read files and run shell commands.

---

## What This Does

**biz-slides** helps analysts, strategists, and operators create presentation-quality HTML slide decks without touching CSS or JavaScript. It uses a **show, don't tell** approach: instead of asking you to describe your visual preferences in words, it generates previews you can actually look at and pick from.

Outputs are single `.html` files — no npm, no dependencies, no build step. Open in browser, present, done.

---

## Key Features

- **Zero dependencies** — every deck is one self-contained HTML file
- **Business-grade presets** — 8 opinionated visual systems designed for strategy/analytics contexts
- **Data patterns** — CSS-only KPI cards, bar charts, comparison grids — no Chart.js
- **Style discovery** — generate 3 previews, pick what you see, not what you describe
- **PPT conversion** — convert existing PPTX files to web
- **Deploy or export** — one command to a live Vercel URL or PDF
- **No AI slop** — no Inter font, no purple gradients, no generic corporate blue

---

## Installation

### Claude Code (plugin)

```bash
/plugin marketplace add https://github.com/YOUR_USERNAME/biz-slides

/plugin install biz-slides@biz-slides
```

Then invoke with: `/biz-slides:biz-slides`

### Claude Code (manual)

```bash
git clone https://github.com/YOUR_USERNAME/biz-slides.git ~/.claude/skills/biz-slides
```

Invoke with: `/biz-slides`

### Other Agents

Point the agent at this repo and ask it to follow `SKILL.md`.  
All core logic is in `SKILL.md`; supporting files are loaded on demand.

---

## Usage

### Create a New Deck

```
/biz-slides

> "I need a QBR deck for our Vietnam market — 12 slides, subscription growth focus"
```

The skill will:
1. Ask for your content, format, and any data
2. Show you 3 visual style previews
3. Let you pick
4. Generate the full deck
5. Open it in your browser

### Convert a PowerPoint

```
/biz-slides

> "Convert my Q3-review.pptx to a web deck"
```

### Share

```bash
# Deploy to a live URL (Vercel, free)
bash scripts/deploy.sh ./my-deck.html

# Export to PDF
bash scripts/export-pdf.sh ./my-deck.html
```

---

## Style Presets

### Dark

| Preset         | Vibe                              |
| -------------- | --------------------------------- |
| Signal Ink     | Authoritative, gold-on-black      |
| Slate Command  | Enterprise-grade, teal split panel|
| Dark Data      | Analytical, emerald table accent  |

### Light

| Preset         | Vibe                              |
| -------------- | --------------------------------- |
| Chalk & Steel  | Executive, print-quality editorial|
| Ledger Light   | Financial-grade, accounting-rigorous |
| Swiss Command  | Minimal, Bauhaus — ideas first    |

### Specialty

| Preset         | Vibe                              |
| -------------- | --------------------------------- |
| Neon Sprint    | Startup bold, high energy         |
| Coral Drive    | Warm, modern, creative-commercial |

---

## File Structure

```
biz-slides/
├── SKILL.md               # Core workflow — start here
├── STYLE_PRESETS.md       # Visual system specs
├── viewport-base.css      # Mandatory responsive CSS (included in every deck)
├── html-template.md       # HTML architecture + JS patterns
├── animation-patterns.md  # Animation library by mood
├── scripts/
│   ├── extract-pptx.py    # PPT content extraction
│   ├── deploy.sh          # Deploy to Vercel
│   └── export-pdf.sh      # Export to PDF
└── README.md
```

---

## Requirements

- A coding agent with filesystem + shell access
- Python 3 + `python-pptx` for PPT conversion
- Node.js + Vercel account (free) for URL deployment
- Node.js for PDF export (Playwright installs automatically)

---

## Philosophy

1. Numbers should be readable at a glance. Data slides exist to transfer insight, not show off.
2. One self-contained file will work in 10 years. A React deck from last year might not.
3. Generic looks forgettable. Every deck gets a visual identity — not a template.
4. The agent does the CSS. You do the thinking.

---

## License

MIT
