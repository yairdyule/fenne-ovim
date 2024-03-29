(local bind-key vim.keymap.set)
(set vim.g.mapleader " ")
(set vim.g.maplocalleader " ")

(let [opt vim.opt
      options {:number true
               :relativenumber true
               :mouse :a
               :clipboard :unnamedplus
               :breakindent true
               :undofile true
               :ignorecase true
               :smartcase true
               :splitright true
               :splitbelow true
               :inccommand :split
               :scrolloff 4
               :laststatus 3
               :hlsearch true
               :showmode false
               :signcolumn :yes
               :expandtab true
               :shiftwidth 2
               :smartindent true
               :tabstop 2
               :numberwidth 3
               :softtabstop 2}]
  (each [key value (pairs options)]
    (tset opt key value)))

(let [key-bindings [[:n "<Esc>" "<CMD>nohlsearch<CR>"]
                    [:n "<C-l>" "<C-w><C-l>"]
                    [:n "<C-j>" "<C-w><C-j>"]
                    [:n "<C-k>" "<C-w><C-k>"]
                    [:n "<C-h>" "<C-w><C-h>"]
                    [:n "<C-s>" "<CMD>w<CR>"]
                    [:n "<C-y>" "5<C-y>"]
                    [:n "<C-e>" "5<C-e>"]]]
  (each [_ binding (ipairs key-bindings)]
    (let [[mode key command] binding]
      (bind-key mode key command))))

(vim.api.nvim_create_autocmd :TextYankPost
                             {:desc "Highlight on yank"
                              :group (vim.api.nvim_create_augroup :hl-yank
                                                                  {:clear true})
                              :callback (fn [] (vim.highlight.on_yank))})

(vim.api.nvim_create_autocmd :ColorScheme
                             {:desc "Highlights to be done post colorscheme load"
                             :group (vim.api.nvim_create_augroup :hl-post-colo {:clear true})
                             :callback (fn [] (vim.cmd "hi clear SignColumn"))})

;; on write, compile this file to init.lua
(vim.api.nvim_create_autocmd :BufWritePost
                             {:desc "Compiles init fennel to lua"
                              :group (vim.api.nvim_create_augroup :fnl-lua
                                                                  {:clear true})
                              :pattern :init.fnl
                              ; TODO: can I restrict this to only consider ~/.config/nvim/init.fnl, and not, say, ~/.config/nvim/fnl/.../init.fnl ?
                              :callback (fn []
                                          ((. (require :os) :execute) "rm ~/.config/nvim/init.lua && fennel --globals vim --compile ~/.config/nvim/init.fnl >> ~/.config/nvim/init.lua"))})

; bootstrap lazy
(let [lazypath (.. (vim.fn.stdpath :data) :/lazy/lazy.nvim)]
  (if (not (vim.loop.fs_stat lazypath))
      (vim.fn.system [:git
                      :clone
                      "--filter=blob:none"
                      "https://github.com/folke/lazy.nvim.git"
                      :--branch=stable
                      lazypath]))
  (vim.opt.rtp:prepend lazypath))

((. (require :lazy) :setup) [:tpope/vim-sleuth
                             {1 :ellisonleao/gruvbox.nvim
                              :config (fn [] 
                                        (vim.cmd.colorscheme :gruvbox))
                              :opts {}}
                             {1 :numToStr/Comment.nvim :opts {}}
                             {1 :lewis6991/gitsigns.nvim :opts {}}
                             {1 :folke/which-key.nvim
                              :event :VimEnter
                              :opts {}}
                             {1 :nvim-telescope/telescope.nvim
                              :event :VimEnter
                              :dependencies {1 :nvim-lua/plenary.nvim}
                              :opts {}
                              :config (fn []
                                        (let [b (require :telescope.builtin)]
                                          (bind-key :n :<leader>ff b.find_files
                                                    {})
                                          (bind-key :n :<leader>fw b.live_grep
                                                    {})
                                          (bind-key :n :<leader>th
                                                    b.colorscheme {})
                                          (bind-key :n :<leader>fo b.oldfiles
                                                    {})
                                          (bind-key :n :<leader>/
                                                    b.current_buffer_fuzzy_find
                                                    {})
                                          (bind-key :n :<leader>st
                                                    :<CMD>Telescope<CR> {})
                                          (bind-key :n :<leader>uw
                                                    b.grep_string {})))}
                             {1 :nvim-treesitter/nvim-treesitter
                              :build :TSUpdate
                              :config (fn []
                                        ((. (require :nvim-treesitter.configs)
                                            :setup) {:auto_install true
                                                                                                                                    :highlight {:enable true}
                                                                                                                                    :indent {:enable true}}))}
                             {1 :folke/todo-comments.nvim
                              :dependencies [:nvim-lua/plenary.nvim]
                              :event :VimEnter
                              :opts {:signs false}
                              :config true}
                             ; TODO: configure me
                             {1 :hrsh7th/nvim-cmp
                              :event :InsertEnter
                              :dependencies [{1 :L3MON4D3/LuaSnip}
                                             :saadparwaiz1/cmp_luasnip
                                             :hrsh7th/cmp-nvim-lsp
                                             :hrsh7th/cmp-path]
                              :config (fn []
                                        (local cmp (require :cmp))
                                        (local luasnip (require :luasnip))
                                        (luasnip.config.setup {})
                                        (cmp.setup {}))}
                             {1 :stevearc/conform.nvim
                              :opts {:notify_on_error true
                                     :format_on_save {:timeout_ms 500
                                                      :lsp_fallback false
                                                      :formatters_by_ft {:fennel [:fnlfmt]}}}}
                                                      {1 :luukvbaal/statuscol.nvim
                                                      :config true
                                                      :opts {:relculright true}
                                                      }
                             {1 :stevearc/oil.nvim
                              :opts {:default_file_explorer true
                                     :columns [:icon :size :mtime]}
                              :event :VimEnter
                              :config (fn []
                                        (let [oil (require :oil)]
                                          ((. oil :setup))
                                          (bind-key :n :<leader>e :<CMD>Oil<CR>
                                                    {})))}])
