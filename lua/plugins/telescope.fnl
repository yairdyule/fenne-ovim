(local vim vim)

(local defaults {:theme :ivy
                 :prompt_prefix "❯ "
                 :selection_caret "❯ "
                 :entry_prefix "  "
                 :initial_mode :insert
                 :selection_strategy :reset
                 :sorting_strategy :ascending
                 :layout_strategy :horizontal
                 :layout_config {:horizontal {:mirror false}
                                 :vertical {:mirror false}
                                 :width 0.75
                                 :preview_cutoff 120}})

(local pickers {:find_files {:theme :dropdown}
                :oldfiles {:theme :dropdown}
                :registers {:theme :dropdown}
                :colorscheme {:theme :dropdown}
                :git_branches {:theme :dropdown}
                :buffers {:theme :dropdown}
                :grep_string {:theme :ivy}
                :jumplist {:theme :dropdown}
                :help_tags {:theme :dropdown}
                :builtin {:theme :dropdown}
                :current_buffer_fuzzy_find {:theme :ivy}})

(local fzf-settings {:case_mode :smart_case
                     :fuzzy true
                     :override_file_sorter true
                     :override_generic_sorter true})

(local extensions {:fzf fzf-settings})

(local keys
       [{1 :<leader>fo 2 "<CMD>Telescope oldfiles<CR>"}
        {1 :<leader>ff 2 "<CMD>Telescope find_files<CR>"}
        {1 :<leader>fw 2 "<CMD>Telescope live_grep<CR>"}
        {1 :<leader>th 2 "<CMD>Telescope colorscheme<CR>"}
        {1 :<leader>pr 2 "<CMD>Telescope registers<CR>"}
        {1 :<leader>gb 2 "<CMD>Telescope git_branches<CR>"}
        {1 :<leader>gs 2 "<CMD>Telescope git_status<CR>"}
        {1 :<leader>fb 2 "<CMD>Telescope buffers<CR>"}
        {1 :<C-/> 2 "<CMD>Telescope current_buffer_fuzzy_find<CR>"}
        {1 :<leader>sh 2 "<CMD>Telescope help_tags<CR>"}
        {1 :<leader>st 2 "<CMD>Telescope builtin<CR>"}
        {1 :<leader>uw 2 "<CMD>Telescope grep_string<CR>"}
        {1 :<leader>tj 2 "<CMD>Telescope jumplist<CR>"}
        {1 :<leader>uf
         2 (fn []
             (local builtin (require :telescope.builtin))
             (builtin.find_files {:search_file (vim.fn.expand :<cword>)}))}])

{1 :nvim-telescope/telescope.nvim
 :event :VimEnter
 :dependencies [{1 :nvim-lua/plenary.nvim}
                {1 :nvim-telescope/telescope-fzf-native.nvim
                 :build "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"}]
 :config (fn []
           (local telescope (require :telescope))
           (telescope.setup {: defaults : pickers : extensions})
           (telescope.load_extension :fzf))
 : keys}

