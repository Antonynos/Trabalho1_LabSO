#!/bin/bash
usuario=$(whoami)
info_disco=$(df -h | grep "C:" | awk '{print $2}')
nome_processador=$(lscpu | grep "Model name:" | cut -f 2 -d ":" | awk '{$1=$1}1')
memoria_ram=$(free -h | grep "Mem:" | awk '{print $2}')
n_thread=$(lscpu | grep "CPU(s):"| cut -f 2 -d ":" | awk '{$1=$1}1')
n_nucleo=$(lscpu | grep "Core(s) per socket:"| cut -f 2 -d ":" |  awk '{$1=$1}1')
rede=$(ip addr | grep -E 'link/ether (.*?) brd' | tail -1 | awk '{ print $2}')
# echo "PC do $usuario tem um$nome_processador, memoria principal de $info_disco,$memoria_ram de ram,$n_thread threads,$n_nucleo nucleos, endereco de rede sendo $rede"
portas_usb=$(lsusb)
n_porta=$(lsusb | wc -l)
declare -a usbs
for i in $(seq 1 $n_porta); do
	usbs[$i]=$(lsusb | tail -$i | head -1)
	#echo ${usbs[i]}
	#numero=$(expr $n_porta - 1)
	#portas_usb=$(lsusb | tail -$numero)
done

print_usb(){
	for i in $(seq 1 $n_porta); do
        	echo " Portas USB       | ${usbs[i]}";
	done
}
echo -e " ______________________________________________________________________"
echo -e " Nome do usuario  | $usuario"
echo -e " Processador      | $nome_processador"
echo -e " Núcleos          | $n_nucleo"
echo -e " Threads          | $n_thread"
echo -e " Disco            | $info_disco"
echo -e " Memoria RAM      | $memoria_ram"
echo -e " Endereço de Rede | $rede"
print_usb
echo -e " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
