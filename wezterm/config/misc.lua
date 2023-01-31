-- Local Variables
local wezterm = require("wezterm")
local leader_key = { key="j", mods="CTRL" }
local userDirectory = require("../utils/directories").directories.getUser()

-- Update Status when Leader or Key Table is Active 
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
    window:set_right_status(name or "")
  else
    local leaderIsActive = ""
    if window:leader_is_active() then
      leaderIsActive = "LEADER ON"
    end
    window:set_right_status(leaderIsActive)
  end
end);

-- Toast Notification on config reload - WIP
wezterm.on("window-config-reloaded", function(window, pane)
  window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

return {
    term = "xterm-256color",
    default_prog = {userDirectory .. "scoop/shims/pwsh.exe"},
    check_for_updates = true,
    hide_tab_bar_if_only_one_tab = true,
    enable_scroll_bar = true,
    use_fancy_tab_bar = false,
    tab_and_split_indices_are_zero_based = false,
    color_scheme = "OneHalfDark",
    window_close_confirmation = "NeverPrompt",
    default_cursor_style = "BlinkingBar",
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
    leader = leader_key,
    tab_max_width = 16,
    cursor_blink_rate = 800,
    scrollback_lines = 5000,
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    font_size = 10.0,
    window_padding = {
      left = 1,
      right = 1,
      top = 0,
      bottom = 0,
    },
    window_background_image = userDirectory .. ".config/wezterm/wallpaper.jpg",
    window_background_image_hsb = {
      brightness = 0.2,
      hue = 1.0,
      saturation = 1.0,
    },
    font = wezterm.font("IBM Plex Mono"),
    set_environment_variables = {},
}
