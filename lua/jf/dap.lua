local dap, dapui, persistentbreakpoints = require("dap"), require("dapui"), require("persistent-breakpoints.api")

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

vim.keymap.set('n', '<F8>', require 'dap'.continue)
-- vim.keymap.set('n', '<F9>', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<F9>', require('persistent-breakpoints.api').toggle_breakpoint)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)


wk.register({

  ['<leader>d'] = {
    name = "DAP (Debugging)", -- optional group name
    c = { dap.run_to_cursor, "Continues execution to the current cursor." },
    t = { dap.toggle_breakpoint, "Toggle breakpoint" },
    D = { dap.clear_breakpoints, "Toggle breakpoint" },
    L = { function()
        dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
      end, 'Log point breakpoint'
    },
    B = { persistentbreakpoints.set_conditional_breakpoint, 'Conditional breakpoint'
    },
    r = {dap.repl.toggle, "Toggle a REPL / Debug-console"},
    l = {dap.run_last, "Re-runs the last debug adapter / configuration that ran using"}

  },


  ['<leader>du'] = {
    name = "UI",
    c = { function()
      dapui.close({})
      vim.api.nvim_command(':NeoTreeReveal')

    end, "Close debugging UI" }
  }

}, { noremap = true, silent = true })

require('persistent-breakpoints').setup{
	load_breakpoints_event = { "BufReadPost" },
  save_dir = vim.fn.stdpath('data') .. '/nvim_breakpoints',
}

require('dap-go').setup() -- nvim-dap-go


