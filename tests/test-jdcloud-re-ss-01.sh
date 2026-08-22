#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW="$ROOT_DIR/.github/workflows/build-wireless-router25.12.yml"
SUPPORT="$ROOT_DIR/SUPPORT.md"
BUILD_SCRIPT="$ROOT_DIR/mediatek-filogic/build25.sh"
PACKAGE_FILE="$ROOT_DIR/shell/jdcloud-re-ss-01-packages.sh"
VERIFIER="$ROOT_DIR/shell/verify-jdcloud-re-ss-01-image.sh"
FACTORY_PATCHER="$ROOT_DIR/shell/enable-jdcloud-re-ss-01-factory.sh"

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

assert_contains() {
    local file="$1"
    local text="$2"
    grep -Fq -- "$text" "$file" || fail "$file is missing: $text"
}

assert_contains "$WORKFLOW" "- jdcloud_re-ss-01"
assert_contains "$WORKFLOW" "jdcloud_re-ss-01|glinet_gl-axt1800|glinet_gl-ax1800)"
assert_contains "$WORKFLOW" "tag=qualcommax-ipq60xx-snapshot"
assert_contains "$WORKFLOW" 'echo "platform=qualcommax/ipq60xx" >> "$GITHUB_ENV"'
assert_contains "$SUPPORT" "jdcloud_re-ss-01"

if grep -E 'jdcloud_re-ss-01.*mediatek/filogic|mediatek/filogic.*jdcloud_re-ss-01' "$WORKFLOW" >/dev/null; then
    fail "JDCloud RE-SS-01 must not be mapped to MediaTek Filogic"
fi

test -f "$PACKAGE_FILE" || fail "missing Arthur-specific package file"
assert_contains "$BUILD_SCRIPT" 'source shell/jdcloud-re-ss-01-packages.sh'
assert_contains "$BUILD_SCRIPT" 'verify-jdcloud-re-ss-01-image.sh'
assert_contains "$BUILD_SCRIPT" 'if ! bash shell/verify-jdcloud-re-ss-01-image.sh'

# shellcheck disable=SC1090
source "$PACKAGE_FILE"
for package in luci-app-homeproxy sing-box \
    luci-app-mosdns luci-app-tailscale-community \
    luci-i18n-ttyd-zh-cn luci-app-ddns-go \
    luci-app-wol luci-app-watchcat block-mount \
    e2fsprogs kmod-fs-ext4 luci-app-irqbalance \
    luci-app-nlbwmon luci-app-filemanager luci-app-upnp \
    luci-app-sqm luci-app-ksmbd htop ethtool; do
    [[ " $JDCLOUD_PACKAGES " == *" $package "* ]] || fail "Arthur package list is missing $package"
done

for package in luci-app-openclash luci-app-dockerman dockerd docker qemu-ga \
    luci-app-passwall luci-i18n-passwall-zh-cn geoview \
    xray-core hysteria luci-app-vnstat2 \
    tcpdump iperf3 bind-dig mtr-json; do
    [[ " $JDCLOUD_PACKAGES " != *" $package "* ]] || fail "Arthur package list must exclude $package"
done

for package in luci-i18n-diskman-zh-cn; do
    [[ " $JDCLOUD_PACKAGES " == *" -$package "* ]] || fail "Arthur package list must remove $package"
done

assert_contains "$BUILD_SCRIPT" 'libubox20260721-2026.07.21~e7608b69-r1.apk'
assert_contains "$BUILD_SCRIPT" 'libblobmsg-json20260721-2026.07.21~e7608b69-r1.apk'
assert_contains "$BUILD_SCRIPT" '488c471ab4874b15b14ef4be552ed64a31f6c14fa687e52df5bdf5beea49a63b'
assert_contains "$BUILD_SCRIPT" 'enable-jdcloud-re-ss-01-factory.sh'
assert_contains "$VERIFIER" 'MAX_FACTORY_SIZE_BYTES=62914560'

test -x "$VERIFIER" || fail "missing executable Arthur image verifier"
test -x "$FACTORY_PATCHER" || fail "missing executable Arthur factory patcher"

FIXTURE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/jdcloud-image-test.XXXXXX")"
trap 'rm -rf "$FIXTURE_DIR"' EXIT
cat > "$FIXTURE_DIR/ipq60xx.mk" <<'EOF'
define Device/jdcloud_re-ss-01
	$(call Device/FitImage)
endef
EOF
"$FACTORY_PATCHER" "$FIXTURE_DIR/ipq60xx.mk"
factory_line="$(sed -n '2p' "$FIXTURE_DIR/ipq60xx.mk")"
[[ "$factory_line" == $'\t$(call Device/EmmcImage)' ]] || \
    fail "factory patcher did not insert a real Makefile tab"
if [[ "$factory_line" == *'\t'* ]]; then
    fail "factory patcher inserted a literal backslash-t"
fi

printf '%s\n' '{"supported_devices":["jdcloud,re-ss-01"]}' > \
    "$FIXTURE_DIR/immortalwrt-qualcommax-ipq60xx-jdcloud_re-ss-01-squashfs-sysupgrade.bin"
printf 'fake factory image\n' > \
    "$FIXTURE_DIR/immortalwrt-qualcommax-ipq60xx-jdcloud_re-ss-01-squashfs-factory.bin"
"$VERIFIER" "$FIXTURE_DIR" >/dev/null || fail "verifier rejected valid Arthur fixtures"

printf '%s\n' '{"supported_devices":["jdcloud,ax1800-pro"]}' > \
    "$FIXTURE_DIR/immortalwrt-qualcommax-ipq60xx-jdcloud_re-ss-01-squashfs-sysupgrade.bin"
if "$VERIFIER" "$FIXTURE_DIR" >/dev/null 2>&1; then
    fail "verifier accepted legacy jdcloud,ax1800-pro metadata"
fi

echo "PASS: JDCloud RE-SS-01 workflow mapping"
