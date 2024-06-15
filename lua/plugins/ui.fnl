(local vim vim)

[{1 :nvim-lualine/lualine.nvim
  :config true
  :dependencies [:nvim-tree/nvim-web-devicons]}
 {1 :folke/trouble.nvim
  :opts {}
  :cmd :Trouble
  :keys [{1 :<leader>cs 2 "<CMD>Trouble symbols toggle focus=false<CR>"}]}
 {1 :MunifTanjim/nui.nvim}
 {1 :luukvbaal/statuscol.nvim :config true :opts {:relculright true}}
 {1 :lukas-reineke/indent-blankline.nvim
  :config (fn []
            (vim.keymap.set :n :<leader>ib :<CMD>IBLToggle<CR>))
  :opts {:indent {:char :x}}
  :main :ibl}
 {1 :folke/todo-comments.nvim
  :dependencies [:nvim-lua/plenary.nvim]
  :event :VimEnter
  :opts {:signs false}
  :config true}
 {1 :folke/zen-mode.nvim
  :lazy true
  :opts {:plugins {:options {:laststatus 0} :twilight {:enabled false}}}
  :keys [{1 :<leader>tz 2 :<CMD>ZenMode<CR>}]}]

