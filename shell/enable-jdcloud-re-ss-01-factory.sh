#!/usr/bin/env bash

set -euo pipefail

DEVICE_MAKEFILE="${1:-target/linux/qualcommax/image/ipq60xx.mk}"
test -f "$DEVICE_MAKEFILE" || {
    echo "❌ Device Makefile 不存在：$DEVICE_MAKEFILE" >&2
    exit 1
}

device_block="$(sed -n '/^define Device\/jdcloud_re-ss-01$/,/^endef$/p' "$DEVICE_MAKEFILE")"
test -n "$device_block" || {
    echo "❌ 没有找到 Device/jdcloud_re-ss-01 定义" >&2
    exit 1
}

if printf '%s\n' "$device_block" | grep -Fq '$(call Device/EmmcImage)'; then
    echo "✅ 亚瑟 factory image 定义已经存在"
    exit 0
fi

temporary_file="$(mktemp "${DEVICE_MAKEFILE}.XXXXXX")"
trap 'rm -f "$temporary_file"' EXIT
awk '
    { print }
    $0 == "define Device/jdcloud_re-ss-01" {
        print "\t$(call Device/EmmcImage)"
    }
' "$DEVICE_MAKEFILE" > "$temporary_file"
mv "$temporary_file" "$DEVICE_MAKEFILE"
trap - EXIT

echo "✅ 已为亚瑟启用 eMMC factory.bin"
