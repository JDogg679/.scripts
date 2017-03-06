#!/bin/bash

RESET="\e[1;0m"
RED="\033[1;31m"
GREEN="\033[1;32m"
MAGENTA="\033[1;95m"

echo -e "${RED}WARNING${RESET} This will irrevocably destroy all data on /dev/sdx. To restore the USB drive as an empty, usable storage device after using the ISO image, the filesystem signature needs to be removed by running ${GREEN}wipefs --all /dev/sdx${RESET} as ${RED}root${RESET}, before repartitioning and reformating the USB drive."

echo
read -n 1 -s -p "Press any key to continue"

DISKS=($(lsblk --list --noheadings | awk '/disk/{print $1}'))

echo
echo -e "Find out the name of your USB drive. Make sure that it is ${RED}NOT${RESET} mounted."
echo

for D in "${!DISKS[@]}"; do
  if [[ $(lsblk -l -n | grep "${DISKS[D]}" | awk '{print $7}') ]]; then
    echo -e "${DISKS[D]} ${RED}mounted${RESET}"
  else
    echo "${DISKS[D]}"
  fi
done

echo
echo -ne "Enter the name of your USB drive and then press [ ${MAGENTA}ENTER${RESET} ]: "
read -r DRIVE
echo
echo -e "You selected ${MAGENTA}/dev/${DRIVE}${RESET}"
MOUNTPOINT=$(lsblk -l -n | grep "${DRIVE}" | awk '{print $7}' | grep -v "^$")
if [[ ${MOUNTPOINT} ]]; then
  echo -e "The selected drive is mounted! ${GREEN}${MOUNTPOINT}${RESET}"
  echo -ne "Press [ ${MAGENTA}ENTER${RESET} ] to ${GREEN}unmount${RESET} it: "
  read -r
  echo "Waiting for other jobs to finish and then unmounting drive"
  umount "${MOUNTPOINT}" -l &> /dev/null
  echo "Unmounted"
fi
echo
echo -ne "Enter the absolute path to the ISO and then press [ ${MAGENTA}ENTER${RESET} ]: "
read -r ISO
echo -e "You selected ${MAGENTA}${ISO}${RESET} to be burned"
echo

read -n 1 -s -p "Press any key to continue"

echo -e "${RED}DO NOT REMOVE THE DRIVE WHILE THE ISO IS WRITTEN${RESET}"
dd bs=4M if="${ISO}" of=/dev/"${DRIVE}" status=progress && sync
echo -e "[ ${GREEN}DONE${RESET} ]"

exit 0

