-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- Cycle through occupied workspaces and one trailing empty slot on this monitor.
function o.step_numbered_workspace(offset, move_window)
  local function step()
    local monitor = hl.get_active_monitor()
    local workspace = monitor and monitor.active_workspace
    if not workspace or workspace.special then
      return
    end

    local first = o.workspaces.workspace_id(monitor, 1)
    local last = first + o.workspaces.slots - 1
    if move_window then
      local target = workspace.id + offset
      if target >= first and target <= last then
        o.workspaces.move_window(target - first + 1)()
      end
      return
    end

    local occupied = {}
    local highest = first - 1
    for _, candidate in ipairs(hl.get_workspaces()) do
      local id = candidate.id
      if not candidate.special and id >= first and id <= last and candidate.windows > 0 then
        occupied[id] = true
        highest = math.max(highest, id)
      end
    end

    local trailing = math.min(highest + 1, last)
    local cycle = {}
    for id = first, trailing do
      if occupied[id] or id == trailing then
        cycle[#cycle + 1] = id
      end
    end

    local target = offset > 0 and cycle[1] or cycle[#cycle]
    for index = 1, #cycle do
      local id = cycle[offset > 0 and index or #cycle - index + 1]
      if (id - workspace.id) * offset > 0 then
        target = id
        break
      end
    end

    if target ~= workspace.id then
      o.workspaces.focus(target - first + 1)()
    end
  end

  o.bind_expressions[step] = string.format("o.step_numbered_workspace(%d, %s)", offset, tostring(move_window))
  return step
end

hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.rebind("SUPER + DOWN", "Next workspace", o.step_numbered_workspace(1, false))
o.rebind("SUPER + UP", "Previous workspace", o.step_numbered_workspace(-1, false))
o.rebind("SUPER + SHIFT + DOWN", "Move window to next workspace", o.step_numbered_workspace(1, true))
o.rebind("SUPER + SHIFT + UP", "Move window to previous workspace", o.step_numbered_workspace(-1, true))

-- Open the searchable app list when Super is released on its own.
o.bind("SUPER + Super_L", "Search apps", "omarchy-shell omarchy.dock apps", { release = true })
o.bind("SUPER + Super_R", "Search apps", "omarchy-shell omarchy.dock apps", { release = true })
