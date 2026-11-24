# VLESS VPN on Render

免卡部署 VLESS + WebSocket 代理。

## 部署到 Render

1. 把这个仓库推到你的 GitHub
2. Render → New → Web Service → 连接仓库
3. Runtime 选 **Docker**
4. 环境变量：
   - `UUID` = 你的 UUID
   - `WS_PATH` = `/vless`
5. Deploy，拿到地址 `https://xxx.onrender.com`

## 客户端配置

```
vless://<UUID>@xxx.onrender.com:443?encryption=none&security=tls&sni=xxx.onrender.com&fp=chrome&type=ws&host=xxx.onrender.com&path=%2Fvless#Render
```

## 注意

Render 免费实例 15 分钟无流量会休眠，下次访问唤醒约 60 秒。配个 UptimeRobot 每 10 分钟 ping 一次可以保持常驻。
