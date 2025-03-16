local M = {}

function M.setup(opts)
    opts = opts or {}
    require("mimirs_notes.commands").setup()
    require("mimirs_notes.config").setup(opts)
end

return M

