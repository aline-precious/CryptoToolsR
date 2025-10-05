library(testthat)
source("R/hill_cipher.R")

test_that("encrypt and decrypt round trip 2x2", {
  K <- matrix(c(3,3,2,5), nrow=2)
  pt <- "HELLOX"
  ct <- hill_encrypt(pt, K)
  de <- hill_decrypt(ct, K)
  expect_equal(gsub("X+$","",de), gsub("X+$","",toupper(gsub("[^A-Z]","",pt))))
})

test_that("random invertible key produces round-trip", {
  K <- random_invertible_key()
  pt <- "SOMERANDOMTEXT"
  ct <- hill_encrypt(pt, K)
  de <- hill_decrypt(ct, K)
  expect_equal(gsub("X+$","",de), gsub("X+$","",toupper(gsub("[^A-Z]","",pt))))
})
