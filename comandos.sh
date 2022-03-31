#!/bin/bash
#Integrantes: Antônio Augusto, Carlos Walace e Ulysses Ferreira

usuario=$(whoami)

nome_disco=$(df -h | grep "C:" | awk '{print $1}')
#df significa DiskFree, e mostra os dados de memoria de disco como tamanho e memoria livre de tal disco.
# -h faz o sistema mostrar os dados de maneira que consigamos visualizar, em GB. grep C: faz com que o bash pegue
#somente o dado que está contido na linha que contém C: . E awk {print $1} imprimirá na tela somente o primeiro
#elemento, que no caso de tudo o comendo, aparecerá na tela C:
info_disco_total=$(df -h | grep "C:" | awk '{print $2}')
#utilizando a mesma logica do primeiro item, este pega somente o segundo elemento de C:, que no caso é a memoria
#total
info_disco_usado=$(df -h | grep "C:" | awk '{print $3}')
#ai sera a mesma historia, pegando o terceiro elemento de C:, que é a memória já utilizada
disco_livre=$(df -h | grep "C:" | awk '{print $4}')
#Seguindo o mesmo padrão, pegaremos o quarto elemento de C:, que mostrará a memória ainda livre

nome_processador=$(lscpu | grep "Model name:" | cut -f 2 -d ":" | awk '{$1=$1}1')
#o comando lscpu mostra todas as informações sobre a arquitetura do CPU. no caso quando usamos o grep com o
#Model name, pegaremos a informação somente desta linha, que é sobre o nome do modelo do CPU.
#Com o comando cut -f2 -2 : cortaremos e o texto da primeira palavra até o primeiro :, e mostraremos tudo apos isso.
#E com o comando awk estamos cortando o espaço em branco antes da palavra, para deixar bonito na visualização
clock_mhz=$(lscpu | grep "CPU MHz:" | cut -f 2 -d ":" | awk '{$1=$1}1')
#seguindo a mesma estrutura do comando de cima, damos grep em uma parte diferente do comando, que é em CPU MHz, 
#nos mostrando a informação somente dessa linha.
n_thread=$(lscpu | grep "CPU(s):"| cut -f 2 -d ":" | awk '{$1=$1}1')
#Aqui pegamos a linha que mostra os nucleos do cpu, estando na linha que começa por CPU(s):, do qual o grep ira
#selecionar
n_nucleo=$(lscpu | grep "Core(s) per socket:"| cut -f 2 -d ":" |  awk '{$1=$1}1')
#e finalizando esta parte, daremos grep no Core(s) per socket:, do qual mostrará o numero de threads

memoria_ram_total=$(free -h | grep "Mem:" | awk '{print $2}')
#o comando free mostra informações da memoria ram e de swap; adicionando o -h deixaremos os dados em gb.
#Como queremos os dados de memoria ram, daremos um grep em Mem:. e como o dado de memória total esta como o segundo
#elemento da linha de mem:, deremos um awk {print $2}.
memoria_ram_usada=$(free -h | grep "Mem:" | awk '{print $3}')
#seguindo a mesma logica, o dado de memoria usada esta como o terceiro elemento neste grep, entao o awk tera print $3
memoria_ram_livre=$(free -h | grep "Mem:" | awk '{print $4}')
#novamente queremos um resultado do comando free com grep em mem:, como memoria livre é o quarto elemento, o awk
#recebera print $4
rede=$(ip addr | grep -E 'link/ether (.*?) brd' | tail -1 | awk '{ print $2}')
#este comando mostra todas as informações de networking e ip, que no caso queremos o endereço de rede.
# o -E do grep faz com que peguemos um padrão especifico para mostrar na tela. que no caso começa com link/ether
#e termina com brd. o (.*?) faz com que seja pego qualquer informacao entre as duas palavras definidas.
# O comando tail -1 fará com que seja mostrado em tela somente a ultima linha do comando selecionado, no caso, a
#cauda do texto.
#e como falado anteriormente, usaremos o awk { print $2} para imprimir em tela o segundo elemento do texto
#selecionado, que no caso é o endereço de rede desejado.
portas_usb=$(lsusb)
#é um comando que cita as portas USB.
n_porta=$(lsusb | wc -l)
#colocando assim, contaremos quantos dispositivos USB temos no sistema pela quantidade de linhas impressas no
#terminal
declare -a usbs
for i in $(seq 1 $n_porta); do
	usbs[$i]=$(lsusb | tail -$i | head -1)
done

#neste trecho de codigo, criamos um array para armazenar as informações das portas usbs que pegaremos do sistema.
#e faremos um laço que repetirá um numero de vezes igual as portas usb detectadas, assim armazenando a informação
#do nome de todas em cada array.

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

#Aqui criamos uma função para fazer um laço afim de imprimir na tela o nome das portas USBS, também utilizando a
#quantidade de portas USB como vezes que irá rodar. Caso não haja portas USB no dispositivo, ele mostrará uma
#mensagem especial

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

#aqui imprimimos na tela as informações selecionadas para o usuário ver. Note que na parte de imprimir o endereço de
#rede, ao invés de chamar a variavel diretamente, chamamos a função que imprimirá os dados através de um laço, pois
#estão armazenados em um array.
