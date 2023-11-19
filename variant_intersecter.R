#!/usr/bin/env Rscript

library(data.table)
suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
library(cli)

#!/usr/bin/env Rscript
cargs = commandArgs(trailingOnly=TRUE)

if (length(cargs)==0 | length(cargs)>2) {
  cat(col_green("Usage: Rscript Variant_Intersecter.R file1 file2\n"))
  cat(col_green("File formats accepted: .vcf, .vcf.gz, .bim\n"))
  cat(col_green("Both files should be of same genomic build\n"))
  stop()
}

get_variants <- function(varfile) {
  if (str_ends(varfile,"\\.bim")) {
    varfile <- fread(varfile)
    return(paste(varfile$V1,varfile$V4,sep=":"))
  } else if (str_ends(varfile,"\\.vcf") | str_ends(varfile,"\\.vcf.gz")) {
    varfile <- fread(varfile)
    return(paste(varfile$`#CHROM`,varfile$POS,sep=":"))
  } else {
    cli_abort(col_red("File formats accepted are .vcf, .vcf.gz, and .bim. Are you sure your input files end with one of these extensions?\n"))
  }
}

file1 = get_variants(cargs[1])
file2 = get_variants(cargs[2])

cat("Common variants:",length(intersect(file1,file2)),"\n")
cat("File 1 specific:",length(setdiff(file1,file2)),"\n")
cat("File 2 specific:",length(setdiff(file2,file1)),"\n")
