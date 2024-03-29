;; hack to avoid all other `vim` usages triggering diagnostics

(local vim vim)
(local bind-key vim.keymap.set)

(let [leader " "]
  (set vim.g.mapleader leader)
  (set vim.g.maplocalleader leader))

(let [opt vim.opt
      options {:number true
               :relativenumber true
               :mouse :a
               :clipboard :unnamedplus
               :breakindent true
               :wrap false
               :undofile true
               :ignorecase true
               :smartcase true
               :splitright true
               :splitbelow true
               :inccommand :split
               ; for some reason, I think this breaks the display of compilation errors
               :scrolloff 4
               :laststatus 3
               :hlsearch true
               :showmode false
               :signcolumn :yes
               :expandtab true
               :shiftwidth 2
               :hidden true
               :smartindent true
               :tabstop 2
               :numberwidth 3
               :softtabstop 2}]
  (each [key value (pairs options)]
    (tset opt key value)))

(let [key-bindings [[:n :<Esc> :<CMD>nohlsearch<CR>]
                    [:n :<C-l> :<C-w><C-l>]
                    [:n :<C-j> :<C-w><C-j>]
                    [:n :<C-k> :<C-w><C-k>]
                    [:n :<C-h> :<C-w><C-h>]
                    [:n :<C-s> :<CMD>w<CR>]
                    [:n :<C-y> :5<C-y>]
                    [:n :<C-e> :5<C-e>]]]
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
                              :group (vim.api.nvim_create_augroup :hl-post-colo
                                                                  {:clear true})
                              :callback (fn [] (vim.cmd "hi clear SignColumn"))})

;; on write, compile this file to init.lua
(vim.api.nvim_create_autocmd :BufWritePost
                             {:desc "Compiles init fennel to lua"
                              :group (vim.api.nvim_create_augroup :fnl-lua
                                                                  {:clear true})
                              :pattern :init.fnl
                              ; TODO: can I restrict this to only consider ~/.config/nvim/init.fnl, and not, say, ~/.config/nvim/fnl/.../init.fnl ?
                              :callback (fn []
                                          (local status-code
                                                 ((. (require :os) :execute) "rm ~/.config/nvim/init.lua && fennel --globals vim --compile ~/.config/nvim/init.fnl >> ~/.config/nvim/init.lua"))
                                          (if (not (= status-code 0))
                                              (print "Compilation failed... check yo self")))})

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

((. (require :lazy) :setup) [{1 :moll/vim-bbye
                              :config (fn []
                                        (bind-key :n :<leader>x
                                                  :<CMD>Bdelete<CR> {}))}
                             {1 :FabijanZulj/blame.nvim :config true}
                             {1 :navarasu/onedark.nvim
                              :config (fn []
                                        (local od (require :onedark))
                                        ((. od :setup) {:style :warmer}))
                              :opts {}}
                             {1 :ellisonleao/gruvbox.nvim
                              ; :config (fn [] (vim.cmd "colorscheme gruvbox"))
                              :opts {}}
                             {1 :nvim-lualine/lualine.nvim
                              :config (fn []
                                        ((. (require :lualine) :setup)))
                              :dependencies [:nvim-tree/nvim-web-devicons]}
                             {1 :numToStr/Comment.nvim :opts {}}
                             {1 :lewis6991/gitsigns.nvim
                              :lazy false
                              :config (fn []
                                        (local gitsigns (require :gitsigns))
                                        (gitsigns.setup {})
                                        (bind-key :n :<leader>gp
                                                  (fn []
                                                    (gitsigns.preview_hunk_inline))
                                                  {:silent true}))}
                             {1 :zbirenbaum/copilot.lua
                              :opts {:suggestion {:enabled true
                                                  :auto_trigger true
                                                  :debounce 75
                                                  :keymap {:accept :<C-l>}}}
                              :event :InsertEnter}
                             {1 :folke/twilight.nvim
                              :config (fn []
                                        ((. (require :twilight) :setup))
                                        (bind-key :n :<leader>tt
                                                  :<CMD>Twilight<CR> {}))}
                             {1 :folke/which-key.nvim
                              :event :VimEnter
                              :opts {}}
                             {1 :nvim-telescope/telescope.nvim
                              :event :VimEnter
                              :dependencies [{1 :nvim-lua/plenary.nvim}
                                             {1 :nvim-telescope/telescope-fzf-native.nvim
                                              :build "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"}]
                              :config (fn []
                                        ((. (require :telescope) :setup) {:extensions {:fzf {:case_mode :smart_case
                                                                                             :fuzzy true
                                                                                             :override_file_sorter true
                                                                                             :override_generic_sorter true}}})
                                        ((. (require :telescope)
                                            :load_extension) :fzf)
                                        (bind-key :n :<leader>ff
                                                  ":Telescope find_files theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>fw
                                                  ":Telescope live_grep theme=ivy<CR>"
                                                  ; (fn []
                                                  ;   ((. (require :telescope.builtin) :find_files) (. (require :telescope.themes) :live_grep {:previewer false})))
                                                  {:silent true})
                                        (bind-key :n :<leader>th
                                                  ":Telescope colorscheme theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>fo
                                                  ":Telescope oldfiles theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>pr
                                                  ":Telescope registers theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>gb
                                                  ":Telescope git_branches<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>gs
                                                  ":Telescope git_status<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>fb
                                                  ":Telescope buffers theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>vd
                                                  "<CMD>lua vim.diagnostic.disable()<CR>"
                                                  {:silent true})
                                        (bind-key :n :<C-/>
                                                  (fn []
                                                    ((. (require :telescope.builtin)
                                                        :current_buffer_fuzzy_find) ((. (require :telescope.themes)
                                                                                                                                                                             :get_ivy) {:prompt_title false
                                                                                                                                                                                                                                                                                                                                                                                                 :results_title false})))
                                                  ; (fn []
                                                  ;   (. (require :telescope.builtin) :current_buffer_fuzzy_find (. (require :telescope.themes) :get_ivy {:previewer false})))
                                                  {:silent true})
                                        (bind-key :n :<leader>sh
                                                  ":Telescope help_tags theme=dropdown<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>st
                                                  ":Telescope builtin theme=ivy<CR>"
                                                  {:silent true})
                                        (bind-key :n :<leader>uw
                                                  ":Telescope grep_string theme=ivy<CR>"
                                                  {:silent true}))}
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
                                        (local lspconfig (require :lspconfig)) ; (lspconfig.ruff_lsp.setup {}) ; TODO: Use me for everything but types
                                        (lspconfig.pyright.setup {; TODO: Use me for types, nothing else
                                                                  })
                                        (lspconfig.jqls.setup {})
                                        (lspconfig.jsonls.setup {})
                                        (lspconfig.fennel_language_server.setup {:default_config {:settings {:fennel {:diagnostics {:globals [:vim]}}}}})
                                        (vim.api.nvim_create_autocmd :LspAttach
                                                                     {:group (vim.api.nvim_create_augroup :UserLspConfig
                                                                                                          {})
                                                                      :callback (fn [ev]
                                                                                  (let [options {:buffer (. ev
                                                                                                            :buf)}]
                                                                                    (bind-key :n
                                                                                              :gd
                                                                                              vim.lsp.buf.definition
                                                                                              options)
                                                                                    (bind-key :n
                                                                                              :K
                                                                                              vim.lsp.buf.hover
                                                                                              options)))}))}
                             {1 :nvim-treesitter/nvim-treesitter
                              :build :TSUpdate
                              :dependencies [; :nvim-treesitter/nvim-treesitter-textobjects
                                             :nvim-treesitter/nvim-treesitter-context]
                              :config (fn []
                                        ((. (require :nvim-treesitter.configs)
                                            :setup) {:auto_install true
                                                                                                                                    :highlight {:enable true}})
                                        ((. (require :treesitter-context)
                                            :setup) {})
                                        (bind-key :n :<leader>tc
                                                  :<CMD>TSContextToggle<CR> {}))}
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
                                             :saadparwaiz1/cmp_luasnip
                                             :hrsh7th/cmp-nvim-lsp
                                             :hrsh7th/cmp-path]
                              :config (fn []
                                        (local cmp (require :cmp))
                                        (local luasnip (require :luasnip))
                                        (luasnip.config.setup {})
                                        (cmp.setup {:snippet {:expand (fn [args]
                                                                        ((. luasnip
                                                                            :lsp_expand) (. args
                                                                                                                                                                                :body)))}
                                                    :completion {:completeopt "menu,menuone,noinsert"}
                                                    :sources [{:name :nvim_lsp}
                                                              {:name :luasnip}
                                                              {:name :orgmode}
                                                              {:name :path}]
                                                    :mapping (cmp.mapping.preset.insert {:<C-n> (cmp.mapping.select_next_item)
                                                                                         :<C-p> (cmp.mapping.select_prev_item)
                                                                                         :<CR> (cmp.mapping.confirm {:select true})})}))}
                             {1 :stevearc/conform.nvim
                              :opts {:notify_on_error true
                                     :formatters_by_ft {:fennel [:fnlfmt]
                                                        :python [:black]}
                                     :format_on_save {:timeout_ms 500
                                                      :lsp_fallback false}}}
                             {1 :luukvbaal/statuscol.nvim
                              :config true
                              :opts {:relculright true}}
                             {1 :lukas-reineke/indent-blankline.nvim
                              :config (fn []
                                        (bind-key :n :<leader>ib
                                                  :<CMD>IBLToggle<CR>))
                              :opts {}
                              :main :ibl}
                             {1 :nvim-orgmode/orgmode
                              :dependencies {1 :nvim-treesitter/nvim-treesitter
                                             :lazy true}
                              :event :VeryLazy
                              :config (fn []
                                        (local orgmode (require :orgmode))
                                        (local ts-configs
                                               (require :nvim-treesitter.configs))
                                        (orgmode.setup_ts_grammar)
                                        (ts-configs.setup {:highlight {:enable true}
                                                           :ensure_installed [:org]})
                                        (orgmode.setup {:org_agenda_files "~/orgfiles/**/*"
                                                        :org_default_notes_file "~/orgfiles/refile.org"}))}
                             {1 :akinsho/toggleterm.nvim
                              :event :VeryLazy
                              :config (fn []
                                        ((. (require :toggleterm) :setup))
                                        (bind-key :n :<leader>ot
                                                  :<CMD>ToggleTerm<CR>))}
                             {1 :projekt0n/github-nvim-theme
                              :config (fn []
                                        ((. (require :github-theme) :setup) {})
                                        (vim.cmd "colorscheme github_light"))
                              :lazy false
                              :priority 1000}
                             {1 :SuperBo/fugit2.nvim
                              :opts {}
                              :lazy false
                              :dependencies [:MunifTanjim/nui.nvim
                                             :nvim-tree/nvim-web-devicons
                                             :nvim-lua/plenary.nvim
                                             {1 :chrisgrieser/nvim-tinygit
                                              :dependencies {1 :stevearc/dressing.nvim}}
                                             :sindrets/diffview.nvim]
                              :cmd {:Fugit2 :Fugit2Graph}
                              :config (fn []
                                        (local fugit2 (require :fugit2))
                                        (fugit2.setup {})
                                        (bind-key :n :<leader>gg
                                                  :<CMD>Fugit2<CR>))}
                             {1 :stevearc/oil.nvim
                              :event :VimEnter
                              :config (fn []
                                        (local oil (require :oil))
                                        (oil.setup {:default_file_explorer true
                                                    :columns [:permissions
                                                              :mtime
                                                              :size
                                                              :icon]
                                                    :keymaps {:q :actions.close
                                                              :C-x :actions.select_split
                                                              :C-v :actions.select_vsplit}})
                                        (bind-key :n :<leader>e :<CMD>Oil<CR>
                                                  {}))}])

