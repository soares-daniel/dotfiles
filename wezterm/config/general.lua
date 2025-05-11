local Icons = require "utils.class.icon"
local fs = require("utils.fn").fs

local Config = {}

local GIT_PATH = "C:\\Users\\d.a.soares\\AppData\\Local\\Programs\\Git\\bin\\bash.exe"

if fs.platform().is_win then
    Config.default_prog = { GIT_PATH, "--login" }
    Config.default_cwd = fs.home()

  Config.launch_menu = {
    {
      label = Icons.Progs["pwsh.exe"] .. " PowerShell V7",
      args = {
        "pwsh",
        "-NoLogo",
        "-ExecutionPolicy",
        "RemoteSigned",
        "-NoProfileLoadTime",
      },
      cwd = "~",
    },
    { label = "Command Prompt", args = { "cmd.exe" }, cwd = "~" },
    {
        label = Icons.Progs["git"] .. " Git bash",
        args = { GIT_PATH, "--login" },
        cwd = "~"
    },
    {
      label = "Project",
      args = { GIT_PATH, "--login" },
      cwd = "~/EDF/softdev/code/ics2-ssa-portal"
    }

  }

  -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html

end

Config.default_cwd = fs.home()

-- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
Config.ssh_domains = {}

-- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
Config.unix_domains = {}

return Config
