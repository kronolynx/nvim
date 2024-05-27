return {
  {
    "rebelot/heirline.nvim",
    event = "ColorScheme",
    enabled = true,
    dependencies = {
      "lewis6991/gitsigns.nvim",
      -- "nvim-lua/lsp-status.nvim"
    },
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local palette = require("catppuccin.palettes").get_palette "frappe"

      local colors = {
        bright_bg = palette.mantle,
        bright_fg = palette.text,
        red = palette.maroon,
        dark_red = palette.red,
        green = palette.green,
        blue = palette.blue,
        gray = palette.surface2,
        orange = palette.peach,
        purple = palette.mauve,
        cyan = palette.teal,
        diag_warn = palette.yellow,
        diag_error = palette.maroon,
        diag_hint = palette.sky,
        diag_info = palette.sapphire,
        git_del = palette.maroon,
        git_add = palette.teal,
        git_change = palette.yellow,
      }

      local Align = { provider = "%=" }
      local Space = { provider = " " }
      local AlignL = { provider = "%<" }
      local EndBar = {
        provider = '▊',
        hl = { fg = colors.blue },
      }

      local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
          mode_names = { -- change the strings if you like it vvvvverbose!
            n = "",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "",
            vs = "Vs",
            V = "",
            Vs = "Vs",
            ["\22"] = "^",
            ["\22s"] = "^",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "",
          },
          mode_colors = {
            n = colors.red,
            i = colors.green,
            v = colors.cyan,
            V = colors.cyan,
            ["\22"] = colors.cyan,
            c = colors.orange,
            s = colors.purple,
            S = colors.purple,
            ["\19"] = colors.purple,
            R = colors.orange,
            r = colors.orange,
            ["!"] = colors.red,
            t = colors.red,
          }
        },
        provider = function(self)
          return " " .. self.mode_names[self.mode]
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true, }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and it's children
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      -- We can now define some children separately and add them later

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
            { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end
      }

      local FileName = {
        init = function(self)
          -- see :help filename-modifiers
          self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
          if self.lfilename == "" then self.lfilename = "[No Name]" end
        end,
        hl = { fg = utils.get_highlight("Directory").fg },

        flexible = 2,

        {
          provider = function(self)
            return self.lfilename
          end,
        },
        {
          provider = function(self)
            return vim.fn.pathshorten(self.lfilename, 2)
          end,
        },
        {
          provider = function(self)
            return vim.fn.pathshorten(self.lfilename)
          end,
        },
      }

      local HelpFileName = {
        condition = function()
          return vim.bo.filetype == "help"
        end,
        provider = function()
          local filename = vim.api.nvim_buf_get_name(0)
          -- see :help filename-modifiers
          return vim.fn.fnamemodify(filename, ":t")
        end,
        hl = { fg = colors.blue },
      }

      local TerminalName = {
        -- we could add a condition to check that buftype == 'terminal'
        -- or we could do that later (see #conditional-statuslines below)
        provider = function()
          local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
          return " " .. tname
        end,
        hl = { fg = colors.blue, bold = true },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = colors.green },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = colors.orange },
        },
      }

      -- Now, let's say that we want the filename color to change if the buffer is
      -- modified. Of course, we could do that directly using the FileName.hl field,
      -- but we'll see how easy it is to alter existing components using a "modifier"
      -- component

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = colors.cyan, bold = true, force = true }
          end
        end,
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = '%<' }                      -- this means that the statusline is cut here when there's not enough space
      )

      local FileType = {
        provider = function()
          return string.upper(vim.bo.filetype)
        end,
        hl = { fg = utils.get_highlight("Type").fg, bold = true },
      }

      local FileEncoding = {
        provider = function()
          local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
          return enc ~= 'utf-8' and enc:upper()
        end
      }

      local WorkDir = {
        init = function(self)
          self.icon = " " .. " "
          self.cwd = vim.fn.getcwd(0)
        end,
        hl = { fg = colors.blue, bold = true },

        {
          -- evaluates to directory
          provider = function(self)
            -- see :help filename-modifiers
            local cwd = vim.fn.fnamemodify(self.cwd, ":t")
            return self.icon .. cwd .. " "
          end,
        },
      }

      local FileFormat = {
        provider = function()
          local fmt = vim.bo.fileformat
          return fmt ~= 'unix' and fmt:upper()
        end
      }

      -- We're getting minimalists here!
      local Ruler = {

        flexible = 1,
        {
          -- %l = current line number
          -- %L = number of lines in the buffer
          -- %c = column number
          -- %P = percentage through file of displayed window
          provider = "%7(%l/%3L%):%2c %P",
        },
        {
          provider = ""
        }
      }
      -- I take no credits for this! :lion:
      local ScrollBar = {
        static = {
          sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
          -- Another variant, because the more choice the better.
          -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
        },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = colors.blue, bg = colors.bright_bg },
      }

      local LSPActive = {
        condition = conditions.lsp_attached,
        update    = { 'LspAttach', 'LspDetach' },

        flexible  = 2,

        {
          provider = function()
            local dev_icons = require("nvim-web-devicons").get_icon_by_filetype
            local icons = {
              lua_ls = dev_icons("lua"),
              copilot = "",
              metals = dev_icons("scala"),
              pyright = dev_icons("python"),
              kotlin_language_server = dev_icons("kotlin"),
              jsonls = dev_icons("json"),
              rust_analyzer = dev_icons("rust"),
              yamlls = dev_icons("yaml"),
              bashls = dev_icons("bash"),
              marksman = dev_icons("markdown"),
            }
            local icon_or_name = {}

            for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
              table.insert(icon_or_name, icons[server.name] or server.name)
            end


            return " " .. table.concat(icon_or_name, " ") .. " "
          end,
          hl       = { fg = colors.cyan, bold = true },
        },
        {
          provider = function()
            return " "
          end,
          hl       = { fg = colors.cyan, bold = true },
        }

      }

      local LspStatus = {
        condition = conditions.lsp_attached and package.loaded['noice'] and
            require('noice').api.status.lsp_progress.has(),
        -- condition = conditions.lsp_attached,
        -- update    = { 'LspAttach', 'LspDetach' },
        provider  = function()
          return require('noice').api.status.lsp_progress.get_hl()
        end,
        hl        = { fg = colors.cyan, bold = true },

      }

      local Diagnostics = {

        condition = conditions.has_diagnostics,

        static = {
          error_icon = '',
          warn_icon = '',
          info_icon = '',
          hint_icon = '',
        },

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
          self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        update = { "DiagnosticChanged", "BufEnter" },

        {
          provider = " ",
        },
        {
          provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
          end,
          hl = { fg = colors.diag_error },
        },
        {
          provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
          end,
          hl = { fg = colors.diag_warn },
        },
        {
          provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
          end,
          hl = { fg = colors.diag_info },
        },
        {
          provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
          end,
          hl = { fg = colors.diag_hint },
        },
        {
          provider = " ",
        },
      }

      local GitBranch = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
              self.status_dict.changed ~= 0
        end,

        hl = { fg = colors.orange },
        on_click = {
          callback = function()
            vim.defer_fn(function()
              vim.cmd("FzfLua git_branches")
            end, 100)
          end,
          name = "heirline_git",
        },

        flexible = 1,
        { -- git branch name
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { bold = true }
        },
        {
          -- evaluates to "", hiding the component
          provider = "",
        }
      }

      local GitChanges = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
              self.status_dict.changed ~= 0
        end,

        hl = { fg = colors.orange },


        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = " "
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and (' ' .. count)
          end,
          hl = { fg = colors.git_add },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and (' ' .. count)
          end,
          hl = { fg = colors.git_del },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and (' ' .. count)
          end,
          hl = { fg = colors.git_change },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "",
        },
      }

      local DAPMessages = {
        condition = function()
          local session = require("dap").session()
          return session ~= nil
        end,
        provider = function()
          return " " .. require("dap").status()
        end,
        hl = "Debug"
        -- see Click-it! section for clickable actions
      }

      local MacroRec = {
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = " " .. " ",
        hl = { fg = colors.orange, bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function()
            return vim.fn.reg_recording()
          end,
          hl = { fg = colors.green, bold = true },
        }),
        update = {
          "RecordingEnter",
          "RecordingLeave",
        }
      }

      ViMode = utils.surround({ "", "" }, colors.bright_bg, { ViMode, MacroRec })

      local DefaultStatusline = {
        EndBar, ViMode, WorkDir, FileNameBlock,
        AlignL,
        Space, Diagnostics, Align,
        DAPMessages, Align,
        LspStatus, LSPActive, Space, GitBranch, GitChanges, FileFormat,
        { flexible = 3, { FileEncoding, Space }, { provider = "" } },
        Space, Ruler, Space, ScrollBar, Space, EndBar
      }

      local InactiveStatusline = {
        condition = conditions.is_not_active,
        FileNameBlock,
        Space,
        Align,
        GitBranch
      }

      local SpecialStatusline = {
        condition = function()
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive" },
          })
        end,

        FileType,
        Space,
        HelpFileName,
        Align
      }

      local TerminalStatusline = {

        condition = function()
          return conditions.buffer_matches({ buftype = { "terminal" } })
        end,

        hl = { bg = colors.bright_bg },

        -- Quickly add a condition to the ViMode to only show it when buffer is active!
        { condition = conditions.is_active, ViMode, Space },
        FileType,
        Space,
        TerminalName,
        Align,
      }

      local StatusLines = {

        hl = function()
          if conditions.is_active() then
            return "StatusLine"
          else
            return "StatusLineNC"
          end
        end,

        -- the first statusline with no condition, or which condition returns true is used.
        -- think of it as a switch case with breaks to stop fallthrough.
        fallthrough = false,

        SpecialStatusline,
        TerminalStatusline,
        InactiveStatusline,
        DefaultStatusline,
      }

      require("heirline").setup({
        colors = colors,
        statusline = StatusLines
      })
      -- Update the statusline with the latest LSP message.
      vim.api.nvim_create_autocmd('LspProgress', {
        pattern = '*',
        command = 'redrawstatus',
      })
    end
  },
}
