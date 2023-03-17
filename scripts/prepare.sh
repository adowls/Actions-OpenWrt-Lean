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
mkdir target/linux/rockchip/files/include/dt-bindings/soc/
cp ../etc/rockchip-vop2.h target/linux/rockchip/files/include/dt-bindings/soc/rockchip-vop2.h

./scripts/feeds update -a
./scripts/feeds install -a

wget https://downloads.openwrt.org/releases/22.03.3/targets/rockchip/armv8/config.buildinfo -O .config
sed -i '/.*r2s/d' .config
sed -i '/.*rockpro64/d' .config
sed -i '/.*rock-pi-4a/d' .config
sed -i 's/r4s/r4se/' .config
sed -i 's/CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/' .config
sed -i 's/CONFIG_PACKAGE_qosify=m/# CONFIG_PACKAGE_qosify is not set/' .config
make defconfig

make -j11 download
