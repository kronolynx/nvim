return {
  "sontungexpt/url-open",
  lazy = true,
  cmd = "URLOpenUnderCursor",
  keys = {
    { "<leader>gx", "<cmd>URLOpenUnderCursor<CR>", desc = "Open URL" }
  },
  config = function()
    local status_ok, url_open = pcall(require, "url-open")
    if not status_ok then
      return
    end
    url_open.setup({})
  end,
}
