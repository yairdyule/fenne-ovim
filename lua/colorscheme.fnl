;; Synchronize Wezterm's theme with Nvim's 
(local vim vim)
(local is-dark true)
(vim.cmd (.. "colorscheme " (if is-dark :onedark :onelight)))

