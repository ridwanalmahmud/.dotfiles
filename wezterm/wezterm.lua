local wezterm = require("wezterm")
local config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    enable_tab_bar = false,
    color_scheme = "Gruvbox Dark",

    window_close_confirmation = "NeverPrompt",
    window_decorations = "NONE",
    window_background_opacity = 0.8,
    window_padding = {
        left = 2,
        right = 2,
        top = 0,
        bottom = 0,
    },

    font = wezterm.font({
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
    }),
    font_size = 18,
}

return config
