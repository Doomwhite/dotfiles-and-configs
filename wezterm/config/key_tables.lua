local wezterm = require("wezterm")
local waction = wezterm.action

return {
    tables_pane = {
      { key = "t",               action=waction{ActivateKeyTable={name="activate_tab",one_shot=false,replace_current=false}}},

      { key = "r",               action=waction{ActivateKeyTable={name="resize_pane",one_shot=false,replace_current=false}}},
      { key = "v",               action=waction{ActivateKeyTable={name="activate_pane",one_shot=false,replace_current=false}}},
      { key = "j",               action=waction{ActivateKeyTable={name="movement_keys",one_shot=false,replace_current=false}}},

      { key = "Escape",          action="PopKeyTable"}
    },
    resize_pane = {
      { key = "LeftArrow",       action=waction{AdjustPaneSize={"Left", 1}}},
      { key = "h",               action=waction{AdjustPaneSize={"Left", 1}}},
      { key = "h", mods="SHIFT", action=waction{AdjustPaneSize={"Left", 10}}},

      { key = "RightArrow",      action=waction{AdjustPaneSize={"Right", 1}}},
      { key = "l",               action=waction{AdjustPaneSize={"Right", 1}}},
      { key = "l", mods="SHIFT", action=waction{AdjustPaneSize={"Right", 10}}},

      { key = "UpArrow",         action=waction{AdjustPaneSize={"Up", 1}}},
      { key = "k",               action=waction{AdjustPaneSize={"Up", 1}}},
      { key = "k", mods="SHIFT", action=waction{AdjustPaneSize={"Up", 10}}},

      { key = "DownArrow",       action=waction{AdjustPaneSize={"Down", 1}}},
      { key = "j",               action=waction{AdjustPaneSize={"Down", 1}}},
      { key = "j", mods="SHIFT", action=waction{AdjustPaneSize={"Down", 10}}},

      { key = "Escape",          action="PopKeyTable"},
    },
    activate_tab = {
      { key = "1",               action=wezterm.action{ActivateTab=0}},
      { key = "2",               action=wezterm.action{ActivateTab=1}},
      { key = "3",               action=wezterm.action{ActivateTab=2}},
      { key = "4",               action=wezterm.action{ActivateTab=3}},
      { key = "5",               action=wezterm.action{ActivateTab=4}},
      { key = "6",               action=wezterm.action{ActivateTab=5}},
      { key = "7",               action=wezterm.action{ActivateTab=6}},
      { key = "8",               action=wezterm.action{ActivateTab=7}},
      { key = "9",               action=wezterm.action{ActivateTab=8}},

      { key = "LeftArrow",       action=waction{ActivateTabRelative=1}},
      { key = "l",               action=waction{ActivateTabRelative=1}},

      { key = "h",               action=waction{ActivateTabRelative=-1}},
      { key = "RightArrow",      action=waction{ActivateTabRelative=-1}},

      { key = "j",               action="PopKeyTable"},
      { key = "Escape",          action="PopKeyTable"},
    },
    activate_pane = {
      { key = "LeftArrow",       action=waction{ActivatePaneDirection="Left"}},
      { key = "h",               action=waction{ActivatePaneDirection="Left"}},

      { key = "RightArrow",      action=waction{ActivatePaneDirection="Right"}},
      { key = "l",               action=waction{ActivatePaneDirection="Right"}},

      { key = "UpArrow",         action=waction{ActivatePaneDirection="Up"}},
      { key = "k",               action=waction{ActivatePaneDirection="Up"}},

      { key = "DownArrow",       action=waction{ActivatePaneDirection="Down"}},
      { key = "j",               action=waction{ActivatePaneDirection="Down"}},

      { key = "Escape",          action="PopKeyTable"},
    },
    movement_keys = {
      { key = "u",               action=waction{ScrollByLine=-15}},
      { key = "d",               action=waction{ScrollByLine=15}},

      { key = "k",               action=waction{ScrollByLine=-1}},
      { key = "j",               action=waction{ScrollByLine=1}},

      { key = "g",               action="ScrollToTop"},
      { key = "g", mods="SHIFT",  action="ScrollToBottom"},

      { key = "Escape",          action="PopKeyTable"},
    },
  }
