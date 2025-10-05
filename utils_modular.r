# helpers for modular arithmetic and matrix inverse (mod m)

mod <- function(x, m=26) {
  ((x %% m) + m) %% m
}

egcd <- function(a, b) {
  # extended gcd: returns list(g, x, y) with ax + by = g
  if (b == 0) return(list(g = a, x = 1, y = 0))
  r <- egcd(b, a %% b)
  list(g = r$g, x = r$y, y = r$x - floor(a / b) * r$y)
}

modinv <- function(a, m=26) {
  # modular inverse of a mod m, or NA if none
  r <- egcd(a, m)
  if (r$g != 1) return(NA)
  mod(r$x, m)
}

matrix_mod_inv <- function(A, m=26) {
  # modular inverse of an integer matrix A mod m (A must be square)
  if (!is.matrix(A) || nrow(A) != ncol(A)) stop("A must be square matrix")
  n <- nrow(A)
  detA <- round(det(A))  # determinant as integer
  det_mod <- mod(detA, m)
  inv_det <- modinv(det_mod, m)
  if (is.na(inv_det)) return(NULL) # not invertible mod m
  # compute adjugate (classical adjoint)
  adj <- matrix(0, n, n)
  for (i in 1:n) {
    for (j in 1:n) {
      # minor M_ji because adj(A) = cofactor^T
      M <- A[-j, -i, drop=FALSE] # note swapped indices for transpose
      cofactor <- (-1)^(i+j) * round(det(M))
      adj[i, j] <- cofactor
    }
  }
  invA <- mod(inv_det * adj, m)
  return(invA)
}
