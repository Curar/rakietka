#!/bin/bash
#
# Skrypt skanujący z użyciem Nmap
# By Wojtek 2020

echo "\e[32m========================================================\e[0m"
echo "\e[32m  _   _                          ____      _   _       \e[0m"       
echo "\e[32m | \ | |                        / __ \    | | (_)      \e[0m"      
echo "\e[32m |  \| |_ __ ___   __ _ _ __   | |  | |___| |_ _ _ __  \e[0m"  
echo "\e[32m | | | | |_ | _ \ / _| | |_ \  | |  | / __| __| | |_ \ \e[0m"
echo "\e[32m | |\  | | | | | | (_| | |_) | | |__| \__ \ |_| | | | |\e[0m"
echo "\e[32m |_| \_|_| |_| |_|\__|_| |__/   \____/|___/\__|_|_| |_|\e[0m"
echo "\e[32m                       | |                             \e[0m"
echo "\e[32m                       |_|                             \e[0m"
echo "\e[32m========================================================\e[0m"

echo "\e[32m Podaj adres IPv4 :\e[0m"
read ADRES_IP

echo "\e[32m Jakie skanowanie przeprowadzić ? :\e[0m"
select WYBOR in SZYBKIE GLEBOKIE
do
	case $WYBOR in
		"SZYBKIE") 
			echo "Rozpoczynam skanowanie SZYBKIE dla adresu : $ADRES_IP"
			nmap $ADRES_IP
		;;
		"GLEBOKIE") 
			echo "Rozpoczynam skanowanie GŁĘBOKIE dla adresu : $ADRES_IP"
			nmap $ADRES_IP
		;;
	*) echo "Brak wyboru !"
	esac
	brake
done
