#!/bin/bash
rm .gitignore
git clean -df
git checkout .
make distclean
# make target/linux/clean

# cp -R ../lede/config .
# cp -R ../lede/target/linux/generic/config-5.15 target/linux/generic/

cp -R ../lede/package/boot/arm-trusted-firmware-rockchip-vendor package/boot/
rm -Rf package/boot/uboot-rockchip
cp -R ../lede/package/boot/uboot-rockchip package/boot/
# rm -Rf target/linux/generic/
# cp -R ../lede/target/linux/generic/ target/linux/
rm -Rf target/linux/rockchip
cp -R ../lede/target/linux/rockchip target/linux/
# # # fix openwrt vermagic
git checkout target/linux/rockchip/armv8/config-5.10
# # # fix CONFIG_HW_RANDOM_ROCKCHIP waiting choice
echo 'CONFIG_HW_RANDOM_ROCKCHIP=n' >> target/linux/rockchip/armv8/config-5.10
# sed -i 's/kmod-r8168 -urngd/kmod-r8169/' target/linux/rockchip/image/armv8.mk
git checkout target/linux/rockchip/Makefile
rm target/linux/rockchip/patches-5.10/002-net-usb-r8152-add-LED-configuration-from-OF.patch
rm target/linux/rockchip/patches-5.10/003-dt-bindings-net-add-RTL8152-binding-documentation.patch
# # # fix No rule to make target 'drivers/net/phy/motorcomm.o', needed by 'drivers/net/phy/built-in.a'
rm target/linux/rockchip/patches-5.10/600-net-phy-Add-driver-for-Motorcomm-YT85xx-PHYs.patch
# # # fix rk3328 devfreq
rm target/linux/rockchip/patches-5.10/803-PM-devfreq-rockchip-add-devfreq-driver-for-rk3328-dmc.patch
# # # fix missing rockchip,vop2.h error
# mkdir target/linux/rockchip/files/include/dt-bindings/soc/
# cp $GITHUB_WORKSPACE/r4se.v22.03.3/rockchip,vop2.h target/linux/rockchip/files/include/dt-bindings/soc/rockchip,vop2.h
# # # fix drm_dp_aux_bus.ko error
# sed -i 's/drm_dp_aux_bus.ko@lt5.19/drm_dp_aux_bus.ko@ge5.19/' target/linux/rockchip/modules.mk
rm target/linux/rockchip/modules.mk
# # # fix other rockchip u-boot compile error
echo 'define Device/friendlyarm_nanopi-r4se' > target/linux/rockchip/image/armv8.mk
echo '  DEVICE_VENDOR := FriendlyARM' >> target/linux/rockchip/image/armv8.mk
echo '  DEVICE_MODEL := NanoPi R4SE' >> target/linux/rockchip/image/armv8.mk
echo '  SOC := rk3399' >> target/linux/rockchip/image/armv8.mk
echo '  UBOOT_DEVICE_NAME := nanopi-r4se-rk3399' >> target/linux/rockchip/image/armv8.mk
echo '  IMAGE/sysupgrade.img.gz := boot-common | boot-script nanopi-r4s | pine64-bin | gzip | append-metadata' >> target/linux/rockchip/image/armv8.mk
echo '  DEVICE_PACKAGES := kmod-r8169' >> target/linux/rockchip/image/armv8.mk
echo 'endef' >> target/linux/rockchip/image/armv8.mk
echo 'TARGET_DEVICES += friendlyarm_nanopi-r4se' >> target/linux/rockchip/image/armv8.mk
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
# cp ../lede/include/kernel-defaults.mk include/kernel-defaults.mk
cp ../lede/include/image-commands.mk include/image-commands.mk
sed -i 's/$(STAGING_DIR_HOST)\/bin\/gzip -f -9n -c/gzip -f -9n -c/' include/image-commands.mk
# # # fix rk3399-nanopi-r4se.dtb': No such file or directory
cp ../lede/target/linux/rockchip/patches-5.15/105-rockchip-rock-pi-4.patch target/linux/rockchip/patches-5.10/105-rockchip-rock-pi-4.patch

# # # fix nanopi-r4se-rk3399-idbloader.img': No such file or directory
# sed -i 's/ifneq ($(USE_RKBIN),)/ifeq ($(USE_RKBIN),)/' package/boot/uboot-rockchip/Makefile

# # # only for kernel 5.15.98
# echo "LINUX_VERSION-5.15 = .98" > include/kernel-5.15
# echo "LINUX_KERNEL_HASH-5.15.98 = 7dc62cd3a45f95c9b60316a5886ea9406aee256308869dac1e4ec088fbb37787" >> include/kernel-5.15

# sed -i 's/$/&;master/' feeds.conf.default
./scripts/feeds update -a && ./scripts/feeds install -a

wget https://downloads.openwrt.org/releases/22.03.3/targets/rockchip/armv8/config.buildinfo -O .config
sed -i '/.*r2s/d' .config
sed -i '/.*rockpro64/d' .config
sed -i '/.*rock-pi-4a/d' .config
sed -i 's/r4s/r4se/' .config
sed -i 's/CONFIG_TARGET_MULTI_PROFILE=y/# CONFIG_TARGET_MULTI_PROFILE is not set/' .config
sed -i 's/CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/' .config
sed -i 's/CONFIG_TARGET_PER_DEVICE_ROOTFS=y/# CONFIG_TARGET_PER_DEVICE_ROOTFS is not set/' .config
sed -i 's/CONFIG_TARGET_DEVICE_PACKAGES_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=""/CONFIG_TARGET_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=y/' .config
echo 'CONFIG_TARGET_ROOTFS_SQUASHFS=y' >> .config
echo '# CONFIG_TARGET_ROOTFS_EXT4FS is not set' >> .config

# echo 'CONFIG_TARGET_rockchip=y' > .config
# echo 'CONFIG_TARGET_rockchip_armv8=y' >> .config
# # echo 'CONFIG_TARGET_MULTI_PROFILE=y' >> .config
# echo 'CONFIG_TARGET_DEVICE_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=y' >> .config
# echo 'CONFIG_TARGET_rockchip_armv8_DEVICE_friendlyarm_nanopi-r4se=y' >> .config
# echo '# CONFIG_TARGET_ALL_PROFILES is not set' >> .config
# echo '# CONFIG_TARGET_MULTI_PROFILE is not set' >> .config
# echo 'CONFIG_TARGET_ROOTFS_SQUASHFS=y' >> .config
# echo '# CONFIG_TARGET_ROOTFS_EXT4FS is not set' >> .config
# echo 'CONFIG_ALL_KMODS=y' >> .config

# # echo 'CONFIG_MODULE_DEFAULT_kmod-gpio-button-hotplug=y' >> .config
# # echo 'CONFIG_MODULE_DEFAULT_kmod-nft-offload=y' >> .config
# # echo 'CONFIG_MODULE_DEFAULT_kmod-r8169=y' >> .config
# # echo 'CONFIG_MODULE_DEFAULT_kmod-usb-net-rtl8152=y' >> .config


# # echo 'CONFIG_TARGET_SQUASHFS_BLOCK_SIZE=1024' >> .config
# # echo 'CONFIG_TARGET_KERNEL_PARTSIZE=32' >> .config
# # echo 'CONFIG_TARGET_ROOTFS_PARTSIZE=160' >> .config

# echo 'CONFIG_PACKAGE_cgi-io=y' >> .config
# # echo 'CONFIG_PACKAGE_libiwinfo=y' >> .config
# # echo 'CONFIG_PACKAGE_libiwinfo-data=y' >> .config
# # echo 'CONFIG_PACKAGE_libiwinfo-lua=y' >> .config
# echo 'CONFIG_PACKAGE_liblua=y' >> .config
# echo 'CONFIG_PACKAGE_liblucihttp=y' >> .config
# echo 'CONFIG_PACKAGE_liblucihttp-lua=y' >> .config
# echo 'CONFIG_PACKAGE_libubus-lua=y' >> .config
# echo 'CONFIG_PACKAGE_lua=y' >> .config
# echo 'CONFIG_PACKAGE_luci=y' >> .config
# echo 'CONFIG_PACKAGE_luci-app-firewall=y' >> .config
# echo 'CONFIG_PACKAGE_luci-app-opkg=y' >> .config
# echo 'CONFIG_PACKAGE_luci-base=y' >> .config
# echo 'CONFIG_PACKAGE_luci-lib-base=y' >> .config
# echo 'CONFIG_PACKAGE_luci-lib-ip=y' >> .config
# echo 'CONFIG_PACKAGE_luci-lib-jsonc=y' >> .config
# echo 'CONFIG_PACKAGE_luci-lib-nixio=y' >> .config
# echo 'CONFIG_PACKAGE_luci-mod-admin-full=y' >> .config
# echo 'CONFIG_PACKAGE_luci-mod-network=y' >> .config
# echo 'CONFIG_PACKAGE_luci-mod-status=y' >> .config
# echo 'CONFIG_PACKAGE_luci-mod-system=y' >> .config
# echo 'CONFIG_PACKAGE_luci-proto-ipv6=y' >> .config
# echo 'CONFIG_PACKAGE_luci-proto-ppp=y' >> .config
# # echo 'CONFIG_PACKAGE_luci-ssl=y' >> .config
# echo 'CONFIG_PACKAGE_luci-theme-bootstrap=y' >> .config
# # echo 'CONFIG_PACKAGE_px5g-wolfssl=y' >> .config
# echo 'CONFIG_PACKAGE_rpcd=y' >> .config
# echo 'CONFIG_PACKAGE_rpcd-mod-file=y' >> .config
# # echo 'CONFIG_PACKAGE_rpcd-mod-iwinfo=y' >> .config
# echo 'CONFIG_PACKAGE_rpcd-mod-luci=y' >> .config
# echo 'CONFIG_PACKAGE_rpcd-mod-rrdns=y' >> .config
# echo 'CONFIG_PACKAGE_uhttpd=y' >> .config
# echo 'CONFIG_PACKAGE_uhttpd-mod-ubus=y' >> .config

# sed -i '/CONFIG_ALL_KMODS=y/d' .config
# sed -i '/CONFIG_ALL_NONSHARED=y/d' .config
# sed -i '/CONFIG_DEVEL=y/d' .config
# # # sed -i '/CONFIG_AUTOREMOVE=y/d' .config
# sed -i '/CONFIG_BPF_TOOLCHAIN_BUILD_LLVM=y/d' .config
# # # sed -i '/# CONFIG_BPF_TOOLCHAIN_NONE is not set/d' .config
# sed -i '/CONFIG_BUILDBOT=y/d' .config
# # # sed -i '/CONFIG_COLLECT_KERNEL_DEBUG=y/d' .config
# sed -i '/CONFIG_HAS_BPF_TOOLCHAIN=y/d' .config
# sed -i '/CONFIG_IB=y/d' .config
# sed -i '/CONFIG_IMAGEOPT=y/d' .config
# # # sed -i '/CONFIG_KERNEL_BUILD_DOMAIN=\"buildhost\"/d' .config
# # # sed -i '/CONFIG_KERNEL_BUILD_USER=\"builder\"/d' .config
# # # sed -i '/# CONFIG_KERNEL_KALLSYMS is not set/d' .config
# # # sed -i '/CONFIG_MAKE_TOOLCHAIN=y/d' .config
# # sed -i '/CONFIG_PACKAGE_libbpf=m/d' .config
# # sed -i '/CONFIG_PACKAGE_libelf=m/d' .config
# # sed -i '/CONFIG_PACKAGE_luci-ssl=y/d' .config
# # sed -i '/CONFIG_PACKAGE_px5g-wolfssl=y/d' .config
# # sed -i '/CONFIG_PACKAGE_qosify=m/d' .config
# # sed -i '/CONFIG_PACKAGE_tc-full=m/d' .config
# # sed -i '/CONFIG_PACKAGE_tc-mod-iptables=m/d' .config
# # sed -i '/CONFIG_PACKAGE_zlib=m/d' .config
# # # sed -i '/CONFIG_REPRODUCIBLE_DEBUG_INFO=y/d' .config
# # # sed -i '/CONFIG_SDK=y/d' .config
# # # sed -i '/CONFIG_SDK_LLVM_BPF=y/d' .config
# # # sed -i '/CONFIG_USE_LLVM_BUILD=y/d' .config
# # # sed -i '/CONFIG_VERSIONOPT=y/d' .config
# # # sed -i '/CONFIG_VERSION_BUG_URL=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_CODE=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_DIST=\"OpenWrt\"/d' .config
# # # sed -i '/CONFIG_VERSION_FILENAMES=y/d' .config
# # # sed -i '/CONFIG_VERSION_HOME_URL=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_HWREV=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_MANUFACTURER=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_MANUFACTURER_URL=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_NUMBER=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_PRODUCT=\"\"/d' .config
# # # sed -i '/CONFIG_VERSION_REPO=\"https:\/\/downloads.openwrt.org\/releases\/22.03.3\"/d' .config
# # # sed -i '/CONFIG_VERSION_SUPPORT_URL=\"\"/d' .config

make defconfig
# sed -i 's/CONFIG_PACKAGE_r8169-firmware=m/CONFIG_PACKAGE_r8169-firmware=y/' .config
sed -i 's/CONFIG_PACKAGE_kmod-r8169=m/CONFIG_PACKAGE_kmod-r8169=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-mii=m/CONFIG_PACKAGE_kmod-mii=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-phy-realtek=m/CONFIG_PACKAGE_kmod-phy-realtek=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-mdio-devres=m/CONFIG_PACKAGE_kmod-mdio-devres=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-libphy=m/CONFIG_PACKAGE_kmod-libphy=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-of-mdio=m/CONFIG_PACKAGE_kmod-of-mdio=y/' .config
# sed -i 's/CONFIG_PACKAGE_kmod-fixed-phy=m/CONFIG_PACKAGE_kmod-fixed-phy=y/' .config

# sed -i '/=m$/d' .config
make -j$(nproc) download
IGNORE_ERRORS=1 make -j$(nproc) V=sc
# make target/linux/compile -j$(nproc) V=sc