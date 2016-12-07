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
         # base_dir="/bin"

        # Variável atribuída quando o usuário pedir ajuda pelo teclado
        help="$1"

#=======================================================================
#=======================================================================
#
# Texto que será impresso caso o usuário peça ajuda ao programa

        if [ "${help}" = --help ] || [ "${help}" = \-h ]
        then
                echo "
 $0 versão 0.03

 Script versão beta desenvolvido como objeto de defesa de MBA em
redes Linux na UNIARA por Wellington Pine Omori em 07 de Dezembro de 2016.

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
		qiime_fa.sh

	   ;;


	2) echo "			Executando QIIME para arquivos no formato fastq ... "
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fastq ... \n "
		qiime_fq.sh

	   ;;

	3) echo " 			Executando trimagem para arquivos no formato fastq single-end ... "
	   echo "			Executando os scripts do Scythe, Cutadapt, Prinseq e FastQC ... "
	   echo "			Executando QIIME para os arquivos no formato fasta"
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fasta ... \n "
		qiime_sg_raw.sh
	   ;;

	4) echo "			Executando trimagem para arquivos no formato fastq paired-end ... "
	   echo "			Executando os scripts do Pandaseq, Cutadapt, Prinseq e FastQC ... "
	   echo "			Executando QIIME para os arquivos no formato fasta"
	   echo "			Executando o script para arquivos de entrada no "
	   echo "			formato fasta ... \n "
		qiime_pe_pa.sh
	   ;;

	5)
	# Enquanto a opção for inválida, $OK estará vazia
	OK=

		until [ "$OK" ] ; do

		# A opção -n abaixo, serve para não saltar a linha ao final do echo
		echo -n " Para quais dados você precisa visualizar os arquivos exemplos?

			Opção	Ação
			=====	====
			  1	Arquivos exemplos no formato fasta (trimado a priori).
			  2	Arquivos exemplos no formato fastq (trimado a priori).
			  3	Arquivos exemplos no formato fastq (não trimado e single-end).
			  4	Arquivos exemplos no formato fastq (não trimado e paired-end).
			  5	Sair do programa.
			Escolha UMA opção entre as opções acima (1-5): 

"

		read Opcao
		echo "\n"

		# Até que se prove o contrário, a opção é boa!
	 	OK=1

			case "$Opcao"
			in
		1) echo "Copiando os arquivos exemplos no formato fasta trimados a priori"
	  	 echo "para o diretório atual" ; pwd
		cp -r /usr/local/bioinfo/qiime_examples/scripts_qiime-master/examples/1_arquivos_fasta_trimados .

	   	;;


		2) echo "Copiando os arquivos exemplos no formato fastq trimados a priori"
	   	echo "para o diretório atual" ; pwd
		cp -r /usr/local/bioinfo/qiime_examples/scripts_qiime-master/examples/2_arquivos_fastq_trimados .

	   	;;

		3) echo "Copiando os arquivos exemplos no formato fastq single-end (dados brutos)"
	   	echo "para o diretório atual" ; pwd
		cp -r /usr/local/bioinfo/qiime_examples/scripts_qiime-master/examples/3_arquivos_fq_raw .
	   	;;

		4) echo "Copiando os arquivos exemplos no formato fastq paired-end (dados brutos)"
	   	echo "para o diretório atual" ; pwd
		cp -r /usr/local/bioinfo/qiime_examples/scripts_qiime-master/examples/4_pe_fq_raw .
	   	;;

		5) echo "			Saindo do programa ... \n "
	   	sleep 2
	   	;;

		*) echo "São válidas somente opções entre 1-5 ... "
	   	sleep 1
	  	 # Opção incorreta porque $OK está vazia, forcando loop
	   	OK=
	   	;;
	    esac
	done;

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
