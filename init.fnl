(local vim vim)

;; TODO: Rainbow parens in lisp mode
;; XXX: Unified wezterm/vim colorscheme
;; TODO: Integrate nvim-jqx https://github.com/gennaro-tedesco/nvim-jqx
(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")
(local modules [:autocommands :options :lazy-bootstrap :general-bindings])

(each [_ m (ipairs modules)]
  (require m))

(let [lazy (require :lazy)]
  (lazy.setup :plugins))

(local is-dark true)
(vim.cmd (if is-dark "colorscheme onedark" "colorscheme github_light_default"))

