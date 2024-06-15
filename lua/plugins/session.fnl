{1 :rmagatti/auto-session
 :config (fn [] (local session (require :auto-session))
           (session.setup {:log_level :error}))}

