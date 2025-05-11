local wezterm = require 'wezterm';
local mux = wezterm.mux
local Config = {}

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})

    -- Tab 1: WSL AlmaLinux - Project Directory
    local tab1 = window:spawn_tab({
        domain = { DomainName = 'WSL:AlmaLinux-8' }
    })
    tab1:set_title('WSL')

    -- Tab 2: Git Bash - Project Directory
    local tab2 = window:spawn_tab({
        domain = { DomainName = 'local' }
    })
    tab2:set_title('Project')

end)

return Config