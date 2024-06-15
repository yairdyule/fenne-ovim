(local vim vim)

[{1 :stevearc/oil.nvim
  :event :VimEnter
  :config (fn []
            (local oil (require :oil))
            (oil.setup {:default_file_explorer true
                        :columns [; :permissions 
                                  ; :mtime 
                                  ; :size 
                                  :icon]
                        :keymaps {:q :actions.close
                                  ; TODO: Why doesn't this apply? <C-H> splits, not <C-x>.
                                  :C-x :actions.select_split
                                  :C-v :actions.select_vsplit}})
            (vim.keymap.set :n :<leader>e :<CMD>Oil<CR> {}))}
 ; I don't use this plugin anymore, but I'm keeping it here for reference
 {1 :nvim-neo-tree/neo-tree.nvim
  :branch :v3.x
  :dependencies [:nvim-lua/plenary.nvim
                 :nvim-tree/nvim-web-devicons
                 :MunifTanjim/nui.nvim]
  :config (fn []
            (local neotree (require :neo-tree))
            (neotree.setup {})
            (vim.keymap.set :n :<C-n> "<CMD>Neotree toggle reveal<CR>" {}))}]

