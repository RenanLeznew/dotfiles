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
    { trig = "python" },
    fmta(
      [[
      ---
      title: "<>"
      author: "Renan Wenzel"
      date: "<>"
      format:
        html:
          code-fold: true
          toc: true 
      jupyter: python3
      ---
      <>
      ]],
      {
        i(1, "Título"),
        i(2, "Data"),
        i(0),
      }
    )
  ),
  s(
    { trig = "rqmd" },
    fmta(
      [[
      ---
      title: "<>"
      author: "Renan Wenzel"
      date: "<>"
      format:
        html:
          toc: true
          df-print: paged
          code-fold: true
      ---
      <>
      ]],
      {
        i(1, "Título"),
        i(2, "Data"),
        i(0),
      }
    )
  ),
  s(
    { trig = "gen" },
    fmta(
      [[
      ---
      title: "<>"
      author: "Renan Wenzel"
      date: "<>"
      format:
        html:
          toc: true 
          code-fold: true
      ---
      <>
      ]],
      {
        i(1, "Título"),
        i(2, "Data"),
        i(0),
      }
    )
  ),
}
