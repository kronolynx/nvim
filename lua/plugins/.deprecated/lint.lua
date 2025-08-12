return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  enabled = false,
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
    },
  },
}
