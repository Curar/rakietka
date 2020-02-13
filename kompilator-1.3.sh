#!bin/bash
# BY WOJTEK 2020
# Automatyczna kompilacja kernela


echo -e "\e[31m=============================================================\e[0m"
echo -e "\e[31m= UWAGA !!! Skrypt kompiluje kernele z gałęzi 5.x tylko !!! =\e[0m"
echo -e "\e[31m=============================================================\e[0m"
echo ""
echo "Podaj nową wersję kernela np.: 5.5.1"
read KERNEL

echo "Podaj ile masz wątków procesora np.: 16"
read RDZENIE

echo "Podaj starą wersję kernela np. 5.5"
read SKERNEL

SKERNEL_EXIST="linux-${SKERNEL}/.config"
KERNEL_EXIST="linux-${KERNEL}.tar.xz"
KERNEL_SIGN="linux-${KERNEL}.tar.sign"
KERNEL_D="linux-${KERNEL}"
ADRES_KERNELA="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL}.tar.xz"
ADRES_PODPISU="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL}.tar.sign"

function download {
        if [ ! -e "$KERNEL_EXIST" ] && [ ! -e "$KERNEL_SIGN" ]
	then
	curl --compressed --progress-bar -o "$KERNEL_EXIST" "$ADRES_KERNELA"
	curl --compressed --progress-bar -o "$KERNEL_SIGN" "$ADRES_PODPISU"
	clear	
	else
	echo -e "\e[32m===========================\e[0m"
	echo -e "\e[32m= Kernel jest już pobrany =\e[0m"
	echo -e "\e[32m===========================\e[0m"
	fi
}

function archlinux {
cat << EOF > linux-${KERNEL}.preset

ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux-${KERNEL}"
PRESETS=('default' 'fallback')
default_image="/boot/initramfs-linux-${KERNEL}.img"
fallback_image="/boot/initramfs-linux-${KERNEL}-fallback.img"
fallback_options="-S autodetect"
	
EOF

	sudo cp linux-${KERNEL}.preset /etc/mkinitcpio.d/linux-${KERNEL}.preset	
	sudo mkinitcpio -p linux-${KERNEL}
	sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function kompilacja {

	echo "Masz $RDZENIE wątków procesora !!!"
	echo "Pobierma klucze GPG"
	gpg --locate-keys torvalds@kernel.org gregkh@kernel.org
	unxz -c linux-${KERNEL}.tar.xz | gpg --verify linux-${KERNEL}.tar.sign -
	if [ $? -eq 0 ]
	then
		echo -e "\e[32m=====================\e[0m"
		echo -e "\e[32m=  Podpis poprawny  =\e[0m"
		echo -e "\e[32m=====================\e[0m"	
		else
    		echo "Problem z podpisem : linux-${KERNEL}.tar.xz"
		exit
	fi	
	[ ! -d $KERNEL_D ] && { tar xavf linux-${KERNEL}.tar.xz; }
	[ -f $SKERNEL_EXIST ] && { echo "$SKERNEL_EXIST Konfig istnieje !!!"; cp linux-${SKERNEL}/.config linux-${KERNEL}/.config; }
        if [ ! -e "$SKERNEL_EXIST" ]
	then
	cd linux-${KERNEL}
	make localmodconfig
	cd ..
	fi
	cd linux-${KERNEL}
	make menuconfig
	make clean
	make -j ${RDZENIE}
	sudo make modules_install
	sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux-${KERNEL}

}

echo "Ściągnąć pliki z kernel.org ? :"
select SCIAGAJ in kernel.org WYJŚCIE
do
  case "$SCIAGAJ" in
    "kernel.org") download;;
    "WYJŚCIE") exit ;;
    *) echo "Brak wyboru"
  esac
break
done

if [ -e "$KERNEL_EXIST" ] && [ -e "$KERNEL_SIGN" ]
	then

	echo "Weryfikowanie podpisu"
	kompilacja
	echo "Czy masz Arch Linux ?"
	select ARCH in ArchLinux WYJŚCIE
	do
	  case "$ARCH" in
	  "ArchLinux") archlinux;;
	  "WYJŚCIE") exit;;
	  *) echo "Brak wyboru"
	esac
	break
	done
	echo "Zakończyłem kompilację"

	else
	echo "Brak plików"
fi
