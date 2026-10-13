# Automatically inject custom U-Boot defconfig into source tree upon unpacking
function post_unpack_uboot__inject_defconfig() {
    if [ -f "${USERPATCHES_DIR}/u-boot/u-boot-sunxi/fly_pi_v1_defconfig" ]; then
        cp "${USERPATCHES_DIR}/u-boot/u-boot-sunxi/fly_pi_v1_defconfig" "${SRC}/configs/"
        echo "Successfully injected fly_pi_v1_defconfig into U-Boot sources"
    fi
}
