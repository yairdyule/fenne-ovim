(local vim vim)
;; create a map of colorscheme names

[{1 :pogyomo/submode.nvim
  :lazy false
  :config (fn []
            (local mode (require :submode))
            (mode.create :WinManage {:mode :n :enter :<C-w><C-r> :leave :<ESC>})
            (mode.set :WinManage :h "<C-w>\\>")
            (mode.set :WinManage :l "<C-w>\\<")
            (mode.set :WinManage :k :<C-w>+)
            (mode.set :WinManage :j :<C-w>-))}
 {1 :FabijanZulj/blame.nvim :config true :lazy true :event :BufEnter}
 {}
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
            (lspconfig.rust_analyzer.setup {})
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
 {1 :akinsho/toggleterm.nvim
  :event :VeryLazy
  :config (fn []
            (local toggleterm (require :toggleterm))
            (toggleterm.setup {})
            (local Terminal (. (require :toggleterm.terminal) :Terminal))
            (local lazygit (Terminal:new {:cmd :lazygit :direction :float}))
            (vim.keymap.set :n :<leader>ot :<CMD>ToggleTerm<CR>)
            (vim.keymap.set :n :<leader>gg (fn [] (lazygit:toggle))))}
 {1 :vhyrro/luarocks.nvim :priority 1000 :config true}]

