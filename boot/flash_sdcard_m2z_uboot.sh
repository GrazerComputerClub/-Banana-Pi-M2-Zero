#!/bin/bash

function pt_error()
{
    echo -e "\033[1;31mERROR: $*\033[0m"
}

function pt_warn()
{
    echo -e "\033[1;31mWARN: $*\033[0m"
}

function pt_info()
{
    echo -e "\033[1;32mINFO: $*\033[0m"
}

function pt_ok()
{
    echo -e "\033[1;33mOK: $*\033[0m"
}

mmc="mmcblk"
out="$1"

if [ -z "$out" ]; then
    pt_error "Usage: $0 <SD card> (SD CARD: /dev/sdX  where X is your sd card letter or /dev/mmcblkY  where Y your device number)"
    exit 1
fi

if [ $UID -ne 0 ]
    then
    pt_error "Please run as root."
    exit
fi

if [[ $out == *$mmc* ]]; 
then
part="p"
else
part=""
fi


pt_info "Umounting $out, please wait..."
sync
umount ${out}* >/dev/null 2>&1
sleep 1
sync

set -e

pt_info "Reading partition..."
sudo partprobe
sleep 2
sync
sudo partprobe ${out}
sleep 2

set -e
pt_warn "Flashing $out...."
dd if=./bootloader_m2z_v2.bin conv=notrunc bs=1k seek=8 of=$out

sync
pt_ok "Finished flashing uboot $out!"


