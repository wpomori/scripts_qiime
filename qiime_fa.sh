#!/bin/bash

# Script qiime_fa.sh: para dados trimados a priori

# Todos os comentários estão identificados por cerquilha. Eles não são
#   reconhecidos pelo interpretador quando o QIIME for executado.

# Este scritp faz parte do meu TCC em MBA em redes linux, da Uniara 2016.
# O objetivo deste script é realizar a classificação de sequências fasta
# de 16S rRNA no QIIME

# Script versão 0.01, terminado dia 06/12/2016 ás 08:56h. Parte deste shell
#   script foi baseado em um script para QIIME, o qual é distribuído com o
#   Biolinux 8 (UBUNTU 14.04 LTS, http://environmentalomics.org/bio-linux/).

# Confira todos os scripts de QIIME v.1.9.1 em: http://qiime.org/scripts/

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
# 4) Antes de iniciar o script qiime_fa.sh, tenha certeza de que os
#   arquivos de 16S trimados no formato fasta estejam dentro do
#   diretório do qiime. Também adicione o arquivo map_file.txt
#   (http://qiime.org/documentation/file_formats.html#metadata-mapping-files)
#   e o arquivo custom_parameters.txt
#   (http://qiime.org/documentation/qiime_parameters_files.html) neste diretório
#
# 5) Para conhecer algumas análises e comandos que podem ser usados
#   com QIIME, visite:
#   http://qiime.org/tutorials/tutorial.html
#
#========================================================================

#========================================================================
#
# Verificando se a variável $QIIME_CONFIG está ativa. Ver mais em: 
# http://qiime.org/install/qiime_config.html
#
#========================================================================

	# Saindo de erros
	set -e

	echo -n " Executando em " ; pwd

	if [ -z "$QIIME_CONFIG_FP" ] ; then
		echo " A variável \$QIIME_CONFIG_FP não está ativa. "
		echo " Você deve executar este script no shell zsh do QIIME. Basta invocar \$qiime no terminal ... "
	exit 1
fi

#========================================================================
#
# Verificando se o diretório "trim_data" está criado. Em caso negativo, 
# ele será criado
#
#========================================================================

	# Diretório atual
	base_dir="."

	# input = diretório trim_data, para onde serão movidos os arquivos fastq,
	#   map_file.txt e custom_parameters.txt
	input="${base_dir}/trim_data"
	
	# Página 223 livro Programação Shell Linux, Cap. Liberdade Condicional, autor Júlio Cezar Nevess, 10ª edição, 2015
	# Verificando a existência do diretório $MeuDir, caso ele não exista, o shell o cria
	if [ ! -d "${input}" ]
	then
	mkdir ${input} && echo " Criando trim_data ... "
fi

#=======================================================================
#
# Variáveis que indicam a localização de arquivos e diretórios usados
# pelo QIIME. Dependendo da configuração de seu sistema, elas podem ser
# alteradas.
#
#=======================================================================


# Caminho absoluto para o banco de dados do SILVA verssão 119 (o mais atual até
#    27/04/2016, https://www.arb-silva.de/documentation/release-119/)
    silva="/db/mothur/silva/silva.nr_v119.align"

# Caminho absoluto para o banco de dados do RDP II versão de 14 de 03/2014
    rdp_fas="/db/mothur/rdp/trainset14_032015.rdp.fasta"
    rdp_tax="/db/mothur/rdp/trainset14_032015.rdp.tax"

# Caminho relativo para o arquivo map_file.txt
    map="${base_dir}/trim_data/map_file.txt"

# Caminho relativo para o arquivo custom_parameters.txt
    cust="${base_dir}/trim_data/custom_parameters.txt"

# Caminho relativo para diretório contendo os dados trimados
    trim="${base_dir}/trim_data/fastq_fna_dir"

# Caminho relativo para o diretório onde serão registrados logs de erro e
#    mensagens de execução dos scripts do QIIME
    logs="${base_dir}/logs"

# Caminho relativo para o diretório onde serão armazenados os dados processados
    proc="${base_dir}/out_analysis"

# Caminho relativo onde serão armazenados os arquivos trimados após a
#    concatenação
    conc="${base_dir}/trim_data/combined_fasta"

# Caminho para diretório rep_set
	rep="${conc}/rep_set"

# Caminho relativo para o diretório onde serão armazenados os dados de beta diversidade
    beta="${proc}/tds/beta_even"

# Caminho relativo para o diretório onde serão armazenados os dados da alfa diversidade
    alfa="${proc}/tds/alpha"

# Caminho relativo para o diretório onde serão armazenados os dados da análise Jackkniffe
    jack="${proc}/tds/jack"

# Caminho relativo para o script do uparse. Este script foi criado
#    exclusivamente para ser executado com QIIME
    uparse="/bin/uparse.sh"

# Caminho absoluto para os scripts do BMP
    bmp_map="/home/softwares/BMP-master/bmp-map2qiime.py"

# Caminho para os arquivos 97_otus.fasta e 97_otu_taxonomy.txt usado por Picrust
    picru_97_fa="/usr/share/qiime/data/gg_13_8_otus/rep_set/97_otus.fasta"
    picru_97_tx="/usr/share/qiime/data/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt"

#========================================================================
#
# Verificando se os arquivos map_file.txt e custom_parameters.txt estão no diretório atual. Em caso negativo, uma mensagem de erro será impressa.
#
#========================================================================


	ma=${base_cir}/map_file.txt
	cus=${base_dir}/custom_parameters.txt

    if [ ! -f ${cus} ] && [ ! -f ${ma} ]
    then
            echo " Arquivos ${cust} e ${map} não encontrados. Visite http://qiime.org/documentation/file_formats.html#metadata-mapping-files e http://qiime.org/documentation/qiime_parameters_files.html para maiores informações. "
	exit
	fi

#========================================================================
#
#        Removendo diretórios/subdiretórios usados pelo pipeline 
#	 em outras execuções
#
#========================================================================

		echo " Removendo diretórios antigos ( ${proc}  ${logs}  ${trim} ) ... "
 		rm -rf ${proc} ${logs} ${trim}

#========================================================================
#
#        Criando diretórios/subdiretórios usados pelo pipeline
#
#========================================================================

		echo " Criando os diretórios onde serão processados os dados por QIIME ... "
		mkdir -p ${base_dir}/${logs}
		mkdir -p ${base_dir}/${proc}/tds
		mkdir -p ${base_dir}/${proc}/arch
		mkdir -p ${base_dir}/${proc}/bact
		mkdir -p ${base_dir}/${trim}
		mkdir -p ${base_dir}/${rep}

#========================================================================
#
#                    Iniciando o pipeline do QIIME
#
#========================================================================

# Movendo os arquivos fasta, map_file.txt e custom_parameters.txt para os seus
#    respectivos diretórios

	mv ${base_dir}/map_file.txt ${base_dir}/trim_data
	mv ${base_dir}/custom_parameters.txt ${base_dir}/trim_data

    	echo "          Validando o arquivo map_file.txt (validate_mapping_file.py) ... "
        echo "		Quando checado com estas opções, um error irá aparecer. Isto é
                  	normal. O aviso diz que este tipo de formatação do arquivo só irá
                  	funcionar com o script qiime add_qiime_labels.py. Para saber mais:
                  	http://qiime.org/documentation/file_formats.html#metadata-mapping-files "
	validate_mapping_file.py -m ${map} -o ${proc}/check_id_output -p -b 1> ${logs}/validate_map_out.txt 2> ${logs}/validate_map_err.txt


#========================================================================
#	# Verificando a presença de arquivos fasta no diretório atual
	for fasta in `ls ${base_dir}/*.fasta` ; do

        # fnname - string com o nome do arquivo fasta
        fnname=`basename ${fasta} .fasta`
        echo "   ${fnname} ..."
	cp ${base_dir}/${fnname}.fasta ${trim}/${fnname}.fna 1> ${logs}/cp_arquivos_fasta_prinseq.out.txt 2> ${logs}/cp_arquivos_fasta_prinseq.err.txt

done;
#========================================================================

    	echo "          Adicionando cabeçalho das sequências/amostras nos arquivos fna recém convertidos (add_qiime_labels.py) ... "
        echo " 		Fazer o arquivo map_file.txt no LibryOffice Calc sem os barcodes e
                  	primerlinker. Salve em CSV, com tabulação. No diretório do arquivo
                  	salvo, retire da extenção .CSV e deixe map_file.txt. Esta estratégia
                  	funciona somente com o comando add_qiime_labels.py. "
    	add_qiime_labels.py -i ${trim} -m ${map} -c Treatment -n 1 -o ${conc} 1> ${logs}/add_qiime_lab_out.txt 2> ${logs}/add_qiime_lab_err.txt

        echo "		Renomeando o arquivo concatenado ( ${conc}/combined_seqs.fna ) para all.fna ( ${conc}/all.fna ) ... "
        mv ${conc}/combined_seqs.fna ${conc}/all.fna 1> ${logs}/mv_out.txt 2> ${logs}/mv_err.txt

            echo " Chamando script uparse via usearch para identificação/remoção de quimeras ... "
            ${uparse} 1> ${logs}/uparse_out.txt 2> ${logs}/uparse_err.txt

	echo "		Classificando as sequências com mothur e usando os arquivos ${rdp_fas} e ${rdp_tax} (97% de confiança) ... "
        echo "		Para ver outros bancos de dados que podem ser usados por QIIME,
                  	visite: http://qiime.org/home_static/dataFiles.html "
	assign_taxonomy.py -i ${conc}/otus.fa -m mothur -c 0.97 -r ${rdp_fas} -t ${rdp_tax} -o ${conc}/assign_tax 1> ${logs}/assign_taxonomy_out.txt 2> ${logs}/assign_taxonomy_err.txt

    	echo "          Alinhando as sequências com MUSCLE ... "
    	align_seqs.py -m muscle -i ${conc}/otus.fa -o ${rep}/rep_set_align -t ${silva} -p 0.97 1> ${logs}/align_seqs_out.txt 2> ${logs}/align_seqs_err.txt

    	echo "          Filtrando alinhamento ... "
    	filter_alignment.py -i ${rep}/rep_set_align/otus_aligned.fasta --remove_outliers -o ${rep}/filtered_alignment 1> ${logs}/filter_alignment_out.txt 2> ${logs}/filter_alignment_err.txt

    	echo "          Construindo a árvore guia ... "
    	make_phylogeny.py -i ${rep}/filtered_alignment/otus_aligned_pfiltered.fasta -o ${rep}/rep_set.tre 1> ${logs}/make_phylogeny_out.txt 2> ${logs}/make_phylogeny_err.txt

        echo "          Convertendo arquivo UC para otu-table.txt ( ${proc}/tds/otu_table.txt ) ... "
        echo "		Usando ${bmp_map} para converter $c{conc}/all_otu_map.uc para ${proc}/tds/otu_table.txt ... "
        python ${bmp_map} ${conc}/all_otu_map.uc > ${proc}/tds/otu_table.txt 2> ${logs}/bmp_map_err.txt

    	echo "          Convertendo arquivo ${proc}/tds/otu_table.txt para ${proc}/tds/otu-table.biom ... "
    	make_otu_table.py -i ${proc}/tds/otu_table.txt -t ${conc}/assign_tax/otus_tax_assignments.txt -o ${proc}/tds/otu_table.biom 1> ${logs}/make_otu_table_out.txt 2> ${logs}/make_otu_table_err.txt

        	ln -s -f ${proc}/tds/otu_table.biom . 1> ${logs}/ln_otu_table_biom_out.txt 2> ${logs}/ln_otu_table_biom_err.txt
		ln -s -f ${rep}/rep_set.tre . 1> ${logs}/ln_rep_set_tre_out.txt 2> ${logs}/ln_rep_set_tre_err.txt
		ln -s -f ${input}/map_file.txt . 1> ${logs}/ln_map_file_out.txt 2> ${logs}/ln_map_file_err.txt
		ln -s -f ${input}/custom_parameters.txt . 1> ${logs}/ln_custom_parameters_out.txt 2> ${logs}/ln_custom_parameters_err.txt

        echo "          Acessando arquivo ${conc}/otu_table.biom para identificar a menor quantidade de sequência e a que amostra pertence ... "
        biom summarize-table -i ${proc}/tds/otu_table.biom -o ${proc}/tds/results_biom_table 1> ${logs}/biom_summarize_table_out.txt 2> ${logs}/biom_summarize_table_err.txt


    	echo "          Executando alpha_rarefaction.py normalizando pela menor amostra ... "
	cat ${proc}/tds/results_biom_table | perl -e 'while(<>){if(/Min: (\d+)/){system(`alpha_rarefaction.py -i otu_table.biom -o alpha -m map_file.txt -e ${1} -t rep_set.tre --min_rare_depth 5`)}}' 1> ${logs}/results_biom_table_alpha_rarefaction_out.txt 2> ${logs}/results_biom_table_alpha_rarefaction_err.txt

        echo "		Ver o link http://scikit-bio.org/docs/latest/generated/skbio.diversity.alpha.html
                  	e http://qiime.org/1.6.0/scripts/alpha_diversity_metrics.html para saber outras opções que podem ser usadas. "
    	alpha_diversity.py -i ${proc}/tds/otu_table.biom -m chao1,ace,observed_otus,equitability,goods_coverage,simpson,shannon,observed_species -o ${proc}/tds/adiv_chao1_pd.txt -t ${rep}/rep_set.tre 1> ${logs}/alpha_diversity_out.txt 2> ${logs}/alpha_diversity_err.txt


	echo " shared_phylotypes.py "
	shared_phylotypes.py -i ${proc}/tds/otu_table.biom -o ${proc}/tds/shared_otus.txt 1> ${logs}/shared_phylotypes_out.txt 2> ${logs}/shared_phylotypes_err.txt


	echo "          Iniciando construção do conjunto de arquivos para análise Jackknifing (jackknifed_beta_diversity.py) ... "
	cat ${proc}/tds/results_biom_table | perl -e 'while(<>){if(/Min: (\d+)/){system(`jackknifed_beta_diversity.py -i otu_table.biom -p custom_parameters.txt -t rep_set.tre -m map_file.txt -o jack -e $1`)}}' 1> ${logs}/results_biom_table_jackknifed_beta_diversity_out.txt 2> ${logs}/results_biom_table_jackknifed_beta_diversity_err.txt


	echo "          Finalizando a construção da árvore Jackknifing dos dados sem quiméras (make_bootstrapped_tree.py) ... "
	#go out/jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf
	make_bootstrapped_tree.py -m ${base_dir}/jack/unweighted_unifrac/upgma_cmp/master_tree.tre -s ${base_dir}/jack/unweighted_unifrac/upgma_cmp/jackknife_support.txt -o ${base_dir}/jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf 1> ${logs}/make_bootstrapped_tree_out.txt 2> ${logs}/make_bootstrapped_tree_err.txt

	echo " Copiando o arquivo $PWD${jack}/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf para $PWD${jack} ... "
	cp ${base_dir}/jack/unweighted_unifrac/upgma_cmp/jackknife_named_nodes.pdf ${base_dir}/jack 1> ${logs}/cp_jack_tree_out.txt 2> ${logs}/cp_jack_tree_err.txt

        echo " Construção do gráfico de Análise de Componentes Principais (PCA - BETA-DIVERSITY) (beta_diversity_through_plots.py) ... "
        cat ${proc}/tds/results_biom_table | perl -e 'while(<>){if(/Min: (\d+)/){system(`beta_diversity_through_plots.py -i otu_table.biom -m map_file.txt -e $1 -t rep_set.tre -p custom_parameters.txt -o beta_even`)}}' 1> ${logs}/results_biom_table_beta_diversity_through_plots_out.txt 2> ${logs}/results_biom_table_beta_diversity_through_plots_err.txt


	echo "core_diversity tds ... "
	cat ${proc}/tds/results_biom_table | perl -e 'while(<>){if(/Min: (\d+)/){system(`core_diversity_analyses.py -i otu_table.biom -o core_tds -m map_file.txt -c Treatment -t rep_set.tre -e $1`)}}' 1> ${logs}/core_diversity_analyses_tds_out.txt 2> ${logs}/core_diversity_analyses_tds_err.txt

	echo " make_2d_plots.py ${base_dir}/beta_even/weighted_unifrac_pc.txt "
	make_2d_plots.py -i ${base_dir}/beta_even/weighted_unifrac_pc.txt -m ${map} -o ${base_dir}/beta_even/weighted_unifrac_2d 1> ${logs}/make_2d_plots_weighted_out.txt 2> ${logs}/make_2d_plots_weighted_err.txt

	echo " make_2d_plots.py ${base_dir}/beta_even/unweighted_unifrac_pc.txt "
	make_2d_plots.py -i ${base_dir}/beta_even/unweighted_unifrac_pc.txt -m ${map} -o ${base_dir}/beta_even/unweighted_unifrac_2d 1> ${logs}/make_2d_plots_unweighted_out.txt 2> ${logs}/make_2d_plots_unweighted_err.txt



#====================================================================================
#
# Análises de Archaea
#
#====================================================================================

	echo " filter_taxa_from_otu_table.py para Archaea ... "
	filter_taxa_from_otu_table.py -i ${proc}/tds/otu_table.biom -o ${proc}/arch/otu_table_arch_only.biom -p Archaea
	biom summarize-table -i ${proc}/arch/otu_table_arch_only.biom -o ${proc}/arch/results_biom_table_arch_only 1> ${logs}/biom_summarize_table_arch_out.txt 2> ${logs}/biom_summarize_table_arch_err.txt

                ln -s ${proc}/arch/otu_table_arch_only.biom . 1> ${logs}/ln_otu_table_arch_only_out.txt 2> ${logs}/ln_otu_table_arch_only_err.txt

	echo " filter_fasta.py para Archaea ... "
	filter_fasta.py -f ${conc}/otus.fa -o ${proc}/arch/biom_filt_seqs_arch.fa -b ${proc}/arch/otu_table_arch_only.biom 1> ${logs}/filter_fasta_arch_out.txt 2> ${logs}/filter_fasta_arch_err.txt

	echo " normalize_table.py para Archaea ... "
	normalize_table.py -i ${proc}/arch/otu_table_arch_only.biom -a CSS -o ${proc}/arch/CSS_normalized_otu_table_arch.biom 1> ${logs}/CSS_normalized_otu_table_arch_out.txt 2> ${logs}/CSS_normalized_otu_table_arch_err.txt

	echo " biom summarize-table para Archaea ... "
	biom summarize-table -i ${proc}/arch/CSS_normalized_otu_table_arch.biom -o ${proc}/arch/results_CSS_normalized_otu_table_arch 1> ${logs}/biom_summarize_table_CSS_normalized_otu_table_arch_out.txt 2> ${logs}/biom_summarize_table_CSS_normalized_otu_table_arch_err.txt

	echo " summarize_taxa_through_plots.py para Archaea ... "
	summarize_taxa_through_plots.py -o ${proc}/arch/taxa_summary_arch -i ${proc}/arch/CSS_normalized_otu_table_arch.biom -m ${map} -l 1,2,3,4,5,6,7 1> ${logs}/summarize_taxa_through_plots_arch_out.txt 2> ${logs}/summarize_taxa_through_plots_arch_err.txt

	echo " core_diversity_analyses.py para Archaea ... "
	cat ${proc}/arch/results_biom_table_arch_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`core_diversity_analyses.py -i otu_table_arch_only.biom -o core_arch -m map_file.txt -c Treatment -t rep_set.tre -e $1`)}}' 1> ${logs}/core_diversity_analyses_arch_out.txt 2> ${logs}/core_diversity_analyses_arch_err.txt

    	echo "          Executando alpha_rarefaction.py normalizando pela menor amostra (Archaea) ... "
	cat ${proc}/arch/results_biom_table_arch_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`alpha_rarefaction.py -i otu_table_arch_only.biom -o alpha_arch -m map_file.txt -e ${1} -t rep_set.tre --min_rare_depth 5`)}}' 1> ${logs}/results_biom_table_alpha_rarefaction_arch_out.txt 2> ${logs}/results_biom_table_alpha_rarefaction_arch_err.txt

        echo "		Ver o link http://scikit-bio.org/docs/latest/generated/skbio.diversity.alpha.html
                  	e http://qiime.org/1.6.0/scripts/alpha_diversity_metrics.html para saber outras opções que podem ser usadas (Archaea) ... "
    	alpha_diversity.py -i ${proc}/arch/CSS_normalized_otu_table_arch.biom -m chao1,ace,observed_otus,equitability,goods_coverage,simpson,shannon,observed_species -o ${proc}/arch/adiv_chao1_pd_arch.txt -t ${rep}/rep_set.tre 1> ${logs}/alpha_diversity_arch_out.txt 2> ${logs}/alpha_diversity_arch_err.txt

	echo " shared_phylotypes.py (Archaea) ... "
	shared_phylotypes.py -i ${proc}/arch/CSS_normalized_otu_table_arch.biom -o ${proc}/arch/shared_otus_arch.txt 1> ${logs}/shared_phylotypes_arch_out.txt 2> ${logs}/shared_phylotypes_arch_err.txt

        echo " Construção do gráfico de Análise de Componentes Principais para Archaea (PCA - BETA-DIVERSITY) (beta_diversity_through_plots.py) ... "
        cat ${proc}/arch/results_biom_table_arch_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`beta_diversity_through_plots.py -i otu_table_arch_only.biom -m map_file.txt -e $1 -t rep_set.tre -p custom_parameters.txt -o beta_even_arch`)}}' 1> ${logs}/results_biom_table_beta_diversity_through_plots_arch_out.txt 2> ${logs}/results_biom_table_beta_diversity_through_plots_arch_err.txt



#====================================================================================
#
# Análises de Bacteria
#
#====================================================================================


	echo " filter_taxa_from_otu_table.py para Bacteria ... "
	filter_taxa_from_otu_table.py -i ${proc}/tds/otu_table.biom -o ${proc}/bact/otu_table_bact_only.biom -p Bacteria
	biom summarize-table -i ${proc}/bact/otu_table_bact_only.biom -o ${proc}/bact/results_biom_table_bact_only 1> ${logs}/biom_summarize_table_bact_out.txt 2> ${logs}/biom_summarize_table_bact_err.txt

                ln -s ${proc}/bact/otu_table_bact_only.biom . 1> ${logs}/ln_otu_table_bact_only_out.txt 2> ${logs}/ln_otu_table_bact_only_err.txt

	echo " filter_fasta.py para Bacteria ... "
	filter_fasta.py -f ${conc}/otus.fa -o ${proc}/bact/biom_filt_seqs_bact.fa -b ${proc}/bact/otu_table_bact_only.biom 1> ${logs}/filter_fasta_bact_out.txt 2> ${logs}/filter_fasta_bact_err.txt

	echo " normalize_table.py para Bacteria ... "
	normalize_table.py -i ${proc}/bact/otu_table_bact_only.biom -a CSS -o ${proc}/bact/CSS_normalized_otu_table_bact.biom 1> ${logs}/CSS_normalized_otu_table_bact_out.txt 2> ${logs}/CSS_normalized_otu_table_bact_err.txt

	echo " biom summarize-table para Bacteria ... "
	biom summarize-table -i ${proc}/bact/CSS_normalized_otu_table_bact.biom -o ${proc}/bact/results_CSS_normalized_otu_table_bact 1> ${logs}/biom_summarize_table_CSS_normalized_otu_table_bact_out.txt 2> ${logs}/biom_summarize_table_CSS_normalized_otu_table_bact_err.txt

	echo " summarize_taxa_through_plots.py para Bacteria ... "
	summarize_taxa_through_plots.py -o ${proc}/bact/taxa_summary_bact -i ${proc}/bact/CSS_normalized_otu_table_bact.biom -m ${map} 1> ${logs}/summarize_taxa_through_plots_bact_out.txt 2> ${logs}/summarize_taxa_through_plots_bact_err.txt

	echo " core_diversity_analyses.py para Bacteria ... "
	cat ${proc}/bact/results_biom_table_bact_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`core_diversity_analyses.py -i otu_table_bact_only.biom -o core_bact -m map_file.txt -c Treatment -t rep_set.tre -e $1`)}}' 1> ${logs}/core_diversity_analyses_bact_out.txt 2> ${logs}/core_diversity_analyses_bact_err.txt

    	echo "          Executando alpha_rarefaction.py normalizando pela menor amostra (Bacteria) ... "
	cat ${proc}/bact/results_biom_table_bact_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`alpha_rarefaction.py -i otu_table_bact_only.biom -o alpha_bact -m map_file.txt -e ${1} -t rep_set.tre --min_rare_depth 5`)}}' 1> ${logs}/results_biom_table_alpha_rarefaction_bact_out.txt 2> ${logs}/results_biom_table_alpha_rarefaction_bact_err.txt

        echo "		Ver o link http://scikit-bio.org/docs/latest/generated/skbio.diversity.alpha.html
                  	e http://qiime.org/1.6.0/scripts/alpha_diversity_metrics.html para saber outras opções que podem ser usadas (Bacteria) ... "
    	alpha_diversity.py -i ${proc}/bact/CSS_normalized_otu_table_bact.biom -m chao1,ace,observed_otus,equitability,goods_coverage,simpson,shannon,observed_species -o ${proc}/bact/adiv_chao1_pd_bact.txt -t ${rep}/rep_set.tre 1> ${logs}/alpha_diversity_bact_out.txt 2> ${logs}/alpha_diversity_bact_err.txt

	echo " shared_phylotypes.py (Bacteria) ... "
	shared_phylotypes.py -i ${proc}/bact/CSS_normalized_otu_table_bact.biom -o ${proc}/bact/shared_otus_bact.txt 1> ${logs}/shared_phylotypes_bact_out.txt 2> ${logs}/shared_phylotypes_bact_err.txt


        echo " Construção do gráfico de Análise de Componentes Principais para Bacteria (PCA - BETA-DIVERSITY) (beta_diversity_through_plots.py) ... "
        cat ${proc}/bact/results_biom_table_bact_only | perl -e 'while(<>){if(/Min: (\d+)/){system(`beta_diversity_through_plots.py -i otu_table_bact_only.biom -m map_file.txt -e $1 -t rep_set.tre -p custom_parameters.txt -o beta_even_bact`)}}' 1> ${logs}/results_biom_table_beta_diversity_through_plots_bact_out.txt 2> ${logs}/results_biom_table_beta_diversity_through_plots_bact_err.txt






	echo " pick_closed_reference_otus.py "
	echo "pick_otus:enable_rev_strand_match True"  >> ${base_dir}/trim_data/otu_picking_params_97.txt
	echo "pick_otus:similarity 0.97" >> ${base_dir}/trim_data/otu_picking_params_97.txt
	pick_closed_reference_otus.py -i ${conc}/all.fna -f -o ${proc}/ucrC97 -p ${base_dir}/trim_data/otu_picking_params_97.txt -r ${picru_97_fa} -t ${picru_97_tx}

	echo " filter_otus_from_otu_table.py "
	filter_otus_from_otu_table.py -i ${proc}/ucrC97/otu_table.biom -o ${proc}/ucrC97/closed_otu_table.biom --negate_ids_to_exclude -e ${picru_97_fa}

	echo "  Biom convert from txt "
	biom convert -i ${proc}/ucrC97/closed_otu_table.biom -o ${proc}/ucrC97/table.from_biom_json.tab --table-type="OTU table" --to-json
#	biom convert -i ${proc}/ucrC97/closed_otu_table.biom -o ${proc}/ucrC97/table.from_biom.txt --to-tsv



	mv alpha ${proc}/tds
	mv jack ${proc}/tds
	mv beta_even ${proc}/tds
	mv core_tds ${proc}/tds



mv core_arch ${proc}/arch
mv alpha_arch ${proc}/arch
mv beta_even_arch ${proc}/arch

mv core_bact ${proc}/bact
mv alpha_bact ${proc}/bact
mv beta_even_bact ${proc}/bact


	rm -f map_file.txt
	rm -f rep_set.tre
	rm -f otu_table.biom
	rm -f custom_parameters.txt
	rm -f otu_table_arch_only.biom
	rm -f otu_table_bact_only.biom

exit;
