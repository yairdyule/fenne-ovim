(local vim vim)

(vim.api.nvim_create_autocmd :TextYankPost
                             {:desc "Highlight on yank"
                              :group (vim.api.nvim_create_augroup :hl-yank
                                                                  {:clear true})
                              :callback (fn [] (vim.highlight.on_yank))})

(vim.api.nvim_create_autocmd :ColorScheme
                             {:desc "Highlights to be done post colorscheme load"
                              :group (vim.api.nvim_create_augroup :hl-post-colo
                                                                  {:clear true})
                              :callback (fn []
                                          (vim.cmd "hi clear SignColumn") ; (vim.cmd "hi Normal guibg=None ctermbg=None")
                                          )})

;; Sometimes I hate vim
(vim.api.nvim_create_autocmd :WinLeave
                             {:callback (fn []
                                          (when (and (= vim.bo.ft
                                                        :TelescopePrompt)
                                                     (= (vim.fn.mode) :i))
                                            (vim.api.nvim_feedkeys (vim.api.nvim_replace_termcodes :<Esc>
                                                                                                   true
                                                                                                   false
                                                                                                   true)
                                                                   :i false)))})

