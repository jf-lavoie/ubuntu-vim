local dap, dapui, persistentbreakpoints = require("dap"), require("dapui"),
                                          require("persistent-breakpoints.api")
local dappython = require('dap-python')
local wk = require 'which-key'

-- dap.set_log_level('TRACE')

require("mason-nvim-dap").setup({
  ensure_installed = {
    "delve", -- golang, delve
    "node2", -- node-debug2-adapter'
    "bash", -- bash-debug-adapter'
    "python" -- debugpy
  }
})

dapui.setup()

require('dap.ext.vscode').load_launchjs(nil, {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {"dap-repl", "lua"},
  desc = "omnifunc implementation",
  callback = function() require('dap.ext.autocompl').attach() end
})

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
vim.fn.sign_define('DapBreakpoint',
                   {text = '🟥', texthl = '', linehl = '', numhl = ''})
vim.fn.sign_define('DapStopped',
                   {text = '▶️', texthl = '', linehl = '', numhl = ''})
-- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
-- - `DapLogPoint` for log points (default: `L`)
-- - `DapBreakpointRejected` to indicate breakpoints rejected by the debug

local merge = function(target, toMerge)
  local output = {}

  for key, value in pairs(target) do output[key] = value end

  for key, value in pairs(toMerge) do output[key] = value end

  return output
end

local setBindings = function(bindings, opts)

  for _, value in pairs(bindings) do
    vim.keymap.set('n', value[1], value[2], merge(opts, {desc = value[3]}))
  end

end

local defaultFKeysMappings = {

  {'<F8>', require'dap'.continue, "Continue"}, {
    '<F9>', require('persistent-breakpoints.api').toggle_breakpoint,
    "Toggle breakpoint"
  }, {'<F10>', require'dap'.step_over, "Step over"},
  {'<S-F10>', require'dap'.run_to_cursor, "Run to cursor"},
  {'<F11>', require'dap'.step_into, "Stop into"},
  {'<S-F11>', require'dap'.step_out, "Step out"}
}

local dapMenuKey = '<leader>d'
local dapMenuAdvancedDebugKey = '<leader>dA'
local dapUIMenuKey = '<leader>du'
local dapAdadptorCommandsMenuKey = '<leader>da'
local defaultAdvancedDebugKeyMapping = {
  name = "[A]dvanced Debugging",
  b = {dap.step_back, "Step [b]ack"},
  d = {dap.down, "[d]own in current stacktrace without stepping."},
  f = {dap.restart_frame, "Restart [f]rame"},
  g = {
    function()
      local userInput = vim.fn.input(
                            "Line number (empty for line under cursor):")
      if userInput == "" then
        dap.goto_(nil)
      else
        dap.goto_(tonumber(userInput))
      end
    end, "[g]oto line # or line under cursor"
  },
  p = {function() dap.pause(vim.fn.input("Thread id: ")) end, "[p]ause thread"},
  r = {dap.reverse_continue, "[r]everse continue"},
  u = {dap.up, "[u]p in current stacktrace without stepping."}

}
local defaultDapKeyMapping = {
  name = "[d]ebugger (DAP)",
  d = {dap.clear_breakpoints, "[d]elete all breakpoints"},
  c = {
    persistentbreakpoints.set_conditional_breakpoint, '[c]onditional breakpoint'
  },
  l = {
    function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, '[l]og point breakpoint'
  },
  r = {
    dap.run_last,
    "[r]e-runs the last debug adapter / configuration that ran using"
  },
  s = {dap.status, "[s]tatus of debug session"},
  v = {dap.list_breakpoints, "[v]iew all breakpoints"},

  D = {dap.clear_breakpoints, "[D]elete breakpoint"},
  R = {dap.repl.toggle, "Toggle a [R]EPL / Debug-console"},
  T = {
    function() dap.terminate({}, {terminateDebuggee = true}, nil) end,
    "[T]erminate session+try close adaptor"
  }
}
local defaultDapUIKeyMapping = {
  name = "DAP [U]I",
  c = {
    function()
      dapui.close({})
      vim.api.nvim_command(':NeoTreeReveal')
    end, "[c]lose debugging UI"
  }
}

vim.api.nvim_create_augroup("dap-bindings", {clear = true})
vim.api.nvim_create_autocmd("FileType", {
  group = "dap-bindings",
  pattern = {"go", "gomod"},
  desc = "Apply Golang dap bindings",
  callback = function(data)

    local bufOpts = {noremap = true, silent = true, buffer = data.buf}

    setBindings(defaultFKeysMappings, bufOpts)

    local keys = {}
    keys[dapMenuKey] = defaultDapKeyMapping
    keys[dapMenuAdvancedDebugKey] = defaultAdvancedDebugKeyMapping
    keys[dapUIMenuKey] = defaultDapUIKeyMapping
    keys[dapAdadptorCommandsMenuKey] = {
      name = "DAP [a]daptor (Golang dlv)",
      t = {require('dap-go').debug_test, "Debug [t]est"},
      l = {require('dap-go').debug_last_test, "Debug [l]ast test"}
    }

    wk.register(keys, bufOpts)
  end
})
vim.api.nvim_create_autocmd("FileType", {
  group = "dap-bindings",
  pattern = {"lua"},
  desc = "Apply Lua dap bindings",
  callback = function(data)

    local bufOpts = {noremap = true, silent = true, buffer = data.buf}

    setBindings(defaultFKeysMappings, bufOpts)

    local keys = {}

    keys[dapMenuKey] = defaultDapKeyMapping
    keys[dapMenuAdvancedDebugKey] = defaultAdvancedDebugKeyMapping
    keys[dapUIMenuKey] = defaultDapUIKeyMapping
    keys[dapAdadptorCommandsMenuKey] = {
      name = "DAP [a]daptor (Lua osv)",
      l = {
        function() require"osv".launch({port = 8086, log = false}) end,
        '[l]aunch the lua dap server'
      },
      r = {
        function() require"osv".run_this({log = false}) end,
        '[r]un the lua dap server and debug current file'
      },
      s = {require"osv".stop, '[s]top the lua dap server'}
    }

    wk.register(keys, bufOpts)

  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = "dap-bindings",
  pattern = {"sh"},
  desc = "Apply Bash dap bindings",
  callback = function(data)

    local bufOpts = {noremap = true, silent = true, buffer = data.buf}

    setBindings(defaultFKeysMappings, bufOpts)

    local keys = {}

    keys[dapMenuKey] = defaultDapKeyMapping
    keys[dapMenuAdvancedDebugKey] = defaultAdvancedDebugKeyMapping
    keys[dapUIMenuKey] = defaultDapUIKeyMapping
    keys[dapAdadptorCommandsMenuKey] = {
      name = " DAP [a]daptor (bash-debug-adapter)"
      -- l = { function() dap.launch(bashdb, sh, {}) end, '[l]aunch the lua dap server' },
      -- r = { function() require "osv".run_this({ log = false }) end, '[r]un the lua dap server and debug current file' },
      -- s = { require "osv".stop, '[s]top the lua dap server' }
    }

    wk.register(keys, bufOpts)

  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = "dap-bindings",
  pattern = {"python"},
  desc = "Apply Python dap bindings",
  callback = function(data)

    local bufOpts = {noremap = true, silent = true, buffer = data.buf}

    setBindings(defaultFKeysMappings, bufOpts)

    local keys = {}

    keys[dapMenuKey] = defaultDapKeyMapping
    keys[dapMenuAdvancedDebugKey] = defaultAdvancedDebugKeyMapping
    keys[dapUIMenuKey] = defaultDapUIKeyMapping
    keys[dapAdadptorCommandsMenuKey] = {
      name = " DAP [a]daptor (debugpy)",
      c = {function() dappython.test_class({}) end, 'Test [c]lass above cursor'},
      d = {function() dappython.debug_selection({}) end, '[d]ebug selection'},
      t = {
        function() dappython.test_class({}) end, '[t]est method above cursor'
      }

      -- DebugOpts:
      -- {
      --    console = ("internalConsole"|"integratedTerminal"|"externalTerminal"|nil),
      --    test_runner = ("unittest"|"pytest"|"django"|string),
      --    config = {
      --      {django}           (boolean|nil)        Enable django templates. Default is `false`
      --      {gevent}           (boolean|nil)        Enable debugging of gevent monkey-patched code. Default is `false`
      --      {jinja}            (boolean|nil)        Enable jinja2 template debugging. Default is `false`
      --      {justMyCode}       (boolean|nil)        Debug only user-written code. Default is `true`
      --      {pathMappings}     (PathMapping[]|nil)  Map of local and remote paths.
      --      {pyramid}          (boolean|nil)        Enable debugging of pyramid applications
      --      {redirectOutput}   (boolean|nil)        Redirect output to debug console. Default is `false`
      --      {showReturnValue}  (boolean|nil)        Shows return value of function when stepping
      --      {sudo}             (boolean|nil)        Run program under elevated permissions. Default is `false`
      --    }
      -- }
    }

    wk.register(keys, bufOpts)

  end
})

require('persistent-breakpoints').setup {
  load_breakpoints_event = {"BufReadPost"},
  save_dir = vim.fn.stdpath('data') .. '/nvim_breakpoints'
}

require('dap-go').setup() -- nvim-dap-go

dappython.setup('~/.virtualenvs/debugpy/bin/python')

dap.adapters.nlua = function(callback, config)
  callback({
    type = 'server',
    host = config.host or "127.0.0.1",
    port = config.port or 8086
  })
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
    end
  }
}

dap.adapters.bashdb = {
  type = 'executable',
  command = vim.fn.stdpath("data") ..
      '/mason/packages/bash-debug-adapter/bash-debug-adapter',
  name = 'bashdb'
}
dap.configurations.sh = {
  {
    type = 'bashdb',
    request = 'launch',
    name = "Launch file",
    showDebugOutput = true,
    pathBashdb = vim.fn.stdpath("data") ..
        '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
    pathBashdbLib = vim.fn.stdpath("data") ..
        '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
    trace = true,
    file = "${file}",
    program = "${file}",
    cwd = '${workspaceFolder}',
    pathCat = "cat",
    pathBash = "/bin/bash",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    args = {},
    env = {},
    terminalKind = "integrated"
  }
}
