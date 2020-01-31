#!/bin/bash
# BY WOJTEK 2020
# Automatyczne generowanie WIKI dla Github'a

KERNEL="-5.5"
SYGNATURA="linux-5.5.tar.sign"
CODE="'"


cat << EOF >> wiki.txt

# Arch Linux - building the kernel using the classical method :
### Required Packages :
${CODE}sudo pacman -S base-devel bc inetutils${CODE}
### optionally you can add :
${CODE}usermod -G wheel USERNAME${CODE}
### WARNING !!! we perform operations from 1 to 7 on a regular user :
### 1. Generating the default configa :
 ${CODE}zcat /proc/config.gz > config-arch-default${CODE}
### 2. Adding GPG keys :
 ${CODE}gpg --locate-keys torvalds@kernel.org gregkh@kernel.org${CODE}
### 3. Verification of kernel sources :
### Download source and signature :
 ${CODE}wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux${KERNEL}.tar.xz${CODE}

 ${CODE}wget https://cdn.kernel.org/pub/linux/kernel/v5.x/${SYGNATURA}${CODE}
### Verify signature :
 ${CODE}unxz -c linux${KERNEL}.tar.xz | gpg --verify linux${KERNEL}.tar.sign -${CODE}
### 4. Unpacking :
 ${CODE}tar xavf linux${KERNEL}.tar.xz${CODE}
### 5. Copying the configuration :
 ${CODE}cp config-arch-default linux${KERNLE}/.config${CODE}
### Optionally, you can use :
 ${CODE}make localmodconfig${CODE}
### 6. Own settings :
 ${CODE}make menuconfig${CODE}
### 7. Compilation :
 ${CODE}make -j16${CODE}
### 8. Install the modules :
 ${CODE}sudo make modules_install${CODE}
### 9. Copying the new kernel to the / boot folder :
 ${CODE}sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux${KERNEL}${CODE}
### 10. Make initial RAM disk :
 ${CODE}sudo cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux${KERNEL}.preset${CODE}
### 11. Edit files linux${KERNEL}.preset
 ${CODE}sudo vim /etc/mkinitcpio.d/linux${KERNEL}.preset${CODE}
***

 ${CODE}ALL_config="/etc/mkinitcpio.conf${CODE}

 ${CODE}ALL_kver="/boot/vmlinuz-linux${KERNEL}${CODE}

 ${CODE}PRESETS=('default' 'fallback')${CODE}

 ${CODE}default_image="/boot/initramfs-linux${KERNEL}.img${CODE}

 ${CODE}fallback_image="/boot/initramfs-linux${KERNEL}-fallback.img${CODE}

 ${CODE}fallback_options="-S autodetect${CODE}

**We issue the command :**

 ${CODE}sudo mkinitcpio -p linux${KERNEL}${CODE}

### 12. Refresh the THICK configuration :
 ${CODE}sudo grub-mkconfig -o /boot/grub/grub.cfg${CODE}

EOF
