local M = {}

function M.setup_build_hooks()
  local build_hooks = {
    ["blink.cmp"] = { "cargo", "build", "--release" },
  }

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      local cmd = build_hooks[name]
      if cmd and (kind == "install" or kind == "update") then
        Snacks.notify.info("Building " .. name .. "...", { title = "Pack Build" })
        vim.system(cmd, { cwd = ev.data.path }, function(result)
          vim.schedule(function()
            if result.code == 0 then
              Snacks.notify.info(name .. " built successfully.", { title = "Pack Build" })
            else
              Snacks.notify.error(name .. " build failed:\n" .. (result.stderr or ""), { title = "Pack Build" })
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
      Snacks.notify.info("Fetching plugin updates...")
      vim.schedule(function()
        vim.pack.update()
      end)
      return
    end

    local before = {}
    for _, p in ipairs(vim.pack.get(nil, { info = false })) do
      before[p.spec.name] = p.rev
    end

    Snacks.notify.info("Fetching plugin updates...")
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
          Snacks.notify.info("All " .. up_to_date .. " plugins up to date.", { title = "Pack Update" })
        else
          local msg = #updated .. " updated, " .. up_to_date .. " unchanged:\n\n" .. table.concat(updated, "\n")
          Snacks.notify.info(msg, { title = "Pack Update", timeout = 15000 })
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
    Snacks.notify.info(header .. table.concat(lines, "\n"), { title = "Pack Status", timeout = 10000 })
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
        vim.fn.writefile({ tostring(now) }, state_file)

        local pack_dir = vim.fn.stdpath("data") .. "/site/pack"
        local cmd = 'for dir in ' .. pack_dir .. '/*/*; do '
          .. '[ -d "$dir/.git" ] || continue; '
          .. 'git -C "$dir" fetch --quiet 2>/dev/null; '
          .. 'count=$(git -C "$dir" rev-list --count HEAD..@{u} 2>/dev/null); '
          .. '[ "${count:-0}" -gt 0 ] && echo "$(basename "$dir"):$count"; '
          .. 'done'

        vim.system({ "bash", "-c", cmd }, { text = true }, function(result)
          vim.schedule(function()
            if result.code ~= 0 or result.stdout == "" then
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
              Snacks.notify.info(
                #updates .. " plugin(s) have updates:\n\n" .. table.concat(updates, "\n")
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
