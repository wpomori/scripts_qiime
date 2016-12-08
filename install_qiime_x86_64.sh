#!/bin/bash

#=========================================================================
#
# Script de instalação do QIIME v.1.9.1 usando ambiente virtual Conda
# v.4.2.12 e outros programas usados no pipeline de identificação
# taxonômica de gene 16S rRNA de bactérias.
#
# Embora o pipeline tenha sido construído levando em consideração muitos
# critérios metodológicos, não é garantido que o uso deste script não
# retorne resultados 100% confiáveis.
#
# Qualquer dúvidas, sugestões ou críticas: wpomori@gmail.com
#
#=========================================================================


# Tudo que estiver precedido de "#" são comentários
# Este script serve para instalar os programas em sistemas baseados em 
# Ubuntu 14.04 LTS

# Comando clear limpa tudo o que estiver digitado no terminal

	clear

# echo é uma variável para que o sistema entenda que algo deve ser 
# impresso no terminal. Neste caso, o cabeçalho do script.

	echo "

Este shell scrip foi desenvolvido por Wellington Pine Omori no dia 06/12/2016.

E-mail para contato: wpomori@gmail.com

Mestre em Microbiologia Agropecuária pela Faculdade de Ciências Agrárias e 
Veterinárias de Jaboticabal - UNESP/FCAV.
Endereço eletrônico: http://www.fcav.unesp.br/

MBA em Administração de Redex Linux pela Universidade de Araraquara (UNIARA).
Endereço eletrônico: http://www.uniara.com.br/home/

Afiliado aos Departamento de Tecnologia e Departamento de Biologia Aplicada a 
Agropecuária.

  Laboratórios:
             Bioquímica de Micro-organismos e Plantas (LBMP) e Laboratório de 
	     Genética Aplicada (LGA)"
		echo "

Iniciando a instalação dos programas e dependências para o funcionamento do 
pipeline de trimagem, construção de gráficos de qualidade e identificação e 
classificação taxonômica usando FastQC, Cutadapt, Prinseq, Pandaseq e QIIME. 
Para maiores esclarecimentos sobre o pipeline:

			https://github.com/wpomori/scripts_qiime

Durante a instalação dos programas, APERTE Y ou YES para confirmar a 
instalação e possibilitar o funcionamentos dos programas

Se der algum erro durante a instalação, execute a atualização do SO e depois
execute novamente este instalador. Faça assim (sem o $):

	\$sudo apt-get update
	\$sudo apt-get upgrade -y

   SENHA ROOT DO SO qiime: qiime
"

#=========================================================================
#
# INSTALAÇÃO PRINSEQ STAND-ALONE
#
#=========================================================================

	# Instalando o Prinseq stand-alone
	# http://www.vcru.wisc.edu/simonlab/bioinformatics/programs/install/prinseq.htm
	echo "	Instalando Prinseq stand-alone ... "
	cd /tmp
	# Would you like to configure as much as possible automatically? [yes] = yes
	# Would you like me to automatically choose some CPAN mirror sites for you? (This means connecting to the Internet) [yes]
	cpan Getopt::Long Pod::Usage File::Temp Fcntl Digest::MD5 Cwd List::Util
	apt-get update && apt-get install libcairo2-dev -y
	cpan Getopt::Long Pod::Usage File::Temp Fcntl Cwd JSON Cairo Statistics::PCA MIME::Base64
	wget -N http://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz
	tar -zxvf prinseq-lite-0.20.4.tar.gz
	cp -puv prinseq-lite-0.20.4/prinseq-lite.pl /usr/local/bin/prinseq-lite.pl && chmod +x /usr/local/bin/prinseq-lite.pl
	cp -puv prinseq-lite-0.20.4/prinseq-graphs.pl /usr/local/bin/prinseq-graphs.pl && chmod +x /usr/local/bin/prinseq-graphs.pl
	cp -puv prinseq-lite-0.20.4/prinseq-graphs-noPCA.pl /usr/local/bin/prinseq-graphs-noPCA.pl && chmod +x /usr/local/bin/prinseq-graphs-noPCA.pl
	rm prinseq-lite-0.20.4* -rf
	echo " Finalizando instalação do Prinseq stand-alone ... "

#=========================================================================
#
# INSTALAÇÃO PANDASEQ
#
#=========================================================================

	# Instalando Pandaseq (https://github.com/neufeld/pandaseq/wiki/Installation)
	echo "	Iniciando a instalação do Pandaseq ... "
	echo "	 Quando solicitado, aperte ENTER e Y para continuar a instalar PANDASEQ ... "
	apt-add-repository ppa:neufeldlab/ppa && apt-get update && apt-get install pandaseq -y
	echo " Finalizando a instalação do Pandaseq ... "

#=========================================================================
#
# INSTALAÇÃO FASTQC
#
#=========================================================================

	# Instalando o java 
	# https://www.digitalocean.com/community/tutorials/como-instalar-o-java-no-ubuntu-com-apt-get-pt
	echo "	Instalando JAVA 8 para execução do FastQC ... "
	apt-get install default-jre -y && apt-get install default-jdk -y
	# Atualizando o java (http://tecadmin.net/install-oracle-java-8-jdk-8-ubuntu-via-ppa/#)
	add-apt-repository ppa:webupd8team/java && apt-get update && apt-get install oracle-java8-installer -y
	java -version
	echo " Terminado instalação do JAVA 8 ... "
	sleep 2
	# Instalando FastQC
	# http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc
	echo "	Iniciando a instalação do FastQC ... "
	wget -N http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip
	unzip fastqc_v0.11.5.zip
	chmod 755 ./FastQC/fastqc
	mkdir -p /usr/local/bioinfo
	mv ./FastQC /usr/local/bioinfo
	ln -s /usr/local/bioinfo/FastQC/fastqc /usr/local/bin/fastqc
	rm -f fastqc_v0.11.5.zip FastQC
	echo " Finalizando a instalação de FastQC ... "

#=========================================================================
#
# INSTALAÇÃO CUTADAPT
#
#=========================================================================

	# Instalando Cutadapt usando pip 
	# http://www.saltycrane.com/blog/2010/02/how-install-pip-ubuntu/
	echo "	Instalando Cutadapt ... "
	apt-get -y install python-pip python-dev && pip install --upgrade pip && pip install cutadapt
	echo " Finalizando instalação ambiente Cutadapt ... "

#=========================================================================
#
# INSTALAÇÃO MINICONDA
#
#=========================================================================

	# Download miiconda: http://conda.pydata.org/miniconda.html
	# Instalação miniconda em /usr/local/bioinfo/miniconda2
	# Colocar os binários do minoconda no PATH 
	# https://www.vivaolinux.com.br/artigo/O-que-e-PATH-como-funciona-e-como-trabalhar-com-eleInsta
	echo "	Instalando ambiente virtual conda ... "
#	cp /etc/profile /etc/profile_backup
#	echo "PATH=$PATH:/usr/local/bioinfo/miniconda2/bin" > arquivo.txt
#	echo "`echo 'PATH=$PATH:/usr/local/bioinfo/miniconda2/bin'``cat arquivo.txt`" > /etc/profile
#	echo $PATH
#	export PATH=$PATH:/usr/local/bioinfo/miniconda2/bin
#	echo $PATH
	wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh && chmod +x ./Miniconda2-latest-Linux-x86_64.sh && ./Miniconda2-latest-Linux-x86_64.sh -f -p /usr/local/bioinfo/miniconda2
	ln -s /usr/local/bioinfo/miniconda2/bin/conda /usr/local/bin/conda
	conda update conda
	rm -f ./Miniconda2-latest-Linux-x86_64.sh && rm -f ./arquivo.txt
	echo " Terminado instalação conda ... "

#=========================================================================
#
# INSTALAÇÃO QIIME
#
#=========================================================================

	# Instalando QIIME http://qiime.org/install/install.html
	echo "	Iniciando a instalação do QIIME 1.9.1 ... "
	conda create -n qiime python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
	# source activate qiime
	# print_qiime_config.py -t
	# source deactivate
	# Upgrade qiime (http://wiki.ubuntu-br.org/Aptitude) (http://qiime.org/install/upgrade.html)
	apt-get update && apt-get install python-numpy build-essential -y && apt-get install aptitude -y
	aptitude install python-dev python-devel
#	pip install --upgrade pip && pip install --upgrade qiime
	apt-get install mothur -y && apt-get install muscle -y

	# Criando os diretórios que conteram os dados do RDP (https://www.mothur.org/wiki/RDP_reference_files)
	# cd /tmp
	mkdir -p /db/mothur/rdp
	chown -R $USER /db/mothur/rdp
	wget -N https://www.mothur.org/w/images/6/6c/Trainset14_032015.rdp.tgz
	tar -zxvf Trainset14_032015.rdp.tgz
	mv /tmp/trainset14_032015.rdp/trainset14_032015.rdp.fasta /db/mothur/rdp
	mv /tmp/trainset14_032015.rdp/trainset14_032015.rdp.tax /db/mothur/rdp
	rm -rf trainset14_032015.rdp
	rm -f Trainset14_032015.rdp.tgz

	# Fazer download do banco de dados do gold.fa, para buscar qimeras.
	# cd /tmp
	wget -N http://drive5.com/uchime/gold.fa
	mkdir -p /db/qiime/
	mv ./gold.fa /db/qiime

	# Download dos scripts usado no pipeline
	wget https://github.com/wpomori/scripts_qiime/archive/master.zip
	unzip master.zip
	rm -rf master.zip
	tar -jxvf /tmp/scripts_qiime-master/examples.tar.bz2 && mv /tmp/examples /tmp/scripts_qiime-master && rm -rf /tmp/scripts_qiime-master/examples.tar.bz2

# Download dos dados exemplos que estarão na pasta /usr/local/bioinfo/qiime_examples
# Peguei os dados paired-end que o Schloss deixou na página do mothur
# https://mothur.org/wiki/MiSeq_SOP
cd /tmp
wget https://mothur.org/w/images/d/d6/MiSeqSOPData.zip
unzip MiSeqSOPData.zip

mv ./MiSeq_SOP/F3D0_S188_L001_R1_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw
mv ./MiSeq_SOP/F3D0_S188_L001_R2_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw

mv ./MiSeq_SOP/F3D1_S189_L001_R1_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw
mv ./MiSeq_SOP/F3D1_S189_L001_R2_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw

mv ./MiSeq_SOP/F3D5_S193_L001_R1_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw
mv ./MiSeq_SOP/F3D5_S193_L001_R2_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw

mv ./MiSeq_SOP/F3D150_S216_L001_R1_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw
mv ./MiSeq_SOP/F3D150_S216_L001_R2_001.fastq ./scripts_qiime-master/examples/4_pe_fq_raw


# Criando diretório que conterá os exemplos para o pipeline do qiime
mkdir -p /usr/local/bioinfo/qiime_examples

# Dando permissão de acesso ao diretório /usr/local/bioinfo/qiime_examples
chown -R $USER /usr/local/bioinfo/qiime_examples

# Copiando o diretório dos scripts do pipeline do qiime para /usr/local/bioinfo/qiime_examples
cp -r /tmp/scripts_qiime-master /usr/local/bioinfo/qiime_examples
rm -rf __MACOSX MiSeq*

# Dando permissão de execussão e colocando os scripts do pipeline do QIIME no PATH
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/usearch && mv /usr/local/bioinfo/qiime_examples/scripts_qiime-master/usearch /usr/local/bioinfo/qiime_examples/scripts_qiime-master/usearch81 && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/usearch81 /usr/local/bin/usearch81
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/pipe_trim_ion_16s.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/pipe_trim_ion_16s.sh /usr/local/bin/pipe_trim_ion_16s.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_fa.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_fa.sh /usr/local/bin/qiime_fa.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_pe_pa.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_pe_pa.sh /usr/local/bin/qiime_pe_pa.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/uparse.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/uparse.sh /usr/local/bin/uparse.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_fq.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_fq.sh /usr/local/bin/qiime_fq.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_sg_raw.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/qiime_sg_raw.sh /usr/local/bin/qiime_sg_raw.sh
	chmod +x /usr/local/bioinfo/qiime_examples/scripts_qiime-master/start.sh && ln -s /usr/local/bioinfo/qiime_examples/scripts_qiime-master/start.sh /usr/local/bin/start.sh

# Colocando os scripts do pipeline no PATH
#	echo "PATH=$PATH:/usr/local/bioinfo/qiime_examples/scripts_qiime-master" > arquivo.txt
#	echo "`echo 'PATH=$PATH:/usr/local/bioinfo/qiime_examples/scripts_qiime-master'``cat arquivo.txt`" > /etc/profile
#	echo $PATH
#	export PATH=$PATH:/usr/local/bioinfo/qiime_examples/scripts_qiime-master
#	echo $PATH
	rm -rf master.zip

	# Instalando scripts BMP para usar com QIIME (https://github.com/vpylro/BMP)
	# cd /tmp
	wget -N https://github.com/vpylro/BMP/archive/master.zip
	unzip master.zip
	chmod +x ./BMP-master/*.py && chmod +x ./BMP-master/*.pl
	mv ./BMP-master /usr/local/bioinfo && ln -s /usr/local/bioinfo/BMP-master/bmp-map2qiime.py /usr/local/bin && ln -s /usr/local/bioinfo/BMP-master/bmp-otuName.pl /usr/local/bin
	rm -rf master.zip BMP-master
	 
	# Instalando o fastx_toolkit (http://hannonlab.cshl.edu/fastx_toolkit/download.html)
	# cd /tmp
	wget -N http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
	tar -jxvf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
	mkdir -p /usr/local/bioinfo/fastx_toolkit_0.0.13
	mv ./bin /usr/local/bioinfo/fastx_toolkit_0.0.13

	# Colocar os binários do fastx_toolkit no PATH
	# https://www.vivaolinux.com.br/artigo/O-que-e-PATH-como-funciona-e-como-trabalhar-com-eleInsta
	cp /etc/profile /etc/profile_backup
	echo "PATH=$PATH:/usr/local/bioinfo/fastx_toolkit_0.0.13/bin" > arquivo.txt
	echo "`echo 'PATH=$PATH:/usr/local/bioinfo/fastx_toolkit_0.0.13/bin'``cat arquivo.txt`" > /etc/profile
	echo $PATH
	export PATH=$PATH:/usr/local/bioinfo/fastx_toolkit_0.0.13/bin
	echo $PATH
	rm -rf arquivo.txt && rm -f fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2


	echo "	Instando comando locate ... "
	apt-get install mlocate -y
	updatedb
	echo " Finalizando instalação comando locate ... "

	echo "	Instalando editor VIM ... "
	apt-get install vim -y
	echo " Finalizando instalação do editor VIM"
	rm -rf ./scripts_qiime-master

#=========================================================================
#
# INSTALAÇÃO DO PACOTE R
#
#=========================================================================

	# Instalando o R
	echo "	Iniciando a instalação do pacote R ... "
	apt-get install r-base-core -y
	echo " Finalizando a instalação do R ... "
	echo " Visite https://github.com/wpomori/scripts_qiime/blob/master/README.md "
	echo " para ver como instalar pacotes adicionais no R para que o pipeline funcione"
	echo " por completo."
	echo "		Finalizando instalação do pipeline"
	sleep 2
exit;
