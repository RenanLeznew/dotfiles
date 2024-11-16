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

  s(
    { trig = "(.)arw", regTrig = true, wordTrig = false },
    fmta("<>\\draw[Arrow](<>)--(<>);<>", {
      i(1),
      i(2),
      i(3),
      i(0),
    })
  ),

  s(
    { trig = "(.)arb", regTrig = true, wordTrig = false },
    fmta("<>\\draw[Arrow](<>)--node[<>, <>] {<>}(<>);<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(5),
      i(6),
      i(0),
    })
  ),

  s(
    { trig = "(.)dsh", regTrig = true, wordTrig = false },
    fmta("<>\\draw[Arrow, dashed](<>)--(<>);<>", {
      i(1),
      i(2),
      i(3),
      i(0),
    })
  ),

  s(
    { trig = "(.)dbl", regTrig = true, wordTrig = false },
    fmta("<>\\draw[dbl](<>) to [out=0, in=180](<>);<>", {
      i(1),
      i(2),
      i(3),
      i(0),
    })
  ),

  s(
    { trig = "(.)nod", regTrig = true, wordTrig = false },
    fmta("<>\\node(<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)var", regTrig = true, wordTrig = false },
    fmta("<>\\node[observed](<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)lat", regTrig = true, wordTrig = false },
    fmta("<>\\node[latent](<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)out", regTrig = true, wordTrig = false },
    fmta("<>\\node[outcome](<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)con", regTrig = true, wordTrig = false },
    fmta("<>\\node[confounding](<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)err", regTrig = true, wordTrig = false },
    fmta("<>\\node[error](<>) at (<>){<>};<>", {
      i(1),
      i(2),
      i(3),
      i(4),
      i(0),
    })
  ),

  s(
    { trig = "(.)ler", regTrig = true, wordTrig = false },
    fmta(
      "<>\\node[isosceles triangle, thick, draw, text centered, shape border rotate=90, minimum height=2.4em, minimum width=2.4em](<>) at (<>){<>};<>",
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(0),
      }
    )
  ),

  s(
    { trig = "(.)sem", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{tikzpicture}[
      observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
    latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
      error/.style ={circle, thick, draw, text centered},
      confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
      outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
       <>-<>/.tip =Latex, thick]
        <>
  \end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),

  s(
    { trig = "(.)cats", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{tikzpicture}[
      observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
    latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
      error/.style ={circle, thick, draw, text centered},
      confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
      outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
       ]
      \node(TL) at (-2,1){<>};
			\node(BL) at (-2,-1){<>};
			\node(TR) at (2,1){<>};
			\node(BR) at (2,-1){<>};

			\draw[Arrow](TL)--node[midway, above] {<>}(TR);
			\draw[Arrow](BL)--node[midway, below] {<>}(BR);
			\draw[Arrow](TL)--node[midway, left] {<>}(BL);
			\draw[Arrow](TR)--node[midway, right] {<>}(BR);
        <>
  \end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)triplet", regTrig = true, wordTrig = false },
    fmta(
      [[
      \begin{tikzpicture}[
      observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
    latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
      error/.style ={circle, thick, draw, text centered},
      confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
      outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
       ]

      \node(T) at (0,1){<>};
			\node(BL) at (-2,-1){<>};
			\node(BR) at (2,-1){<>};

			\draw[Arrow](T)--node[midway, above] {<>}(BL);
			\draw[Arrow](T)--node[midway, above] {<>}(BR);
			\draw[Arrow](BL)--node[midway, below] {<>}(BR);
        <>
  \end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)prods", regTrig = true, wordTrig = false },
    fmta(
      [[
\begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
			\node(S1) at (-2,0){<>};
			\node(S2) at (2,0){<>};
			\node(IS) at (0,2){<>};
			\node(PD) at (0,-2){\(<> <>  <>\)};

			\draw[Arrow](PD)--node[midway, above] {\(\pi_1\)}(S1);
			\draw[Arrow](PD)--node[midway, above] {\(\pi_2\)}(S2);
			\draw[Arrow](IS)--node[midway, left] {<>}(S1);
			\draw[Arrow](IS)--node[midway, left] {<>}(S2);
			\draw[dashed, Arrow](IS)--node[midway, left] {<>}(PD);
      
		\end{tikzpicture}
<>
  ]],
      {
        i(1),
        i(2),
        i(3),
        rep(1),
        i(4),
        rep(2),
        i(5),
        i(6),
        i(7),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)copds", regTrig = true, wordTrig = false },
    fmta(
      [[
\begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
			\node(S1) at (-2,0){<>};
			\node(S2) at (2,0){<>};
			\node(IS) at (0,-2){<>};
			\node(PD) at (0,2){\(<> <> <>\)};

			\draw[Arrow](S1)--node[midway, above] {i}(PD);
			\draw[Arrow](S2)--node[midway, above] {j}(PD);
			\draw[Arrow](S2)--node[midway, left] {<>}(IS);
			\draw[Arrow](S1)--node[midway, left] {<>}(IS);
			\draw[dashed, Arrow](PD)--node[midway, left] {<>}(IS);
      
		\end{tikzpicture}
<>
  ]],
      {
        i(1),
        i(2),
        i(3),
        rep(1),
        i(4),
        rep(2),
        i(5),
        i(6),
        i(7),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)diaker", regTrig = true, wordTrig = false },
    fmta(
      [[
\begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
			\node(X) at (-2,1){<>};
			\node(A) at (0,1){<>};
			\node(B) at (2,1){<>};
			\node(Y) at (0,-1){<>};

			\draw[Arrow](X)--node[midway, above] {<>}(A);
			\draw[Arrow](A)--node[midway, above] {<>}(B);
			\draw[Arrow](Y)--node[midway, left] {<>}(A);
			\draw[Arrow, dashed](Y)--node[midway, left] {<>}(X);
      
		\end{tikzpicture}
<>
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)cokr", regTrig = true, wordTrig = false },
    fmta(
      [[
\begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
      \node(X) at (-2,1){<>};
			\node(A) at (0,1){<>};
			\node(B) at (2,1){<>};
			\node(Y) at (0,-1){<>};

			\draw[Arrow](X)--node[midway, above] {<>}(A);
			\draw[Arrow](A)--node[midway, above] {<>}(B);
			\draw[Arrow](A)--node[midway, left] {<>}(Y);
			\draw[Arrow, dashed](B)--node[midway, left] {<>}(Y);
		      
		\end{tikzpicture}
<>
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(0),
      }
    )
  ),

  s(
    { trig = "(.)fmchn", regTrig = true, wordTrig = false },
    fmta(
      [[ 
\begin{tikzpicture}[
			observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
			latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
			error/.style ={circle, thick, draw, text centered},
			confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
			outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
		]
		\node(TTL) at (-4,1){\(\dotsc \)};
		\node(BBL) at (-4,-1){\(\dotsc \)};
		\node(TL) at (-2,1){\(<>_{n+1}\)};
		\node(BL) at (-2,-1){\(<>_{n+1}\)};
		\node(TM) at (0,1){\(<>_{n}\)};
		\node(BM) at (0,-1){\(<>_{n}\)};
		\node(TR) at (2,1){\(<>_{n-1}\)};
		\node(BR) at (2,-1){\(<>_{n-1}\)};
		\node(TTR) at (4,1){\(\dotsc \)};
		\node(BBR) at (4,-1){\(\dotsc \)};

		\draw[Arrow](TTL)--(TL);
		\draw[Arrow](BBL)--(BL);
		\draw[Arrow](BR)--(BBR);
		\draw[Arrow](TR)--(TTR);
		\draw[Arrow](TL)--node[midway, above] {\(\partial_{n+1}^{<>}\)}(TM);
		\draw[Arrow](TM)--node[midway, above] {\(\partial_{n}^{<>}\)}(TR);
		\draw[Arrow](BL)--node[midway, below] {\(\partial_{n+1}^{<>}\)}(BM);
		\draw[Arrow](BM)--node[midway, below] {\(\partial_{n}^{<>}\)}(BR);
		\draw[Arrow](TL)--node[midway, left] {\(<>_{n+1}\)}(BL);
		\draw[Arrow](TM)--node[midway, left] {\(<>_{n}\)}(BM);
		\draw[Arrow](TR)--node[midway, right] {\(<>_{n-1}\)}(BR);
	\end{tikzpicture}
  <>
    ]],
      {
        i(1),
        i(2),
        rep(1),
        rep(2),
        rep(1),
        rep(2),
        rep(1),
        rep(1),
        rep(2),
        rep(2),
        i(3),
        rep(3),
        rep(3),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)dirlim", regTrig = true, wordTrig = false },
    fmta(
      [[ 
        \begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
			\node(TL) at (-2,1){<>};
			\node(BL) at (0,-1){<>};
			\node(TR) at (2,1){<>};
			\node(BR) at (0,-3){<>};

			\draw[Arrow](TL)--node[midway, above] {<>}(TR);
			\draw[Arrow, dashed](BL)--node[midway, right] {<>}(BR);
			\draw[Arrow](TL)--node[midway, right] {<>}(BL);
			\draw[Arrow](TR)--node[midway, left] {<>}(BL);
			\draw[Arrow, -stealth](TL)to[out = 250, in = 150, edge node={node[midway, left] {<>}}](BR); % To use in/out, imagine a circle around the node. The angles are with respect to the node as the center.
			\draw[Arrow, -stealth](TR)to[out = 300, in = 30, edge node={node[midway, right] {<>}}](BR);
		\end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10),
      }
    )
  ),
  s(
    { trig = "(.)invlim", regTrig = true, wordTrig = false },
    fmta(
      [[ 
        \begin{tikzpicture}[
				observed/.style = {rectangle, thick, text centered, draw, text width = 6em},
				latent/.style = {ellipse, thick, draw, text centered, text width = 6em},
				error/.style ={circle, thick, draw, text centered},
				confounding/.style = {rectangle, thick, text centered, draw, text width = 6em, minimum width = 5.5in},
				outcome/.style = {rectangle, thick, draw, text centered, minimum height = 3.5in, text width = 6em},
			]
			\node(TL) at (-2,-1){<>};
			\node(BL) at (0,1){<>};
			\node(TR) at (2,-1){<>};
			\node(BR) at (0,3){<>};

			\draw[Arrow](TL)--node[midway, above] {<>}(TR);
			\draw[Arrow, dashed](BR)--node[midway, right] {<>}(BL);
			\draw[Arrow](BL)--node[midway, right] {<>}(TL);
			\draw[Arrow](BL)--node[midway, left] {<>}(TR);
			\draw[Arrow, -stealth](BR)to[out = 200, in = 130, edge node={node[midway, left] {<>}}](TL); % To use in/out, imagine a circle around the node. The angles are with respect to the node as the center.
			\draw[Arrow, -stealth](BR)to[out = 340, in = 60, edge node={node[midway, right] {<>}}](TR);
		\end{tikzpicture}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
        i(10),
      }
    )
  ),
}
