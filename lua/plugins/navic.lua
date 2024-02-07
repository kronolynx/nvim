return {
  "SmiteshP/nvim-navic",
  requires = "neovim/nvim-lspconfig",
  config = function()
    require("nvim-navic").setup({
      -- icons = require("lspkind").symbol_map,
      separator = "",
    })
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not vim.tbl_contains({ "copilot", "null-ls", "ltex" }, client.name) then
          require("nvim-navic").attach(client, bufnr)
        end
      end,
    })
  end,
}
