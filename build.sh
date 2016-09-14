#!/bin/bash

export ARCH=arm
export KBUILD_BUILD_USER="Sattarvoybek"
export KBUILD_BUILD_HOST="Sattar-Server"
export CROSS_COMPILE="/home/sattarvoybek/android_prebuilt_toolchains/arm-eabi-5.3/bin/arm-eabi-"


make Metro_defconfig
make -j16

./dtbToolCM -2 -o dt.img -s 2048 -p scripts/dtc/ arch/arm/boot/dts/

#cp ./arch/arm/boot/zImage ./out/zImage

