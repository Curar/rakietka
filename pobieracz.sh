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

function download {
        if [ ! -e "$KERNEL_EXIST" ] && [ ! -e "$KERNEL_SIGN" ]
	then
		wget https://cdn.kernel.org/pub/linux/kernel/v${GKERNEL}.x/linux-${KERNEL}.tar.xz
		wget https://cdn.kernel.org/pub/linux/kernel/v${GKERNEL}.x/linux-${KERNEL}.tar.sign	
   	else
		echo "Kernel jest już pobrany"
	fi
}

function sprawdzanie {
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
