source("R/utils_modular.R")

# conversions
char_to_num <- function(ch) {
  utf8ToInt(ch) - utf8ToInt("A")
}
num_to_char <- function(n) {
  intToUtf8(mod(n,26) + utf8ToInt("A"))
}

string_to_nums <- function(s) {
  s <- gsub("[^A-Za-z]", "", toupper(s))
  sapply(strsplit(s, "")[[1]], char_to_num)
}

nums_to_string <- function(nums) {
  paste0(sapply(nums, num_to_char), collapse = "")
}

pad_vector <- function(nums, n) {
  if (length(nums) %% n == 0) return(nums)
  pad_len <- n - (length(nums) %% n)
  c(nums, rep(char_to_num("X"), pad_len))
}

hill_encrypt <- function(plaintext, K, m=26) {
  nums <- string_to_nums(plaintext)
  n <- nrow(K)
  nums <- pad_vector(nums, n)
  blocks <- split(nums, ceiling(seq_along(nums)/n))
  encrypted <- unlist(lapply(blocks, function(block) {
    v <- matrix(block, nrow=n)
    mod((K %*% v), m)
  }))
  nums_to_string(encrypted)
}

hill_decrypt <- function(ciphertext, K, m=26) {
  nums <- string_to_nums(ciphertext)
  n <- nrow(K)
  if (length(nums) %% n != 0) stop("Ciphertext length not multiple of block size")
  Kinv <- matrix_mod_inv(K, m)
  if (is.null(Kinv)) stop("Key matrix is not invertible mod m; cannot decrypt.")
  blocks <- split(nums, ceiling(seq_along(nums)/n))
  decrypted <- unlist(lapply(blocks, function(block) {
    v <- matrix(block, nrow=n)
    mod((Kinv %*% v), m)
  }))
  nums_to_string(decrypted)
}

# convenience: generate random invertible key (n x n)
random_invertible_key <- function(n=2, m=26, tries=1000) {
  for (i in seq_len(tries)) {
    K <- matrix(sample(0:(m-1), n*n, replace=TRUE), nrow=n)
    if (!is.null(matrix_mod_inv(K, m))) return(K)
  }
  stop("failed to find invertible key")
}
