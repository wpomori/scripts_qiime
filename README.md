# scripts_qiime

http://blogdoplastico.com/wp-content/uploads/2010/11/apostila_1.pdf

http://www.endophyte.uky.edu/ngs/sites/default/files/Class_9_QIIME.pdf

#                                          INSTALANDO OS SCRIPTS DO PIPELINE
Primeiro faça download do arquivo compactado usando wget:

	$wget https://github.com/wpomori/scripts_qiime/archive/master.zip                               \
	 unzip master.zip && rm -f master.zip

	$tar -jxvf ./scripts_qiime-master/examples.tar.bz2 && sudo mv ./examples ./scripts_qiime-master \
	 sudo rm -f ./scripts_qiime-master/examples.tar.bz2

	$sudo chmod +x ./scripts_qiime-master/install_qiime_x86_64.sh && sudo ./scripts_qiime-master/install_qiime_x86_64.sh
	
Pronto, agora é só executar o programa.

#                                          SINTAXE DE USO DO PROGRAMA start.sh
  
Crie um diretório e dentro dele forneça os arquivos fasta ou fastq (trimados a priori ou não) junto dos arquivos necessários. Para pedir ajuda digite o seguinte:

          $start.sh -h
      ou
          $statr.sh --help


Análise de dados single-end trimados a priori: no diretório de análise você deve fornecer os arquivos fasta ou fasta junto dos arquivos map_file.txt e custom_parameters.txt. Invoque o programa start.sh (sem colocar opções) e selecione a opção 1 para arquivo trimado no formato fasta ou 2 para arquivo trimado no formato fastq.


Análise de dados single-end sem trimar: forneça os arquivos de adaptadores, primers, map_file.txt e custom_parameters.txt e, no mesmo diretório, coloque os arquivos fastq. Invoque o programa start.sh normalmente.


Análise de dados paired-end sem trimar: além dos arquivos de adaptarores, primers, map_file.txt e custom_parameters, forneça o arquivo list.txt, o qual será reconhecido para a execução do programa Pandaseq.


Em seguida ao preparo do diretório de análise para dados single-end ou paired-end, use o seguinte comando:

          $start.sh

Uma janela contendo os seguintes dados será aberta:

			Opção	Ação
			=====	====
			  1	Arquivo de entrada está no formato fasta (trimado a priori).
			  2	Arquivo de entrada está no formato fastq (trimado a priori).
			  3	Arquivo de entrada está no formato fastq (não trimado e single-end, Ion Torrent PGM/Próton).
			  4	Arquivo de entrada está no formato fastq (não trimado e paired-end, Pandaseq).
			  5	Ajuda (?)
			  6	Sair do programa.
			Escolha UMA opção entre as opções acima (1-6): 

Escolha a opção desejada e espere finalizar a análise. Para as análises da opção 1 e 2, os dados de interesse estaram localizados dentro do diretório out_analysis. Para as opções 3 e 4, os dados de interesse estaram dentro dos diretórios cut_pri_fas (dados processados por Cutadapt e Prinseq-lite stand alone) e out_analysis (dados de saída do QIIME).

#                                                INSTALAÇÃO DO PACOTE R

Antes de executar o script todo, será necessário que alguns pacotes do R estejam instalados no sistema. Para isso:

	$sudo R

	>install.packages(c('ape', 'biom', 'optparse', 'RColorBrewer', 'randomForest', 'vegan'))
	
	>source('http://bioconductor.org/biocLite.R')
	
	>biocLite(c('DESeq2', 'metagenomeSeq', 'CSS'))
	
	>q()


Os scripts foram desenvolvidos por Wellington Pine Omori (lattes: http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K4451674A5) durante o seu Doutorado em Microbiologia Agropecuária em bioinformática (UNESP/FCAV de Jabticabal-SP) e MBA em Administração de Redes Linux (UNIARA de Araraquara-SP). O material foi atualizado no dia 08/12/16.

Quaisquer dúvidas, entre em contato pelo e-mail: wpomori@gmail.com
