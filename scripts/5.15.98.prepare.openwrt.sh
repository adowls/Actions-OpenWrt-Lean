#!/bin/bash
rm .gitignore
git clean -df
rm -Rf feeds
git checkout .
git checkout master

cp -R ../lede/config .
# cp -R ../lede/target/linux/generic/config-5.15 target/linux/generic/

cp -R ../lede/package/boot/arm-trusted-firmware-rockchip-vendor package/boot/
rm -Rf package/boot/uboot-rockchip
cp -R ../lede/package/boot/uboot-rockchip package/boot/
rm -Rf target/linux/generic/
cp -R ../lede/target/linux/generic/ target/linux/
rm -Rf target/linux/rockchip
cp -R ../lede/target/linux/rockchip target/linux/
sed -i 's/kmod-r8168 -urngd/kmod-r8169/' target/linux/rockchip/image/armv8.mk
git checkout target/linux/rockchip/Makefile
# rm target/linux/rockchip/patches-5.10/002-net-usb-r8152-add-LED-configuration-from-OF.patch
# rm target/linux/rockchip/patches-5.10/003-dt-bindings-net-add-RTL8152-binding-documentation.patch
# rm target/linux/rockchip/patches-5.10/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch
# # # fix missing rockchip,vop2.h error
# mkdir target/linux/rockchip/files/include/dt-bindings/soc/
# cp $GITHUB_WORKSPACE/r4se.v22.03.3/rockchip,vop2.h target/linux/rockchip/files/include/dt-bindings/soc/rockchip,vop2.h
# # # fix drm_dp_aux_bus.ko error
# sed -i 's/drm_dp_aux_bus.ko@lt5.19/drm_dp_aux_bus.ko@ge5.19/' target/linux/rockchip/modules.mk
# # # fix other rockchip u-boot compile error

# git checkout target/linux/rockchip/image/armv8.mk
# sed -i '25,44d' target/linux/rockchip/image/armv8.mk
# sed -i '5,14d' target/linux/rockchip/image/armv8.mk
# sed -i 's/friendlyarm_nanopi-r4s/friendlyarm_nanopi-r4se/' target/linux/rockchip/image/armv8.mk
# sed -i 's/NanoPi R4S/NanoPi R4SE/' target/linux/rockchip/image/armv8.mk
# sed -i 's/nanopi-r4s-rk3399/nanopi-r4se-rk3399/' target/linux/rockchip/image/armv8.mk

# # # fix Packages for kmod-r8169 found, but incompatible with the architectures configured
# mkdir -p package/lean
# cp -R ../lede/package/lean/r8168 package/lean/
# sed -i 's/kmod-r8169/kmod-r8168 -urngd/' target/linux/rockchip/image/armv8.mk
# # # fix rk3399-nanopi-r4se.dtb: No such file or directory & /workdir/openwrt/staging_dir/host/bin/gzip: No such file or directory
# cp $GITHUB_WORKSPACE/r4se.v22.03.3/image-rk3399-nanopi-r4se.dtb  target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4se.dtb

# # # fix QCOM_QMI_HELPERS
cp ../lede/include/kernel-defaults.mk include/kernel-defaults.mk
cp ../lede/include/image-commands.mk include/image-commands.mk
sed -i 's/$(STAGING_DIR_HOST)\/bin\/gzip -f -9n -c/gzip -f -9n -c/' include/image-commands.mk

# cp ../lede/target/linux/rockchip/patches-5.15/105-rockchip-rock-pi-4.patch target/linux/rockchip/patches-5.10/105-rockchip-rock-pi-4.patch

# # # fix nanopi-r4se-rk3399-idbloader.img': No such file or directory
# sed -i 's/ifneq ($(USE_RKBIN),)/ifeq ($(USE_RKBIN),)/' package/boot/uboot-rockchip/Makefile

# # # only for kernel 5.15.98
echo "LINUX_VERSION-5.15 = .98" > include/kernel-5.15
echo "LINUX_KERNEL_HASH-5.15.98 = 7dc62cd3a45f95c9b60316a5886ea9406aee256308869dac1e4ec088fbb37787" >> include/kernel-5.15

sed -i 's/$/&;master/' feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

# wget https://downloads.openwrt.org/releases/22.03.3/targets/rockchip/armv8/config.buildinfo -O .config
# sed -i '/.*r2s/d' .config
# sed -i '/.*rockpro64/d' .config
# sed -i '/.*rock-pi-4a/d' .config
# sed -i 's/r4s/r4se/' .config
# sed -i 's/CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/' .config

echo '#' > .config 
sed -i '$a CONFIG_TARGET_rockchip=y' .config
sed -i '$a CONFIG_TARGET_rockchip_armv8=y' .config
sed -i '$a CONFIG_TARGET_MULTI_PROFILE=y' .config
sed -i '$a CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=y' .config
sed -i '$a CONFIG_TARGET_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=y' .config
sed -i '$a # CONFIG_TARGET_ALL_PROFILES is not set' .config
sed -i '$a # CONFIG_TARGET_MULTI_PROFILE is not set' .config
sed -i '$a CONFIG_TARGET_ROOTFS_SQUASHFS=y' .config
sed -i '$a # CONFIG_TARGET_ROOTFS_EXT4FS is not set' .config

# sed -i '$a CONFIG_TARGET_SQUASHFS_BLOCK_SIZE=1024' .config
# sed -i '$a CONFIG_TARGET_KERNEL_PARTSIZE=32' .config
# sed -i '$a CONFIG_TARGET_ROOTFS_PARTSIZE=160' .config

sed -i '$a CONFIG_PACKAGE_cgi-io=y' .config
# sed -i '$a CONFIG_PACKAGE_libiwinfo=y' .config
# sed -i '$a CONFIG_PACKAGE_libiwinfo-data=y' .config
# sed -i '$a CONFIG_PACKAGE_libiwinfo-lua=y' .config
sed -i '$a CONFIG_PACKAGE_liblua=y' .config
sed -i '$a CONFIG_PACKAGE_liblucihttp=y' .config
sed -i '$a CONFIG_PACKAGE_liblucihttp-lua=y' .config
sed -i '$a CONFIG_PACKAGE_libubus-lua=y' .config
sed -i '$a CONFIG_PACKAGE_lua=y' .config
sed -i '$a CONFIG_PACKAGE_luci=y' .config
sed -i '$a CONFIG_PACKAGE_luci-app-firewall=y' .config
sed -i '$a CONFIG_PACKAGE_luci-app-opkg=y' .config
sed -i '$a CONFIG_PACKAGE_luci-base=y' .config
sed -i '$a CONFIG_PACKAGE_luci-lib-base=y' .config
sed -i '$a CONFIG_PACKAGE_luci-lib-ip=y' .config
sed -i '$a CONFIG_PACKAGE_luci-lib-jsonc=y' .config
sed -i '$a CONFIG_PACKAGE_luci-lib-nixio=y' .config
sed -i '$a CONFIG_PACKAGE_luci-mod-admin-full=y' .config
sed -i '$a CONFIG_PACKAGE_luci-mod-network=y' .config
sed -i '$a CONFIG_PACKAGE_luci-mod-status=y' .config
sed -i '$a CONFIG_PACKAGE_luci-mod-system=y' .config
sed -i '$a CONFIG_PACKAGE_luci-proto-ipv6=y' .config
sed -i '$a CONFIG_PACKAGE_luci-proto-ppp=y' .config
# sed -i '$a CONFIG_PACKAGE_luci-ssl=y' .config
sed -i '$a CONFIG_PACKAGE_luci-theme-bootstrap=y' .config
# sed -i '$a CONFIG_PACKAGE_px5g-wolfssl=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-file=y' .config
# sed -i '$a CONFIG_PACKAGE_rpcd-mod-iwinfo=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-luci=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-rrdns=y' .config
sed -i '$a CONFIG_PACKAGE_uhttpd=y' .config
sed -i '$a CONFIG_PACKAGE_uhttpd-mod-ubus=y' .config
make defconfig
sed -i '/=m$/d' .config
make -j$(nproc) download
IGNORE_ERRORS=1 make -j$(nproc) V=sc
