FROM granatumx/gbox-py-sdk:1.0.0

COPY ./install_from_CRAN.R .

RUN Rscript ./install_from_CRAN.R BiocManager
RUN Rscript ./install_from_CRAN.R RCurl
RUN Rscript ./install_from_CRAN.R XML
RUN Rscript ./install_from_CRAN.R survival
RUN Rscript ./install_from_CRAN.R samr
RUN Rscript ./install_from_CRAN.R combinat
RUN Rscript ./install_from_CRAN.R remotes

COPY ./install_from_bioconductor.R .

RUN Rscript ./install_from_bioconductor.R impute
RUN Rscript ./install_from_bioconductor.R limma
RUN Rscript ./install_from_bioconductor.R edgeR
RUN Rscript ./install_from_bioconductor.R SummarizedExperiment
RUN Rscript ./install_from_bioconductor.R genefilter
RUN Rscript ./install_from_bioconductor.R geneplotter
RUN Rscript ./install_from_bioconductor.R DESeq2
RUN Rscript ./install_from_bioconductor.R Biobase

COPY ./install_from_github.R .
RUN Rscript ./install_from_github.R metaOmics/MetaDE

COPY . .

RUN ./GBOXtranslateVERinYAMLS.sh
RUN tar zcvf /gbox.tgz package.yaml yamls/*.yaml
