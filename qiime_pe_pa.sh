#!/bin/bash

#=========================================================================
#
# Script qiime_pe_pa.sh: para dados paired-end que não foram trimados a
# priori e que serão submetidos ao Pandaseq para busca de overlap entre
# a extremidade 3' do arquivo R1 e 5' do R2, formando um único amplicon.
#
# Todos os comentários estão identificados por cerquilha. Eles não são
#   reconhecidos pelo interpretador quando o QIIME for executado.
#
# Este scritp faz parte do meu TCC em MBA em redes linux, da Uniara 2016.
# O objetivo deste script é primeiro realizar a trimagem dos dados brutos
# obtidos do sequenciamento em Ion Torrent usando Cutadapt, Prinseq e
# FastQC para somente depois usar estes dados lapdados para realização
# das classificações de sequências e análises de alfa- e beta-diversidade
# usando o QIIME v.1.9.1
#
# Script versão 0.01, terminado dia 07/12/2016 ás 08:56h. Parte deste shell
#   script foi baseado em um script para QIIME, o qual é distribuído com o
#   Biolinux 8 (UBUNTU 14.04 LTS, http://environmentalomics.org/bio-linux/).
#
# Confira todos os scripts de QIIME v.1.9.1 em: http://qiime.org/scripts/
#
#=========================================================================
#=========================================================================
#
#                 Dúvidas de como iniciar QIIME?
#
# 1) Como este script shell foi baseado no sistema operacional Biolinux 8,
#   o script que irá trabalhar os dados de 16S rRNA está configurado para
#   ser executado em terminal zsh. Para saber mais, informe-se sobre o
#   Biolinux 8 em http://environmentalomics.org/bio-linux/
#
# 2) Escolha um local de seu computador para iniciar as análises com
#   QIIME v.1.9.1. Crie um diretório chamado qiime e entre dentro dele:
#
#    $mkdir -p $PWD/qiime
#    $cd qiime
#
# 3) Dentro do diretório qiime, transfira os arquivos de 16S trimados
#   no formato fasta (https://en.wikipedia.org/wiki/FASTA_format)
#   trimados a priori com seus programas preferidos. Para dados
#   single-end, costumo usar Scythe para trimar adaptadores/barcodes/primers
#   na posição 3', Cutadapt para trimar adaptadores/barcodes/primers na
#   posição 5' e Prinseq stand-alone para trimar sequências curtas
#   e sequências com baixa qualidade Phred
#   (https://en.wikipedia.org/wiki/Phred_quality_score). Para
#   conferir se tudo foi executado perfeitamente, verifico a
#   qualidade dos dados brutos com FastQC para os dados antes e após
#   o processo de trimagem.
#
#    Scythe: https://github.com/vsbuffalo/scythe
#    Cutadapt: https://github.com/marcelm/cutadapt
#    Prinseq: http://prinseq.sourceforge.net/
#    FastQC: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/
#
# 3) Com QIIME v.1.9.1 corretamente configurado, basta invocar qiime como 
#   usuário regular no terminal do Biolinux 8:
#
#    $qiime
#
#   Após alguns segundos o terminal zsh será iniciado, com QIIME
#   pronto para ser iniciado as análises. O script aqui descrito foi
#   desenvolvido conforme sugerido pelos desenvolvedores do Biolinux,
#   e por isso algumas alterações necessitarão de ser feitas caso você
#   não configurado QIIME para ser executado desta forma. Para ver uma
#   outra forma de instalar e usar QIIME: http://qiime.org/install/install.html
#
#========================================================================
#========================================================================
#
# Diretórios de entrada e saída de dados usados no script
#
#========================================================================
#========================================================================

	# Diretório atual
	base_dir="."

	# Diretório para onde serão movidos os dados brutos antes da
	# execução do Pandaseq
	raw_data="${base_dir}/1_raw"

	# Diretório onde serão criados os arquivos processados por
	# Pandaseq
	panda="${base_dir}/2_panda"

#========================================================================
#========================================================================
#
# Verificando se a variável $QIIME_CONFIG está ativa. Ver mais em: 
# http://qiime.org/install/qiime_config.html
#
#========================================================================
#========================================================================

        # Saindo de erros
        set -e

        echo -n " Executando em " ; pwd

        if [ -z "$QIIME_CONFIG_FP" ] ; then
                echo " A variável \$QIIME_CONFIG_FP não está ativa. "
                echo " Você deve executar este script no shell zsh do QIIME. Basta invocar \$qiime no terminal ... "
		exit 1
		fi

#=========================================================================
#=========================================================================
#
# Verificando a existência de "1_raw". Caso ele não exista, o mesmo será
# criado.
#
#=========================================================================
#=========================================================================

	# Página 223 livro Programação Shell Linux, Cap. Liberdade Condicional, autor Júlio Cezar Nevess, 10ª edição, 2015
	# Verificando a existência do diretório $MeuDir, caso ele não exista, o shell o cria
	if [ ! -d "${raw_data}" ]
	then
	mkdir ${raw_data} && echo " Criando ${raw_data} e movendo dados brutos para ele ... "
	mv *.fastq ${raw_data}
fi

#=========================================================================
#=========================================================================

# Criando diretório de saída de dados processados pelos programas

	mkdir -p ${panda}


#=========================================================================
#=========================================================================

# Executando Pandaseq para junção das extremidades 3' do R1 com a 5' do R2
# As configurações foram usadas conforme sugestão a seguir
# https://github.com/edamame-course/2015-tutorials/blob/master/final/2015-06-23-QIIME1.md

# use pandaseq to merge reads - requires name list (file <list.txt> in same folder as this script) of forward and reverse reads to be merged using the panda-seq program

for file in $(<list.txt)
do
	echo " Juntando extremidades 3' R1 ( ${file}R1.fastq ) a 5' do R2 ( ${file}R2.fastq ) ... "
# Para saber mais sobre Pandaseq, visite:
# http://neufeldserver.uwaterloo.ca/~apmasell/pandaseq_man1.html
	pandaseq -f ${raw_data}/${file}R1.fastq -r ${raw_data}/${file}R2.fastq -w ${panda}/${file}merged.fasta -g ${panda}/${file}merged.log -B -F -A simple_bayesian

	done;
echo " Pandaseq finalizado!!! "
sleep 1

#=========================================================================
#=========================================================================




exit;
