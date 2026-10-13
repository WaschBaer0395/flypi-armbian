mkdir -p userpatches
cat << 'EOF' > userpatches/customize-image.sh
#!/bin/bash
RELEASE=$1
BOARD=$2
BRANCH=$3

# Hold kernel and dtb packages to prevent accidental updates from breaking boot
export DEBIAN_FRONTEND=noninteractive
apt-mark hold linux-image-current-sunxi64 linux-dtb-current-sunxi64 || true
EOF
chmod +x userpatches/customize-image.sh
