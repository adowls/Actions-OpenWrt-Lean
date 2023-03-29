#!/bin/bash
./scripts/feeds update -a && ./scripts/feeds install -a
# wget https://downloads.openwrt.org/releases/22.03.3/targets/rockchip/armv8/config.buildinfo -O .config
# sed -i '/.*r2s/d' .config
# sed -i '/.*rockpro64/d' .config
# sed -i '/.*rock-pi-4a/d' .config
# sed -i 's/r4s/r4se/' .config
# sed -i 's/CONFIG_TARGET_ALL_PROFILES=y/# CONFIG_TARGET_ALL_PROFILES is not set/' .config
# sed -i 's/CONFIG_AUTOREMOVE=y/# CONFIG_AUTOREMOVE is not set/' .config

# make clean
# rm -Rf tmp
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

sed -i '$a CONFIG_PACKAGE_cgi-io=y' .config
sed -i '$a CONFIG_PACKAGE_libiwinfo=y' .config
sed -i '$a CONFIG_PACKAGE_libiwinfo-data=y' .config
sed -i '$a CONFIG_PACKAGE_libiwinfo-lua=y' .config
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
sed -i '$a CONFIG_PACKAGE_luci-ssl=y' .config
sed -i '$a CONFIG_PACKAGE_luci-theme-bootstrap=y' .config
sed -i '$a CONFIG_PACKAGE_px5g-wolfssl=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-file=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-iwinfo=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-luci=y' .config
sed -i '$a CONFIG_PACKAGE_rpcd-mod-rrdns=y' .config
sed -i '$a CONFIG_PACKAGE_uhttpd=y' .config
sed -i '$a CONFIG_PACKAGE_uhttpd-mod-ubus=y' .config

cp ../openwrt/include/target.mk include/target.mk
cp ../openwrt/target/linux/rockchip/Makefile target/linux/rockchip/Makefile
make defconfig
sed -i '/=m$/d' .config
sed -i 's/CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_Go=y/# CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_Go is not set/' .config
make -j$(nproc) download
#IGNORE_ERRORS=1 make -j$(nproc) V=sc
