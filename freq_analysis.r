# Frequency analysis helpers
library(ggplot2)

letter_freq <- function(text) {
  t <- gsub("[^A-Z]","", toupper(text))
  tabs <- table(strsplit(t, "")[[1]])
  freq <- as.integer(tabs)
  names(freq) <- names(tabs)
  freq
}

plot_freq <- function(text, title="Letter frequency") {
  freq <- letter_freq(text)
  df <- data.frame(letter = names(freq), count = as.integer(freq))
  ggplot(df, aes(x=reorder(letter, -count), y=count)) +
    geom_col() + labs(title = title, x="Letter", y="Count")
}

chi_squared_score <- function(text) {
  # compare to english letter frequencies (approx)
  eng <- c(
    A=8.167, B=1.492, C=2.782, D=4.253, E=12.702, F=2.228, G=2.015, H=6.094,
    I=6.966, J=0.153, K=0.772, L=4.025, M=2.406, N=6.749, O=7.507, P=1.929,
    Q=0.095, R=5.987, S=6.327, T=9.056, U=2.758, V=0.978, W=2.360, X=0.150,
    Y=1.974, Z=0.074
  )
  txt <- toupper(gsub("[^A-Z]","", text))
  n <- nchar(txt)
  if (n == 0) return(Inf)
  obs <- table(strsplit(txt,"")[[1]])
  all_letters <- names(eng)
  obs_vector <- sapply(all_letters, function(L) ifelse(!is.na(obs[L]), obs[L], 0))
  exp_vector <- eng/100 * n
  sum((obs_vector - exp_vector)^2 / exp_vector)
}
