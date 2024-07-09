{1 :hrsh7th/nvim-cmp
 :event :InsertEnter
 :dependencies [{1 :uga-rosa/cmp-dictionary}
                {1 :L3MON4D3/LuaSnip
                 :dependencies {1 :rafamadriz/friendly-snippets
                                :config (fn []
                                          ((. (require :luasnip.loaders.from_vscode)
                                              :lazy_load)))}}
                :saadparwaiz1/cmp_luasnip
                :hrsh7th/cmp-nvim-lsp
                :hrsh7th/cmp-path]
 :config (fn []
           (local luasnip (require :luasnip))
           (local cmp (require :cmp))
           (local dict (require :cmp_dictionary))
           (local window {:completion {}})
           (luasnip.config.setup {})
           (cmp.setup {:snippet {:expand (fn [args]
                                           ((. luasnip :lsp_expand) (. args
                                                                       :body)))}
                       : window
                       :completion {:keyword_length 1
                                    :completeopt "menu,menuone,noinsert"}
                       :matching {:disallow_fuzzy_matching false}
                       :sources [{:name :nvim_lsp}
                                 {:name :luasnip}
                                 {:name :orgmode}
                                 {:name :path}
                                 {:name :dictionary}
                                 ; {:name :cmp-dbee}
                                 ]
                       :mapping {:<C-n> (cmp.mapping.select_next_item)
                                 :<C-p> (cmp.mapping.select_prev_item)
                                 :<CR> (cmp.mapping (fn [fallback]
                                                      (if (cmp.visible)
                                                          (if (luasnip.expandable)
                                                              (luasnip.expand)
                                                              (cmp.confirm {:select true}))
                                                          (fallback))))
                                 :<S-Tab> (cmp.mapping (fn [fallback]
                                                         (if (cmp.visible)
                                                             (cmp.select_prev_item)
                                                             (luasnip.locally_jumpable (- 1))
                                                             (luasnip.jump (- 1))
                                                             (fallback)))
                                                       [:i :s])
                                 :<Tab> (cmp.mapping (fn [fallback]
                                                       (if (cmp.visible)
                                                           (cmp.select_next_item)
                                                           (luasnip.locally_jumpable 1)
                                                           (luasnip.jump 1)
                                                           (fallback)))
                                                     [:i :s])}})
           (dict.setup {}))}

