#!/bin/bash

export ARCH=arm64
export CROSS_COMPILE="/home/sattarvoybek/android_prebuilt_toolchains/arm-eabi-4.8/bin/arm-eabi-"


make msm8939-blade_defconfig
make -j16

./dtbToolCM -2 -o dt.img -s 2048 -p scripts/dtc/ arch/arm/boot/dts/

#cp ./arch/arm/boot/zImage ./out/zImage

