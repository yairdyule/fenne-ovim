(local vim vim)

(local is-dark (= vim.o.background :dark))
(local colors {:default {}
               :cat {1 :catppuccin/nvim
                     :name :catppuccin
                     :priority 1000
                     :config (fn []
                               (local colo
                                      (if is-dark :catppuccin-frappe
                                          :catppuccin-latte))
                               (vim.cmd (.. :colorscheme colo)))}
               :gruv {1 :ellisonleao/gruvbox.nvim
                      :priority 1000
                      :lazy false
                      :config (fn []
                                (local colo :gruvbox)
                                (vim.cmd (.. :colorscheme colo)))
                      :opts {}}
               :vscode {1 :Mofiqul/vscode.nvim
                        :priority 1000
                        :lazy false
                        :config (fn [] (vim.cmd "colorscheme vscode"))}
               :onedark {1 :olimorris/onedarkpro.nvim
                         :priority 1000
                         :lazy false
                         :config (fn []
                                   (vim.cmd (.. "colorscheme "
                                                (if is-dark :onedark
                                                    :onelight))))}
               :github {1 :projekt0n/github-nvim-theme
                        :config (fn []
                                  (vim.cmd (.. "colorscheme "
                                               (if is-dark :github_dark
                                                   :github_light))))
                        :lazy false
                        :priority 1000}})

(. colors vim.g.colorscheme)

