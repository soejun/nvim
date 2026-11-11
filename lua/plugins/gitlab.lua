-- GitLab MR/issue pickers via glab, plus gitbrowse URLs for self-hosted GitLab.
local function is_gitlab()
  local url = vim.fn.systemlist({ "git", "remote", "get-url", "origin" })[1] or ""
  return url:find("gitlab") ~= nil
end

local function glab(args, on_json)
  vim.system(vim.list_extend({ "glab" }, args), { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        return Snacks.notify.error(res.stderr, { title = "glab" })
      end
      on_json(vim.json.decode(res.stdout))
    end)
  end)
end

local function val(v)
  return v ~= vim.NIL and v or nil
end

---@param kind "mr"|"issue"
---@param opts {all?: boolean, args?: string[], label?: string}
local function glab_pick(kind, opts)
  local args = { kind, "list", kind == "mr" and "-F" or "-O", "json", "-P", "100" }
  if opts.all then
    table.insert(args, "--all")
  end
  vim.list_extend(args, opts.args or {})
  glab(args, function(list)
    local items = {}
    for _, it in ipairs(list) do
      local ref = (kind == "mr" and "!" or "#") .. it.iid
      local ms = val(it.milestone) and ("%" .. it.milestone.title) or ""
      local iter = val(it.iteration) and ("*" .. it.iteration.start_date) or ""
      table.insert(items, {
        text = ("%s %s @%s [%s] %s %s"):format(ref, it.title, it.author.username, it.state, ms, iter),
        url = it.web_url,
        preview = { text = ("# %s %s\n\n%s"):format(ref, it.title, val(it.description) or ""), ft = "markdown" },
      })
    end
    Snacks.picker({
      title = ("GitLab %s (%s)"):format(kind == "mr" and "MRs" or "Issues", opts.label or (opts.all and "all" or "open")),
      items = items,
      format = "text",
      preview = "preview",
      confirm = function(picker, item)
        picker:close()
        vim.ui.open(item.url)
      end,
    })
  end)
end

local function by_milestone(kind)
  glab({ "api", "projects/:id/milestones?state=active" }, function(list)
    vim.ui.select(list, {
      prompt = "Milestone",
      format_item = function(m) return m.title end,
    }, function(m)
      if m then
        glab_pick(kind, { args = { "-m", m.title }, label = "%" .. m.title })
      end
    end)
  end)
end

local function by_iteration()
  glab({ "api", "projects/:id/iterations?state=opened" }, function(list)
    table.sort(list, function(a, b) return a.start_date < b.start_date end)
    vim.ui.select(list, {
      prompt = "Iteration",
      format_item = function(i)
        return ("%s → %s%s"):format(i.start_date, i.due_date, i.state == 2 and " (current)" or "")
      end,
    }, function(i)
      if i then
        glab_pick("issue", { args = { "-i", tostring(i.id) }, label = "*" .. i.start_date })
      end
    end)
  end)
end

local function pick(fn, gh)
  return function()
    if is_gitlab() then
      fn()
    elseif gh then
      gh()
    else
      Snacks.notify.warn("Not a GitLab remote")
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
    { "<leader>gi", pick(function() glab_pick("issue", {}) end, function() Snacks.picker.gh_issue() end), desc = "Issues (open)" },
    { "<leader>gI", pick(function() glab_pick("issue", { all = true }) end, function() Snacks.picker.gh_issue({ state = "all" }) end), desc = "Issues (all)" },
    { "<leader>gp", pick(function() glab_pick("mr", {}) end, function() Snacks.picker.gh_pr() end), desc = "MRs/PRs (open)" },
    { "<leader>gP", pick(function() glab_pick("mr", { all = true }) end, function() Snacks.picker.gh_pr({ state = "all" }) end), desc = "MRs/PRs (all)" },
    { "<leader>gm", pick(function() by_milestone("issue") end), desc = "GitLab Issues by Milestone" },
    { "<leader>gM", pick(function() by_milestone("mr") end), desc = "GitLab MRs by Milestone" },
    { "<leader>gt", pick(by_iteration), desc = "GitLab Issues by Iteration" },
  },
}
