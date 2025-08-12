return {
  'tigion/nvim-asciidoc-preview',
  enabled = false,
  cmd = { 'AsciiDocPreview' },
  ft = { 'asciidoc' },
  build = 'cd server && npm install',
  opts = {},
}
