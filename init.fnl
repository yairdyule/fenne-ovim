(local vim vim)

(local leader " ")
(set vim.g.mapleader leader)
(set vim.g.maplocalleader leader)

(require :au)
(require :options)
(require :lazy-bs)
(require :general-bindings)

(local lazy (require :lazy))
(lazy.setup :plugins)

