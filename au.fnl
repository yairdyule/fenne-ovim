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

