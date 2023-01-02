local dap, dapui, persistentbreakpoints = require("dap"), require("dapui"), require("persistent-breakpoints.api")

dap.set_log_level('TRACE')

require("mason-nvim-dap").setup({
  ensure_installed = {
    "delve", -- golang, delve
    "node2", -- node-debug2-adapter'
    "bash", -- bash-debug-adapter'
    "debugpy", -- debugpy
  }
})

dap.adapters.bashdb = {
  type = 'executable';
  command = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/bash-debug-adapter';
  name = 'bashdb';
}
dap.configurations.sh = {
  {
    type = 'bashdb';
    request = 'launch';
    name = "Launch file";
    showDebugOutput = true;
    pathBashdb = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb';
    pathBashdbLib = vim.fn.stdpath("data") .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir';
    trace = true;
    file = "${file}";
    program = "${file}";
    cwd = '${workspaceFolder}';
    pathCat = "cat";
    pathBash = "/bin/bash";
    pathMkfifo = "mkfifo";
    pathPkill = "pkill";
    args = {};
    env = {};
    terminalKind = "integrated";
  }
}


dapui.setup()

require('dap.ext.vscode').load_launchjs(nil, {})


dap.listeners.after.event_initialized["dapui_config"] = function()
  vim.api.nvim_command(':NeoTreeClose')
  dapui.open({})
end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close({})
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close({})
-- end

-- taken from : https://miguelcrespo.co/how-to-debug-like-a-pro-using-neovim
vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })


local wk = require 'which-key'

-- vim.keymap.set('n', '<F8>', require 'dap'.continue)
-- vim.keymap.set('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint)
-- vim.keymap.set('n', '<F10>', require 'dap'.step_over)
-- vim.keymap.set('n', '<F11>', require 'dap'.step_into)
-- vim.keymap.set('n', '<F12>', require 'dap'.step_out)

local merge = function(target, toMerge)
  local output = {}

  for key, value in pairs(target) do
    output[key] = value
  end

  for key, value in pairs(toMerge) do
    output[key] = value
  end

  return output
end

local defaultKeyMappings = {

  ['<leader>d'] = {
    name = "DAP (Debugging)", -- optional group name
    c = { dap.run_to_cursor, "Continues execution to the current cursor." },
    t = { dap.toggle_breakpoint, "Toggle breakpoint" },
    D = { dap.clear_breakpoints, "Clear breakpoint" },
    L = { function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, 'Log point breakpoint'
    },
    B = { persistentbreakpoints.set_conditional_breakpoint, 'Conditional breakpoint'
    },
    r = { dap.repl.toggle, "Toggle a REPL / Debug-console" },
    l = { dap.run_last, "Re-runs the last debug adapter / configuration that ran using" }

  },


  ['<leader>du'] = {
    name = "UI",
    c = { function()
      dapui.close({})
      vim.api.nvim_command(':NeoTreeReveal')

    end, "Close debugging UI" }
  }

}



vim.api.nvim_create_augroup("dap-bindings", { clear = true })
vim.api.nvim_create_autocmd("FileType",
  {
    group = "dap-bindings",
    pattern = { "go", "gomod" },
    desc = "Apply Golang dap bindings",
    callback = function(data)

      local bufOpts = { noremap = true, silent = true, buffer = data.buf }


      vim.keymap.set('n', '<F8>', require 'dap'.continue, bufOpts)
      vim.keymap.set('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint, bufOpts)
      vim.keymap.set('n', '<F10>', require 'dap'.step_over, bufOpts)
      vim.keymap.set('n', '<F11>', require 'dap'.step_into, bufOpts)
      vim.keymap.set('n', '<F12>', require 'dap'.step_out, bufOpts)

      wk.register(defaultKeyMappings, bufOpts)

    end
  }
)
vim.api.nvim_create_autocmd("FileType",
  {
    group = "dap-bindings",
    pattern = { "lua" },
    desc = "Apply Lua dap bindings",
    callback = function(data)

      local bufOpts = { noremap = true, silent = true, buffer = data.buf }
      vim.keymap.set('n', '<F8>', function()
        print("jf-debug: continue");
        -- if dap.session() == nil then
        --   -- require "osv".launch({ port = 8086 })
        --   require "osv".run_this()
        -- else
        dap.continue()
        -- end
      end,
        bufOpts)
      vim.keymap.set('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint, bufOpts)
      vim.keymap.set('n', '<F10>', require 'dap'.step_over, bufOpts)
      vim.keymap.set('n', '<F11>', function()
        print("jf-debug: step_into!");
        require 'dap'.step_into()
      end, bufOpts)
      vim.keymap.set('n', '<F12>', require 'dap'.step_out, bufOpts)

      -- vim.api.nvim_set_keymap('n', '<F8>', [[:lua require"dap".toggle_breakpoint()<CR>]], { noremap = true })
      -- vim.api.nvim_set_keymap('n', '<F9>', [[:lua require"dap".continue()<CR>]], { noremap = true })
      -- vim.api.nvim_set_keymap('n', '<F10>', [[:lua require"dap".step_over()<CR>]], { noremap = true })
      -- vim.api.nvim_set_keymap('n', '<S-F10>', [[:lua require"dap".step_into()<CR>]], { noremap = true })
      -- vim.api.nvim_set_keymap('n', '<F12>', [[:lua require"dap.ui.widgets".hover()<CR>]], { noremap = true })
      -- vim.api.nvim_set_keymap('n', '<F5>', [[:lua require"osv".launch({port = 8086})<CR>]], { noremap = true })

      wk.register({

        ['<leader>d'] = {
          name = "DAP (Debugging)", -- optional group name
          c = { dap.run_to_cursor, "Continues execution to the current cursor." },
          t = { dap.toggle_breakpoint, "Toggle breakpoint" },
          D = { dap.clear_breakpoints, "Clear breakpoint" },
          L = { function()
            dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
          end, 'Log point breakpoint'
          },
          B = { persistentbreakpoints.set_conditional_breakpoint, 'Conditional breakpoint'
          },
          r = { dap.repl.toggle, "Toggle a REPL / Debug-console" },
          l = { dap.run_last, "Re-runs the last debug adapter / configuration that ran using" },
          s = { function() require "osv".launch({ port = 8086, log = true }) end, 'Launch the dap server' }

        },


        ['<leader>du'] = {
          name = "UI",
          c = { function()
            dapui.close({})
            vim.api.nvim_command(':NeoTreeReveal')

          end, "Close debugging UI" }
        }

      }, bufOpts)

    end
  }
)

-- wk.register({

--   ['<leader>d'] = {
--     name = "DAP (Debugging)", -- optional group name
--     c = { dap.run_to_cursor, "Continues execution to the current cursor." },
--     t = { dap.toggle_breakpoint, "Toggle breakpoint" },
--     D = { dap.clear_breakpoints, "Clear breakpoint" },
--     L = { function()
--       dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
--     end, 'Log point breakpoint'
--     },
--     B = { persistentbreakpoints.set_conditional_breakpoint, 'Conditional breakpoint'
--     },
--     r = { dap.repl.toggle, "Toggle a REPL / Debug-console" },
--     l = { dap.run_last, "Re-runs the last debug adapter / configuration that ran using" }

--   },


--   ['<leader>du'] = {
--     name = "UI",
--     c = { function()
--       dapui.close({})
--       vim.api.nvim_command(':NeoTreeReveal')

--     end, "Close debugging UI" }
--   }

-- }, { noremap = true, silent = true })

require('persistent-breakpoints').setup {
  load_breakpoints_event = { "BufReadPost" },
  save_dir = vim.fn.stdpath('data') .. '/nvim_breakpoints',
}

require('dap-go').setup() -- nvim-dap-go


dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      -- local value = vim.fn.input('Host [127.0.0.1]: ')
      -- if value ~= "" then
      --   return value
      -- end
      return '127.0.0.1'
    end,
    port = function()
      -- local val = tonumber(vim.fn.input('Port: '))
      -- assert(val, "Please provide a port number")
      -- return val
      return 8086
    end,
  }
}
