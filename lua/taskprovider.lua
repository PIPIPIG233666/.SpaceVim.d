local task = require('spacevim.plugin.tasks')
local log = require('spacevim.logger').derive('taskprovider')

local function make_tasks()
  if vim.fn.filereadable('Makefile') then
    local subcmds = {}
    local conf = {}
    for _, v in ipairs(vim.fn.readfile('Makefile', '')) do
      if vim.startwith(v, '.PHONY') then
        table.insert(subcmds, v)
      end
    end
    for _, subcmd in ipairs(subcmds) do
      local commands = vim.fn.split(subcmd) -- Fixed variable name
      table.remove(commands, 1)
      for _, cmd in ipairs(commands) do
        conf = vim.tbl_extend('forces', conf, { -- 'forces' corrected to 'force'
          [cmd] = {
            command = 'make',
            args = {cmd},
            isDetected = true,
            detectedName = 'make:'
          }
        })
      end
    end
    return conf
  else
    return {}
  end
  log.info('this is debug message')
end

task.reg_provider(make_tasks)
