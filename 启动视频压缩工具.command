#!/bin/bash
# 视频压缩工具 · macOS 启动脚本
cd "$(dirname "$0")" || { echo "无法定位脚本目录"; exit 1; }

if ! command -v python3 >/dev/null 2>&1; then
  echo "未找到 python3。请在终端运行 xcode-select --install 安装后重试。"
  read -r -n 1 -s
  exit 1
fi

PORT=8765
while [ "$PORT" -le 8795 ]; do
  if ! nc -z 127.0.0.1 "$PORT" >/dev/null 2>&1; then
    break
  fi
  PORT=$((PORT + 1))
done

if [ "$PORT" -gt 8795 ]; then
  echo "本地端口 8765-8795 均被占用，请关闭占用程序后重试。"
  read -r -n 1 -s
  exit 1
fi

URL="http://127.0.0.1:$PORT/视频压缩.html"
echo "视频压缩工具已启动：$URL"
echo "关闭本窗口即可停止。"

( sleep 1; open "$URL" ) >/dev/null 2>&1 &
exec python3 -m http.server "$PORT" --bind 127.0.0.1
