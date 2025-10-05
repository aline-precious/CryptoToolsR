# CryptoTools — Hill Cipher & Cryptanalysis Suite (R) 🔐

**CryptoTools** is a hands-on R toolkit for exploring **matrix-based cryptography** (Hill cipher) and **basic cryptanalysis**. Encrypt, decrypt, analyze, and even attempt key recovery — all while learning how linear algebra powers modern cryptography.

Perfect for students, hobbyists, or anyone looking to **showcase practical cybersecurity skills** in R.

---

## 🚀 Why This Project Matters
- Connects **linear algebra** with real-world cryptography.
- Demonstrates **modular arithmetic** and **matrix inversion mod 26**.
- Provides **ciphertext analysis tools**: frequency histograms, English similarity scoring, brute-force cracking.
- Fully **ready-to-demo** on GitHub — a polished showcase of cryptography and R programming.

---

## ⚡ Features
| File | Purpose |
|------|--------|
| `R/hill_cipher.R` | Core Hill cipher: encryption, decryption, key generation, padding |
| `R/freq_analysis.R` | Analyze ciphertext frequency & English-similarity scoring |
| `R/cracker.R` | Brute-force search & candidate ranking (2×2 keys) |
| `scripts/cryptotools_cli.R` | Command-line interface for quick encrypt/decrypt |
| `demo/cryptotools_demo.Rmd` | Hands-on demo notebook |
| `tests/test_hill.R` | Unit tests ensuring correct functionality |

---

## ⚡ Quick Start
1. **Clone the repo** and open in **RStudio** or R console.  
2. **Source the main Hill cipher script**:
```r
source("R/hill_cipher.R")
