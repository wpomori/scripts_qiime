#!/bin/bash

#=========================================================================
#
# Script qiime_sg_raw.sh: para dados que não foram trimados a priori
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
# Verificando se a variável $QIIME_CONFIG está ativa. Ver mais em: 
# http://qiime.org/install/qiime_config.html
#
#========================================================================
#=========================================================================

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

	# Executando o script do Cutadapt, Prinseq e FastQC
	echo " Executando trimagem (Cutadapt e Prinseq) e construção dos gráficos de qualidade (FastQC) dos dados brutos e trimados ... "
	# Diretório atual
	bin="/bin"	
	base_dir="."
	${bin}/pipe_trim_ion_16s.sh
	trim="${base_dir}/cut_pri_fas/3_trim/2_prinseq"

#=========================================================================
#=========================================================================

if [ -d "${trim}" ]
then
        for fasta in `ls ${trim}/*.fasta` ; do
        fnname=`basename ${fasta} .cutadapt.prinseq.fasta`
	cp ${trim}/${fnname}.cutadapt.prinseq.fasta ${base_dir}/${fnname}.fasta
done;
fi;

#=========================================================================
#=========================================================================

	# Executando o script do QIIME
	echo " Iniciando análises no QIIME v.1.9.1 ... "
	${bin}/qiime_fa.sh

#=========================================================================
#=========================================================================

if [ -d "${trim}" ]
then

	# Movendo os dados processados por QIIME para diretório geral
	echo " Movendo os diretórios processados por QIIME para diretório "
	echo " geral ... "
	mkdir -p ${base_dir}/QIIME
	mv ${base_dir}/logs ${base_dir}/QIIME
	mv ${base_dir}/out_analysis ${base_dir}/QIIME
	mv ${base_dir}/trim_data ${base_dir}/QIIME
	rm -f ${base_dir}/*.fasta
fi;

#=========================================================================
#=========================================================================

	echo "	Obrigado por usar nossas soluções de análises!!!! "
	echo "	Finalizando os programas ... "
	
	sleep 2
exit;
