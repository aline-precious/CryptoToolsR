#!/usr/bin/env Rscript

# CLI to encrypt/decrypt using hill cipher
suppressPackageStartupMessages(library(optparse))
source("R/hill_cipher.R")
source("R/freq_analysis.R")

option_list <- list(
  make_option(c("-m","--mode"), type="character", default="encrypt",
              help="encrypt | decrypt", metavar="MODE"),
  make_option(c("-k","--key"), type="character", default=NULL,
              help="key matrix entries comma-separated, row-major (e.g. '3,3,2,5' for 2x2)", metavar="KEY"),
  make_option(c("-n","--n"), type="integer", default=2,
              help="block size n (key is n x n)", metavar="N"),
  make_option(c("-t","--text"), type="character", default=NULL,
              help="text to process", metavar="TEXT")
)

opt <- parse_args(OptionParser(option_list = option_list))
if (is.null(opt$key) || is.null(opt$text)) {
  cat("Please provide --key and --text\n")
  q(status=1)
}
entries <- as.integer(unlist(strsplit(opt$key, ",")))
K <- matrix(entries, nrow = opt$n, byrow = TRUE)
if (opt$mode == "encrypt") {
  cat("Ciphertext:\n")
  cat(hill_encrypt(opt$text, K), "\n")
} else {
  cat("Plaintext:\n")
  cat(hill_decrypt(opt$text, K), "\n")
}
