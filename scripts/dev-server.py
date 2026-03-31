#!/usr/bin/env python3
"""dev-server — 项目本地开发服务器（预览用）"""
import http.server, socketserver, os, sys
port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
os.chdir(os.path.dirname(os.path.abspath(__file__)) or '.')
print(f"🖥️  http://localhost:{port}")
socketserver.TCPServer(("", port), http.server.SimpleHTTPRequestHandler).serve_forever()
