return require "utils.functions".config.merge_all(
	require("config.misc"),
	{ launch_menu = require("config.launch_menu") },
	{ keys = require("config.keys") },
	{ key_tables = require("config.key_tables") }
)
