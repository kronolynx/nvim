return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",
  enabled = false,

-- 2024-07-10T00:24:22  ERROR There is no parser available for buffer 1 and one could not be created because lang could not be deter
-- 2024-07-10T00:24:22  ERROR UfoFallbackException
-- 2024-07-10T00:24:22  ERROR ...share/nvim/lazy/nvim-ufo/lua/ufo/provider/treesitter.lua:136: attempt to index local 'parser' (a ni
-- 2024-07-10T00:25:40  ERROR UfoFallbackException
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function()
    -- Fold options
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    vim.o.foldcolumn = "0" -- '0' remove fold column at the right
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.foldnestmax = 10

    -- Hide fold columnn for some file types (still have them enable)
    local folding_group = vim.api.nvim_create_augroup("folding_group", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Hide foldcolumn for some file types",
      pattern = { "Outline", "toggleterm", "neotest-summary" },
      group = folding_group,
      callback = function()
        vim.opt_local.foldcolumn = "0"
      end,
    })

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (' 󰁂 %d '):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end

    -- treesitter as a main provider instead
    -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = handler
    })
  end,
}
