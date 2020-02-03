#!bin/bash
# BY WOJTEK 2020
# Automatyczna kompilacja kernela

echo "Podaj nową wersję kernela np.: 5.5.1"
read KERNEL

echo "Podaj starą wersję kernela np. 5.5"
read SKERNEL

if [ -e linux-${SKERNEL}/.config ]
then
	unxz -c linux-${KERNEL}.tar.xz | gpg --verify linux-${KERNEL}.tar.sign -

	tar xavf linux-${KERNEL}.tar.xz

	cp linux-${SKERNEL}/.config linux-${KERNEL}/.config

	cd linux-${KERNEL}

	make menuconfig

	make -j 16

	sudo make modules_install

	sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux-${KERNEL}
else
	echo "Brak pliku .config"
fi

