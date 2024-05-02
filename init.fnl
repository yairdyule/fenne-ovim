(local vim vim)

(require :au)
(require :options)
(require :lazy-bs)
(require :general-bindings)

(local leader " ")

(set vim.g.mapleader leader)
(set vim.g.maplocalleader leader)

(local lazy (require :lazy))
(lazy.setup :plugins)

