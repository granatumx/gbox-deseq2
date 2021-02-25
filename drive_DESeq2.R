library(DESeq2)
library(Biobase)
library("BiocParallel")
register(MulticoreParam(14))

## rw: the expression matrix
## phe: the phenotype (grouping) vector
run_DESeq <- function(rw, phe) {
  se <- SummarizedExperiment(SimpleList(counts=as.matrix(rw)), colData=DataFrame(phe=phe))
  dds <- DESeqDataSet(se, ~ phe)
  dds <- DESeq(dds, parallel=TRUE)
  res <- results(dds)
  print(res)
  return(res)
  ## log(assays(se)$fpkm+1)[order(res$padj),] %>% zh
  ## leadingGenesDESeq2 <- rownames(res[order(res$padj),])[1:1000]
  ## return {
}
