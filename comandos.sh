#!/bin/bash
usuario=$(whoami)
info_disco=$(df -h | grep "C:" | awk '{print $2}')
nome_processador=$(lscpu | grep "Model name:"| awk '{$1=$1}1' | cut -f 2 -d ":")
memoria_ram=$(free -h | grep "Mem:" | cut -f 1 -d "6" | awk '{$1=$1}1' | cut -f 2 -d ":")
n_thread=$(lscpu | grep "CPU(s):"| awk '{$1=$1}1' | cut -f 2 -d ":")
n_nucleo=$(lscpu | grep "Core(s) per socket:"| awk '{$1=$1}1' | cut -f 2 -d ":")
rede=$(ip addr | grep -E 'link/ether (.*?) brd' | tail -1 | awk '{ print $2}')
echo "PC do $usuario tem um$nome_processador, memoria principal de $info_disco,$memoria_ram de ram,$n_thread threads,$n_nucleo nucleos, endereco de rede sendo $rede"
lsusb | tr -d '\n'
