#!/bin/bash
usuario=$(whoami)
info_disco=$(df -h | grep "C:")
nome_processador=$(lscpu | grep "Model name:"| awk '{$1=$1}1' | cut -f 2 -d ":")
echo "PC do $usuario tem um$nome_processador"