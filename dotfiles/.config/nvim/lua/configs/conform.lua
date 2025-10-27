local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "biome" },
    html = { "prettierd" },
    javascript = { "biome" },
    typescriptreact = { "biome" },
    javascriptreact = { "biome" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    jsx = { "biome" },
    tsx = { "biome" },
    markdown = { "prettierd" },
    go = { "goimports", "gofmt" },
    yaml = { "prettierd" },
    qml = { "qmlformat" },
    nix = { "nixfmt" },
  },
  formatters = {
    stylua = {
      command = vim.fn.stdpath "data" .. "/mason/bin/stylua",
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
    prettier = {
      prepend_args = {
        "--tab-width=2",
        "--use-tabs=false",
      },
    },
    prettierd = {
      prepend_args = {
        "--tab-width=2",
        "--use-tabs=false",
      },
    },
    isort = {
      prepend_args = { "--line-length", "88", "--profile", "black" },
    },
    black = {
      prepend_args = { "--line-length", "88" },
    },
    htmlbeautifier = {
      prepend_args = { "--indent-size", "2" },
    },
    biome = {
      prepend_args = {
        "format",
        "--indent-style",
        "space",
        "--indent-width",
        "2",
      },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
return options
