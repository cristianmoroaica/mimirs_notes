local M = {}

function M.setup(opts)
    opts = opts or {}
    require("mimirs_notes.config").setup(opts)
    require("mimirs_notes.commands").setup()
end

return M

