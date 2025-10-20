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

config.hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
        regex = "\\((\\w+://\\S+)\\)",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
        regex = "\\[(\\w+://\\S+)\\]",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
        regex = "\\{(\\w+://\\S+)\\}",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
        regex = "<(\\w+://\\S+)>",
        format = "$1",
        highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
        regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
        format = "$1",
        highlight = 1,
    },
}

return config
