return {
  {
    "quentingruber/pomodoro.nvim",
    lazy = false, -- needed so the pomodoro can start at launch
    opts = {
      start_at_launch = false,
      work_duration = 25,
      break_duration = 5,
      delay_duration = 1, -- The additional work time you get when you delay a break
      long_break_duration = 15,
      breaks_before_long = 4,
      display_ui_on_break = true, -- Disable it if you only want to see the lualine
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 3, {
        function()
          return require("pomodoro").get_pomodoro_status("🍅❌", "🍅", "☕")
        end,
      })
    end,
  },
}
