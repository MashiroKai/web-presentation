#!/bin/bash
# init_project.sh — Initialize a new web-presentation project
# Usage: bash init_project.sh <project-name> <template> [output-dir]
# Example: bash init_project.sh my-talk academic

set -e

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_NAME="${1:?Usage: init_project.sh <project-name> <template> [output-dir]}"
TEMPLATE="${2:?Usage: init_project.sh <project-name> <template> [academic|tech-talk|project-review|minimal|custom]}"
OUTPUT_DIR="${3:-projects}"

# Auto-deduplicate: if OUTPUT_DIR already ends with PROJECT_NAME, strip it
if [[ "$OUTPUT_DIR" == */"$PROJECT_NAME" ]]; then
  OUTPUT_DIR="${OUTPUT_DIR%/$PROJECT_NAME}"
fi

PROJECT_DIR="$OUTPUT_DIR/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
  echo "❌ 项目目录已存在: $PROJECT_DIR"
  exit 1
fi

# Validate template
TEMPLATE_FILE="$SKILL_DIR/templates/$TEMPLATE.md"
if [[ ! -f "$TEMPLATE_FILE" && "$TEMPLATE" != "custom" ]]; then
  echo "❌ 未知模板: $TEMPLATE"
  echo "可用模板: academic, tech-talk, project-review, minimal, custom"
  exit 1
fi

echo "📁 创建项目: $PROJECT_NAME (模板: $TEMPLATE)"

# Create directory structure
mkdir -p "$PROJECT_DIR/src/pages"
mkdir -p "$PROJECT_DIR/assets"

# Copy base index.html into src/
cp "$SKILL_DIR/templates/base-index.html" "$PROJECT_DIR/src/index.html"

# Generate style.css from template
if [[ -f "$TEMPLATE_FILE" ]]; then
  echo "/* Generated from template: $TEMPLATE */" > "$PROJECT_DIR/src/style.css"
  # Extract CSS variables from template
  grep -A 50 '## 配色' "$TEMPLATE_FILE" | grep -E '^\-|^[0-9]' | while IFS= read -r line; do
    # Parse color values
    if [[ "$line" =~ ^-\ *([^:]+):[[:space:]]*(#[0-9A-Fa-f]+) ]]; then
      var_name=$(echo "${BASH_REMATCH[1]}" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
      var_color="${BASH_REMATCH[2]}"
      echo "  --color-${var_name}: ${var_color};" >> "$PROJECT_DIR/style.css"
    fi
  done
else
  echo "/* Custom template — edit as needed */" > "$PROJECT_DIR/src/style.css"
fi

# Slide ratio (default 16:9, override with SLIDE_RATIO env var)
SLIDE_RATIO="${SLIDE_RATIO:-16:9}"

# Generate manifest.json
cat > "$PROJECT_DIR/manifest.json" << EOF
{
  "name": "$PROJECT_NAME",
  "template": "$TEMPLATE",
  "slideRatio": "$SLIDE_RATIO",
  "created": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "pages": []
}
EOF

# Generate project-index.md
cat > "$PROJECT_DIR/project-index.md" << 'EOF'
# 项目索引

## 项目信息
- 主题：（待填写）
- 场景：（待填写）
- 模板：TEMPLATE_NAME
- 创建：CREATED_DATE

## 文件清单

| 文件 | 用途 | 修改频率 |
|------|------|----------|
| index.html | 总控（导航/过渡/加载） | 低 |
| style.css | 全局样式 | 低 |
| manifest.json | 页面清单 + 元数据 | 低 |

## 页面列表

_（待添加页面）_

## 页面详情

_（待添加页面详情）_
EOF

# Replace placeholders
sed -i.bak "s/TEMPLATE_NAME/$TEMPLATE/g" "$PROJECT_DIR/project-index.md"
sed -i.bak "s/CREATED_DATE/$(date +%Y-%m-%d)/g" "$PROJECT_DIR/project-index.md"
rm -f "$PROJECT_DIR/project-index.md.bak"

# Create a placeholder first page
cat > "$PROJECT_DIR/src/pages/01-title.html" << 'EOF'
<section>
  <h1>演示标题</h1>
  <p>副标题</p>
  <p><small>作者 · 日期</small></p>
</section>
EOF

# Copy dev-server.py for local preview
cp "$SKILL_DIR/scripts/dev-server.py" "$PROJECT_DIR/dev-server.py"
chmod +x "$PROJECT_DIR/dev-server.py"

# Update manifest with first page
python3 -c "
import json
with open('$PROJECT_DIR/manifest.json') as f:
    m = json.load(f)
m['pages'] = ['src/pages/01-title.html']
with open('$PROJECT_DIR/manifest.json', 'w') as f:
    json.dump(m, f, indent=2, ensure_ascii=False)
"

echo ""
echo "✅ 项目创建完成: $PROJECT_DIR"
echo ""
echo "📁 结构:"
echo "  $PROJECT_NAME/"
echo "  ├── index.html        ← 构建产物（双击可打开）"
echo "  ├── dev-server.py     ← 本地预览服务器"
echo "  ├── project-index.md"
echo "  ├── manifest.json"
echo "  ├── assets/"
echo "  └── src/"
echo "      ├── index.html    ← 开发版（动态加载 pages）"
echo "      ├── style.css"
echo "      └── pages/"
echo "          └── 01-title.html"
echo ""
echo "🚀 下一步:"
echo "  1. 编辑 project-index.md 填写项目信息"
echo "  2. 在 src/pages/ 下创建演示页面，并更新 src/index.html 的 PAGE_MANIFEST"
echo "  3. 启动本地预览：python3 dev-server.py"
echo "  4. 浏览器打开 http://localhost:8000/src/"
