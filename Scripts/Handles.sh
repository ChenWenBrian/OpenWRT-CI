#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

PKG_PATH="$GITHUB_WORKSPACE/wrt/package"


#修改argon主题字体为正常字重（上游默认600粗体，改为normal）
ARGON_CFG="$PKG_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"
if [ -f "$ARGON_CFG" ]; then
	sed -i "s/font_weight '600'/font_weight 'normal'/" "$ARGON_CFG"
	echo "argon font_weight set to normal!"
fi

#修复Rust编译问题 (避免CI中llvm依赖导致构建中断)
FEEDS_PACKAGES="$PKG_PATH/../feeds/packages"
RUST_FILE="$(find "$FEEDS_PACKAGES" -maxdepth 3 -type f -wholename '*/rust/Makefile' -print -quit 2>/dev/null)"
if [ -f "$RUST_FILE" ]; then
	echo " "
	if sed -i 's/ci-llvm=true/ci-llvm=false/g' "$RUST_FILE"; then
		echo "rust has been fixed!"
	else
		echo "rust fix failed; continuing!"
	fi
fi
