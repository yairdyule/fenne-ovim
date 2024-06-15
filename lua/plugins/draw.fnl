(local vim vim)
{1 :jbyuki/venn.nvim
 :config (fn []
           (fn _G.Toggle_venn []
             (let [venn-enabled (vim.inspect vim.b.venn_enabled)]
               (if (= venn-enabled :nil)
                   (do
                     (set vim.b.venn_enabled true)
                     (vim.cmd "setlocal ve=all")
                     (vim.api.nvim_buf_set_keymap 0 :n :J "<C-v>j:VBox<CR>"
                                                  {:noremap true})
                     (vim.api.nvim_buf_set_keymap 0 :n :K "<C-v>k:VBox<CR>"
                                                  {:noremap true})
                     (vim.api.nvim_buf_set_keymap 0 :n :L "<C-v>l:VBox<CR>"
                                                  {:noremap true})
                     (vim.api.nvim_buf_set_keymap 0 :n :H "<C-v>h:VBox<CR>"
                                                  {:noremap true})
                     (vim.api.nvim_buf_set_keymap 0 :v :f ":VBox<CR>"
                                                  {:noremap true}))
                   (do
                     (vim.cmd "setlocal ve=")
                     (vim.api.nvim_buf_del_keymap 0 :n :J)
                     (vim.api.nvim_buf_del_keymap 0 :n :K)
                     (vim.api.nvim_buf_del_keymap 0 :n :L)
                     (vim.api.nvim_buf_del_keymap 0 :n :H)
                     (vim.api.nvim_buf_del_keymap 0 :v :f)
                     (set vim.b.venn_enabled nil)))))

           (vim.api.nvim_set_keymap :n :<leader>v ":lua Toggle_venn()<CR>"
                                    {:noremap true}))}

