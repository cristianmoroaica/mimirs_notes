local M = {}

-- Function to check if a directory exists
local function dir_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat ~= nil and stat.type == "directory"
end

-- Function to ensure notes directory exists
local function ensure_notes_dir()
    local notes_dir = vim.fn.expand("~") .. "/notes"

    -- Check if directory exists
    local stat = vim.loop.fs_stat(notes_dir)
    if not stat then
        vim.loop.fs_mkdir(notes_dir, 493) -- 493 (rwxr-xr-x)
    end

    return notes_dir
end


function M.setup()
    -- Command: :Tnote (Opens today's note)
    vim.api.nvim_create_user_command("Tnote", function()
        local today = os.date("%Y-%m-%d")
        local notes_dir = ensure_notes_dir()
        vim.cmd("e " .. notes_dir .. "/" .. today .. ".md")
    end, {})

    -- Command: :Notes (Opens general notes.md)
    vim.api.nvim_create_user_command("Notes", function()
        local notes_dir = ensure_notes_dir()
        vim.cmd("e " .. notes_dir .. "/notes.md")
    end, {})
end

return M

