 #
 # Copyright © 2014, Audiogod@sonic-developers.com
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm/boot/Image
DTBTOOL=$KERNEL_DIR/dtbToolCM
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/sattarvoybek/android_prebuilt_toolchains/arm-eabi-4.8/bin/arm-eabi-"
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="Sattarvoybek"
export KBUILD_BUILD_HOST="Metro"
STRIP="/home/sattarvoybek/android_prebuilt_toolchains/arm-eabi-4.8/bin/arm-eabi-strip"
MODULES_DIR=$KERNEL_DIR/modules_blades6

compile_kernel ()
{
echo -e "$blue***********************************************"
echo "          Compiling Metro kernel          "
echo -e "***********************************************$nocol"
rm $KERN_IMG
make msm8939-blade_defconfig
make Image -j8
make dtbs -j8
make modules -j8
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
strip_modules
}

strip_modules ()
{
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
zip -9 modules *
cd $KERNEL_DIR
}

case $1 in
clean)
make ARCH=arm -j8 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
*)
compile_kernel
;;
esac
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"


