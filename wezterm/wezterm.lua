local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font({
    family = "Monaspace Radon",
    weight = "SemiBold",
    harfbuzz_features = {
        "calt",
        "liga",
        "ss01",
        "ss02",
        "ss03",
        "ss04",
        "ss05",
        "ss06",
        "ss07",
        "ss08",
        "ss09",
    },
})
config.font_size = 18

config.window_decorations = "NONE"
config.window_background_opacity = 0.8

config.color_scheme = "Gruvbox Dark"

return config
