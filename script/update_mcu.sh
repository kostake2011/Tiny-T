#!/bin/bash

#chmod u+x /home/orangepi/printer_data/config/script/update_mcu.sh

#mkdir ~/firmware

#sudo service klipper stop

cd ~/klipper
make clean
make -j4 KCONFIG_CONFIG=/home/orangepi/printer_data/config/script/config.octopus.CAN
mv ~/klipper/out/klipper.bin ~/firmware/octopus_klipper.bin

make clean
make -j4 KCONFIG_CONFIG=/home/orangepi/printer_data/config/script/config.ebb36.CAN
mv ~/klipper/out/klipper.bin ~/firmware/ebb36_klipper.bin

cd ~/katapult/scripts
echo "Start update MCU Octopus"
echo ""
python3 flash_can.py -i can0 -u c55e24b058b9 -f ~/firmware/octopus_klipper.bin
python3 flash_can.py -f ~/firmware/octopus_klipper.bin -d /dev/serial/by-id/usb-katapult_stm32f446xx_2E0011001750344D30353320-if00
sleep 2
read -p "MCU Manta M5P firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU octopus"

# Update MCU EBB36
echo "Start update MCU EBB36"
echo ""
python3 flash_can.py -i can0 -u 7ea06aedaabd -f ~/firmware/ebb36_klipper.bin
sleep 2
#read -p "MCU EBB36 firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU EBB36"

echo ""

#sudo service klipper start
