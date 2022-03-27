#!/bin/bash
#Integrantes: Antônio Augusto, Carlos Walace e Ulysses Ferreira

usuario=$(whoami)

nome_disco=$(df -h | grep "C:" | awk '{print $1}')
info_disco_total=$(df -h | grep "C:" | awk '{print $2}')
info_disco_usado=$(df -h | grep "C:" | awk '{print $3}')
disco_livre=$(df -h | grep "C:" | awk '{print $4}')

nome_processador=$(lscpu | grep "Model name:" | cut -f 2 -d ":" | awk '{$1=$1}1')
clock_mhz=$(lscpu | grep "CPU MHz:" | cut -f 2 -d ":" | awk '{$1=$1}1')
n_thread=$(lscpu | grep "CPU(s):"| cut -f 2 -d ":" | awk '{$1=$1}1')
n_nucleo=$(lscpu | grep "Core(s) per socket:"| cut -f 2 -d ":" |  awk '{$1=$1}1')

memoria_ram_total=$(free -h | grep "Mem:" | awk '{print $2}')
memoria_ram_usada=$(free -h | grep "Mem:" | awk '{print $3}')
memoria_ram_livre=$(free -h | grep "Mem:" | awk '{print $4}')

rede=$(ip addr | grep -E 'link/ether (.*?) brd' | tail -1 | awk '{ print $2}')
portas_usb=$(lsusb)
n_porta=$(lsusb | wc -l)

declare -a usbs
for i in $(seq 1 $n_porta); do
	usbs[$i]=$(lsusb | tail -$i | head -1)
done

print_usb(){
	if [ $n_porta == 0 ]
	then
		echo " Portas USB - Nenhuma porta USB encontrada"
	else
		for i in $(seq 1 $n_porta); do
        		echo " Portas USB -> ${usbs[i]}";
		done
	fi
}

echo -e " ______________________________________________________________________"
echo -e " Nome do usuario   $usuario"
echo -e " Processador - $nome_processador"
echo -e "  ╚ Clock   -> $clock_mhz MHz"
echo -e "  ╚ Núcleos -> $n_thread"
echo -e "  ╚ Threads -> $n_nucleo"
echo -e " Disco - $nome_disco"
echo -e "  ╚ Total -> $info_disco_total"
echo -e "  ╚ Usado -> $info_disco_usado"
echo -e "  ╚ Livre -> $disco_livre"
echo -e " Memoria RAM"
echo -e "  ╚ Total -> $memoria_ram_total"
echo -e "  ╚ Usada -> $memoria_ram_usada"
echo -e "  ╚ Livre -> $memoria_ram_livre"
echo -e " Endereço de Rede - $rede"
print_usb
echo -e " ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"
