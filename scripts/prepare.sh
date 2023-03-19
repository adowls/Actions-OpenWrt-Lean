#!/bin/bash
cp -R ../lede/package/boot/arm-trusted-firmware-rockchip-vendor package/boot/
rm -Rf package/boot/uboot-rockchip
cp -R ../lede/package/boot/uboot-rockchip package/boot/
rm -Rf target/linux/rockchip
cp -R ../lede/target/linux/rockchip target/linux/
git checkout target/linux/rockchip/Makefile
rm target/linux/rockchip/patches-5.10/002-net-usb-r8152-add-LED-configuration-from-OF.patch
rm target/linux/rockchip/patches-5.10/003-dt-bindings-net-add-RTL8152-binding-documentation.patch
# rm target/linux/rockchip/patches-5.10/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch
# mkdir target/linux/rockchip/files/include/dt-bindings/soc/
# cp ../r4se.v22.03.3/rockchip,vop2.h target/linux/rockchip/files/include/dt-bindings/soc/rockchip,vop2.h
# sed -i 's/drm_dp_aux_bus.ko@lt5.19/drm_dp_aux_bus.ko@ge5.19/' target/linux/rockchip/modules.mk
git checkout target/linux/rockchip/image/armv8.mk
sed -i '25,44d' target/linux/rockchip/image/armv8.mk
sed -i '5,14d' target/linux/rockchip/image/armv8.mk
sed -i 's/r4s/r4se/' target/linux/rockchip/image/armv8.mk
cp ../r4se.v22.03.3/image-rk3399-nanopi-r4se.dtb  target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3399-nanopi-r4se.dtb

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
make -j11 download
IGNORE_ERRORS=1 make -j$(nproc) V=sc