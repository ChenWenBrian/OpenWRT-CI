#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

PKG_PATH="$GITHUB_WORKSPACE/wrt/package"

#修改argon主题字体和颜色配置
if [ -d "$PKG_PATH/luci-theme-argon" ]; then
	echo " "
	if [ -f "$PKG_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon" ]; then
		sed -i "s/primary '.*'/primary '#31a1a1'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" \
			"$PKG_PATH/luci-theme-argon/luci-app-argon-config/root/etc/config/argon"
		echo "theme-argon has been fixed!"
	fi
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
