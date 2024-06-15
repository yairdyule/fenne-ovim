(local vim vim)

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
        {1 :<leader>tr 2 "<CMD>Telescope resume<CR>"}
        {1 :<leader>td 2 "<CMD>Telescope diagnostics<CR>"}
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
 :config (fn [] ; (telescope.setup {: defaults ;                   ; : pickers  ;                   : extensions})
           (local Layout (require :nui.layout))
           (local Popup (require :nui.popup))
           (local telescope (require :telescope))
           (local TSLayout (require :telescope.pickers.layout))

           (fn make-popup [options]
             (let [popup (Popup options)]
               (fn popup.border.change_title [self title]
                 (popup.border.set_text popup.border :top title))

               (TSLayout.Window popup)))

           (telescope.setup {: extensions
                             :defaults {:create_layout (fn [picker]
                                                         (local border
                                                                {:preview {:bottom "─"
                                                                           :bottom_left "└"
                                                                           :bottom_right "┘"
                                                                           :left "│"
                                                                           :right "│"
                                                                           :top "─"
                                                                           :top_left "┌"
                                                                           :top_right "┐"}
                                                                 :preview_patch {:horizontal {:bottom "─"
                                                                                              :bottom_left ""
                                                                                              :bottom_right "┘"
                                                                                              :left ""
                                                                                              :top_left ""}
                                                                                 :minimal {}
                                                                                 :vertical {:bottom ""
                                                                                            :bottom_left ""
                                                                                            :bottom_right ""
                                                                                            :left "│"
                                                                                            :top_left "┌"}}
                                                                 :prompt {:bottom "─"
                                                                          :bottom_left "└"
                                                                          :bottom_right "┘"
                                                                          :left "│"
                                                                          :right "│"
                                                                          :top "─"
                                                                          :top_left "├"
                                                                          :top_right "┤"}
                                                                 :prompt_patch {:horizontal {:bottom_right "┴"}
                                                                                :minimal {:bottom_right "┘"}
                                                                                :vertical {:bottom_right "┘"}}
                                                                 :results {:bottom ""
                                                                           :bottom_left ""
                                                                           :bottom_right ""
                                                                           :left "│"
                                                                           :right "│"
                                                                           :top "─"
                                                                           :top_left "┌"
                                                                           :top_right "┬"}
                                                                 :results_patch {:horizontal {:top_left "┌"
                                                                                              :top_right "┬"}
                                                                                 :minimal {:top_left "┌"
                                                                                           :top_right "┐"}
                                                                                 :vertical {:top_left "├"
                                                                                            :top_right "┤"}}})
                                                         (local results
                                                                (make-popup {:border {:style border.results
                                                                                      :text {:top picker.results_title
                                                                                             :top_align :center}}
                                                                             :focusable false
                                                                             :win_options {:winhighlight "Normal:Normal"}}))
                                                         (local prompt
                                                                (make-popup {:border {:style border.prompt
                                                                                      :text {:top picker.prompt_title
                                                                                             :top_align :center}}
                                                                             :enter true
                                                                             :win_options {:winhighlight "Normal:Normal"}}))
                                                         (local preview
                                                                (make-popup {:border {:style border.preview
                                                                                      :text {:top picker.preview_title
                                                                                             :top_align :center}}
                                                                             :focusable false}))
                                                         (local box-by-kind
                                                                {:horizontal (Layout.Box [(Layout.Box [(Layout.Box results
                                                                                                                   {:grow 1})
                                                                                                       (Layout.Box prompt
                                                                                                                   {:size 3})]
                                                                                                      {:dir :col
                                                                                                       :size "50%"})
                                                                                          (Layout.Box preview
                                                                                                      {:size "50%"})]
                                                                                         {:dir :row})
                                                                 :minimal (Layout.Box [(Layout.Box results
                                                                                                   {:grow 1})
                                                                                       (Layout.Box prompt
                                                                                                   {:size 3})]
                                                                                      {:dir :col})
                                                                 :vertical (Layout.Box [(Layout.Box preview
                                                                                                    {:grow 1})
                                                                                        (Layout.Box results
                                                                                                    {:grow 1})
                                                                                        (Layout.Box prompt
                                                                                                    {:size 3})]
                                                                                       {:dir :col})})

                                                         (fn get-box []
                                                           (local strategy
                                                                  picker.layout_strategy)
                                                           (when (or (= strategy
                                                                        :vertical)
                                                                     (= strategy
                                                                        :horizontal))
                                                             (let [___antifnl_rtn_1___ (. box-by-kind
                                                                                          strategy)
                                                                   ___antifnl_rtn_2___ strategy]
                                                               (lua "return ___antifnl_rtn_1___, ___antifnl_rtn_2___")))
                                                           (local (height width)
                                                                  (values vim.o.lines
                                                                          vim.o.columns))
                                                           (var box-kind
                                                                :horizontal)
                                                           (when (< width 100)
                                                             (set box-kind
                                                                  :vertical)
                                                             (when (< height 40)
                                                               (set box-kind
                                                                    :minimal)))
                                                           (values (. box-by-kind
                                                                      box-kind)
                                                                   box-kind))

                                                         (fn prepare-layout-parts [layout
                                                                                   box-type]
                                                           (set layout.results
                                                                results)
                                                           (results.border:set_style (. border.results_patch
                                                                                        box-type))
                                                           (set layout.prompt
                                                                prompt)
                                                           (prompt.border:set_style (. border.prompt_patch
                                                                                       box-type))
                                                           (if (= box-type
                                                                  :minimal)
                                                               (set layout.preview
                                                                    nil)
                                                               (do
                                                                 (set layout.preview
                                                                      preview)
                                                                 (preview.border:set_style (. border.preview_patch
                                                                                              box-type)))))

                                                         (fn get-layout-size [box-kind]
                                                           (. (. picker.layout_config
                                                                 (or (and (= box-kind
                                                                             :minimal)
                                                                          :vertical)
                                                                     box-kind))
                                                              :size))

                                                         (local (box box-kind)
                                                                (get-box))
                                                         (local layout
                                                                (Layout {:position "50%"
                                                                         :relative :editor
                                                                         :size (get-layout-size box-kind)}
                                                                        box))
                                                         (set layout.picker
                                                              picker)
                                                         (prepare-layout-parts layout
                                                                               box-kind)
                                                         (local layout-update
                                                                layout.update)

                                                         (fn layout.update [self]
                                                           (local (box box-kind)
                                                                  (get-box))
                                                           (prepare-layout-parts layout
                                                                                 box-kind)
                                                           (layout-update self
                                                                          {:size (get-layout-size box-kind)}
                                                                          box))

                                                         (TSLayout layout))
                                        :layout_config {:horizontal {:size {:height "100%"
                                                                            :width "100%"}}
                                                        :vertical {:size {:height "100%"
                                                                          :width "100%"}}}
                                        :layout_strategy :flex}})
           (telescope.load_extension :fzf))
 : keys}

