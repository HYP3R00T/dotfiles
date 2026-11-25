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

require("hypr.dynamic-workspaces")

hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.rebind("SUPER + DOWN", "Next workspace", o.step_dynamic_workspace(1, false))
o.rebind("SUPER + UP", "Previous workspace", o.step_dynamic_workspace(-1, false))
o.rebind("SUPER + SHIFT + DOWN", "Move window to next workspace", o.step_dynamic_workspace(1, true))
o.rebind("SUPER + SHIFT + UP", "Move window to previous workspace", o.step_dynamic_workspace(-1, true))

-- Open the searchable app list when Super is released on its own.
o.bind("SUPER + Super_L", "Search apps", "omarchy-shell omarchy.dock apps", { release = true })
o.bind("SUPER + Super_R", "Search apps", "omarchy-shell omarchy.dock apps", { release = true })

-- Open or focus Herdr Desktop with the main terminal shortcut.
o.rebind("SUPER + RETURN", "Herdr Desktop", { launch = "herdr-app", focus = "herdr-app" })
o.window("^herdr-app$", { border_size = 0 })
