(local vim vim)

{1 :lewis6991/gitsigns.nvim
 :lazy false
 :config (fn []
           (local gitsigns (require :gitsigns))
           (gitsigns.setup {:signs {:add {:text "▌"} :change {:text "▌"}}})
           (vim.keymap.set :n :<leader>gp
                           (fn []
                             (gitsigns.preview_hunk_inline))
                           {:silent true}))}

