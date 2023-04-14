
local builtin = require("statuscol.builtin")
local options = {}

options = {
  setopt = true,
  relculright = true,
  --so basically, the segment is literally the order of how things are gonna get built
  -- so to disable the fold line numbers just literally init the segment and comment out the fold part
  segments = {
--    {sign = {name = {builtin.foldfunc}},auto = true, click = "v:lua.ScFa"},
    {
      sign = {name = { "Diagnostic" }, maxwidth = 2, auto = true },
      click = "v:lua.ScSa"
    },
    {text = {builtin.lnumfunc, " "}, click = "v:lua.ScLa"},
    {
      sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true },
      click = "v:lua.ScSa"
    },
--    {sign = {name = {".*"}, maxwidth = 2, colwidth = 1, auto = true}, click ="v:lua.ScSa"}
  }
}
return options
