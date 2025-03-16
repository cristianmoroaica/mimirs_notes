local M = {}

function M.setup()
    vim.api.nvim_create_user_command("tnote", function()
        local today = os.date("%Y-%m-%d")
        local notes_dir = os.getenv("HOME") .. "/notes"

        if not vim.loop.fs_stat(notes_dir) then
            os.execute("mkdir -p " .. notes_dir)
        end

        vim.cmd("e " .. notes_dir .. "/" .. today .. ".md")
    end, {})

    vim.api.nvim_create_user_command("notes", function()
        local notes_dir = os.getenv("HOME") .. "/notes"

        if not vim.loop.fs_stat(notes_dir) then
            os.execute("mkdir -p " .. notes_dir)
        end

        vim.cmd("e " .. notes_dir .. "/notes.md")
    end, {})
end

return M

