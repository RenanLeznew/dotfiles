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
--local in_mathzone = function()
-- return vim.fn["vimtex#syntax#in_mathzone"]() == 2
--end
-- Some LaTeX-specific conditional expansion functions (requires VimTeX)

--local tex_utils = {}
--tex_utils.in_mathzone = function() -- math context detection
-- return vim.fn["vimtex#syntax#in_mathzone"]() == 1
--end
--tex_utils.in_text = function()
-- return not tex_utils.in_mathzone()
--end
--tex_utils.in_comment = function() -- comment detection
-- return vim.fn["vimtex#syntax#in_comment"]() == 1
--end
--tex_utils.in_env = function(name) -- generic environment detection
-- local is_inside = vim.fn["vimtex#env#is_inside"](name)
-- return (is_inside[1] > 0 and is_inside[2] > 0)
--end
--- A few concrete environments---adapt as needed
--tex_utils.in_equation = function() -- equation environment detection
-- return tex_utils.in_env("equation")
--end
--tex_utils.in_itemize = function() -- itemize environment detection
-- return tex_utils.in_env("itemize")
--end
--tex_utils.in_tikz = function() -- TikZ picture environment detection
-- return tex_utils.in_env("tikzpicture")
--end

return {
  --Texttt
  -- s({
  --   trig = "tt",
  --   dscr = "this snippet uses an input to create a texttt latex mode",
  --   priority = 100,
  --  snippetType = "autosnippet",
  -- }, fmt("\\texttt{<>}", { i(1) }, { delimiters = "<>" })),

  s(
    { trig = "(.):=", regTrig = true, wordTrig = false },
    fmta([[<>\coloneqq ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  --Italic
  s(
    { trig = "tii", dscr = "Turn selected line in italic mode.", snippetType = "autosnippet" },
    fmta("\\textit{<>}", {
      d(1, get_visual),
    })
  ),

  --Bold face
  s(
    { trig = "tbf", dscr = "Turn selected line into bold text.", snippetType = "autosnippet" },
    fmta("\\textbf{<>}", {
      d(1, get_visual),
    })
  ),

  s(
    { trig = "(.)txt", dscr = "Turn selected line into text.", regTrig = true, wordTrig = false },
    fmta("<>\\text{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = "(.)unl", dscr = "Underline selected line.", regTrig = true, wordTrig = false },
    fmta("<>\\underline{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  --Subindex
  s(
    { trig = "(.)__", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),

  --Superindex
  s(
    { trig = "(.)pw", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),

  s(
    { trig = "(.)puw", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>_{<>}^{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    })
  ),
  --Mathbb
  s(
    { trig = "(.)mb", regTrig = true, wordTrig = false },
    fmta("<>\\mathbb{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = "(.)mbo", regTrig = true, wordTrig = false },
    fmta("<>\\mathbb{<>}^{\\times}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  --Mathcal
  s(
    { trig = "(.)mc", regTrig = true, wordTrig = false },
    fmta("<>\\mathcal{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  --Mathfrak
  s(
    { trig = "(.)mk", regTrig = true, wordTrig = false },
    fmta("<>\\mathfrak{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  --Mathroman
  s(
    { trig = "(.)mr", regTrig = true, wordTrig = false },
    fmta("<>\\mathrm{<>}", {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = "subfile" },
    fmta(
      [[ 
      \documentclass[<>]{subfiles}
      \begin{document}
      \section{<> - <>, 2025}
      \subsection{Motivações}
      \begin{itemize}
	      \item <>
      \end{itemize}
      \subsection{<>}
      <>
      \end{document}
      ]],
      {
        i(1, "Caminho"),
        i(2, "Aula X"),
        i(3, "Data"),
        i(4, "Tópico"),
        i(5, "Subtítulo"),
        i(0),
      }
    )
  ),
  --Preamble
  s(
    { trig = "pamble" },
    fmta(
      [[\documentclass[12pt]{article}
 \usepackage{bookmark}
 \usepackage{amsmath}
 \usepackage{amsthm}
 \usepackage{amssymb}
 \usepackage{tikz}
 \usepackage{pgfplots}
 \usepackage[utf8]{inputenc}
 \usepackage{amsfonts}
 \usepackage{nicematrix}
 \usepackage[x11names]{xcolor}
 \usepackage{geometry}
 \usepackage{graphicx}
 \usepackage{graphics}
 \usepackage[export]{adjustbox}
 \usepackage{fancyhdr}
 \usepackage[portuguese]{babel}
 \usepackage{hyperref}
 \usepackage{multirow}
 \usepackage{lastpage}
 \usepackage{mathtools}
 \usepackage[many]{tcolorbox}
 \usepackage{newtxsf}
 \usepackage{subfiles}
 \usepackage{flafter}
 \usepackage{float}
 \usepackage{accents}
 \usepackage[T1]{fontenc}
 \setcounter{section}{-1}

 \pagestyle{fancy}
 \fancyhf{}

 \pgfplotsset{compat = 1.18}

 \hypersetup{
     colorlinks,
     citecolor=black,
     filecolor=black,
     linkcolor=black,
     urlcolor=black
 }
 \newtheorem*{theorem*}{\underline{Teorema}}
 \newtheorem*{lemma*}{\underline{Lema}}
 \newtheorem*{prop*}{\underline{Proposição}}
 \newtheorem*{crl*}{\underline{Corolário}}
 \theoremstyle{definition}
 \newtheorem{example}{\underline{Exemplo}}
 \newtheorem*{def*}{\underline{Definição}}
 \newtheorem*{proof*}{\underline{Prova}}
 \newtheorem{exr}{\underline{Exercício}}
 \renewcommand\qedsymbol{$\blacksquare$}

 \rfoot{Página \thepage \hspace{1pt} de \pageref{LastPage}}

 \geometry{a4paper, left=3cm, top=3cm, right=3cm, bottom=3cm}

 \begin{document}
 \begin{figure}[ht]
	\minipage{0.76\textwidth}
		\includegraphics[width=4cm]{../icmc.png}
		\hspace{7cm}
		\includegraphics[height=4.9cm,width=4cm]{../brasao_usp_cor.jpg}
	\endminipage	
\end{figure}

\begin{center}
	\vspace{1cm}
	\LARGE
	UNIVERSIDADE DE SÃO PAULO

	\vspace{1.3cm}
	\LARGE
	INSTITUTO DE CIÊNCIAS MATEMÁTICAS E COMPUTACIONAIS - ICMC

	\vspace{1.7cm}
	\Large
	\textbf{<>}

	\vspace{1.3cm}
	\large
	\textbf{Renan Wenzel - 11169472}

	\vspace{1.3cm}
	\large
	\textbf{Professor(a): <>}

  \textbf{E-mail: <>}

	\vspace{1.3cm}
	\today
\end{center}

 \newpage
\textbf{{\Huge Avisos}}

  {\huge Essas notas não possuem relação com professor algum. 

  Qualquer erro é responsabilidade solene do autor.

Caso julgue necessário, contatar: 

renan.wenzel.rw@gmail.com. 

Além disso, alguns textos em itálicos são clicáveis - normalmente, afim de facilitar o encontro de um resultado, definição ou uma continuação.
}

 \tableofcontents

 \newpage

 <>

 \begin{thebibliography}{99}

 \end{thebibliography}

 \end{document}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(0),
      }
    )
  ),

  s({ trig = ".." }, t("\\dotsc ")),

  s({ trig = ":" }, t("\\vdots")),

  s(
    { trig = "nep" },
    fmta(
      [[
  <>\neq\emptyset
  ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),

  s(
    { trig = "(.)ept", regTrig = true, wordTrig = false },
    fmta(
      [[
  <>\emptyset <>
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
    { trig = "(.)s8", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta("<>\\infty", {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)bb", regTrig = true, wordTrig = false },
    fmta([[<>\overline{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = "(.)url", regTrig = true, wordTrig = false },
    fmta([[<>\url{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),

  s(
    { trig = "(.)rt", regTrig = true, wordTrig = false },
    fmta([[<>\sqrt[<>]{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    })
  ),

  s(
    { trig = "(.)|", regTrig = true, wordTrig = false },
    fmta([[<>| <> |]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),

  s(
    { trig = "(.)nrm", regTrig = true, wordTrig = false },
    fmta([[<>\Vert <> \Vert]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = "(.)Nrm", regTrig = true, wordTrig = false },
    fmta([[<>\biggl\Vert <> \biggr\Vert]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = "(.)tog", regTrig = true, wordTrig = false },
    fmta([[<>\overbracket[0pt]{\leftarrow}^{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),

  s(
    { trig = "(.)cnv", regTrig = true, wordTrig = false },
    fmta([[<>\substack{<> \\ \longrightarrow \\ <>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
    })
  ),

  s(
    { trig = "(.)lim", regTrig = true, wordTrig = false },
    fmta([[<>\lim_{<>\to <>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
      i(0),
    })
  ),

  s(
    { trig = "(.)lid", regTrig = true, wordTrig = false },
    fmta([[<>\varinjlim_{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(0),
    })
  ),

  s(
    { trig = "(.)lii", regTrig = true, wordTrig = false },
    fmta([[<>\varprojlim_{<>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(0),
    })
  ),

  s(
    { trig = "(.)lif", regTrig = true, wordTrig = false },
    fmta([[<>\liminf_{<>\to <>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
      i(0),
    })
  ),

  s(
    { trig = "(.)lip", regTrig = true, wordTrig = false },
    fmta([[<>\limsup_{<>\to <>}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
      i(0),
    })
  ),

  s(
    { trig = "(.)rig", regTrig = true, wordTrig = false },
    fmta([[<>\lim_{<>\to <>^{+}}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
      i(0),
    })
  ),

  s(
    { trig = "(.)lef", regTrig = true, wordTrig = false },
    fmta([[<>\lim_{<>\to <>^{-}}<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      i(2),
      i(0),
    })
  ),

  s(
    { trig = "(.)upt", regTrig = true, wordTrig = false },
    fmta([[<>\uparrow ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)dwt", regTrig = true, wordTrig = false },
    fmta([[<>\downarrow ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)mpt", regTrig = true, wordTrig = false },
    fmta([[<>\mapsto ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)cs", regTrig = true, wordTrig = false },
    fmta([[<>\cos^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)sn", regTrig = true, wordTrig = false },
    fmta([[<>\sin^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)csh", regTrig = true, wordTrig = false },
    fmta([[<>\cosh^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)snh", regTrig = true, wordTrig = false },
    fmta([[<>\sinh^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)log", regTrig = true, wordTrig = false },
    fmta([[<>\log^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)ln", regTrig = true, wordTrig = false },
    fmta([[<>\ln^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)tg", regTrig = true, wordTrig = false },
    fmta([[<>\tan^{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
      d(2, get_visual),
    })
  ),
  s(
    { trig = "(.)det", regTrig = true, wordTrig = false },
    fmta([[<>\det{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = "(.)chv", regTrig = true, wordTrig = false },
    fmta([[<>\langle <> \rangle]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      d(1, get_visual),
    })
  ),
  s(
    { trig = "(.)ell", regTrig = true, wordTrig = false },
    fmta([[<>\ell <>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  s(
    { trig = "(.)q7q", regTrig = true, wordTrig = false },
    fmta([[<>\quad\&\quad <>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  s(
    { trig = "(.)q7", regTrig = true, wordTrig = false },
    fmta([[<>\quad\& <>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  s(
    { trig = "(.)qq", regTrig = true, wordTrig = false },
    fmta([[<>\quad <>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    })
  ),
  s(
    { trig = "(.)sq", regTrig = true, wordTrig = false },
    fmta([[<>\square]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)chr", regTrig = true, wordTrig = false },
    fmta([[<>\chi_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),
  s(
    { trig = "(.)sup", regTrig = true, wordTrig = false },
    fmta([[<>\sup_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),
  s(
    { trig = "(.)inf", regTrig = true, wordTrig = false },
    fmta([[<>\inf_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),
  s(
    { trig = "(.)max", regTrig = true, wordTrig = false },
    fmta([[<>\max\limits_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),
  s(
    { trig = "(.)min", regTrig = true, wordTrig = false },
    fmta([[<>\min\limits_{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    })
  ),
  s(
    { trig = "(.)vee", regTrig = true, wordTrig = false },
    fmta([[<>\vee ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)eev", regTrig = true, wordTrig = false },
    fmta([[<>\wedge ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)eqv", regTrig = true, wordTrig = false },
    fmta([[<>\equiv ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),

  s(
    { trig = "(.)prp", regTrig = true, wordTrig = false },
    fmta([[<>\perp ]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
    })
  ),
  s(
    { trig = "(.)toh", regTrig = true, wordTrig = false },
    fmta(
      [[
    <>\begin{align*}
        &\mathrm{H}_{0}: <> = <>\\
        &\mathrm{H}_{a}: <> \neq <>
    \end{align*}<>
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(2),
        i(3),
        i(4),
        i(5),
        i(0),
      }
    )
  ),
  s(
    { trig = "(.)hom", regTrig = true, wordTrig = false },
    fmta([[H_{<>}(<>)=\frac{Z_{<>}(<>)}{B_{<>}(<>)}<>]], {
      i(1),
      i(2),
      rep(1),
      rep(2),
      rep(1),
      rep(2),
      i(0),
    })
  ),
  s(
    {
      trig = "(.)reminder",
      regTrig = true,
      wordTrig = false,
    },
    fmta(
      [[
          \begin{tcolorbox}[
          skin=enhanced,
          title=Lembrete!,
          after title={\hfill <>},
          fonttitle=\bfseries,
          sharp corners=downhill,
		      colframe=black,
          colbacktitle=yellow!75!white, 
          colback=yellow!30,
          colbacklower=black,
		      coltitle=black,
          %drop fuzzy shadow,
          drop large lifted shadow
          ]
          <>
          \end{tcolorbox}
      ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  s(
    {
      trig = "(.)obs",
      regTrig = true,
      wordTrig = false,
    },
    fmta(
      [[
          \begin{tcolorbox}[
          skin=enhanced,
          title=Observação,
          fonttitle=\bfseries,
		      colframe=black,
          colbacktitle=cyan!75!white, 
          colback=cyan!15,
          colbacklower=black,
		      coltitle=black,
          drop fuzzy shadow,
          %drop large lifted shadow
          ]
          <>
          \end{tcolorbox}
      ]],
      {
        i(1),
      }
    )
  ),
}
