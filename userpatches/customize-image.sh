#!/bin/bash
# Runs inside the image chroot. Args: RELEASE LINUXFAMILY BOARD BUILD_DESKTOP
export DEBIAN_FRONTEND=noninteractive
# Hold kernel/dtb so apt upgrades don't replace the patched Fly Pi DTB
apt-mark hold linux-image-current-sunxi64 linux-dtb-current-sunxi64 || true
