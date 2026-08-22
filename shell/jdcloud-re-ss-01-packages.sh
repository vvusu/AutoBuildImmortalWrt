#!/bin/bash

# 按设备分支需求预装 HomeProxy 和 DNS 管理界面。
JDCLOUD_PACKAGES=""
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-compat kmod-tun kmod-inet-diag kmod-nft-tproxy bash curl ip-full unzip"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-homeproxy luci-i18n-homeproxy-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES sing-box"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-mosdns luci-i18n-mosdns-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-tailscale-community luci-i18n-tailscale-community-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-i18n-ttyd-zh-cn openssh-sftp-server"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-ddns-go luci-i18n-ddns-go-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-wol luci-i18n-wol-zh-cn luci-app-watchcat luci-i18n-watchcat-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES block-mount e2fsprogs kmod-fs-ext4 lsblk blkid"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-irqbalance luci-i18n-irqbalance-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-nlbwmon luci-i18n-nlbwmon-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-filemanager luci-i18n-filemanager-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-upnp luci-i18n-upnp-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-sqm luci-i18n-sqm-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES luci-app-ksmbd luci-i18n-ksmbd-zh-cn"
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES htop ethtool"
# 覆盖 build25.sh 的通用桌面插件，避免亚瑟镜像重新拉入磁盘管理依赖。
JDCLOUD_PACKAGES="$JDCLOUD_PACKAGES -luci-i18n-diskman-zh-cn"

export JDCLOUD_PACKAGES
