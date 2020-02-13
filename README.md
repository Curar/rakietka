
# Linux kernel configuration and automatic kernel compilation and download scripts
## Arch Linux - building the kernel using the classical method :
### Required Packages :
`sudo pacman -S base-devel bc inetutils`
### optionally you can add :
`usermod -G wheel USERNAME`
### WARNING !!! we perform operations from 1 to 7 on a regular user :
### 1. Generating the default configa :
 `zcat /proc/config.gz > config-arch-default`
### 2. Adding GPG keys :
 `gpg --locate-keys torvalds@kernel.org gregkh@kernel.org`
### 3. Verification of kernel sources :
### Download source and signature :
 `wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.5.3.tar.xz`

 `wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.5.3.tar.sign`
### Verify signature :
 `unxz -c linux-5.5.3.tar.xz | gpg --verify linux-5.5.3.tar.sign -`
### 4. Unpacking :
 `tar xavf linux-5.5.3.tar.xz`
### 5. Copying the configuration :
 `cp config-arch-default linux-/.config`
### Optionally, you can use :
 `make localmodconfig`
### 6. Own settings :
 `make menuconfig`
### 7. Compilation :
 `make -j16`
### 8. Install the modules :
 `sudo make modules_install`
### 9. Copying the new kernel to the / boot folder :
 `sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-linux-5.5.3`
### 10. Make initial RAM disk :
 `sudo cp /etc/mkinitcpio.d/linux.preset /etc/mkinitcpio.d/linux-5.5.3.preset`
### 11. Edit files linux-5.5.3.preset
 `sudo vim /etc/mkinitcpio.d/linux-5.5.3.preset`
***

 ```
 ALL_config="/etc/mkinitcpio.conf"

 ALL_kver="/boot/vmlinuz-linux-5.5.3"

 PRESETS=('default' 'fallback')

 default_image="/boot/initramfs-linux-5.5.3.img"

 fallback_image="/boot/initramfs-linux-5.5.3-fallback.img"

 fallback_options="-S autodetect"
 ```

**We issue the command :**

 `sudo mkinitcpio -p linux-5.5.3`

### 12. Refresh the THICK configuration :
 `sudo grub-mkconfig -o /boot/grub/grub.cfg`

