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
  --Fraction (w/ regex)
  s(
    {
      trig = "([^%a])ff",
      regTrig = true,
      wordTrig = false,
      dscr = "This is a snippet used to enter fraction mude \frac{}{} in LaTeX",
      priority = 100,
    },
    fmta(
      [[
      <>\frac{<>}{<>}
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1, "Numerator"),
        i(2, "Denominator"),
      }
    )
  ),

  --Equation
  s(
    { trig = "([^%a])alg", regTrig = true, wordTrig = false, dscr = "This will open an equation environment" },
    fmta(
      [[
     \begin{align*}
         <>
     \end{align*}
   ]],
      { i(0) }
    ) -- The fmta makes for more human-friendly snippets, the a means the default delimiter is <>, thus better than {} for LaTeX.
    -- Here, i(0) signals an exit point once the snippet completes.
  ),

  s(
    { trig = "([^%a])fnc", regTrig = true, wordTrig = false, dscr = "This will open an equation environment" },
    fmta(
      [[
     \begin{align*}
         <>:&<>\rightarrow<> \\
            &<>\longmapsto <>
     \end{align*}
   ]],
      { i(0), i(1), i(2), i(3), i(4) }
    ) -- The fmta makes for more human-friendly snippets, the a means the default delimiter is <>, thus better than {} for LaTeX.
    -- Here, i(0) signals an exit point once the snippet completes.
  ),

  --Environment expansion
  s(
    {
      trig = "([^%a])env",
      wordTrig = false,
      regTrig = true,
      dscr = "This will start and environment in LaTeX using rep to write only once",
    },
    --The term [^%a] prevents the snippet from expanding after any letter (%d for digits, %w for alphanumeric, %s for whitespace).
    fmta(
      [[
    \begin{<>}
      <>
    \end{<>}
   ]],
      {
        i(1),
        i(2),
        rep(1),
      } -- The term rep(1) here means we're repeating the first instance of <> after i(2).
    ),
    {
      condition = line_begin,
    }
  ),
  s(
    {
      trig = "(.)oof",
      wordTrig = false,
      regTrig = true,
    },
    fmta(
      [[
      <><>\circ <>\circ\cdots\circ <><>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        rep(1),
        rep(1),
        i(0),
      }
    )
  ),
  s(
    {
      trig = "(.)onf",
      wordTrig = false,
      regTrig = true,
    },
    fmta(
      [[
      <>\underline{<>\circ <>\circ\cdots\circ <>}_{<>\text{-vezes}}<>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        rep(1),
        rep(1),
        i(2),
        i(0),
      }
    )
  ),
  --Math mode
  s(
    { trig = "([^%a])mm", wordTrig = false, regTrig = true },
    fmta("<>\\(<>\\)", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = "([^%a])Mm", wordTrig = false, regTrig = true },
    fmta(
      [[<>
  \[
    <>
  \]
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),

  --Start a new section
  s({ trig = "h1", dscr = "Top-level section", snippetType = "autosnippet" }, fmta([[\section{<>}]], { i(1) }), {
    condition = line_begin,
  }),

  s(
    { trig = "h2", snippetType = "autosnippet" },
    fmta([[\subsection{<>}]], {
      i(1),
    }),
    {
      condition = line_begin,
    }
  ),

  s(
    { trig = "h3", snippetType = "autosnippet" },
    fmta([[\subsubsection{<>}]], {
      i(1),
    }),
    {
      condition = line_begin,
    }
  ),

  s(
    { trig = "clm", snippetType = "autosnippet" },
    fmta([[\textbf{\underline{Claim}:} <>]], {
      i(1),
    }),
    {
      condition = line_begin,
    }
  ),

  s(
    { trig = "afr", snippetType = "autosnippet" },
    fmta([[\textbf{\underline{Afirmação}:} <>]], {
      i(1),
    }),
    {
      condition = line_begin,
    }
  ),
  --Draw in tikz environment (using conditionals)
  s(
    { trig = "dd" },
    fmta("\\draw [<>]", {
      i(1, "Parameters"),
    }),
    { condition = tex_utils.in_tikz }
  ),
  s(
    { trig = "(.)ffk", regTrig = true, wordTrig = false },
    fmta(
      [[
      <><>:<>\rightarrow 
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
    { trig = "ms", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{bmatrix}
        <>
      \end{bmatrix}
    ]],
      { i(0) }
    )
  ),
  s(
    { trig = "msp", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{pmatrix}
        <>
      \end{pmatrix}
    ]],
      { i(0) }
    )
  ),
  s(
    { trig = "msnice", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{bNiceMatrix}[first-col, first-row]
        <>
      \end{bNiceMatrix}
    ]],
      { i(0) }
    )
  ),
  s(
    { trig = "mspnice", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{pNiceMatrix}[first-col, first-row]
        <>
      \end{pNiceMatrix}
    ]],
      { i(0) }
    )
  ),
  s(
    { trig = "tmc", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\multicolumn{<>}{<>}{<>}
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
    { trig = "tmr", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\multirow{<>}{<>}{<>}
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
    { trig = "tbl", regTrig = true, wordTrig = false },
    fmta(
      [[
    \begin{table}[<>]
    \centering
      \begin{tabular}{<>}
        <>
        <>
        <>
      \end{tabular}
    \caption{<>}
    \end{table}
    ]],
      {
        i(1, "placement"),
        i(2, "c | c | c | to add separations"),
        i(3, "multicolumn if you want to merge columns to make a title"),
        i(4, "hline if you want to separate by a line"),
        i(5, "caption"),
        i(6),
      }
    ),
    {
      condition = line_begin,
    }
  ),
  s(
    { trig = "btbl", regTrig = true, wordTrig = false },
    fmta(
      [[
    \begin{table}[<>]
    \centering
    \resizebox{\textwidth}{!}{
      \begin{tabular}{<>}
        <>
        <>
        <>
      \end{tabular}}
    \caption{<>}
    \end{table}
    ]],
      {
        i(1, "placement"),
        i(2, "c | c | c | to add separations"),
        i(3, "multicolumn if you want to merge columns to make a title"),
        i(4, "hline if you want to separate by a line"),
        i(5, "caption"),
        i(6),
      }
    ),
    {
      condition = line_begin,
    }
  ),
  s(
    { trig = "plt" },
    fmta(
      [[
  \addplot[
    domain=<>:<>,
    samples=100,
    color=red,
  ]
  {<>};
  \addlegendentry{\(<>\)}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    )
  ),

  s(
    { trig = "tkz" },
    fmta(
      [[
  \begin{tikzpicture}
  \begin{axis}[
      axis lines = left,
      xlabel = \(x\),
      ylabel = {\(f(x)\)},
  ]
  \addplot [
      domain=<>:<>, 
      samples=100, 
      color=red,
  ]
  {<>};
  \addlegendentry{\(<>\)}
  %Here the blue parabola is defined
  \end{axis}
\end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    )
  ),

  s(
    { trig = "(.)img", wordTrig = false, regTrig = true },
    fmta(
      [[
  \begin{figure}[H]
  \begin{center}
  \includegraphics[height=\textheight, width=\textwidth, keepaspectratio]{./Images/<>}
  \end{center}
  \caption{<>}
  \label{<>}
  \end{figure}
  ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  s({ trig = "gg", regTrig = true, wordTrig = false }, t("\\qedsymbol")),
  s({ trig = "ggc", regTrig = true, wordTrig = false }, t("\\blacktriangle")),

  s(
    { trig = "([^%a])inn", regTrig = true, wordTrig = false },
    fmt(
      [[
    {}\left< {}, {} \right>
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
    { trig = "(.){", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>\{<>\}
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
    { trig = "ibp" },
    fmta(
      [[
    <>\left\{\begin{array}{ll}
      <> \\
      <>
    \end{array}\right.
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
    { trig = "rbp" },
    fmta(
      [[
    <>\left.\begin{array}{ll}
      <> \\
      <>
    \end{array}\right\}
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
    { trig = "afk" },
    fmta(
      [[
  <><> = \left\{\begin{array}{ll}
      <>
    \end{array}\right.
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
    { trig = "hrf" },
    fmta(
      [[
    <>\hyperlink{<>}{\textit{<>}}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        d(2, get_visual),
      }
    )
  ),

  s(
    { trig = "hta" },
    fmta(
      [[
    <>\hypertarget{<>}{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        d(2, get_visual),
      }
    )
  ),

  s(
    { trig = "bb[", snippetType = "autosnippet" },
    fmta(
      [[
    <>\biggl[<>\biggr]
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
    { trig = "bb(", snippetType = "autosnippet" },
    fmta(
      [[
    <>\biggl(<>\biggr)
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
    { trig = "bb{", snippetType = "autosnippet" },
    fmta(
      [[
    <>\biggl\{<>\biggr\}
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
    { trig = "bb\\", snippetType = "autosnippet" },
    fmta(
      [[
    <>\biggl\vert <> \biggr\vert
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
    { trig = "nb[", snippetType = "autosnippet" },
    fmta(
      [[
    <>\bigl[<>\bigr]
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
    { trig = "nb(", snippetType = "autosnippet" },
    fmta(
      [[
    <>\bigl(<>\bigr)
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
    { trig = "nb{", snippetType = "autosnippet" },
    fmta(
      [[
    <>\bigl\{<>\bigr\}
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
    { trig = "nb\\", snippetType = "autosnippet" },
    fmta(
      [[
    <>\bigl\vert <> \bigr\vert
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
    { trig = "evl" },
    fmta(
      [[
    <>\biggl|_{<>}^{<>}\biggr.
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
    { trig = "chs" },
    fmta(
      [[
    <>\binom{<>}{<>}
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
    { trig = "ovb" },
    fmta(
      [[
    <>\overbrace{<>}^{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
        i(2),
      }
    )
  ),

  s(
    { trig = "unb" },
    fmta(
      [[
    <>\underbrace{<>}_{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
        i(2),
      }
    )
  ),

  s(
    { trig = "stk" },
    fmta(
      [[
    <>\substack{<> \\ <>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
        i(2),
      }
    )
  ),

  s(
    { trig = "(.)smn", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\setminus{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),

  s({ trig = "cmp" }, t("^{\\complement}")),

  s(
    { trig = "(.)chn", regTrig = true, wordTrig = false },
    fmta(
      [[
    \dotsc \longrightarrow <>_{<>}\overbracket[0pt]{\longrightarrow}^{\partial_{<>}} <>_{<>}\overbracket[0pt]{\longrightarrow}^{\partial_{<>}} <>_{<>}\overbracket[0pt]{\longrightarrow}^{\partial_{<>}} <>_{<>}\longrightarrow \dotsc
  ]],
      {
        i(1),
        i(2),
        rep(2),
        rep(1),
        i(3),
        rep(3),
        rep(1),
        i(4),
        rep(4),
        rep(1),
        i(5),
      }
    )
  ),

  s(
    { trig = "(.)clr", regTrig = true, wordTrig = false },
    fmta(
      [[
      <>{\color{<>}<>}<>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
        d(2, get_visual),
        i(0),
      }
    )
  ),

  s(
    { trig = "(.)mcl", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\mathclap{<>}
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
    { trig = "(.)mll", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\mathllap{<>}
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
    { trig = "(.)mrl", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\mathrlap{<>}
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
  ),
}
