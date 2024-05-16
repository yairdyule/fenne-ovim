(local vim vim)

[{1 :FabijanZulj/blame.nvim :config true}
 ; {1 :catppuccin/nvim
 ;  :name :catppuccin
 ;  :priority 1000
 ;  :config (fn []
 ;            (vim.cmd " colorscheme catppuccin-latte"))}
 ; {1 :ellisonleao/gruvbox.nvim
 ;  :config (fn [] (vim.cmd "colorscheme gruvbox"))
 ;  :opts {}}
 {1 :folke/zen-mode.nvim
  :lazy true
  :opts {:plugins {:options {:laststatus 0} :twilight {:enabled false}}}
  :keys [{1 :<leader>tz 2 :<CMD>ZenMode<CR>}]}
 {1 :MunifTanjim/nui.nvim}
 {1 :tpope/vim-dadbod}
 {1 :nvim-lualine/lualine.nvim
  :config true
  :dependencies [:nvim-tree/nvim-web-devicons]}
 {1 :echasnovski/mini.nvim
  :version "*"
  :config (fn []
            ((. (require :mini.pairs) :setup)))}
 {1 :neovim/nvim-lspconfig
  :dependencies [:williamboman/mason.nvim
                 :williamboman/mason-lspconfig.nvim
                 :WhoIsSethDaniel/mason-tool-installer.nvim
                 {1 :j-hui/fidget.nvim :opts {}}]
  :config (fn []
            ((. (require :mason) :setup))
            ((. (require :mason-lspconfig) :setup))
            (local mason-registry (require :mason-registry))
            (local vue-language-server-path
                   (.. (: (mason-registry.get_package :vue-language-server)
                          :get_install_path)
                       "/node_modules/@vue/language-server"))
            (local lspconfig (require :lspconfig))
            (lspconfig.ruff_lsp.setup {}) ; TODO: Use me for everything but types
            (lspconfig.pyright.setup {; TODO: Use me for types, nothing else
                                      })
            (lspconfig.jqls.setup {})
            (lspconfig.jsonls.setup {})
            (lspconfig.volar.setup {}) ; require'lspconfig'.sqlls.setup{ ;   capabilities = capabilities, ;   filetypes = { 'sql' }, ;   root_dir = function(_) ;     return vim.loop.cwd() ;   end, ; }
            (lspconfig.sqlls.setup {:root_dir (fn [_]
                                                (vim.loop.cwd))})
            (lspconfig.tsserver.setup {:init_options {:plugins [{:name "@vue/typescript-plugin"
                                                                 :location vue-language-server-path
                                                                 :languages [:vue]}]}
                                       :filetypes [:typescript
                                                   :javascript
                                                   :javascriptreact
                                                   :typescriptreact
                                                   :vue]})
            (lspconfig.fennel_language_server.setup {:default_config {:settings {:fennel {:diagnostics {:globals [:vim]}}}}})
            (vim.api.nvim_create_autocmd :LspAttach
                                         {:group (vim.api.nvim_create_augroup :UserLspConfig
                                                                              {})
                                          :callback (fn [ev]
                                                      (let [options {:buffer (. ev
                                                                                :buf)}]
                                                        (vim.keymap.set :n :gd
                                                                        vim.lsp.buf.definition
                                                                        options)
                                                        (vim.keymap.set :n :K
                                                                        vim.lsp.buf.hover
                                                                        options)))}))}
 {1 :nvim-treesitter/nvim-treesitter
  :build :TSUpdate
  :dependencies [:RRethy/nvim-treesitter-textsubjects
                 :nvim-treesitter/nvim-treesitter-context]
  :config (fn []
            (local ts-configs (require :nvim-treesitter.configs))
            (ts-configs.setup {:auto_install true
                               :highlight {:enable true}
                               ; :textsubjects {:enable true
                               ;                :keymaps {:<CR> :textsubjects-smart
                               ;                          :<Tab> :textsubjects-container-outer
                               ;                          :<S-Tab> {1 :textsubjects-container-inner
                               ;                                    :desc "Select inside containers (classes, functions, etc.)"}}
                               ;                :prev_selection :<S-CR>}
                               :incremental_selection {:enable true
                                                       :keymaps {:init_selection :<CR>
                                                                 :node_incremental :<CR>
                                                                 :scope_incremental :<TAB>
                                                                 :node_decremental :<S-TAB>}}})
            ((. (require :treesitter-context) :setup) {})
            (vim.keymap.set :n :<leader>tc :<CMD>TSContextToggle<CR> {}))}
 {1 :folke/todo-comments.nvim
  :dependencies [:nvim-lua/plenary.nvim]
  :event :VimEnter
  :opts {:signs false}
  :config true}
 {1 :hrsh7th/nvim-cmp
  :event :InsertEnter
  :dependencies [{1 :L3MON4D3/LuaSnip
                  :dependencies {1 :rafamadriz/friendly-snippets
                                 :config (fn []
                                           ((. (require :luasnip.loaders.from_vscode)
                                               :lazy_load)))}}
                 ; {1 :MattiasMTS/cmp-dbee
                 ;  :enabled true
                 ;  :opts {}
                 ;  :ft :sql}
                 :saadparwaiz1/cmp_luasnip
                 :hrsh7th/cmp-nvim-lsp
                 :hrsh7th/cmp-path]
  :config (fn []
            (local cmp (require :cmp))
            (local luasnip (require :luasnip))
            (luasnip.config.setup {})
            (cmp.setup {:snippet {:expand (fn [args]
                                            ((. luasnip :lsp_expand) (. args
                                                                        :body)))}
                        :completion {:completeopt "menu,menuone,noinsert"}
                        :sources [{:name :nvim_lsp}
                                  {:name :luasnip}
                                  {:name :orgmode}
                                  {:name :path}
                                  ; {:name :cmp-dbee}
                                  ]
                        :mapping (cmp.mapping.preset.insert {:<C-n> (cmp.mapping.select_next_item)
                                                             :<C-p> (cmp.mapping.select_prev_item)
                                                             :<CR> (cmp.mapping.confirm {:select true})})}))}
 {1 :stevearc/conform.nvim
  :opts {:notify_on_error true
         :formatters_by_ft {:fennel [:fnlfmt]
                            :javascript [:prettier]
                            :python [:ruff_format]
                            ; :sql [:sqlfmt]
                            }
         :format_on_save {:timeout_ms 500 :lsp_fallback true}}}
 {1 :luukvbaal/statuscol.nvim :config true :opts {:relculright true}}
 {1 :lukas-reineke/indent-blankline.nvim
  :config (fn []
            (vim.keymap.set :n :<leader>ib :<CMD>IBLToggle<CR>))
  :opts {:indent {:char :x}}
  :main :ibl}
 {1 :nvim-orgmode/orgmode
  :dependencies {1 :nvim-treesitter/nvim-treesitter :lazy true}
  :event :VeryLazy
  :config (fn []
            (local orgmode (require :orgmode))
            (local ts-configs (require :nvim-treesitter.configs))
            (orgmode.setup_ts_grammar)
            (ts-configs.setup {:highlight {:enable true}
                               :ensure_installed [:org]})
            (orgmode.setup {:org_agenda_files "~/orgfiles/**/*"
                            :org_default_notes_file "~/orgfiles/refile.org"}))}
 {1 :akinsho/toggleterm.nvim
  :event :VeryLazy
  :config (fn []
            (local toggleterm (require :toggleterm))
            (toggleterm.setup {})
            (local Terminal (. (require :toggleterm.terminal) :Terminal))
            (local lazygit (Terminal:new {:cmd :lazygit :direction :float}))
            (vim.keymap.set :n :<leader>ot :<CMD>ToggleTerm<CR>)
            (vim.keymap.set :n :<leader>gg (fn [] (lazygit:toggle))))}
 {1 :projekt0n/github-nvim-theme
  :config (fn []
            ((. (require :github-theme) :setup) {}) ; (vim.cmd "colorscheme github_dark") 
            (vim.cmd "colorscheme github_light"))
  :lazy false
  :priority 1000}
 {1 :vhyrro/luarocks.nvim :priority 1000 :config true}
 ; {1 :olimorris/onedarkpro.nvim
 ;  :priority 1000
 ;  :lazy false
 ;  :config (fn [] (vim.cmd "colorscheme onedark"))}
 {1 :nvim-neorg/neorg
  :dependencies [:luarocks.nvim]
  :lazy false
  :version "*"
  :config true}
 {1 :kndndrj/nvim-dbee
  :dependencies [:MunifTanjim/nui.nvim]
  :build (fn []
           (local dbee (require :dbee))
           (dbee.install))
  :config (fn []
            (local dbee (require :dbee))
            (dbee.setup {}))}
 ; {1 :stevearc/oil.nvim
 ;  :event :VimEnter
 ;  :config (fn []
 ;            (local oil (require :oil))
 ;            (oil.setup {:default_file_explorer true
 ;                        :columns [:permissions :mtime :size :icon]
 ;                        :keymaps {:q :actions.close
 ;                                  :C-x :actions.select_split
 ;                                  :C-v :actions.select_vsplit}})
 ;            (vim.keymap.set :n :<leader>e :<CMD>Oil<CR> {}))}
 {1 :nvim-neo-tree/neo-tree.nvim
  :branch :v3.x
  :dependencies [:nvim-lua/plenary.nvim
                 :nvim-tree/nvim-web-devicons
                 :MunifTanjim/nui.nvim]
  :config (fn []
            (local neotree (require :neo-tree))
            (neotree.setup {})
            (vim.keymap.set :n :<leader>e "<CMD>Neotree toggle reveal<CR>" {}))
  ;; end of configs -- leaving this comment s.t. I can easily add more plugins w/o having to find the closing }])
  }]

