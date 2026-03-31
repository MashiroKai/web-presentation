#!/bin/bash
# build.sh — Build self-contained index.html (inline all pages)
# Usage: bash build.sh [project-dir]
# Output: build/index.html (does NOT overwrite source index.html)
set -e

PROJECT_DIR="${1:-.}"
INDEX="$PROJECT_DIR/index.html"
MANIFEST="$PROJECT_DIR/manifest.json"
BUILD_DIR="$PROJECT_DIR/build"
BUILD_INDEX="$BUILD_DIR/index.html"

if [[ ! -f "$INDEX" ]]; then
  echo "❌ index.html not found in $PROJECT_DIR"
  exit 1
fi

# Read page list from manifest.json using python3
PAGES=$(python3 -c "
import json, glob, os
with open('$MANIFEST') as f:
    m = json.load(f)
pages = m.get('pages', [])
if isinstance(pages, list) and all(isinstance(p, str) for p in pages):
    for p in pages:
        print(p)
else:
    for f in sorted(glob.glob('$PROJECT_DIR/pages/*.html')):
        print(os.path.relpath(f, '$PROJECT_DIR'))
")

# Build inline sections
SECTIONS=""
for page in $PAGES; do
  filepath="$PROJECT_DIR/$page"
  if [[ -f "$filepath" ]]; then
    content=$(cat "$filepath")
    SECTIONS="$SECTIONS
      <!-- $page -->
      $content"
  else
    echo "⚠️  Missing: $page"
  fi
done

# Read slide dimensions from manifest (default 16:9)
SLIDE_RATIO=$(python3 -c "
import json
try:
    with open('$MANIFEST') as f:
        m = json.load(f)
    print(m.get('slideRatio', '16:9'))
except: print('16:9')
")
if [ "$SLIDE_RATIO" = "4:3" ]; then
  SLIDE_W=1440; SLIDE_H=1080
else
  SLIDE_W=1920; SLIDE_H=1080
fi

# Create build directory
mkdir -p "$BUILD_DIR"

# Build standalone index.html
cat > "$BUILD_INDEX" << HEADER
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Web Presentation</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reset.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/plugin/highlight/monokai.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0/dist/katex.min.css">
HEADER

# Inline style.css if exists
if [[ -f "$PROJECT_DIR/style.css" ]]; then
  echo "  <style>" >> "$BUILD_INDEX"
  cat "$PROJECT_DIR/style.css" >> "$BUILD_INDEX"
  echo "  </style>" >> "$BUILD_INDEX"
fi

# Overflow prevention CSS
cat >> "$BUILD_INDEX" << 'OVERFLOW_CSS'
  <style>
    .reveal .slides section {
      overflow: hidden !important;
      max-width: 100% !important;
      max-height: 100% !important;
      box-sizing: border-box !important;
    }
    .reveal .slides section {
      display: flex !important;
      flex-direction: column !important;
      align-items: center !important;
      justify-content: center !important;
      text-align: center !important;
      padding: 5% 10% !important;
      max-width: 100% !important;
    }
    .reveal .slides section > * {
      max-width: 75% !important;
      margin-left: auto !important;
      margin-right: auto !important;
    }
    .reveal .slides section ul,
    .reveal .slides section ol {
      text-align: left !important;
      display: inline-block !important;
      margin: 0 auto !important;
      max-width: 100% !important;
    }
    .reveal .slides section > * {
      max-width: 100%;
      box-sizing: border-box;
    }
    .reveal pre {
      max-height: 70vh !important;
      overflow: auto !important;
    }
    .reveal pre::-webkit-scrollbar { width: 4px; }
    .reveal pre::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.2); border-radius: 2px; }
    .reveal .controls { display: none !important; }
    .nav-controls {
      position: fixed; bottom: 36px; left: 50%; transform: translateX(-50%);
      display: flex; gap: 12px; z-index: 200;
    }
    .nav-btn {
      width: 42px; height: 42px; border-radius: 50%;
      border: 1.5px solid var(--nav-color, #2E5C8A);
      background: rgba(255,255,255,0.92); color: var(--nav-color, #2E5C8A);
      font-size: 20px; line-height: 1; cursor: pointer;
      transition: all 0.3s ease; display: flex; align-items: center; justify-content: center;
    }
    .nav-btn:hover { background: var(--nav-color, #2E5C8A); color: #fff; }
    .nav-btn:disabled { opacity: 0.2; cursor: not-allowed; }
    .nav-btn:disabled:hover { background: rgba(255,255,255,0.92); color: var(--nav-color, #2E5C8A); }
    .progress-bar {
      position: fixed; bottom: 0; left: 0; height: 3px;
      background: linear-gradient(90deg, var(--nav-color, #2E5C8A), var(--nav-color-secondary, #5A7D9A));
      transition: width 0.4s ease; z-index: 200;
    }
  </style>
OVERFLOW_CSS

cat >> "$BUILD_INDEX" << MID1
</head>
<body>
  <div class="reveal">
    <div class="slides">
MID1

# Insert all page sections
echo "$SECTIONS" >> "$BUILD_INDEX"

cat >> "$BUILD_INDEX" << MID2
    </div>
  </div>

  <!-- Custom Navigation Buttons -->
  <div class="nav-controls">
    <button class="nav-btn" id="prevBtn" onclick="Reveal.prev()">‹</button>
    <button class="nav-btn" id="nextBtn" onclick="Reveal.next()">›</button>
  </div>

  <!-- Progress Bar -->
  <div class="progress-bar" id="progressBar"></div>

  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/plugin/highlight/highlight.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/plugin/notes/notes.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/plugin/math/math.js"></script>
  <script>
    Reveal.initialize({
      hash: true,
      transition: 'fade',
      transitionSpeed: 'default',
      center: true,
      slideNumber: 'c/t',
      width: $SLIDE_W,
      height: $SLIDE_H,
      margin: 0.04,
      plugins: [ RevealHighlight, RevealNotes, RevealMath.KaTeX ]
    });
    function updateUI() {
      var idx = Reveal.getIndices();
      var total = Reveal.getTotalSlides();
      var cur = idx.h + 1;
      document.getElementById('progressBar').style.width = (cur / total * 100) + '%';
      document.getElementById('prevBtn').disabled = (cur <= 1);
      document.getElementById('nextBtn').disabled = (cur >= total);
    }
    Reveal.on('slidechanged', updateUI);
    Reveal.on('ready', updateUI);
  </script>
</body>
</html>
MID2

# Count pages
PAGE_COUNT=$(echo "$PAGES" | wc -l | tr -d ' ')
echo "✅ Built: $BUILD_INDEX ($PAGE_COUNT pages, self-contained)"
echo "   Source index.html preserved (dev mode with fetch)"
