local M = {}

--- Diagnostic severities.
M.diagnostics = {
  ERROR = '',
  WARN = '',
  HINT = '',
  INFO = '',
}

--- For folding.
M.arrows = {
  right = '',
  left = '',
  up = '',
  down = '',
}

--- LSP symbol kinds.
M.symbol_kinds = {
  Array = '󰅪',
  Boolean = " ",
  Class = '',
  Color = '󰏘',
  Constant = '󰏿',
  Constructor = '',
  Enum = " ",
  EnumMember = " ",
  Event = '',
  Field = '󰜢',
  File = " ",
  Folder = ' ',
  Function = '󰆧',
  Interface = '',
  Keyword = '󰌋',
  Method = '󰆧',
  Module = '',
  Namespace = " ",
  Null = " ",
  Number = " ",
  Operator = '󰆕',
  Property = '󰜢',
  Reference = '󰈇',
  Snippet = '',
  String = " ",
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '󰀫',
}

--- Shared icons that don't really fit into a category.
M.misc = {
  bug = '', -- 
  ellipsis = '…',
  git = '',
  search = '',
  vertical_bar = '│',
  circle_dot = ''
}

return M
