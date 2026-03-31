#!/usr/bin/env python3
"""
extract_pptx.py — 从 .pptx 文件提取设计风格信息

用法: python3 extract_pptx.py <file.pptx> [output_dir]

输出: <output_dir>/extracted-style.json — 包含配色、字体、布局等结构化数据

.pptx 是 ZIP 压缩包，内部结构:
  ppt/theme/theme1.xml      → 配色方案
  ppt/slideMasters/          → 母版（布局骨架）
  ppt/slideLayouts/          → 布局类型
  ppt/slides/                → 每页内容
  ppt/presentation.xml       → 全局设置（尺寸、页数）
"""

import zipfile
import xml.etree.ElementTree as ET
import json
import sys
import os

# OOXML 命名空间
NS = {
    'a': 'http://schemas.openxmlformats.org/drawingml/2006/main',
    'p': 'http://schemas.openxmlformats.org/presentationml/2006/main',
    'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
}

def xml_color_to_hex(color_elem):
    """将 OOXML 颜色元素转为 hex 值"""
    if color_elem is None:
        return None
    # srgbClr: 直接 RGB
    srgb = color_elem.find('a:srgbClr', NS)
    if srgb is not None:
        val = srgb.get('val')
        return f'#{val}' if val else None
    # schemeClr: 主题色引用
    scheme = color_elem.find('a:schemeClr', NS)
    if scheme is not None:
        return f'scheme:{scheme.get("val")}'
    # 直接 val 属性（某些简化格式）
    val = color_elem.get('val')
    if val and len(val) == 6:
        return f'#{val}'
    return None


def extract_colors(theme_root):
    """从 theme1.xml 提取配色方案"""
    colors = {}
    clr_scheme = theme_root.find('.//a:clrScheme', NS)
    if clr_scheme is None:
        return colors

    color_map = {
        'dk1': 'dark1',
        'lt1': 'light1',
        'dk2': 'dark2',
        'lt2': 'light2',
        'accent1': 'accent1',
        'accent2': 'accent2',
        'accent3': 'accent3',
        'accent4': 'accent4',
        'accent5': 'accent5',
        'accent6': 'accent6',
        'hlink': 'hyperlink',
    }

    for xml_name, friendly_name in color_map.items():
        elem = clr_scheme.find(f'a:{xml_name}', NS)
        if elem is not None:
            hex_val = xml_color_to_hex(elem)
            if hex_val:
                colors[friendly_name] = hex_val

    return colors


def extract_fonts(theme_root):
    """从 theme1.xml 提取字体方案"""
    fonts = {}
    font_scheme = theme_root.find('.//a:fontScheme', NS)
    if font_scheme is None:
        return fonts

    major = font_scheme.find('a:majorFont', NS)
    minor = font_scheme.find('a:minorFont', NS)

    if major is not None:
        latin = major.find('a:latin', NS)
        if latin is not None:
            fonts['heading'] = latin.get('typeface', 'unknown')
        ea = major.find('a:ea', NS)
        if ea is not None:
            fonts['heading_cjk'] = ea.get('typeface', '')

    if minor is not None:
        latin = minor.find('a:latin', NS)
        if latin is not None:
            fonts['body'] = latin.get('typeface', 'unknown')
        ea = minor.find('a:ea', NS)
        if ea is not None:
            fonts['body_cjk'] = ea.get('typeface', '')

    return fonts


def extract_slide_size(pres_root):
    """提取幻灯片尺寸"""
    size = pres_root.find('p:sldSz', NS)
    if size is not None:
        cx = int(size.get('cx', '0'))
        cy = int(size.get('cy', '0'))
        # EMU 转像素 (1 inch = 914400 EMU, 96 DPI)
        if cy > 0:
            ratio = cx / cy
            if abs(ratio - 16/9) < 0.05:
                return {'width': 1920, 'height': 1080, 'ratio': '16:9'}
            elif abs(ratio - 4/3) < 0.05:
                return {'width': 1440, 'height': 1080, 'ratio': '4:3'}
            else:
                return {'width': round(cx / 95.25), 'height': round(cy / 95.25), 'ratio': f'{cx}:{cy}'}
    return {'width': 1920, 'height': 1080, 'ratio': '16:9'}


def extract_layout_types(zf):
    """提取布局类型名称"""
    layouts = []
    layout_dir = 'ppt/slideLayouts/'
    for name in sorted(zf.namelist()):
        if name.startswith(layout_dir) and name.endswith('.xml'):
            try:
                tree = ET.parse(zf.open(name))
                root = tree.getroot()
                # cSld 的 name 属性
                cSld = root.find('p:cSld', NS)
                if cSld is not None:
                    layout_name = cSld.get('name', '')
                    if layout_name:
                        layouts.append(layout_name)
            except Exception:
                pass
    return layouts


def extract_bg_fills(theme_root, zf):
    """提取背景填充信息"""
    bg_info = []
    # 从 slide master 提取
    master_dir = 'ppt/slideMasters/'
    for name in zf.namelist():
        if name.startswith(master_dir) and name.endswith('.xml'):
            try:
                tree = ET.parse(zf.open(name))
                root = tree.getroot()
                bg = root.find('.//p:bg', NS)
                if bg is not None:
                    bgPr = bg.find('p:bgPr', NS)
                    if bgPr is not None:
                        solidFill = bgPr.find('a:solidFill', NS)
                        if solidFill is not None:
                            color = xml_color_to_hex(solidFill)
                            if color:
                                bg_info.append({'type': 'solid', 'color': color})
            except Exception:
                pass
    return bg_info


def analyze_slide_content(zf):
    """分析每页内容结构，提取动画和元素类型"""
    slide_analyses = []
    slide_dir = 'ppt/slides/'

    slide_files = sorted([
        n for n in zf.namelist()
        if n.startswith(slide_dir) and n.split('/')[-1].startswith('slide')
        and n.endswith('.xml')
    ])

    for name in slide_files:
        try:
            tree = ET.parse(zf.open(name))
            root = tree.getroot()
            analysis = {'file': name}

            # 动画
            timing = root.find('.//p:timing', NS)
            if timing is not None:
                analysis['has_animation'] = True
                # 简单统计动画数量
                anim_elements = root.findall('.//p:animEffect', NS) + \
                               root.findall('.//p:animClr', NS) + \
                               root.findall('.//p:animScale', NS) + \
                               root.findall('.//p:animRot', NS)
                analysis['animation_count'] = len(anim_elements)
            else:
                analysis['has_animation'] = False
                analysis['animation_count'] = 0

            # 元素类型
            elements = []
            if root.findall('.//a:p', NS):
                elements.append('text')
            if root.findall('.//a:blip', NS):
                elements.append('image')
            if root.findall('.//c:chart', NS):
                elements.append('chart')
            if root.findall('.//a:tbl', NS):
                elements.append('table')
            analysis['elements'] = elements

            # 背景色
            bg = root.find('.//p:bg', NS)
            if bg is not None:
                bgPr = bg.find('p:bgPr', NS)
                if bgPr is not None:
                    solidFill = bgPr.find('a:solidFill', NS)
                    if solidFill is not None:
                        color = xml_color_to_hex(solidFill)
                        if color:
                            analysis['bg_color'] = color

            slide_analyses.append(analysis)
        except Exception:
            pass

    return slide_analyses


def extract_all(pptx_path, output_dir=None):
    """主提取函数"""
    if output_dir is None:
        output_dir = os.path.dirname(pptx_path) or '.'

    os.makedirs(output_dir, exist_ok=True)

    result = {
        'source': os.path.basename(pptx_path),
        'slide_size': {},
        'colors': {},
        'fonts': {},
        'layouts': [],
        'backgrounds': [],
        'slide_analyses': [],
        'slide_count': 0,
    }

    with zipfile.ZipFile(pptx_path, 'r') as zf:
        # 主题配色和字体
        theme_path = 'ppt/theme/theme1.xml'
        if theme_path in zf.namelist():
            theme_tree = ET.parse(zf.open(theme_path))
            theme_root = theme_tree.getroot()
            result['colors'] = extract_colors(theme_root)
            result['fonts'] = extract_fonts(theme_root)

        # 幻灯片尺寸
        pres_path = 'ppt/presentation.xml'
        if pres_path in zf.namelist():
            pres_tree = ET.parse(zf.open(pres_path))
            pres_root = pres_tree.getroot()
            result['slide_size'] = extract_slide_size(pres_root)

        # 布局类型
        result['layouts'] = extract_layout_types(zf)

        # 背景
        result['backgrounds'] = extract_bg_fills(theme_root if 'ppt/theme/theme1.xml' in zf.namelist() else None, zf)

        # 每页分析
        result['slide_analyses'] = analyze_slide_content(zf)
        result['slide_count'] = len(result['slide_analyses'])

    # 输出
    output_path = os.path.join(output_dir, 'extracted-style.json')
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

    return result


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('用法: python3 extract_pptx.py <file.pptx> [output_dir]')
        print()
        print('输出 extracted-style.json，包含:')
        print('  - slide_size: 幻灯片尺寸和比例')
        print('  - colors: 主题配色方案')
        print('  - fonts: 字体方案（标题/正文）')
        print('  - layouts: 布局类型列表')
        print('  - slide_analyses: 每页元素和动画分析')
        sys.exit(1)

    pptx_file = sys.argv[1]
    out_dir = sys.argv[2] if len(sys.argv) > 2 else '.'

    if not os.path.exists(pptx_file):
        print(f'错误: 文件不存在 — {pptx_file}')
        sys.exit(1)

    data = extract_all(pptx_file, out_dir)
    print(f'✅ 提取完成: {data["slide_count"]} 页')
    print(f'   配色: {len(data["colors"])} 种')
    print(f'   字体: {data["fonts"]}')
    print(f'   尺寸: {data["slide_size"]}')
    print(f'   输出: {os.path.join(out_dir, "extracted-style.json")}')
