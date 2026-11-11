-- GitLab MR/issue pickers via glab, plus gitbrowse URLs for the self-hosted instance.
local function is_gitlab()
  local url = vim.fn.systemlist({ "git", "remote", "get-url", "origin" })[1] or ""
  return url:find("gitlab") ~= nil
end

---@param kind "mr"|"issue"
---@param all boolean
local function glab_pick(kind, all)
  local args = { "glab", kind, "list", kind == "mr" and "-F" or "-O", "json", "-P", "100" }
  if all then
    table.insert(args, "--all")
  end
  vim.system(args, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        return Snacks.notify.error(res.stderr, { title = "glab" })
      end
      local items = {}
      for _, it in ipairs(vim.json.decode(res.stdout)) do
        local ref = (kind == "mr" and "!" or "#") .. it.iid
        local body = it.description ~= vim.NIL and it.description or ""
        table.insert(items, {
          text = ("%s %s @%s [%s]"):format(ref, it.title, it.author.username, it.state),
          url = it.web_url,
          preview = { text = ("# %s %s\n\n%s"):format(ref, it.title, body), ft = "markdown" },
        })
      end
      Snacks.picker({
        title = ("GitLab %s (%s)"):format(kind == "mr" and "Merge Requests" or "Issues", all and "all" or "open"),
        items = items,
        format = "text",
        preview = "preview",
        confirm = function(picker, item)
          picker:close()
          vim.ui.open(item.url)
        end,
      })
    end)
  end)
end

local function pick(kind, all, gh)
  return function()
    if is_gitlab() then
      glab_pick(kind, all)
    else
      gh()
    end
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    gitbrowse = {
      url_patterns = {
        ["^https://gitlab%."] = {
          branch = "/-/tree/{branch}",
          file = "/-/blob/{branch}/{file}#L{line_start}-{line_end}",
          permalink = "/-/blob/{commit}/{file}#L{line_start}-{line_end}",
          commit = "/-/commit/{commit}",
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>gi", pick("issue", false, function() Snacks.picker.gh_issue() end), desc = "Issues (open)" },
    { "<leader>gI", pick("issue", true, function() Snacks.picker.gh_issue({ state = "all" }) end), desc = "Issues (all)" },
    { "<leader>gp", pick("mr", false, function() Snacks.picker.gh_pr() end), desc = "MRs/PRs (open)" },
    { "<leader>gP", pick("mr", true, function() Snacks.picker.gh_pr({ state = "all" }) end), desc = "MRs/PRs (all)" },
  },
}
