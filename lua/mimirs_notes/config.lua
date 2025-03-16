local M = {}

function M.setup(opts)
    opts = opts or {}
    M.options = {
        notes_dir = opts.notes_dir or os.getenv("HOME") .. "/notes"
    }
end

return M

