(local vim vim)
(local opt vim.opt)

(let [options {:number true
               :relativenumber true
               :mouse :a
               :bg :light
               :clipboard :unnamedplus
               :breakindent true
               :wrap false
               :undofile true
               :ignorecase true
               :smartcase true
               :splitright true
               :splitbelow true
               :inccommand :split
               ; for some reason, I think this breaks the display of compilation errors
               :scrolloff 4
               :laststatus 3
               :hlsearch true
               :showmode false
               :signcolumn :yes
               :expandtab true
               :shiftwidth 2
               :hidden true
               :smartindent true
               :tabstop 2
               :numberwidth 3
               :softtabstop 2}]
  (each [key value (pairs options)]
    (tset opt key value)))

