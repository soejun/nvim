
local builtin = require("statuscol.builtin")
local options = {}

options = {
  setopt = true,
  relculright = true,
  --so basically, the segment is literally the order of how things are gonna get built
  -- so to disable the fold line numbers just literally init the segment and comment out the fold part
  segments = {
--    {text = {builtin.foldfunc}, click = "v:lua.ScFa"},
    {text = {"%s"}, condition = { false, builtin.not_empty }, click = "v:lua.ScSa"},
    {text = {builtin.lnumfunc, " "}, click = "v:lua.ScLa"},
  }
}
return options
