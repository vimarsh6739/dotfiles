;; Keymaps ported from lua/keymaps.lua using Fennel/nfnl.
(local keymap-set vim.keymap.set)
(local create-autocmd vim.api.nvim_create_autocmd)
(local create-augroup vim.api.nvim_create_augroup)

;; Clear highlights on search when pressing <Esc> in normal mode.
(keymap-set "n" "<Esc>" "<cmd>nohlsearch<CR>")

;; Diagnostic quickfix list shortcut.
(keymap-set "n" "<leader>q" vim.diagnostic.setloclist {:desc "Open diagnostic [Q]uickfix list"})

;; Easier exit from terminal-mode using double <Esc>.
(keymap-set "t" "<Esc><Esc>" "<C-\\><C-n>" {:desc "Exit terminal mode"})

;; Split navigation using Ctrl + hjkl.
(keymap-set "n" "<C-h>" "<C-w><C-h>" {:desc "Move focus to the left window"})
(keymap-set "n" "<C-l>" "<C-w><C-l>" {:desc "Move focus to the right window"})
(keymap-set "n" "<C-j>" "<C-w><C-j>" {:desc "Move focus to the lower window"})
(keymap-set "n" "<C-k>" "<C-w><C-k>" {:desc "Move focus to the upper window"})

;; Highlight text right after yanking.
(create-autocmd "TextYankPost"
  {:desc "Highlight when yanking (copying) text"
   :group (create-augroup "kickstart-highlight-yank" {:clear true})
   :callback (fn []
               (vim.hl.on_yank))})

;; Trigger Neogen documentation generator.
(keymap-set "n" "<leader>dg" ":lua require('neogen').generate()<CR>" {:noremap true :silent true})

true
