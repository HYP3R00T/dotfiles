-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Theme
config.color_scheme = 'Catppuccin Mocha'

config.font_size = 12
config.font = wezterm.font 'Fira Mono'

return config
