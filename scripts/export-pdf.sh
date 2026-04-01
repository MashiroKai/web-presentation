#!/bin/bash
# export-pdf.sh — Export presentation to PDF (all fragments fully revealed)
# Requires: node, puppeteer (auto-installed)
# Usage: bash export-pdf.sh [project-dir] [output.pdf]

set -e

PROJECT_DIR="${1:-.}"
OUTPUT="${2:-$PROJECT_DIR/presentation.pdf}"
BUILD_INDEX="$PROJECT_DIR/index.html"

# ── Step 1: Build (inline all pages) ──
# index.html uses fetch() which doesn't work on file:// protocol.
# Must build a self-contained version first.
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "📦 Building self-contained index.html..."
bash "$SKILL_DIR/scripts/build.sh" "$PROJECT_DIR"

if [[ ! -f "$BUILD_INDEX" ]]; then
  echo "❌ Build failed: $BUILD_INDEX not found"
  exit 1
fi

# Check node
if ! command -v node >/dev/null 2>&1; then
  echo "❌ node required for PDF export"
  exit 1
fi

# Install puppeteer if needed
if ! node -e "require('puppeteer')" 2>/dev/null; then
  echo "📦 Installing puppeteer..."
  npm install --prefix /tmp/ppt-export puppeteer --silent 2>/dev/null
  PUPPETEER_PATH="/tmp/ppt-export/node_modules"
else
  PUPPETEER_PATH=""
fi

# Create export script
EXPORT_JS=$(cat << 'SCRIPT'
const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');

(async () => {
  const projectDir = process.argv[1];
  const output = process.argv[2];
  const indexHtml = path.resolve(projectDir, 'index.html');

  if (!fs.existsSync(indexHtml)) {
    console.error('❌ index.html not found');
    process.exit(1);
  }

  console.log('🚀 Launching browser...');
  const browser = await puppeteer.launch({
    headless: 'new',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  // Parse slide size from manifest (default 16:9)
  const manifestPath = path.join(projectDir, 'manifest.json');
  let slideWidth = 1920;
  let slideHeight = 1080;
  if (fs.existsSync(manifestPath)) {
    try {
      const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
      const ratio = manifest.slideRatio || manifest.slide_ratio || '16:9';
      if (ratio === '4:3') { slideWidth = 1440; slideHeight = 1080; }
    } catch(e) {}
  }

  // Viewport MUST match Reveal.js canvas size, with 2x device scale for sharpness
  const page = await browser.newPage();
  await page.setViewport({ width: slideWidth, height: slideHeight, deviceScaleFactor: 2 });

  // Load presentation
  console.log('📄 Loading presentation...');
  await page.goto('file://' + indexHtml, { waitUntil: 'networkidle0', timeout: 30000 });

  // Wait for Reveal.js to initialize
  await page.waitForFunction(() => typeof Reveal !== 'undefined' && Reveal.isReady(), { timeout: 10000 });

  // Get total number of slides
  const totalSlides = await page.evaluate(() => {
    return document.querySelectorAll('.reveal .slides section').length;
  });
  console.log(`📊 Total slides: ${totalSlides}`);

  // Create a new page for PDF generation (print-friendly)
  const pdfPages = [];

  for (let i = 0; i < totalSlides; i++) {
    // Navigate to slide
    await page.evaluate((slideIndex) => {
      Reveal.slide(slideIndex, 0);
    }, i);

    // Wait for transition
    await new Promise(r => setTimeout(r, 300));

    // Reveal all fragments on this slide
    await page.evaluate(() => {
      const fragments = document.querySelectorAll('.reveal .slides section.present .fragment:not(.visible)');
      fragments.forEach(f => f.classList.add('visible'));
    });

    // Wait for fragment animations
    await new Promise(r => setTimeout(r, 500));

    // Capture screenshot at high resolution
    const screenshot = await page.screenshot({ type: 'png', fullPage: false });
    pdfPages.push(screenshot);

    console.log(`  ✅ Slide ${i + 1}/${totalSlides}`);
  }

  // Build PDF from screenshots using a print page
  console.log('📝 Generating PDF...');

  // Create HTML with all slide images at native resolution
  let html = `<!DOCTYPE html><html><head><style>
    @page { size: ${slideWidth}px ${slideHeight}px; margin: 0; }
    body { margin: 0; padding: 0; }
    .page { width: ${slideWidth}px; height: ${slideHeight}px; page-break-after: always; margin: 0; padding: 0; }
    .page:last-child { page-break-after: auto; }
    img { width: ${slideWidth}px; height: ${slideHeight}px; display: block; }
  </style></head><body>`;

  for (let i = 0; i < pdfPages.length; i++) {
    const base64 = pdfPages[i].toString('base64');
    html += `<div class="page"><img src="data:image/png;base64,${base64}"></div>`;
  }
  html += '</body></html>';

  // Write temp HTML (use absolute path)
  const tmpHtml = path.resolve(projectDir, '.tmp-pdf.html');
  fs.writeFileSync(tmpHtml, html);

  // Load and print
  const pdfPage = await browser.newPage();
  await pdfPage.goto('file://' + tmpHtml, { waitUntil: 'networkidle0' });
  await pdfPage.pdf({
    path: output,
    width: slideWidth,
    height: slideHeight,
    printBackground: true,
    margin: { top: 0, right: 0, bottom: 0, left: 0 }
  });

  // Cleanup
  fs.unlinkSync(tmpHtml);
  await browser.close();

  console.log(`\n✅ PDF exported: ${output}`);
})();
SCRIPT
)

# Run export
if [[ -n "$PUPPETEER_PATH" ]]; then
  NODE_PATH="$PUPPETEER_PATH" node -e "$EXPORT_JS" -- "$PROJECT_DIR" "$OUTPUT"
else
  node -e "$EXPORT_JS" -- "$PROJECT_DIR" "$OUTPUT"
fi
