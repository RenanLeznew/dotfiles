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
return {
  s(
    { trig = "link" },
    fmt(
      [[
      [{}]<{}>
      ]],
      {
        i(1, "Cobertura"),
        i(2, "Link"),
      }
    )
  ),

  s(
    { trig = "tbf" },
    fmta(
      [[
      **<>**
      ]],
      {
        d(1),
      }
    )
  ),

  s(
    { trig = "tii" },
    fmta(
      [[
      *<>*
      ]],
      {
        d(1),
      }
    )
  ),

  s(
    { trig = "pw" },
    fmta(
      [[
      ^<>^ 
      ]],
      {
        d(1),
      }
    )
  ),

  s(
    { trig = "__" },
    fmta(
      [[
      ~<>~ 
      ]],
      {
        d(1),
      }
    )
  ),

  s(
    { trig = "img" },
    fmta(
      [[
      ![<>](<>)
        ]],
      {
        i(1, "Legenda"),
        i(2, "Arquivo"),
      }
    )
  ),

  s(
    {
      trig = "inline",
    },
    fmta(
      [[
      ^[<>]
]],
      {
        i(1, "Nota"),
      }
    )
  ),

  s(
    {
      trig = "page",
    },
    fmt(
      [[{}
      {{< pagebreak >}}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
      }
    )
  ),

  s(
    {
      trig = "div",
    },
    fmta(
      [[
    :::{.<>}
    <>
    :::
    ]],
      {
        i(1, "Classe"),
        i(2, "Conteúdo"),
      }
    )
  ),

  s(
    {
      trig = "ul",
    },
    fmta(
      [[<>
    * <> 
      + <>
        - <>
    ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1, "Item"),
        i(2, "Subitem"),
        i(3, "Subsubitem"),
      }
    )
  ),

  s(
    {
      trig = "task",
    },
    fmta(
      [[<>
      - [ ] <>
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1, "Task"),
      }
    )
  ),

  s(
    {
      trig = "list",
    },
    fmta(
      [[<>
      ::: {}
      <>
      :::
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1, "Numeração"),
      }
    )
  ),

  s(
    {
      trig = "tip",
    },
    fmta(
      [[<>
      ::: {.callout-tip}
      <>
      :::
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
    {
      trig = "note",
    },
    fmta(
      [[<>
      ::: {.callout-note}
      <>
      :::
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
    {
      trig = "important",
    },
    fmta(
      [[<>
      ::: {.callout-important}
      <>
      :::
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
    {
      trig = "caution",
    },
    fmta(
      [[<>
      ::: {.callout-caution}
      <>
      :::
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
    {
      trig = "warning",
    },
    fmta(
      [[<>
      ::: {.callout-warning}
      <>
      :::
      ]],
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        i(1),
      }
    )
  ),
}
