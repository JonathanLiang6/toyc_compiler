(lang dune 3.17)
(using menhir 3.0)

(name toyc_compiler)

(generate_opam_files true)

(source
 (github username/ToyC_Compiler))

(authors "Your Name <your-email@example.com>")

(maintainers "Your Name <your-email@example.com>")

(license MIT)

(documentation https://github.com/username/ToyC_Compiler)

(package
 (name toyc_compiler)
 (synopsis "ToyC compiler with RISC-V code generation")
 (description "A complete ToyC programming language compiler that generates RISC-V 32-bit assembly code. Designed for educational purposes.")
 (depends ocaml dune menhir)
 (tags
  ("compiler" "riscv" "ocaml" "educational" "toy-language")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
