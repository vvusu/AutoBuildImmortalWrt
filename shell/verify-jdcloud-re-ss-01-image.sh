#!/usr/bin/env bash

set -euo pipefail

OUTPUT_DIR="${1:-/home/build/immortalwrt/bin}"
PROFILE_TOKEN="jdcloud_re-ss-01"
DEVICE_ID="jdcloud,re-ss-01"
LEGACY_ID="jdcloud,ax1800-pro"
MAX_FACTORY_SIZE_BYTES=62914560

fail() {
    echo "❌ $*" >&2
    exit 1
}

test -d "$OUTPUT_DIR" || fail "构建输出目录不存在：$OUTPUT_DIR"

artifacts=()
while IFS= read -r artifact; do
    artifacts+=("$artifact")
done < <(find "$OUTPUT_DIR" -type f -name "*${PROFILE_TOKEN}*" \
    \( -name '*.bin' -o -name '*.itb' -o -name '*.ubi' \) | sort)
((${#artifacts[@]} > 0)) || fail "没有找到 ${PROFILE_TOKEN} 的固件文件"

echo "=== JDCloud RE-SS-01 artifacts ==="
for artifact in "${artifacts[@]}"; do
    size="$(wc -c < "$artifact" | tr -d ' ')"
    digest="$(sha256sum "$artifact" | awk '{print $1}')"
    echo "$digest  $size bytes  $artifact"
done

sysupgrades=()
while IFS= read -r artifact; do
    test -n "$artifact" && sysupgrades+=("$artifact")
done < <(printf '%s\n' "${artifacts[@]}" | grep -- '-sysupgrade\.bin$' || true)
((${#sysupgrades[@]} == 1)) || fail "必须且只能生成一个亚瑟 sysupgrade.bin，实际为 ${#sysupgrades[@]} 个"

sysupgrade="${sysupgrades[0]}"
if grep -aFq "$LEGACY_ID" "$sysupgrade" && ! grep -aFq "$DEVICE_ID" "$sysupgrade"; then
    fail "检测到旧 LiBwrt 身份 ${LEGACY_ID}；它不能代替 Snapshot 身份 ${DEVICE_ID}"
fi
grep -aFq "$DEVICE_ID" "$sysupgrade" || \
    fail "sysupgrade 元数据不包含 ${DEVICE_ID}，拒绝发布"

recoveries=()
while IFS= read -r artifact; do
    test -n "$artifact" && recoveries+=("$artifact")
done < <(printf '%s\n' "${artifacts[@]}" | \
    grep -E -- '(initramfs.*\.itb|factory.*\.(bin|ubi)|recovery.*\.(bin|itb))$' || true)
((${#recoveries[@]} > 0)) || fail "未找到可供安全 U-Boot 启动/恢复测试的 initramfs、factory 或 recovery 镜像"

factory_count=0
for recovery in "${recoveries[@]}"; do
    case "$recovery" in
        *-factory.bin)
            factory_count=$((factory_count + 1))
            factory_size="$(wc -c < "$recovery" | tr -d ' ')"
            ((factory_size <= MAX_FACTORY_SIZE_BYTES)) || \
                fail "factory.bin 为 ${factory_size} 字节，超过默认分区 60 MiB 安全上限"
            ;;
    esac
done
((factory_count == 1)) || fail "必须且只能生成一个亚瑟 factory.bin，实际为 ${factory_count} 个"

echo "✅ sysupgrade 元数据确认：$DEVICE_ID"
echo "✅ U-Boot 首次测试候选（先内存启动，不等于已确认可写入分区）："
printf '   %s\n' "${recoveries[@]}"
echo "⚠️ 当前已安装固件身份 ${LEGACY_ID} 与新固件不同，禁止在 LuCI 中强制升级。"
