-- Personal LaTeX snippets. This file is loaded by LuaSnip through Blink's config.
-- Keep active definitions in the lists below; all patterns start inactive.
-- The Lua loader reloads this file when saved in the same Neovim instance.
-- Manual snippets appear in Blink: Ctrl-Space, Ctrl-N/P, Ctrl-Y to accept.
-- Tab / Shift-Tab move through placeholders after expansion.
--
-- To add a definition, use require('luasnip').snippet / insert_node / text_node,
-- or require('luasnip').parser.parse_snippet for a VS Code style body.
-- Math-only definitions should use this condition (and show_condition):
--   function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
-- Automatic definitions belong in autosnippets; regular ones in snippets.
--
-- Pattern catalog inspired by https://castel.dev/post/lecture-notes-1/
-- These are descriptions, NOT implemented snippets; ask to implement one.
--
-- Environments: beg -> matching begin/end names, with an editable body.
-- Math entry: mk -> inline math; dm -> display math.
-- Subscripts: letter+digit -> subscript; brace longer subscripts.
-- Powers: sr -> squared; cb -> cubed; compl -> complement; td -> exponent.
-- Fractions: // -> numerator/denominator; expression/ -> fraction.
-- Fractions: recognize balanced parentheses; wrap selected text.
-- Postfix accents: phat -> hat over p; zbar -> overline over z.
-- Postfix vectors: v,. or v., -> vector over v.
-- Symbols: !> -> mapsto; -> -> to; cc -> subset; ooo -> infinity.
-- Operators: lim, sum -> limits with editable bounds.
-- Functions: fun -> function domain/codomain skeleton.
-- Course-specific notation: bra, ket, and inner-product patterns.
-- Computation: optional SymPy / Mathematica expression evaluation.
-- Context: restrict math shortcuts to math; others to comments/environments.
--
-- Paper-writing ideas: section/label, figure/caption, table, cite, ref, theorem.

local snippets = {}
local autosnippets = {}

return snippets, autosnippets
