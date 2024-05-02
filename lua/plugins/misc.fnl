(local vim vim)

[{1 :Olical/nfnl :ft :fennel}
 {1 :folke/which-key.nvim :event :VimEnter :opts {}}
 {1 :folke/twilight.nvim
  :config true
  :keys [{1 :<leader>tt 2 :<CMD>Twilight<CR> :desc "Toggle Twilight"}]}
 {1 :numToStr/Comment.nvim :opts {}}
 {1 :moll/vim-bbye
  :config (fn []
            (vim.keymap.set :n :<leader>x :<CMD>Bdelete<CR> {}))}]

