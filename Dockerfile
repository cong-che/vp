FROM alpine:latest

RUN apk add --no-cache curl unzip ca-certificates bash tzdata

# 下载 Xray 二进制，多个源依次尝试
RUN set -eux; \
    for url in \
      "https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
      "https://gh-proxy.com/https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
      "https://ghproxy.net/https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
    ; do \
      echo "trying $url"; \
      if curl -fsSL --retry 3 --retry-delay 2 --max-time 180 -o /tmp/xray.zip "$url"; then \
        echo "downloaded from $url"; break; \
      fi; \
    done; \
    unzip /tmp/xray.zip -d /tmp/xray; \
    mv /tmp/xray/xray /usr/local/bin/xray; \
    chmod +x /usr/local/bin/xray; \
    rm -rf /tmp/xray*; \
    /usr/local/bin/xray version

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV UUID=bf25f908-0d27-4f29-ad42-ac526998b3bc
ENV WS_PATH=/vless

EXPOSE 10000

CMD ["/entrypoint.sh"]
