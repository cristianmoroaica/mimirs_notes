local M = {}

local default_opts = {
    notes_dir = os.getenv("HOME") .. "/notes" -- Default notes directory
}

M.options = default_opts

function M.setup(opts)
    M.options = vim.tbl_extend("force", default_opts, opts or {})
end

function M.get()
    return M.options
end

return M

