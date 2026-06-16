#!/usr/bin/env bash
# deploy.sh — Deploy a biz-slides presentation to Vercel
#
# Usage:
#   bash scripts/deploy.sh ./my-deck.html
#   bash scripts/deploy.sh ./my-deck/
#
# Requirements:
#   - Node.js (brew install node or https://nodejs.org)
#   - Vercel account (free at https://vercel.com/signup)
#   - First run: npx vercel login

set -euo pipefail

INPUT="${1:-}"
if [[ -z "$INPUT" ]]; then
    echo "Usage: bash scripts/deploy.sh <file-or-folder>"
    exit 1
fi

# ── Resolve deploy target ───────────────────────────────────────────────────
DEPLOY_DIR=$(mktemp -d)
trap 'rm -rf "$DEPLOY_DIR"' EXIT

if [[ -d "$INPUT" ]]; then
    # Folder: copy everything, Vercel serves index.html
    cp -r "$INPUT"/. "$DEPLOY_DIR/"
    echo "→ Deploying folder: $INPUT"
elif [[ -f "$INPUT" && "$INPUT" == *.html ]]; then
    # Single HTML file: rename to index.html, copy any referenced local assets
    cp "$INPUT" "$DEPLOY_DIR/index.html"

    # Auto-detect local asset references in src="..." and url(...)
    ASSETS=$(grep -oE '(src|href)="(?!http)[^"]*\.(png|jpg|jpeg|gif|svg|webp|mp4|woff2?)"' "$INPUT" \
        | grep -oE '"[^"]*"' | tr -d '"' || true)
    BASE_DIR=$(dirname "$INPUT")
    for asset in $ASSETS; do
        src="$BASE_DIR/$asset"
        dst="$DEPLOY_DIR/$asset"
        mkdir -p "$(dirname "$dst")"
        [[ -f "$src" ]] && cp "$src" "$dst" && echo "  Bundled: $asset"
    done
    echo "→ Deploying file: $INPUT"
else
    echo "Error: Input must be an HTML file or a folder."
    exit 1
fi

# ── Check Vercel CLI ─────────────────────────────────────────────────────────
if ! npx vercel --version &>/dev/null; then
    echo "Vercel CLI not found. Install Node.js first: https://nodejs.org"
    exit 1
fi

# ── Check login ──────────────────────────────────────────────────────────────
if ! npx vercel whoami &>/dev/null; then
    echo ""
    echo "You're not logged in to Vercel."
    echo "1. Sign up free at https://vercel.com/signup"
    echo "2. Then run: npx vercel login"
    echo "3. Re-run this script after logging in."
    exit 1
fi

# ── Deploy ───────────────────────────────────────────────────────────────────
echo ""
echo "Deploying to Vercel…"
URL=$(npx vercel --yes --prod "$DEPLOY_DIR" 2>&1 | grep -E 'https://[^ ]+\.vercel\.app' | tail -1)

echo ""
echo "✓ Live at: $URL"
echo ""
echo "Tips:"
echo "  • Works on phones, tablets, and desktops — share freely"
echo "  • To take it down: https://vercel.com/dashboard → delete the project"
echo "  • Run this script again to update the same URL (redeploy overwrites)"
