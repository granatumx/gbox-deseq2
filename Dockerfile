FROM granatumx/gbox-py-sdk:1.0.0

RUN apt-get install -y gnupg
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN echo "deb http://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y r-base-core r-base r-base-dev r-recommended
RUN apt-get install -y libcurl4-gnutls-dev libcurl4-gnutls-dev libssl-dev

RUN R -e 'install.packages("BiocManager")'
RUN R -e 'install.packages("remotes")'

RUN R -e 'install.packages(c("RCurl", "XML", "survival", "samr", "combinat"))'

RUN R -e 'install.packages("devtools")'

RUN R -e 'devtools::install_version("flexmix", version = "2.3-13", repos = "http://cran.us.r-project.org")'

RUN R -e 'install.packages(c("jsonlite"))'
RUN R -e 'BiocManager::install(c("impute"))'
RUN R -e 'BiocManager::install(c("limma"))'
RUN R -e 'BiocManager::install(c("edgeR"))'
RUN R -e 'BiocManager::install(c("SummarizedExperiment"))'
RUN R -e 'BiocManager::install(c("genefilter"))'
RUN R -e 'BiocManager::install(c("geneplotter"))'
RUN R -e 'BiocManager::install(c("Biobase"))'
# RUN R -e 'BiocManager::install(c("DESeq2"))'
RUN apt-get install -y git
# RUN R -e 'remotes::install_bioc(c("DESeq2"))'
RUN apt-get install -y libcairo2-dev libxt-dev
RUN R -e 'BiocManager::install("scde")'
RUN R -e 'remotes::install_bioc("DESeq2")'
RUN R -e 'remotes::install_github("metaOmics/MetaDE")'

COPY . .

RUN ./GBOXtranslateVERinYAMLS.sh
RUN tar zcvf /gbox.tgz package.yaml yamls/*.yaml
