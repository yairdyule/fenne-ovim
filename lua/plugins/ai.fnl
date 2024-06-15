{1 :zbirenbaum/copilot.lua
 :opts {:suggestion {:enabled true
                     :auto_trigger true
                     :debounce 75
                     :keymap {:accept :<C-l>}}}
 :event :InsertEnter}

{1 :CopilotC-Nvim/CopilotChat.nvim
 :branch :canary
 :dependencies [[:zbirenbaum/copilot.lua] [:nvim-lua/plenary.nvim]]
 :opts {:debug true}}

