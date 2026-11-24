#!/bin/bash
# ============================================================
# VLESS + WebSocket 一键部署脚本
# 适用: Render / Railway / Koyeb / Back4App / 任意支持 Docker 的平台
# 特点: 走 443 端口 + WebSocket，抗封锁强
# ============================================================
set -e

UUID="${UUID:-bf25f908-0d27-4f29-ad42-ac526998b3bc}"
PORT="${PORT:-10000}"
WS_PATH="${WS_PATH:-/vless}"

echo "===================================="
echo " UUID    : ${UUID}"
echo " Port    : ${PORT}"
echo " WS Path : ${WS_PATH}"
echo "===================================="

# 生成 xray 配置
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "${UUID}", "flow": "" }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${WS_PATH}"
        }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ]
}
EOF

echo "[+] 配置已生成:"
cat /etc/xray/config.json

echo "[+] 启动 Xray..."
exec /usr/local/bin/xray -c /etc/xray/config.json
