#!bin/bash
# BY WOJTEK 2020
# Skrypt pobiera dowolną wersję kernela z kernel.org oraz sprawdza jego podpis


echo -e "\e[31m=============================================================\e[0m"
echo -e "\e[31m= UWAGA !!! Skrypt pobiera kernela z https://kernel.org !!! =\e[0m"
echo -e "\e[31m=============================================================\e[0m"
echo ""

echo "Podaj gałąź kernela np.: 3 lub 4 lub 5 :"
read GKERNEL

echo "Podaj wersję kernela którą chcesz pobrać np.: 5.5.1"
read KERNEL

KERNEL_EXIST="linux-${KERNEL}.tar.xz"
KERNEL_SIGN="linux-${KERNEL}.tar.sign"
ADRES_KERNELA="https://cdn.kernel.org/pub/linux/kernel/v${GKERNEL}.x/linux-${KERNEL}.tar.xz"
ADRES_PODPISU="https://cdn.kernel.org/pub/linux/kernel/v${GKERNEL}.x/linux-${KERNEL}.tar.sign"

function download {
        if [ ! -e "$KERNEL_EXIST" ] && [ ! -e "$KERNEL_SIGN" ]
	then
	wget "$ADRES_KERNELA" 2>&1 | \
	stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
	dialog --gauge "Pobieram : ${KERNEL_EXIST}" 10 100

	wget "$ADRES_PODPISU" 2>&1 | \
	stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
	dialog --gauge "Pobieram : ${KERNEL_SIGN}" 10 100
	clear		
	else
		echo -e "\e[32m===========================\e[0m"
		echo -e "\e[32m= Kernel jest już pobrany =\e[0m"
		echo -e "\e[32m===========================\e[0m"
	fi
}

function sprawdzanie {
	echo "Sprawdzam podpis !!!"
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
}
download
sprawdzanie
