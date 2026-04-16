local M = {}

local discovered = nil

local function plugin_modules()
  if discovered then
    return discovered
  end

  local mods = {}
  local dir = vim.fn.stdpath("config") .. "/lua/plugins"

  for name, t in vim.fs.dir(dir) do
    if t == "file" and name:match("%.lua$") and name ~= "pack.lua" then
      local mod_name = "plugins." .. name:gsub("%.lua$", "")
      local ok, mod = pcall(require, mod_name)
      if not ok then
        error("Failed loading " .. mod_name .. ":\n" .. mod)
      end
      if type(mod) == "table" and mod.spec then
        mods[#mods + 1] = mod
      end
    end
  end

  table.sort(mods, function(a, b)
    return (a.name or a.spec) < (b.name or b.spec)
  end)

  discovered = mods
  return mods
end

local function notify_info(msg, opts)
  if _G.Snacks and Snacks.notify and Snacks.notify.info then
    Snacks.notify.info(msg, opts)
  else
    vim.notify(msg, vim.log.levels.INFO)
  end
end

local function notify_error(msg, opts)
  if _G.Snacks and Snacks.notify and Snacks.notify.error then
    Snacks.notify.error(msg, opts)
  else
    vim.notify(msg, vim.log.levels.ERROR)
  end
end

function M.add_specs()
  local specs = {}
  for _, mod in ipairs(plugin_modules()) do
    if vim.islist(mod.spec) then
      for _, spec in ipairs(mod.spec) do
        specs[#specs + 1] = spec
      end
    else
      specs[#specs + 1] = mod.spec
    end
  end
  vim.pack.add(specs)
end

function M.setup_plugins()
  for _, mod in ipairs(plugin_modules()) do
    if type(mod.setup) == "function" then
      mod.setup()
    end
  end
end

function M.setup_build_hooks()
  local build_hooks = {
    ["blink.cmp"] = { "cargo", "build", "--release" },
  }

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      local cmd = build_hooks[name]
      if cmd and (kind == "install" or kind == "update") then
        notify_info("Building " .. name .. "...", { title = "Pack Build" })
        vim.system(cmd, { cwd = ev.data.path }, function(result)
          vim.schedule(function()
            if result.code == 0 then
              notify_info(name .. " built successfully.", { title = "Pack Build" })
            else
              notify_error(name .. " build failed:\n" .. (result.stderr or ""), { title = "Pack Build" })
            end
          end)
        end)
      end

      if name == "nvim-treesitter" and (kind == "install" or kind == "update") and ev.data.active then
        vim.cmd("TSUpdate")
      end
    end,
  })
end

function M.setup_commands()
  vim.api.nvim_create_user_command("PackUpdate", function(opts)
    if opts.bang then
      notify_info("Fetching plugin updates...")
      vim.schedule(function()
        vim.pack.update()
      end)
      return
    end

    local before = {}
    for _, p in ipairs(vim.pack.get(nil, { info = false })) do
      before[p.spec.name] = p.rev
    end

    notify_info("Fetching plugin updates...")
    vim.schedule(function()
      vim.pack.update(nil, { force = true })

      vim.schedule(function()
        local after = vim.pack.get(nil, { info = false })
        local updated = {}
        local up_to_date = 0
        for _, p in ipairs(after) do
          local old_rev = before[p.spec.name]
          if old_rev and old_rev ~= p.rev then
            updated[#updated + 1] = string.format("  %s  %s -> %s", p.spec.name, old_rev:sub(1, 8), p.rev:sub(1, 8))
          else
            up_to_date = up_to_date + 1
          end
        end

        if #updated == 0 then
          notify_info("All " .. up_to_date .. " plugins up to date.", { title = "Pack Update" })
        else
          local msg = #updated .. " updated, " .. up_to_date .. " unchanged:\n\n" .. table.concat(updated, "\n")
          notify_info(msg, { title = "Pack Update", timeout = 15000 })
        end
      end)
    end)
  end, { bang = true, desc = "Update plugins (! for native vim.pack UI)" })

  vim.api.nvim_create_user_command("PackStatus", function()
    local plugins = vim.pack.get(nil, { info = false })
    local lines = {}
    for _, p in ipairs(plugins) do
      local name = p.spec.name
      local rev = p.rev:sub(1, 8)
      local version = p.spec.version
      local tag = ""
      if type(version) == "string" then
        tag = " (" .. version .. ")"
      end
      local status = p.active and "loaded" or "not loaded"
      lines[#lines + 1] = string.format("  %-28s %s  %s%s", name, rev, status, tag)
    end
    table.sort(lines)
    local header = string.format("Plugins: %d total\n", #plugins)
    notify_info(header .. table.concat(lines, "\n"), { title = "Pack Status", timeout = 10000 })
  end, { desc = "Show plugin status summary" })
end

function M.setup_daily_check()
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.defer_fn(function()
        local state_file = vim.fn.stdpath("state") .. "/pack_update_check"
        local now = os.time()
        local ok, lines = pcall(vim.fn.readfile, state_file)
        if ok and (now - (tonumber(lines[1]) or 0)) < 86400 then
          return
        end
        local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
        local cmd = "for dir in "
          .. pack_dir
          .. "/*/*; do "
          .. '[ -d "$dir/.git" ] || continue; '
          .. 'git -C "$dir" fetch --quiet 2>/dev/null; '
          .. 'count=$(git -C "$dir" rev-list --count HEAD..@{u} 2>/dev/null); '
          .. '[ "${count:-0}" -gt 0 ] && echo "$(basename "$dir"):$count"; '
          .. "done"

        vim.system({ "bash", "-c", cmd }, { text = true }, function(result)
          vim.schedule(function()
            if result.code ~= 0 then
              return
            end

            vim.fn.writefile({ tostring(now) }, state_file)

            if result.stdout == "" then
              return
            end
            local updates = {}
            for line in result.stdout:gmatch("[^\n]+") do
              local name, count = line:match("^(.+):(%d+)$")
              if name then
                updates[#updates + 1] = string.format("  %s (%s new)", name, count)
              end
            end
            if #updates > 0 then
              table.sort(updates)
              notify_info(
                #updates
                  .. " plugin(s) have updates:\n\n"
                  .. table.concat(updates, "\n")
                  .. "\n\nRun :PackUpdate to apply.",
                { title = "󰒲 Plugin Updates", timeout = 10000 }
              )
            end
          end)
        end)
      end, 5000)
    end,
  })
end

return M
