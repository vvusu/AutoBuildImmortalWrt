#!/bin/bash
source shell/apk-custom-packages.sh

# 京东云亚瑟使用独立清单，不随全局 PVE 配置继续漂移；Docker 始终排除。
if [ "$PROFILE" = "jdcloud_re-ss-01" ]; then
  source shell/jdcloud-re-ss-01-packages.sh
  CUSTOM_PACKAGES="$JDCLOUD_PACKAGES"
  if [ "$INCLUDE_DOCKER" = "yes" ]; then
    echo "⚠️ 亚瑟首版固件不集成 Docker，已忽略 INCLUDE_DOCKER=yes"
    INCLUDE_DOCKER="no"
  fi
fi
#echo "✅ 你选择了第三方软件包：$CUSTOM_PACKAGES"
if [ -z "$CUSTOM_PACKAGES" ]; then
  echo "⚪️ 未选择 任何第三方软件包"
else
  # ============= 同步第三方插件库==============
  # 同步第三方软件仓库run/apk
  echo "🔄 正在同步第三方软件仓库 Cloning apk file repo..."
  git clone --depth=1 https://github.com/wukongdaily/apk.git /tmp/store-apk-repo

  # 拷贝 run/arm64 下所有 run 文件和apk文件 到 extra-packages 目录
  mkdir -p /home/build/immortalwrt/extra-packages
  cp -r /tmp/store-apk-repo/run/arm64-a53/* /home/build/immortalwrt/extra-packages/

  echo "✅ Run files copied to extra-packages:"
  # 解压并拷贝apk到packages目录
  sh shell/apk-prepare-packages.sh

  # MosDNS 不在 25.12 ImageBuilder 默认仓库中，使用上游发布的 aarch64_cortex-a53 APK。
  if echo " $CUSTOM_PACKAGES " | grep -q " luci-app-mosdns "; then
    MOSDNS_ARCHIVE="aarch64_cortex-a53-openwrt-25.12.tar.gz"
    MOSDNS_URL="https://github.com/sbwml/luci-app-mosdns/releases/latest/download/$MOSDNS_ARCHIVE"
    MOSDNS_TMP="$(mktemp -d /tmp/mosdns-apk.XXXXXX)"

    echo "🔄 正在下载 MosDNS v5 for OpenWrt 25.12..."
    if ! curl -fL --retry 3 --connect-timeout 10 \
      -o "$MOSDNS_TMP/$MOSDNS_ARCHIVE" "$MOSDNS_URL"; then
      echo "❌ MosDNS APK 下载失败"
      exit 1
    fi
    if ! tar -xzf "$MOSDNS_TMP/$MOSDNS_ARCHIVE" -C "$MOSDNS_TMP"; then
      echo "❌ MosDNS APK 解压失败"
      exit 1
    fi
    cp "$MOSDNS_TMP"/packages_ci/*.apk /home/build/immortalwrt/packages/
    rm -rf "$MOSDNS_TMP"
    echo "✅ MosDNS APK packages copied"
  fi

  ls -lah /home/build/immortalwrt/packages/
fi

# 2026-08 的 IPQ60xx Snapshot ImageBuilder 与滚动 APK 仓库短暂错位：
# target 中的 mtd/block-mount 仍依赖 20260721 ABI，而 ImmortalWrt base 索引已移除它。
# OpenWrt 同架构仓库保留了完全相同 ABI 的构建，固定文件名和 SHA-256 后作为临时兼容包。
if [ "$PROFILE" = "jdcloud_re-ss-01" ]; then
  COMPAT_BASE_URL="https://downloads.openwrt.org/snapshots/packages/aarch64_cortex-a53/base"
  download_compat_apk() {
    apk_name="$1"
    apk_sha256="$2"
    apk_path="/home/build/immortalwrt/packages/$apk_name"
    echo "🔄 下载 Snapshot ABI 兼容包：$apk_name"
    curl -fL --retry 3 --connect-timeout 10 -o "$apk_path" "$COMPAT_BASE_URL/$apk_name"
    echo "$apk_sha256  $apk_path" | sha256sum -c -
  }

  download_compat_apk \
    "libubox20260721-2026.07.21~e7608b69-r1.apk" \
    "488c471ab4874b15b14ef4be552ed64a31f6c14fa687e52df5bdf5beea49a63b"
  download_compat_apk \
    "libblobmsg-json20260721-2026.07.21~e7608b69-r1.apk" \
    "431defe92018b21b29cc6af699903c3d57900bcb7b1699a7ef6659de47d07793"
fi



# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"

echo "Include Docker: $INCLUDE_DOCKER"
echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入pppoe变量————>pppoe-settings文件
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."


# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl luci luci-i18n-base-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-theme-argon"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
# 文件管理器
PACKAGES="$PACKAGES luci-i18n-filemanager-zh-cn"


# 第三方软件包 合并
# ======== shell/apk-custom-packages.sh =======
PACKAGES="$PACKAGES $CUSTOM_PACKAGES"


# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "Adding package: luci-i18n-dockerman-zh-cn"
fi

# 若构建openclash 则添加内核
if echo "$PACKAGES" | grep -q "luci-app-openclash"; then
    if [ "$PROFILE" = "jdcloud_re-ss-01" ]; then
      echo "✅ 亚瑟仅预装 OpenClash UI；核心和 Geo 数据留待首次启动后写入 overlay"
    else
      echo "✅ 已选择 luci-app-openclash，添加 openclash core"
      mkdir -p files/etc/openclash/core
      # Download clash_meta
      META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
      wget -qO- "$META_URL" | tar xOvz > files/etc/openclash/core/clash_meta
      chmod +x files/etc/openclash/core/clash_meta
      # Download GeoIP and GeoSite
      wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -O files/etc/openclash/GeoIP.dat
      wget -q https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -O files/etc/openclash/GeoSite.dat
    fi
    # Download latest openclash Client
    URL=$(curl -s https://api.github.com/repos/vernesong/OpenClash/releases/latest \
      | grep "browser_download_url.*apk" \
      | head -n1 \
      | cut -d '"' -f 4)
    echo "OpenClash latest apk: $URL"
    wget "$URL" -P /home/build/immortalwrt/packages/
else
    echo "⚪️ 未选择 luci-app-openclash"
fi


# Snapshot 尚未给亚瑟声明 eMMC factory 产物；安全 U-Boot 首刷需要 rootfs factory.bin。
if [ "$PROFILE" = "jdcloud_re-ss-01" ]; then
  DEVICE_MAKEFILE="target/linux/qualcommax/image/ipq60xx.mk"
  bash shell/enable-jdcloud-re-ss-01-factory.sh "$DEVICE_MAKEFILE"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files"

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

if [ "$PROFILE" = "jdcloud_re-ss-01" ]; then
    if ! bash shell/verify-jdcloud-re-ss-01-image.sh /home/build/immortalwrt/bin; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Arthur artifact safety verification failed!"
        exit 1
    fi
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
