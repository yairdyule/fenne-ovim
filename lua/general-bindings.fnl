(local vim vim)

(fn toggle-vim-diagnostics []
  (local diagnostics vim.diagnostic)
  (if (diagnostics.is_disabled)
      (diagnostics.enable)
      (diagnostics.disable)))

(local bindings
       [[:n :<Esc> :<CMD>nohlsearch<CR>]
        [:n :<C-l> :<C-w><C-l>]
        [:n :<C-j> :<C-w><C-j>]
        [:n :<C-k> :<C-w><C-k>]
        [:n :<C-h> :<C-w><C-h>]
        [:n :<C-s> :<CMD>w<CR>]
        [:n :<C-y> :5<C-y>]
        [:n :<C-e> :5<C-e>]
        [:t :<Esc> "<C-\\><C-n>"]
        [:n :<leader>vt (fn [] (toggle-vim-diagnostics))]])

(each [_ binding (ipairs bindings)]
  (let [[mode key command] binding]
    (vim.keymap.set mode key command)))

