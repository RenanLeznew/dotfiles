return {
  {
    "ptdewey/pendulum-nvim",
    config = function()
      require("pendulum").setup({
        log_file = vim.env.HOME .. "/pendulum-log.csv",
        timeout_len = 180,
        timer_len = 120,
        top_n = 5,
        gen_reports = true,
        time_zone = "America/Sao_Paulo",
        hours_n = 5,
        time_format = "24h",
        report_section_excludes = {
          "branch", -- Hide `branch` section of the report
        },
      })
    end,
  },
}
