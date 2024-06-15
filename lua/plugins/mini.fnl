(local pick-enabled false)

{1 :echasnovski/mini.nvim
 :version "*"
 :lazy false
 :config (fn []
           (if pick-enabled
               (let [pick (require :mini.pick)
                     mappings {:choose :<CR>
                               :choose_in_split :<C-s>
                               :choose_in_vsplit :<C-v>
                               :choose_marked :<C-CR>
                               :mark :<Tab>
                               :refine :<C-r>
                               :refine_marked :<C-Space>
                               :toggle_preview :<Tab>}
                     options {:content_from_bottom false} ;  delay {}
                     window {:config (fn [] {})}]
                 (pick.setup {: mappings : window : mappings : options})))
           (local pairs (require :mini.pairs))
           (local extra (require :mini.extra))
           (pairs.setup)
           (extra.setup))
 :keys [{1 :<leader>ff 2 "<CMD>Pick files<CR>"}
        {1 :<leader>uf 2 "<CMD>Pick files pattern='<cword>'<CR>"}
        {1 :<leader>fe 2 "<CMD>Pick explorer<CR>"}
        {1 :<leader>fw 2 "<CMD>Pick grep_live<CR>"}
        {1 :<leader>uw 2 "<CMD>Pick grep pattern='<cword>'<CR>"}
        {1 :<C-/> 2 "<CMD>Pick buf_lines<CR>"}
        {1 :<leader>fo 2 "<CMD>Pick oldfiles<CR>"}
        {1 :<leader>fh 2 "<CMD>Pick help<CR>"}]}

