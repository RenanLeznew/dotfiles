require("luasnip.loaders.from_lua").load({ path = "../luasnip_loaders.lua" })
-- This is the `get_visual` function.
-- ----------------------------------------------------------------------------
-- Summary: If `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- If `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 1 then
    return sn(nil, i(2, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(2))
  end
end

-- This local is going to be used to make a snippet trigger only when it is the beggining of a new line.
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- This local is used to tell when you're in math mode.
local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 2
end
-- Some LaTeX-specific conditional expansion functions (requires VimTeX)

local tex_utils = {}
tex_utils.in_mathzone = function() -- math context detection
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function() -- comment detection
  return vim.fn["vimtex#syntax#in_comment"]() == 1
end
tex_utils.in_env = function(name) -- generic environment detection
  local is_inside = vim.fn["vimtex#env#is_inside"](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function() -- equation environment detection
  return tex_utils.in_env("equation")
end
tex_utils.in_itemize = function() -- itemize environment detection
  return tex_utils.in_env("itemize")
end
tex_utils.in_tikz = function() -- TikZ picture environment detection
  return tex_utils.in_env("tikzpicture")
end

return {
  --Greek letters
  s(
    { trig = "(.);a", regTrig = true, wordTrig = false, priority = 100, snippetType = "autosnippet" },
    fmta("<>\\alpha ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);b", regTrig = true, wordTrig = false, priority = 100, snippetType = "autosnippet" },
    fmta("<>\\beta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);g", regTrig = true, wordTrig = false, priority = 100, snippetType = "autosnippet" },
    fmta("<>\\gamma ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);m", regTrig = true, wordTrig = false, priority = 100, snippetType = "autosnippet" },
    fmta("<>\\mu ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),g", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Gamma ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);t", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\theta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);f", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\varphi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),f", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Phi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);p", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\pi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),p", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Pi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);z", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\zeta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);o", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\omega ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),o", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Omega ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);l", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\lambda ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),l", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Lambda ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);e", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\varepsilon ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);d", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\delta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),d", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Delta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);s", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\sigma ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.),s", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Sigma ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.);n", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\eta ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.);r", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\rho ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.);k", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\kappa ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.);w", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\tau ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);x", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\xi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);X", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\Xi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);c", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\chi ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.);y", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\nu ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
}
