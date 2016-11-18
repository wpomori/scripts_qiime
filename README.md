# scripts_qiime
Scripts for QIIME that will be used for my defense of TCC MBA Uniara 2017

Os scripts aqui apresentados foram construídos em Bourn Shell Again (BASH) e Ubuntu 14.04 LTS.

O script principal é o start.sh, o qual pode invocar o qiime_fa.sh, qiime_fq.sh, qiime_sg_raw.sh e qiime_pe_pa.sh. Abaixo eles são melhores explicados:

  -start.sh: permite ao usuário escolher entre seis opções, sendo que o número 1 chama o script qiime_fa.sh, o 2 chama o qiime_fq.sh, o 3 qiime_sg_raw.sh e o 4 qiime_pe_pa.sh. As opções 5 e 6 representam uma informação de ajuda para entender o propósito do programa e saída do mesmo;
  -qiime_fa.sh: caso o usuário selecione a opção 1, este script será invocado. Ele realiza análise de alfa- e beta-diversidade a partir de dados de 16S de fasta de nucleotídeos trimados a priori;
  -qiime_fq.sh: caso o usuário selecione a opção 2, este script será invocado. Ele realiza análise de alfa- e beta-diversidade a partir de dados de 16S de arquivo fastq, trimados a priori;
  -qiime_sg_raw.sh: antes de iniciar as análises de alfa- e beta-diversidade com QIIME v.1.9.1, este script para dados fastq single-end invoca o pipeline de trimagem pipe_trim_ion_16s.sh, o qual usa Cutadapt para remover sequências de adaptadores, primers, barcodes e sequências menores do que 50pb. A seguir, os dados são trimados para Q Phred < 20, sequências menores do que 300pb e maiores do que 415pb usando Prinseq. Os dados são processados por FastQC para aferir a qualidade antes e após as etapas de trimagem. Por último o programa invoca o script qiime_fa.sh para realização das análises no QIIME.
  -qiime_pe_pa.sh: este script aceita como entrada dados paired-end não trimados, os quais tem suas extremidades unidas por Pandaseq usando inferencia "simple bayesian". A seguir ele dispara os programas Cutadapt, Prinseq e FastQC, terminando com as análises no QIIME.
  -uparse.sh: após a trimagem, todos os programas das opções de 1-4 do programa start.sh usam a abordagem UPARSE do USEARCH para identificar e eliminar sequências quimeras.
