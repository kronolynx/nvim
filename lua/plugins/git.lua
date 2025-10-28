vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { confirm = false })

vim.defer_fn(function()
  require("gitsigns").setup({
    preview_config = {
      border = 'rounded',
      style = "minimal",
      relative = "cursor",
      row = 1,
      col = 0,
    },
    current_line_blame = false,

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      -- Register the leader group with miniclue.
      vim.b[bufnr].miniclue_config = {
        clues = {
          { mode = 'n', keys = '<leader>m',  desc = '+git' },
          { mode = 'x', keys = '<leader>m',  desc = '+git' },
          { mode = 'n', keys = '<leader>mh', desc = '+hunk' },
          { mode = 'x', keys = '<leader>mh', desc = '+hunk' },
          { mode = 'n', keys = '<leader>mb', desc = '+buffer' },
          { mode = 'x', keys = '<leader>mb', desc = '+buffer' },
        },
      }

      -- Mappings.
      ---@param lhs string
      ---@param rhs function
      ---@param desc string
      local function nmap(lhs, rhs, desc)
        vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = bufnr })
      end
      nmap('[g', gs.prev_hunk, 'Previous hunk')
      nmap(']g', gs.next_hunk, 'Next hunk')
      nmap('<leader>mhp', gs.prev_hunk, 'Previous hunk')
      nmap('<leader>mhn', gs.next_hunk, 'Next hunk')
      nmap('<leader>gR', gs.reset_buffer, 'Reset buffer')
      nmap('<leader>mv', gs.blame_line, 'Blame line')
      nmap('<leader>mp', gs.preview_hunk, 'Preview hunk')
      nmap('<leader>mhR', gs.reset_hunk, 'Reset hunk')
      nmap('<leader>mhs', gs.stage_hunk, 'Stage hunk')
      nmap('<leader>mbs', gs.stage_buffer, 'Stage buffer')
      nmap('<leader>mbR', gs.reset_buffer, 'Reset buffer')
      nmap('<leader>mz', function()
        require('core.float_term').float_term('lazygit', {
          size = { width = 0.85, height = 0.9 },
          cwd = vim.b.gitsigns_status_dict.root,
        })
      end, 'Lazygit')
    end
  })
end, 200)
