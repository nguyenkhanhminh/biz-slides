#!/usr/bin/env bash
# export-pdf.sh — Export an HTML slide deck to PDF
#
# Usage:
#   bash scripts/export-pdf.sh <deck.html> [output.pdf] [--compact]
#
# Options:
#   --compact    Render at 1280×720 instead of 1920×1080 (smaller file, ~50-70% size reduction)
#
# Requirements:
#   - Node.js (brew install node or https://nodejs.org)
#   - Playwright installs automatically on first run

set -euo pipefail

INPUT="${1:-}"
OUTPUT="${2:-}"
COMPACT=false
for arg in "$@"; do [[ "$arg" == "--compact" ]] && COMPACT=true; done

if [[ -z "$INPUT" ]]; then
    echo "Usage: bash scripts/export-pdf.sh <deck.html> [output.pdf] [--compact]"
    exit 1
fi

if [[ -z "$OUTPUT" || "$OUTPUT" == "--compact" ]]; then
    OUTPUT="${INPUT%.html}.pdf"
fi

# ── Dimensions ───────────────────────────────────────────────────────────────
if $COMPACT; then
    WIDTH=1280; HEIGHT=720
    echo "→ Compact mode: 1280×720 (smaller file)"
else
    WIDTH=1920; HEIGHT=1080
    echo "→ Full quality: 1920×1080"
fi

# ── Check Node ───────────────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
    echo "Node.js is required. Install: https://nodejs.org"
    exit 1
fi

# ── Write export script ──────────────────────────────────────────────────────
SCRIPT=$(mktemp /tmp/export-XXXXXX.mjs)
trap 'rm -f "$SCRIPT"' EXIT

cat > "$SCRIPT" << JSEOF
import { chromium } from 'playwright';
import { createServer } from 'http';
import { readFileSync, createReadStream, writeFileSync } from 'fs';
import { join, dirname, basename, extname } from 'path';
import { fileURLToPath } from 'url';
import { PDFDocument } from 'pdf-lib';

const INPUT = process.argv[2];
const OUTPUT = process.argv[3];
const WIDTH = parseInt(process.argv[4]);
const HEIGHT = parseInt(process.argv[5]);
const baseDir = dirname(INPUT);

// Serve local files over HTTP so fonts and relative paths work
const server = createServer((req, res) => {
    const filePath = join(baseDir, decodeURIComponent(req.url.split('?')[0]));
    try {
        const data = readFileSync(filePath);
        const ext = extname(filePath).toLowerCase();
        const mime = {
            '.html': 'text/html', '.css': 'text/css', '.js': 'application/javascript',
            '.png': 'image/png', '.jpg': 'image/jpeg', '.svg': 'image/svg+xml',
            '.woff2': 'font/woff2', '.woff': 'font/woff',
        };
        res.writeHead(200, { 'Content-Type': mime[ext] || 'application/octet-stream' });
        res.end(data);
    } catch {
        res.writeHead(404); res.end();
    }
});

await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const { port } = server.address();
const url = \`http://127.0.0.1:\${port}/\${basename(INPUT)}\`;

const browser = await chromium.launch();
const page = await browser.newPage();
await page.setViewportSize({ width: WIDTH, height: HEIGHT });
await page.goto(url, { waitUntil: 'networkidle' });

// Count slides
const slideCount = await page.evaluate(() =>
    document.querySelectorAll('.slide').length);

if (slideCount === 0) {
    console.error('No .slide elements found. Check that slides use class="slide".');
    process.exit(1);
}

console.log(\`Found \${slideCount} slides. Capturing...\`);

const screenshots = [];
for (let i = 0; i < slideCount; i++) {
    // Navigate to slide i
    await page.evaluate(i => {
        const slides = document.querySelectorAll('.slide');
        slides.forEach((s, idx) => {
            s.classList.toggle('active', idx === i);
            s.classList.remove('exit-left', 'exit-right');
        });
        // Trigger reveals
        slides[i].querySelectorAll('.reveal').forEach(el => el.classList.add('visible'));
        // Update progress bar
        const bar = document.getElementById('progressBar');
        if (bar) bar.style.width = ((i + 1) / slides.length * 100) + '%';
    }, i);

    await page.waitForTimeout(300); // let animations settle
    const screenshot = await page.screenshot({ type: 'png' });
    screenshots.push(screenshot);
    process.stdout.write(\`  \${i + 1}/\${slideCount}\\r\`);
}

await browser.close();
server.close();

// Combine into PDF
const pdf = await PDFDocument.create();
for (const png of screenshots) {
    const img = await pdf.embedPng(png);
    const page_ = pdf.addPage([WIDTH, HEIGHT]);
    page_.drawImage(img, { x: 0, y: 0, width: WIDTH, height: HEIGHT });
}
writeFileSync(OUTPUT, await pdf.save());
console.log(\`\nDone: \${OUTPUT}\`);
JSEOF

# ── Install Playwright if needed ─────────────────────────────────────────────
if ! node -e "require.resolve('playwright')" 2>/dev/null; then
    echo "Installing Playwright (first run — downloads ~150MB Chromium)…"
    npm install --save-dev playwright pdf-lib 2>/dev/null || npx playwright install chromium
fi

if ! node -e "require.resolve('pdf-lib')" 2>/dev/null; then
    npm install pdf-lib 2>/dev/null || npm install --global pdf-lib
fi

# ── Run ──────────────────────────────────────────────────────────────────────
echo "Exporting $INPUT → $OUTPUT"
node "$SCRIPT" "$INPUT" "$OUTPUT" "$WIDTH" "$HEIGHT"

# ── Open result ──────────────────────────────────────────────────────────────
SIZE=$(du -sh "$OUTPUT" | cut -f1)
echo "✓ PDF saved: $OUTPUT ($SIZE)"

if [[ "$SIZE" > "10M" ]]; then
    echo ""
    echo "Tip: File is large. Re-run with --compact flag to reduce by ~60%:"
    echo "  bash scripts/export-pdf.sh $INPUT $OUTPUT --compact"
fi

# Open on macOS/Linux
if command -v open &>/dev/null; then
    open "$OUTPUT"
elif command -v xdg-open &>/dev/null; then
    xdg-open "$OUTPUT"
fi
