;; hack to avoid all other `vim` usages triggering diagnostics

(require :au)
(require :options)
(require :lazy-bs)

(local vim vim)

(local leader " ")
(set vim.g.mapleader leader)
(set vim.g.maplocalleader leader)

(let [key-bindings [[:n :<Esc> :<CMD>nohlsearch<CR>]
                    [:n :<C-l> :<C-w><C-l>]
                    [:n :<C-j> :<C-w><C-j>]
                    [:n :<C-k> :<C-w><C-k>]
                    [:n :<C-h> :<C-w><C-h>]
                    [:n :<C-s> :<CMD>w<CR>]
                    [:n :<C-y> :5<C-y>]
                    [:n :<C-e> :5<C-e>]
                    [:t :<Esc> "<C-\\><C-n>"]
                    [:n
                     :<leader>vt
                     (fn []
                       (local is-disabled (vim.diagnostic.is_disabled))
                       (if is-disabled
                           (vim.diagnostic.enable)
                           (vim.diagnostic.disable)))]]]
  (each [_ binding (ipairs key-bindings)]
    (let [[mode key command] binding]
      (vim.keymap.set mode key command))))

(local lazy (require :lazy))
(lazy.setup :plugins)

{}

