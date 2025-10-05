source("R/hill_cipher.R")
source("R/freq_analysis.R")

# brute-force search for 2x2 keys (warning: can be heavy)
bruteforce_hill_2x2 <- function(ciphertext, plaintext_sample = NULL, m=26, limit = NULL) {
  # If plaintext_sample provided (a known crib), test candidate keys by decrypting first len(crib) letters.
  # limit - maximum tries, helpful to avoid long runtime
  candidates <- list()
  count <- 0
  for (a in 0:25) for (b in 0:25) for (c in 0:25) for (d in 0:25) {
    count <- count + 1
    if (!is.null(limit) && count > limit) return(candidates)
    K <- matrix(c(a,b,c,d), nrow=2, byrow=TRUE)
    if (is.null(matrix_mod_inv(K, m))) next
    # attempt decrypt
    decrypted <- tryCatch(hill_decrypt(ciphertext, K, m=m), error=function(e) NULL)
    if (is.null(decrypted)) next
    if (!is.null(plaintext_sample)) {
      # check whether plaintext sample matches beginning
      if (startsWith(decrypted, toupper(gsub("[^A-Za-z]","", plaintext_sample)))) {
        candidates[[length(candidates)+1]] <- list(K=K, decrypted=decrypted)
      }
    } else {
      # compute chi-score and keep top few by score
      score <- chi_squared_score(decrypted)
      candidates[[length(candidates)+1]] <- list(K=K, decrypted=decrypted, score=score)
    }
  }
  candidates
}

# wrapper to rank by chi score
rank_candidates_by_chi <- function(candidates, top_n=10) {
  df <- do.call(rbind, lapply(candidates, function(x) {
    data.frame(a=x$K[1,1], b=x$K[1,2], c=x$K[2,1], d=x$K[2,2],
               decrypted = x$decrypted, score = ifelse(is.null(x$score), chi_squared_score(x$decrypted), x$score),
               stringsAsFactors=FALSE)
  }))
  df[order(df$score),][1:min(top_n, nrow(df)),]
}
