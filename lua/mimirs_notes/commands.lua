local M = {}

-- Ensure the notes directory exists
local function ensure_notes_dir()
    local notes_dir = vim.fn.expand("~") .. "/notes"

    -- Check if directory exists
    local stat = vim.loop.fs_stat(notes_dir)
    if not stat then
        vim.loop.fs_mkdir(notes_dir, 0o755) -- rwxr-xr-x
    end

    return notes_dir
end

local function get_note_filename(offset)
    local time = os.time() + (offset * 24 * 60 * 60)
    return os.date("%Y-%m-%d", time) .. ".md"
end

function M.setup()
    local notes_dir = ensure_notes_dir()

    -- Command: :Tnote (Opens today's note)
    vim.api.nvim_create_user_command("Tnote", function()
        vim.cmd("e " .. notes_dir .. "/" .. get_note_filename(0))
    end, {})

    -- Command: :Ynote (Opens yesterday's note)
    vim.api.nvim_create_user_command("Ynote", function()
        vim.cmd("e " .. notes_dir .. "/" .. get_note_filename(-1))
    end, {})

    -- Command: :Tmnote (Opens tomorrow's note)
    vim.api.nvim_create_user_command("Tmnote", function()
        vim.cmd("e " .. notes_dir .. "/" .. get_note_filename(1))
    end, {})

    -- Command: :Notes (Opens general notes file)
    vim.api.nvim_create_user_command("Notes", function(opts)
        if opts.args ~= "" then
            -- Get current year and month
            local current_year = os.date("%Y")
            local current_month = os.date("%m")

            local input = opts.args

            -- Case 1: Single number (Day) → Assume current month
            if string.match(input, "^%d+$") then
                input = string.format("%s-%s-%02d", current_year, current_month, tonumber(input))

            -- Case 2: Month-Day → Assume current year
            elseif string.match(input, "^%d%d?%-%d%d?$") then
                local month, day = input:match("^(%d%d?)%-(%d%d?)$")
                input = string.format("%s-%02d-%02d", current_year, tonumber(month), tonumber(day))

            -- Case 3: Invalid date format. Creating custom notes
            elseif not string.match(input, "^%d%d?%-%d%d?%-%d+$") then
                print("Creating custom note: " .. input)
            end

            -- Open the formatted date note
            vim.cmd("e " .. notes_dir .. "/" .. input .. ".md")

        else
            -- Open the general notes file if no argument is provided
            vim.cmd("e " .. notes_dir .. "/notes.md")
        end
    end, { nargs = ? })
end

return M

