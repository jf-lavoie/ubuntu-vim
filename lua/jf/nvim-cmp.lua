-- print('loading nvim-cmp.lua')
-- vim.o.completeopt="menu,menuone,noselect"
-- vim.o.completeopt = "menu,menuone,noselect"
vim.o.completeopt = "menu,menuone,noinsert"
-- vim.o.completeopt = "menuone,noinsert"
local cmp = require "cmp"

cmp.setup({

  completion = {
    -- from: https://github.com/hrsh7th/nvim-cmp/issues/209#issuecomment-921635222
    -- completeopt = 'menu,menuone,noinsert'
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      -- require("snippy").expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- defaults
    -- from: https://github.com/hrsh7th/nvim-cmp/blob/8523568448d0be7cfda4fedd3041849120c9c6c9/lua/cmp/config/mapping.lua#L37
    -- ['<Down>'] = { i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }), },
    -- ['<Up>'] = { i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }), },
    -- ['<C-n>'] = { i = mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }), },
    -- ['<C-p>'] = { i = mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }), },
    -- ['<C-y>'] = { i = mapping.confirm({ select = false }), },
    -- ['<C-e>'] = { i = mapping.abort(), },

    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" }, { name = 'nvim_lsp_signature_help' },
    -- { name = "vsnip" }, -- For vsnip users.
    -- { name = "luasnip" }, -- For luasnip users.
    { name = "ultisnips" } -- For ultisnips users.
    -- { name = "snippy" }, -- For snippy users.
  }, { { name = "buffer" } }, { { name = 'path' } })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" } -- You can specify the `cmp_git` source if you were installed it.
  }, { { name = "buffer" } })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
})
