#!/bin/bash

#=======================================================================
#
# Script teste para iniciar o qiime na opção de ajuda
# Existem os sequenciamentos single-end e paired-end
# Aqui você tem que escolher qual tipo de sequenciamento
# é o seu
#
#=======================================================================
#=======================================================================

        # Variáveis para serem usadas como referências aos programas
         # Diretório atual
         base_dir="/bin"

        # Variável atribuída quando o usuário pedir ajuda pelo teclado
        help="$1"

#=======================================================================
#=======================================================================
#
# Texto que será impresso caso o usuário peça ajuda ao programa

        if [ "${help}" = --help ] || [ "${help}" = \-h ]
        then
                echo "
 $0 versão 0.02

 Script versão beta desenvolvido como objeto de defesa de MBA em
redes Linux na UNIARA por Wellington Pine Omori em 07 de Outubro de 2016.

			e-mail: wpomori@gmail.com
 
 Script para trimagem de dados de sequenciamento (Ion Torrent PGM/Próton)
single-end no formato fastq usando Cutadapt e Prinseq. Os gráficos de 
qualidade dos dados brutos e processados são construídos com FastQC. Modo
de uso:


        $0

	Orientação de uso: o programa $0 não precisa que nenhum diretório
			   ou arquivo seja informado quando invocado.
			   Apenas tenha a certeza de que os arquivos fastq
			   dos dados brutos estejam no diretório atual.
			   Não se esqueça de informar o arquivo map_file.txt
			   e o arquivo custom_parameters.txt, os quais serão
			   importantes ao QIIME. O resto o programa fará por
			   você. "
        fi;

#=======================================================================
#=======================================================================
#
# Construído a partir do exemplo da página 274 do livro
# Programação Shell Linux de Júlio Cezar Neves, 10ª ED

	if [ "$#" -eq 1 ]
	then
	# $0 pega o nome do programa (start.sh) e $* 
	# contém a quantidades de parâmetros usados
	echo "
			   O programa $0 não precisa de atribuição de mais "
	echo "		   	   de um parâmetro [ contém $# parâmetro(s) ] além do  "
	echo "		           --help ou -h [ $0 --help ou $0 -h ] .
		 "
	exit;
fi;

#=======================================================================
#=======================================================================
#
	# Enquanto a opção for inválida, $OK estará vazia
	OK=

	until [ "$OK" ] ; do

	# A opção -n abaixo, serve para não saltar a linha ao final do echo
	echo -n "
			Opção	Ação
			=====	====
			  1	Arquivo de entrada está no formato fasta (trimado a priori).
			  2	Arquivo de entrada está no formato fastq (trimado a priori).
			  3	Arquivo de entrada está no formato fastq (não trimado e single-end, Ion Torrent PGM/Próton).
			  4	Arquivo de entrada está no formato fastq (não trimado e paired-end, Pandaseq).
			  5	Ajuda (?)
			  6	Sair do programa.
			Escolha UMA opção entre as opções acima (1-6): "

read Opcao
echo "\n"

	# Até que se prove o contrário, a opção é boa!
	 OK=1

	 # Variáveis para serem usadas como referências aos programas
	 # Diretório atual
#	 base_dir="."


case "$Opcao"
in
	1) echo "			Executando QIIME para arquivos no formato fasta "
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fasta ... \n "
		${base_dir}/qiime_fa.sh

	   ;;


	2) echo "			Executando QIIME para arquivos no formato fastq ... "
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fastq ... \n "
		${base_dir}/qiime_fq.sh

	   ;;

	3) echo " 			Executando trimagem para arquivos no formato fastq single-end ... "
	   echo "			Executando os scripts do Scythe, Cutadapt, Prinseq e FastQC ... "
	   echo "			Executando QIIME para os arquivos no formato fasta"
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fasta ... \n "
		${base_dir}/qiime_sg_raw.sh
	   ;;

	4) echo "			Executando trimagem para arquivos no formato fastq paired-end ... "
	   echo "			Executando os scripts do Pandaseq, Cutadapt, Prinseq e FastQC ... "
	   echo "			Executando QIIME para os arquivos no formato fasta"
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fasta ... \n "
		${base_dir}/qiime_pe_pa.sh
	   ;;

#	5) echo "                       Executando trimagem para arquivos no formato fastq paired-end ... "
#           echo "                       Executando os scripts do Micaa ... "
#           echo "                       Executando ???QIIME??? para os arquivos no formato fasta"
#           echo "                       Executando o script para arquivos de entrada no "
#           echo "                       formato fasta ... \n "
#                ${base_dir}/qiime_pe_mi.sh
#           ;;




	5) echo "
			Para saber sobre os métodos de sequênciamento visite \nhttp://www.science.smith.edu/cmbs/wp-content/uploads/sites/36/2015/09/Tutorial-from-sample-to-analyzed-data-using-Qiime-for-analysis.pdf \n\n\n 
		   "
	   ;;

	6) echo "			Saindo do programa ... \n "
	   sleep 2
	   ;;


	*) echo "São válidas somente opções entre 1-6 ... "
	   sleep 1
	   # Opção incorreta porque $OK está vazia, forcando loop
	   OK=
	   ;;
	esac
done;

#=======================================================================
#=======================================================================

exit;
