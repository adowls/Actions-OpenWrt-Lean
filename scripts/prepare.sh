#!/bin/bash
cp -R ../lede/package/boot/arm-trusted-firmware-rockchip-vendor package/boot/
rm -Rf package/boot/uboot-rockchip
cp -R ../lede/package/boot/uboot-rockchip package/boot/
rm -Rf target/linux/rockchip
cp -R ../lede/target/linux/rockchip target/linux/
git checkout target/linux/rockchip/Makefile
rm target/linux/rockchip/patches-5.10/002-net-usb-r8152-add-LED-configuration-from-OF.patch
rm target/linux/rockchip/patches-5.10/003-dt-bindings-net-add-RTL8152-binding-documentation.patch
rm target/linux/rockchip/patches-5.10/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch
# # # fix missing rockchip,vop2.h error
# mkdir target/linux/rockchip/files/include/dt-bindings/soc/
# cp $GITHUB_WORKSPACE/r4se.v22.03.3/rockchip,vop2.h target/linux/rockchip/files/include/dt-bindings/soc/rockchip,vop2.h
# # # fix drm_dp_aux_bus.ko error
# sed -i 's/drm_dp_aux_bus.ko@lt5.19/drm_dp_aux_bus.ko@ge5.19/' target/linux/rockchip/modules.mk
# # # fix other rockchip u-boot compile error
git checkout target/linux/rockchip/image/armv8.mk
sed -i '25,44d' target/linux/rockchip/image/armv8.mk
sed -i '5,14d' target/linux/rockchip/image/armv8.mk
sed -i 's/friendlyarm_nanopi-r4s/friendlyarm_nanopi-r4se/' target/linux/rockchip/image/armv8.mk
sed -i 's/NanoPi R4S/NanoPi R4SE/' target/linux/rockchip/image/armv8.mk
sed -i 's/nanopi-r4s-rk3399/nanopi-r4se-rk3399/' target/linux/rockchip/image/armv8.mk
# # # fix Packages for kmod-r8169 found, but incompatible with the architectures configured
# mkdir -p package/lean
# cp -R ../lede/package/lean/r8168 package/lean/
# sed -i 's/kmod-r8169/kmod-r8168 -urngd/' target/linux/rockchip/image/armv8.mk
# # # fix rk3399-nanopi-r4se.dtb: No such file or directory & /workdir/openwrt/staging_dir/host/bin/gzip: No such file or directory
# cp $GITHUB_WORKSPACE/r4se.v22.03.3/image-rk3399-nanopi-r4se.dtb  target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4se.dtb
cp ../lede/include/image-commands.mk include/image-commands.mk
sed -i 's/$(STAGING_DIR_HOST)\/bin\/gzip -f -9n -c/gzip -f -9n -c/' include/image-commands.mk
cp ../lede/target/linux/rockchip/patches-5.15/105-rockchip-rock-pi-4.patch target/linux/rockchip/patches-5.10/105-rockchip-rock-pi-4.patch
# # # fix nanopi-r4se-rk3399-idbloader.img': No such file or directory
sed -i 's/ifneq ($(USE_RKBIN),)/ifeq ($(USE_RKBIN),)/' package/boot/uboot-rockchip/Makefile

./scripts/feeds update -a
./scripts/feeds install -a

wget https://downloads.openwrt.org/releases/22.03.3/targets/rockchip/armv8/config.buildinfo -O .config
sed -i '/.*r2s/d' .config
sed -i '/.*rockpro64/d' .config
sed -i '/.*rock-pi-4a/d' .config
sed -i 's/r4s/r4se/' .config
sed -i 's/CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/' .config
make defconfig
sed -i '/=m$/d' .config
sed -i 's/CONFIG_AUTOREMOVE=y/# CONFIG_AUTOREMOVE is not set/' .config
make -j$(nproc) download
IGNORE_ERRORS=1 make -j$(nproc) V=sc
