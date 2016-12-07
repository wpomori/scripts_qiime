#################################################################################################################################################
#
#								readme.txt
#
#################################################################################################################################################

	Os scripts foram construídos para o Sistema Operacional Ubuntu 14.04 LTS Trusty 64 bits (https://www.ubuntu.com/), usando um notebook com processador Intel(R) Core(TM) i7-4510U CPU @ 2.00GHz e 2 núcleos (Máquina Virtual construída com VirtualBox 5). Os programas que precisam estar instalados para o pipeline funcionar são:

	=> Normalmente já vem instalados no SO:
	-Python v.2.7 (https://www.python.org/)
	-Perl v.5.18 (http://www.perl.org/)

	=> Esses o script install.sh irá instalar e adicionar no PATH automaticamente:
	-Java version v.1.8 (https://www.oracle.com/index.html)
	-Qiime v.1.9.1 (http://qiime.org/index.html)
	-Usearch v.8.1.1861_i86linux32 (http://www.drive5.com/usearch/download.html)
	-R v.3.0.2 (https://www.r-project.org/)
	-Conda v.4.2.12 (http://conda.pydata.org/miniconda.html)
	-MUSCLE v3.8.31 (http://www.drive5.com/muscle)
	-PRINSEQ stand alone v.0.20.4 (https://sourceforge.net/projects/prinseq/files/)
	-Cutadapt v.1.11 (http://cutadapt.readthedocs.io/en/stable/installation.html)
	-Pandaseq v.2.10 (https://github.com/neufeld/pandaseq/wiki/Installation)
	-FastQC v0.11.5 (http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
	-Mothur v.1.31.2 (https://www.mothur.org/)
	-bmp-map2qiime.py (https://github.com/vpylro/BMP)
	-bmp-otuName.pl (https://github.com/vpylro/BMP)
	-Fastx_toolkit v.0.0.13 (http://hannonlab.cshl.edu/fastx_toolkit/)
	-Pip v.8.1.2 (https://wiki.ubuntuusers.de/pip/)


#################################################################################################################################################
#
#							Descrição dos scripts usados no pipeline
#
#################################################################################################################################################

	Os scripts aqui apresentados foram construídos em Bourn Shell Again (BASH) e Ubuntu 14.04 LTS.

	O script principal é o start.sh, o qual pode invocar o qiime_fa.sh, qiime_fq.sh, qiime_sg_raw.sh e qiime_pe_pa.sh. Abaixo segue uma breve descrição de cada um dos scripts:


	-start.sh: permite ao usuário escolher entre seis opções, sendo que o número 1 chama o script qiime_fa.sh, o 2 chama o qiime_fq.sh, o 3 qiime_sg_raw.sh e o 4 qiime_pe_pa.sh. A opção 5 fornce a possibilidade de ter acesso aos arquivos exemplos que são necessários ao funcionamento do pipeline, enquanto que a opção 6 permite que usuário encerre o programa;

	-qiime_fa.sh: caso o usuário selecione a opção 1, este script será invocado. Ele realiza análise de alfa- e beta-diversidade a partir de dados de 16S de fasta de nucleotídeos trimados a priori;

	-qiime_fq.sh: caso o usuário selecione a opção 2, este script será invocado. Ele realiza análise de alfa- e beta-diversidade a partir de dados de 16S de arquivo fastq, trimados a priori;

	-qiime_sg_raw.sh: antes de iniciar as análises de alfa- e beta-diversidade com QIIME v.1.9.1, este script para dados fastq single-end invoca o pipeline de trimagem pipe_trim_ion_16s.sh, o qual usa Cutadapt para remover sequências de adaptadores, primers, barcodes e sequências menores do que 50pb. A seguir, os dados são trimados para Q Phred < 20, sequências menores do que 300pb e maiores do que 415pb usando Prinseq. Os dados são processados por FastQC para aferir a qualidade antes e após as etapas de trimagem. Por último o programa invoca o script qiime_fa.sh para realização das análises no QIIME.

	-qiime_pe_pa.sh: este script aceita como entrada dados paired-end não trimados, os quais tem suas extremidades unidas por Pandaseq usando inferencia "simple bayesian". A seguir ele dispara os programas Cutadapt, Prinseq e FastQC, terminando com as análises no QIIME.

	-uparse.sh: após a trimagem, todos os programas das opções de 1-4 do programa start.sh usam a abordagem UPARSE do USEARCH para identificar e eliminar sequências quimeras.

	-pipe_trim_ion_16s.sh: contém os comandos paras os programas Cutadapt, Prinseq-lite stand alone e FastQC, usados para trimagem e criação de gráficos de qualidade.

	-install.sh: script de instalação automática de todos os programas e scripts descritos acima.

#################################################################################################################################################
#
#							Descrição dos scripts usados no pipeline
#
#################################################################################################################################################
