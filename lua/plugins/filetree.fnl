(local vim vim)

{1 :nvim-neo-tree/neo-tree.nvim
 :branch :v3.x
 :dependencies [:nvim-lua/plenary.nvim
                :nvim-tree/nvim-web-devicons
                :MunifTanjim/nui.nvim]
 :config (fn []
           (local neotree (require :neo-tree))
           (neotree.setup {})
           (vim.keymap.set :n :<leader>e "<CMD>Neotree toggle reveal<CR>" {}))
 ;; end of configs -- leaving this comment s.t. I can easily add more plugins w/o having to find the closing
 }

