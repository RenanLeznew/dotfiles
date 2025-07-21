require("luasnip.loaders.from_lua").load({ path = "../luasnip_loaders.lua" })
-- This is the `get_visual` function.
-- ----------------------------------------------------------------------------
-- Summary: If `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- If `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if #parent.snippet.env.SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
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
  s(
    { trig = "([^%a])int", regTrig = true, wordTrig = false },
    fmta(
      [[
         <>\int_{<>}^{<>}<> \mathrm{d<>}<>
        ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
      }
    )
  ),
  s(
    { trig = "([^%a])inu", regTrig = true, wordTrig = false },
    fmta(
      [[
         <>\overline{\intup_{<>}^{<>}}<>\mathrm{d<>}
        ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
  s(
    { trig = "([^%a])inl", regTrig = true, wordTrig = false },
    fmta(
      [[
         <>\underline{\intup_{<>}^{<>}}<>\mathrm{d<>}
        ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
        i(0),
      }
    )
  ),
  s(
    { trig = "([^%a])iin", regTrig = true, wordTrig = false },
    fmta(
      [[
        <>\iint_{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
  s(
    { trig = "([^%a])ins", regTrig = true, wordTrig = false },
    fmta(
      [[
        <>\iiint_{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
  s(
    { trig = "([^%a])inc", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\oint_{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
  s(
    { trig = "([^%a])mnt", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\int_{<>}<> d\mu_{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s(
    { trig = "([^%a])lnt", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\int_{<>}<> \mathrm{dm}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = "([^%a])dv", regTrig = true, wordTrig = false },
    fmta(
      [[
     <>\frac{\mathrm{d}<>}{\mathrm{d}<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = "([^%a])dvw", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
     <>\frac{\mathrm{d}^{<>}<>}{\mathrm{d}<>^{<>}}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s(
    { trig = "([^%a])pp", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\frac{\partial <>}{\partial <>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = "([^%a])dvp", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\frac{\partial^{<>}<>}{\partial <>^{<>}}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s(
    { trig = "([^%a])dp", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\partial_{<>}^{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),
  s(
    { trig = "([^%a])vk", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\vec{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "(.)vrs", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\hat{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "(.)Vrs", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta(
      [[
      <>\widehat{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "([^%a])all", regTrig = true, wordTrig = false },
    fmta("<>\\forall ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)ra", regTrig = true, wordTrig = false },
    fmta("<>\\rightarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)Ra", regTrig = true, wordTrig = false },
    fmta("<>\\Rightarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)la", regTrig = true, wordTrig = false },
    fmta("<>\\leftarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)La", regTrig = true, wordTrig = false },
    fmta("<>\\Leftarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)hal", regTrig = true, wordTrig = false },
    fmta("<>\\hookleftarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)har", regTrig = true, wordTrig = false },
    fmta("<>\\hookrightarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)rtl", regTrig = true, wordTrig = false },
    fmta("<>\\rightarrowtail ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)ltl", regTrig = true, wordTrig = false },
    fmta("<>\\leftarrowtail ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)iar", regTrig = true, wordTrig = false },
    fmta("<>\\rightarrowtail\\mathrel{\\mspace{-15mu}}\\twoheadrightarrow", {

      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)ial", regTrig = true, wordTrig = false },
    fmta("<>\\twoheadleftarrow\\mathrel{\\mspace{-15mu}}\\leftarrowtail", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)her", regTrig = true, wordTrig = false },
    fmta("<>\\twoheadrightarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)hel", regTrig = true, wordTrig = false },
    fmta("<>\\twoheadleftarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "([^%a])ea", regTrig = true, wordTrig = false },
    fmta("<>\\Longleftrightarrow ", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "([^%a])pd", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\prod\limits_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "([^%a])ss", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\sum\limits_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "(.)~", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\cong <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),
  s(
    { trig = "(.)tld", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\tilde{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "(.)Tld", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\widetilde{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
  s(
    { trig = "it" },
    fmta(
      [[
  <>\item[<>)]
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
  --Set (k)ontained
  s(
    { trig = "sk", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\subseteq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end), -- Adds a whitespace after expanding the snippet
      }
    )
  ),

  --Set outside
  s(
    { trig = "so", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\supseteq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),

  s(
    { trig = "(.)qup", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\sqcup 
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)cup", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\cup 
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "buc", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\bigcup_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "(.)cap", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\cap 
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "bac", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\bigcap_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "suc", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\bigsqcup_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "sac", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\bigsqcap_{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "(.)oo", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\circ <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),

  s(
    { trig = "(.)>", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\geq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),
  s(
    { trig = "(.)<", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\leq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),
  s(
    { trig = "(.)nml", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\trianglelefteq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),

  s(
    { trig = "(.)fkr", regTrig = true, wordTrig = false },
    fmta(
      [[
    <><>|_{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        i(2),
      }
    )
  ),

  s(
    { trig = "(.)nmr", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\trianglerighteq <>
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        f(function(_, snip)
          return snip.captures[2]
        end),
      }
    )
  ),

  s({ trig = "dt" }, t("\\cdot ")),

  s({ trig = "akt" }, t("\\curvearrowright ")),

  s(
    { trig = "rmo" },
    fmta(
      [[
    <>^{\mathrm{o}}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),

  s({ trig = "bnd" }, t("\\partial ")),

  s(
    { trig = "(.)deg", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\deg{(<>)}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
  s(
    { trig = "(.)tim", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\times 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)Tim", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\Times 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)tom", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\otimes 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)Tom", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\bigotimes 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)plos", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\oplus
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),

  s(
    { trig = "(.)Plos", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\bigoplus
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)and", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\wedge 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
  s(
    { trig = "(.)or", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\vee 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),

  s(
    { trig = "(.)del", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\nabla 
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),
}
