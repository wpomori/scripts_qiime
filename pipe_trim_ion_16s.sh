#!/bin/bash

#========================================================================
# Todos os comentários são marcados por cerquilha
#
# Este script foi desenvolvido por Wellington Pine Omori e melhorado
# durante o ano de 2016 para dados de amplicons de 16S rRNA.
# Esta versão beta 0.03 foi melhorada em 07 de Dezembro de 2016.
#
# Os dados em formato fastq serão trimados pelo Cutadapt e Prinseq. O
# FastQC irá produzir os gráficos de qualidade antes e após as etapas de
# trimagem.
#
# Espera-se que o usuário saiba os adaptadores, barcodes e primers usados
# para o sequencimento de suas amostras, pois estes terão de ser informados
# ao programa Cutadap.
#
#========================================================================
#========================================================================

	# Atribuição de varáveis para os arquivos e diretórios de entrada
	# de dados (input)

	# Diretório atual
	base_dir="."

	# input - diretório contendo os arquivos de entrada no formato
	# *.fastq
	input="${base_dir}/1_raw"

#========================================================================
#========================================================================

	# Atribuição de variáveis para os arquivos e diretórios de saída
	# de dados (output) 

	# Arquivo contendo adaptadores, barcodes e primers do 16S rRNA
	primers="${base_dir}/primers.fa"

	adapters="${base_dir}/adapters.fa"

        # Diretório de saída dos dados processados por Cutadapt e
        # Prinseq
        trim="${base_dir}/3_trim"

	# graph1_out - Caminho para o diretório onde serão criados
	# os gráficos de qualidade dos dados brutos por FastQC
	graph1_out="${base_dir}/2_graphs/qualidade_raw"

	# Diretório de saída dos dados processados por Cutadapt e
	# Prinseq
	trim="${base_dir}/3_trim"

	# cutadapt_out - Caminho para o diretório de saída dos dados
	# processados por Cutadapt
	cutadapt_out="${trim}/1_cutadapt"
	
	# prinseq_out - Caminho para o diretório de saída dos dados
	# processados por Prinseq
	prinseq_out="${trim}/2_prinseq"

	# graph2_out - Caminho para o diretório onde FastQC irá criar 
	# os gráficos de qualidade dos dados trimados por Cutadapt e
	# Prinseq
	graph2_out="${base_dir}/2_graphs/qualidade_trim"

        # Diretório final para onde as análises serão movidas
        final="${base_dir}/cut_pri_fas"

#========================================================================
#========================================================================

	# Criando os diretórios para os dados de saída dos programas
	echo "* Creating directories"

	mkdir -p ${graph1_out}
	mkdir -p ${cutadapt_out}
	mkdir -p ${prinseq_out}
	mkdir -p ${graph2_out}
	mkdir -p ${final}

#========================================================================
#========================================================================

        # Checagem da existência de um diretório contendo os dados brutos
        # no diretório atual. Caso ele não exista o mesmo será criado.

	if [ ! -d ${input} ]
		then
			echo "Construindo diretório de dados brutos"
			mkdir ${input}
	fi

#========================================================================
#========================================================================

	# Listando os arquivos *.fastq existentes no diretório atual e 
	# reservando os nomes dos arquivos na memória
		for fastq in `ls ${base_dir}/*.fastq` ; do
		fqname=`basename ${fastq} .fastq`
		echo " ${fqname} "
	done;

		# Movendo os dados brutos para o diretório 1_raw
		echo " Movendo todos os arquivos fastq para o diretório "
		echo " ${input} recém criado ... "
		mv *.fastq ${input}

#========================================================================
#========================================================================

# Executando o programa FastQC para análise dos dados brutos

	for fastq2 in `ls ${input}/*.fastq` ; do
	fqname2=`basename ${fastq2} .fastq`

		echo "      Creating graphs raw data samples - step 1/4 (FastQC) ..."
		echo " ${fqname} "
		fastqc ${fastq2} -o ${graph1_out} 1> ${graph1_out}/${fqname2}.fastqc_raw.err.txt

	echo "      Adapter trimming - step 2/4 (Cutadapt) ..."
        cutadapt --format=fastq --adapter=${adapters} --anywhere=${primers} --error-rate=0.1 --times=2 --overlap=5 --minimum-length=80 --output=${cutadapt_out}/${fqname2}.cutadapt.fastq ${input}/${fqname2}.fastq 1> ${cutadapt_out}/${fqname2}.cutadapt.report.txt 2> ${cutadapt_out}/${fqname2}.cutadapt.log.txt

		echo "      Quality trimming - step 3/3 (Prinseq) ..."
                prinseq-lite.pl -verbose -fastq ${cutadapt_out}/${fqname2}.cutadapt.fastq -out_format 1 -out_good ${prinseq_out}/${fqname2}.cutadapt.prinseq -out_bad null -qual_noscale -min_len 150 -ns_max_p 80 -noniupac -trim_qual_right 25 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 3 -trim_qual_step 1 &> ${prinseq_out}/${fqname2}.cutadapt.prinseq.log.txt

                echo "      Quality trimming - step 3'/3 (Prinseq) ..."
                prinseq-lite.pl -verbose -fastq ${cutadapt_out}/${fqname2}.cutadapt.fastq -out_format 3 -out_good ${prinseq_out}/${fqname2}.cutadapt.prinseq.fq -out_bad null -qual_noscale -min_len 150 -ns_max_p 80 -noniupac -trim_qual_right 25 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 3 -trim_qual_step 1 &> ${prinseq_out}/${fqname2}.cutadapt.prinseq.fq.log.txt

	done;

#========================================================================
#========================================================================

	# Executando o programa FastQC para análise dos dados trimados

        for fastq3 in `ls ${prinseq_out}/*.fastq` ; do
        fqname3=`basename ${fastq3} .fastq`

#        for fastq3 in `ls ${final}/3_trim/2_prinseq/*.fastq` ; do
#        fqname3=`basename ${fastq3} .fastq`

        echo "      Creating graphs data triming - step 4/4 (FastQC) ..."
	fastqc ${prinseq_out}/${fqname3}.fastq -o ${graph2_out} 1> ${graph2_out}/${fqname}.fastqc_trim.err.txt

done;

#========================================================================
#========================================================================

	# Movendo os diretórios contendo os dados processados para o
	# diretório geral

	echo " Movendo os diretórios contendo dados trimados para "
	echo " ${final} "
		mv ${input} ${final}
		mv ${base_dir}/2_graphs ${final}
		mv ${base_dir}/3_trim ${final}

#========================================================================
#========================================================================

echo "		Finalizando análises e fechando programas ... "
echo "		Obrigado por usar nossas soluções!!! "
sleep 2
exit;
