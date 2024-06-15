{1 :ibhagwan/fzf-lua
 :enabled false
 :dependencies [:nvim-tree/nvim-web-devicons]
 :config (fn []
           (local fzf (require :fzf-lua))
           (fzf.setup {}))
 :keys [{1 :<leader>fo 2 "<CMD>Fzf oldfiles<CR>"}
        {1 :<C-p> 2 "<CMD>Fzf files<CR>"}
        {1 :<leader>ff 2 "<CMD>Fzf files<CR>"}
        {1 :<leader>fw 2 "<CMD>Fzf live_grep_native<CR>"}
        {1 :<C-f> 2 "<CMD>Fzf live_grep_native<CR>"}
        {1 :<C-/> 2 "<CMD>Fzf blines<CR>"}
        {1 :<leader>uw 2 "<CMD>Fzf grep_cword<CR>"}
        {1 :<leader>sh 2 "<CMD>Fzf helptags<CR>"}
        {1 :<leader>st 2 "<CMD>Fzf git_status<CR>"}
        {1 :<leader>bi 2 :<CMD>Fzf<CR>}]}

