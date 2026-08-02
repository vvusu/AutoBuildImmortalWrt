# ImmortalWrt 插件参考手册

> 本文档整理了当前项目中所有可用插件的分类说明，以及 25.12.x 构建脚本中已默认启用的插件列表。

## 目录

- [当前 25.12.x 已启用的插件](#当前-2512x-已启用的插件)
- [可用但未启用的第三方插件](#可用但未启用的第三方插件)
  - [科学上网 / 代理](#科学上网--代理)
  - [内网穿透 / VPN](#内网穿透--vpn)
  - [网络工具 / DDNS](#网络工具--ddns)
  - [文件共享 / 网盘](#文件共享--网盘)
  - [下载 / P2P](#下载--p2p)
  - [网络管理 / 监控](#网络管理--监控)
  - [IPTV / 流媒体](#iptv--流媒体)
  - [系统工具](#系统工具)
  - [QoS / 限速 / 广告过滤](#qos--限速--广告过滤)
  - [智能家居 / IoT](#智能家居--iot)
  - [其他实用工具](#其他实用工具)
- [如何启用插件](#如何启用插件)
- [插件冲突注意事项](#插件冲突注意事项)

---

## 当前 25.12.x 已启用的插件

> 配置文件：`x86-64/build25.sh`

| 插件名 | 用途 |
|--------|------|
| `curl` | 网络传输工具 |
| `luci-i18n-diskman-zh-cn` | 磁盘管理 |
| `luci-i18n-firewall-zh-cn` | 防火墙管理（中文） |
| `luci-theme-argon` | Argon 主题 |
| `luci-app-argon-config` | Argon 主题配置 |
| `luci-i18n-argon-config-zh-cn` | Argon 配置中文 |
| `luci-i18n-package-manager-zh-cn` | 软件包管理器 |
| `luci-i18n-ttyd-zh-cn` | Web 终端 |
| `openssh-sftp-server` | SFTP 文件传输 |
| `luci-i18n-filemanager-zh-cn` | 文件管理器 |
| `luci-i18n-dockerman-zh-cn` | Docker 管理器（workflow 勾选 Docker 时生效） |
| `luci-app-store` | iStore 应用商店（workflow 勾选 Store 时生效） |

---

## 可用但未启用的第三方插件

> 配置文件：
> - 25.12.x (apk)：`shell/apk-custom-packages.sh`
> - 24.10.x (ipk)：`shell/custom-packages.sh`

### 科学上网 / 代理

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-nikki-zh-cn` | Nikki — 新一代代理工具 |
| `luci-app-ssr-plus` + mihomo core | SSR+ — 经典代理工具，自带 mihomo 内核 |
| `luci-app-passwall2` + sing-box 等 | PassWall2 — 功能丰富的代理客户端 |
| `luci-i18n-passwall` + sing-box 等 | PassWall — 代理客户端 |
| `luci-app-openclash` + clash_meta | OpenClash — Clash 图形化管理，自带 clash 内核 |
| `luci-i18n-homeproxy-zh-cn` | HomeProxy — 基于 sing-box 的代理工具 |
| `luci-i18n-dae-zh-cn` | Dae — 基于 eBPF 的透明代理 |
| `luci-i18n-daed-zh-cn` (1.28.0) | Daed — Dae 的 Web 管理界面 |
| `clashoo` + `luci-app-clashoo` | Clashoo — Clash 另一实现（⚠️ 与 nikki 冲突） |

### 内网穿透 / VPN

| 插件名 | 说明 |
|--------|------|
| `luci-proto-wireguard` | WireGuard — 高性能 VPN |
| `luci-app-tailscale-community` | Tailscale — 零配置组网 |
| `luci-i18n-zerotier-zh-cn` | ZeroTier — 虚拟局域网 |
| `luci-i18n-frpc-zh-cn` | FRP 客户端 — 内网穿透 |
| `luci-i18n-frps-zh-cn` | FRP 服务端 — 内网穿透 |
| `luci-i18n-ngrokc-zh-cn` | ngrok — 内网穿透 |
| `luci-i18n-nps-zh-cn` | NPS — 功能完善的内网穿透 |
| `luci-i18n-xfrpc-zh-cn` | XFRPC — 内网穿透客户端 |
| `luci-i18n-openvpn-zh-cn` | OpenVPN — 传统 VPN |
| `luci-i18n-ipsec-vpnd-zh-cn` | IPSec VPN 服务器 |

### 网络工具 / DDNS

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-ddns-go-zh-cn` | DDNS-Go — 动态域名（推荐） |
| `luci-i18n-ddns-zh-cn` | 传统 DDNS |
| `luci-i18n-smartdns-zh-cn` | SmartDNS — DNS 分流加速 |
| `luci-i18n-upnp-zh-cn` | UPnP — 自动端口映射 |
| `luci-i18n-unbound-zh-cn` | Unbound — 高性能 DNS 解析 |
| `luci-i18n-https-dns-proxy-zh-cn` | HTTPS DNS 代理 |
| `luci-i18n-nextdns-zh-cn` | NextDNS — 云端 DNS 过滤 |
| `luci-i18n-cloudflared-zh-cn` | Cloudflare Tunnel |

### 文件共享 / 网盘

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-samba4-zh-cn` | Samba — Windows 文件共享 |
| `luci-i18n-ksmbd-zh-cn` | KSmbd — 内核级文件共享（更高性能） |
| `luci-i18n-nfs-zh-cn` | NFS — Linux 文件共享 |
| `luci-i18n-openlist-zh-cn` | OpenList — 网盘聚合管理 |
| `luci-i18n-filebrowser-go-zh-cn` | FileBrowser（Go 版）— Web 文件管理 |
| `luci-i18n-filebrowser-zh-cn` | FileBrowser — Web 文件管理 |
| `luci-i18n-cifs-mount-zh-cn` | CIFS 挂载 |
| `luci-i18n-dufs-zh-cn` | Dufs — 静态文件服务器 |
| `bash` + `quickfile` + `luci-app-quickfile` | QuickFile — 文件管理器（⚠️ 与 Run 安装器冲突） |

### 下载 / P2P

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-transmission-zh-cn` | Transmission — BT 下载 |
| `luci-i18n-qbittorrent-zh-cn` | qBittorrent — BT 下载 |
| `luci-i18n-aria2-zh-cn` | Aria2 — 多协议下载 |
| `luci-i18n-amule-zh-cn` | aMule — 电驴下载 |

### 网络管理 / 监控

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-netdata-zh-cn` | NetData — 实时系统监控（推荐） |
| `luci-i18n-vnstat2-zh-cn` | VNStat — 流量统计 |
| `bandix` + `luci-app-bandix` | Bandix — 流量监控（by timsaya） |
| `luci-i18n-nlbwmon-zh-cn` | 网络带宽监控 |
| `luci-i18n-statistics-zh-cn` | 统计图表（collectd） |
| `luci-i18n-uhttpd-zh-cn` | Web 服务管理 |
| `luci-i18n-watchcat-zh-cn` | Watchcat — 看门狗（网络断线自动重启） |
| `luci-i18n-snmpd-zh-cn` | SNMP 监控 |
| `luci-i18n-lldpd-zh-cn` | LLDP — 链路层发现 |

### IPTV / 流媒体

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-udpxy-zh-cn` | UDPXY — IPTV 组播转发 |
| `luci-app-rtp2httpd` | RTP 转 HTTP — IPTV 流媒体转发 |
| `luci-i18n-minidlna-zh-cn` | MiniDLNA — DLNA 媒体服务器 |
| `luci-i18n-msd_lite-zh-cn` | MSD Lite — 多媒体服务 |

### 系统工具

| 插件名 | 说明 |
|--------|------|
| `luci-app-partexp` | 分区扩容（by sirpdboy） |
| `luci-app-lucky` | Lucky 大吉 — 多功能工具（DDNS/端口转发/反代等） |
| `luci-app-taskplan` | 任务计划 — 定时任务管理（by sirpdboy） |
| `luci-i18n-quickstart-zh-cn` | 首页和网络向导（依赖 iStore 商店） |
| `luci-app-run` | Run 安装器 — 快速安装 makeself 打包的 run 文件 |
| `luci-theme-aurora` + `luci-app-aurora-config` | 极光主题（by eamonxg） |
| `luci-i18n-commands-zh-cn` | 自定义命令 |
| `luci-i18n-wol-zh-cn` | 网络唤醒 |
| `luci-i18n-timewol-zh-cn` | 定时网络唤醒 |
| `luci-i18n-autoreboot-zh-cn` | 定时重启 |
| `luci-i18n-attendedsysupgrade-zh-cn` | 系统在线升级 |
| `luci-i18n-advanced-reboot-zh-cn` | 高级重启 |
| `luci-app-watchdog` | 看门狗（by sirpdboy） |
| `luci-app-uninstall` | 高级卸载（by YT Video Talk） |
| `luci-i18n-cpulimit-zh-cn` | CPU 限速 |

### QoS / 限速 / 广告过滤

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-qos-zh-cn` | QoS — 流量限速 |
| `luci-i18n-nft-qos-zh-cn` | NFT QoS — 基于 nftables 的限速 |
| `luci-i18n-sqm-zh-cn` | SQM — 智能队列管理（抗缓冲膨胀） |
| `luci-i18n-eqos-zh-cn` | EQoS — 按设备限速 |
| `luci-i18n-adblock-fast-zh-cn` | 快速广告过滤 |
| `luci-i18n-adblock-zh-cn` | 传统广告过滤 |
| `luci-app-adguardhome` | AdGuard Home — DNS 级去广告 |
| `luci-i18n-banip-zh-cn` | BanIP — IP 黑名单封禁 |
| `luci-i18n-privoxy-zh-cn` | Privoxy — 代理过滤 |
| `luci-i18n-appfilter-zh-cn` | 应用过滤 — 按应用管控上网 |
| `luci-app-mosdns` | MosDNS — DNS 分流解析 |

### 智能家居 / IoT

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-mosquitto-zh-cn` | Mosquitto — MQTT Broker |
| `luci-i18n-airplay2-zh-cn` | AirPlay2 — 苹果投屏 |
| `luci-i18n-spotifyd-zh-cn` | Spotify 播放支持 |
| `luci-i18n-music-remote-center-zh-cn` | 音乐遥控中心 |
| `luci-i18n-mjpg-streamer-zh-cn` | USB 摄像头推流 |

### 其他实用工具

| 插件名 | 说明 |
|--------|------|
| `luci-i18n-wechatpush-zh-cn` | 微信推送通知（设备上线/离线报警等） |
| `luci-i18n-hd-idle-zh-cn` | 硬盘休眠管理 |
| `luci-i18n-syncthing-zh-cn` | Syncthing — P2P 文件同步 |
| `luci-i18n-rclone-zh-cn` | Rclone — 云盘同步 |
| `luci-i18n-radicale-zh-cn` | Radicale — CalDAV/CardDAV 日历联系人 |
| `luci-i18n-oled-zh-cn` | OLED 屏幕显示 |
| `luci-i18n-p910nd-zh-cn` | 打印服务器 |
| `luci-i18n-usb-printer-zh-cn` | USB 打印机支持 |
| `luci-i18n-vlmcsd-zh-cn` | KMS 激活服务器 |
| `luci-i18n-tinyproxy-zh-cn` | TinyProxy — 轻量 HTTP 代理 |
| `luci-i18n-squid-zh-cn` | Squid — 代理缓存服务器 |
| `luci-i18n-haproxy-tcp-zh-cn` | HAProxy — TCP 负载均衡 |
| `luci-i18n-keepalived-zh-cn` | Keepalived — 高可用 |
| `luci-i18n-gost-zh-cn` | Gost — 多协议隧道 |
| `luci-i18n-n2n-zh-cn` | N2N — 轻量 VPN |
| `luci-i18n-mwan3-zh-cn` | MWAN3 — 多 WAN 负载均衡 |
| `luci-i18n-travelmate-zh-cn` | Travelmate — 旅行路由管理 |
| `luci-i18n-ua2f-zh-cn` | UA2F — User-Agent 混淆 |
| `luci-i18n-tor-zh-cn` | Tor — 匿名网络 |
| `luci-i18n-rustdesk-server-zh-cn` | RustDesk Server — 远程桌面服务端 |
| `luci-i18n-softethervpn-zh-cn` | SoftEther VPN — 多协议 VPN |

---

## 如何启用插件

### 25.12.x 固件（apk 格式）

编辑 `shell/apk-custom-packages.sh`，取消对应行的 `#` 注释。

### 24.10.x 固件（ipk 格式）

编辑 `shell/custom-packages.sh`，取消对应行的 `#` 注释。

### 示例

启用 SSR+ 和 PassWall2：

```bash
# 取消注释这两行：
CUSTOM_PACKAGES="$CUSTOM_PACKAGES kmod-nft-tproxy kmod-nft-socket xray-core naiveproxy luci-app-ssr-plus luci-i18n-ssr-plus-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES geoview xray-core sing-box hysteria kmod-nft-socket kmod-nft-tproxy luci-app-passwall2 luci-i18n-passwall2-zh-cn"
```

启用 OpenClash（脚本会自动下载 clash_meta 内核 + GeoIP/GeoSite 数据库）：

```bash
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash luci-compat kmod-tun kmod-inet-diag kmod-nft-tproxy bash curl ip-full unzip"
```

改完后 push 到远端，重新触发 workflow 即可。

---

## 插件冲突注意事项

| 冲突项 | 说明 |
|--------|------|
| `luci-app-clashoo` vs `luci-i18n-nikki-zh-cn` | 两者配置冲突，不能同时集成 |
| `luci-app-quickfile` vs `luci-app-run` | nginx 配置冲突，不能同时集成 |
| `luci-app-advancedplus` vs `luci-app-argon-config` | 两者功能重叠，集成 advancedplus 时需排除 argon-config |
| `luci-app-openclash` vs `luci-app-ssr-plus` | 可共存但通常不需要同时用两个代理核心 |
| 硬路由闪存限制 | 闪存空间有限时，酌情开启插件，避免固件过大或构建失败 |
