local wezterm = require("wezterm")
local userDirectory = require("../utils/directories").directories.getUser()
local isPc = require("../utils/directories").directories.getIsPc()
if isPc then
	return {
		{
			label = "PowerShell",
			args = { "C:/Program Files/PowerShell/7/pwsh.exe", "-WorkingDirectory", wezterm.home_dir },
			domain = { DomainName = "local" },
		},
		{
			label = "Bash",
			args = { "C:/Program Files/Git/bin/bash.exe" },
			cwd = userDirectory,
			domain = { DomainName = "local" },
		},
		{
			label = "Wezterm Config",
			args = { "C:/Program Files/PowerShell/7/pwsh.exe" },
			cwd = userDirectory .. ".config/wezterm",
			domain = { DomainName = "local" },
		},
		{
			label = "Neovim Config",
			args = { "C:/Program Files/PowerShell/7/pwsh.exe" },
			cwd = userDirectory .. "AppData/Local/nvim",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Neovim Config",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = userDirectory .. "AppData/Local/nvim",
			domain = { DomainName = "local" },
		},
		{
			label = "Rustling Exercises",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "Documents/Projects/Rust/rustlings",
			domain = { DomainName = "local" },
		},
		{
			label = "Documents",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "Documents",
			domain = { DomainName = "local" },
		},
		{
			label = "Dotfiles",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "dotfiles",
			domain = { DomainName = "local" },
		},
	}
else
	return {
		{
			label = "PWSH",
			args = { userDirectory .. "scoop/shims/pwsh.exe", "-WorkingDirectory", wezterm.home_dir },
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = userDirectory,
			domain = { DomainName = "local" },
		},
		{
			label = "PWSH Budget",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = "C:/Projetos/budget-project/budget-app",
			domain = { DomainName = "local" },
		},
		{
			label = "PWSH Quality",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = "C:/Projetos/quality-project/quality-app",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh budget APP",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = "C:/Projetos/budget-project/budget-app",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Budget API",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = "C:/Projetos/budget-project/budget-api",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Quality APP",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = "C:/Projetos/quality-project/quality-app",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Quality API",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = "C:/Projetos/quality-project/quality-api",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Movtech Projects",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = "C:/Projetos/",
			domain = { DomainName = "local" },
		},
		{
			label = "Neovim Config",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "AppData/Local/nvim",
			domain = { DomainName = "local" },
		},
		{
			label = "WezTerm Config",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. ".config/wezterm",
			domain = { DomainName = "local" },
		},
		{
			label = "Documents",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "Documents",
			domain = { DomainName = "local" },
		},
		{
			label = "Zsh Courses",
			args = { userDirectory .. "scoop/shims/msys2.exe" },
			cwd = userDirectory .. "Documents/Projects/Courses",
			domain = { DomainName = "local" },
		},
		{
			label = "Dotfiles",
			args = { userDirectory .. "scoop/shims/pwsh.exe" },
			cwd = userDirectory .. "dotfiles",
			domain = { DomainName = "local" },
		},
	}
end
