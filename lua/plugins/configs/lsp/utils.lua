local M = {}

M.get_python_path = function(workspace)
  local lsp_util = require("lspconfig/util")
  local path = lsp_util.path

  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv in workspace directory
  for _, pattern in ipairs({ "*", ".*" }) do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      return path.join(path.dirname(match), "bin", "python")
    end
  end

  --Fallback to system Python
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

M.get_python_path_pylsp = function()
end


local uv = vim.loop
M.find_path_from_root = function(root, target)
    local function is_directory(path)
        local stat = uv.fs_stat(path)
        return stat and stat.type == "directory"
    end

    local function scan_dir(path)
        local handle = uv.fs_scandir(path)
        if not handle then
            return nil
        end

        repeat
            local name, type = uv.fs_scandir_next(handle)
            if not name then break end
            local full_path = path .. "/" .. name

            -- Check if it's the target
            if name == target then
                return full_path
            end

            -- Recursively scan directories
            if type == "directory" then
                local found = scan_dir(full_path)
                if found then
                    return found
                end
            end
        until not name

        return nil
    end

    -- Ensure the root exists and is a directory
    if is_directory(root) then
        return scan_dir(root)
    else
        return nil
    end
end

return M
