(local vim vim)

;; TODO: Rainbow parens in lisp mode
;; TODO: Unified wezterm/vim colorscheme
;; TODO: <Tab> through position in snippets
;; TODO: Integrate nvim-jqx https://github.com/gennaro-tedesco/nvim-jqx

(set vim.o.background :dark)
(set vim.g.colorscheme :onedark)
(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(local modules [:autocommands :options :lazy-bootstrap :general-bindings])
(each [_ m (ipairs modules)]
  (require m))

(let [lazy (require :lazy)]
  (lazy.setup :plugins))

