local fn = require("utils.fn")

-- Require configuration modules
local appearance_config = require "config.appearance"
local font_config = require "config.font"
local tab_bar_config = require "config.tab-bar"
local general_config = require "config.general"
local gpu_config = require "config.gpu"
local startup_config = require "config.startup"

-- Merge configuration tables
local merged_config = fn.tbl.merge(
  appearance_config,
  font_config,
  tab_bar_config,
  general_config,
  gpu_config
)

return merged_config
