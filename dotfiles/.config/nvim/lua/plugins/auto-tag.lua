return {
  "windwp/nvim-ts-autotag",
  event = { "BufReadPre", "BufNewFile" }, -- Recommended events for lazy loading
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure treesitter is loaded
  config = function()
    require("nvim-ts-autotag").setup {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
      },
      -- Override individual filetype configs, if needed
      per_filetype = {
        -- Example: Customize for specific filetypes
        -- ["html"] = { enable_close = true },
        -- ["javascript"] = { enable_close = true },
        -- ["typescript"] = { enable_close = true },
        -- ["jsx"] = { enable_close = true },
        -- ["tsx"] = { enable_close = true },
        -- ["markdown"] = { enable_close = true },
      },
    }
  end,
}
