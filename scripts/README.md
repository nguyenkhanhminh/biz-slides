# Scripts

Helper scripts for PPT extraction, deployment, and PDF export.

---

## extract-pptx.py

Extract content from PowerPoint files for conversion.

```bash
# Install dependency (once)
pip install python-pptx

# Run
python scripts/extract-pptx.py ./my-deck.pptx ./extracted/
```

**Output:**
- `extracted/content.md` — all text, titles, bullets, notes
- `extracted/manifest.json` — structured slide manifest for the agent
- `extracted/assets/` — all images from the PPTX

---

## deploy.sh

Deploy a presentation to a free Vercel live URL.

```bash
# Single HTML file
bash scripts/deploy.sh ./my-deck.html

# Folder with index.html + assets
bash scripts/deploy.sh ./my-deck/
```

**First time:**
1. Sign up free at https://vercel.com/signup
2. `npx vercel login`
3. Then run the script

The URL stays live until you delete the project at https://vercel.com/dashboard.  
Re-running the script updates the same URL.

---

## export-pdf.sh

Export slides to PDF. Each slide becomes a full-resolution page.

```bash
# Default: 1920×1080 output
bash scripts/export-pdf.sh ./my-deck.html

# Specify output path
bash scripts/export-pdf.sh ./my-deck.html ./my-deck-v2.pdf

# Compact mode: 1280×720, ~60% smaller file
bash scripts/export-pdf.sh ./my-deck.html output.pdf --compact
```

**First run** installs Playwright (~150MB Chromium download) — takes 30–60s.  
Subsequent runs are fast.

**Note:** Animations are not preserved in PDF. The export captures each slide's final visual state.

---

## Requirements

| Script          | Requirements                              |
| --------------- | ----------------------------------------- |
| extract-pptx.py | Python 3, `pip install python-pptx`       |
| deploy.sh       | Node.js, Vercel account (free)            |
| export-pdf.sh   | Node.js (Playwright installs itself)      |
