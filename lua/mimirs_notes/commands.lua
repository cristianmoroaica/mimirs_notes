local M = {}
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")


-- Attempt to load Telescope safely
local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    print("❌ Telescope.nvim is not installed. NotesList & NotesFind will not work.")
end

-- Ensure the notes directory exists
local function ensure_notes_dir()
    local notes_dir = vim.fn.expand("~") .. "/notes"

    -- Create directory if missing
    if not vim.loop.fs_stat(notes_dir) then
        vim.fn.mkdir(notes_dir, "p")
    end

    return notes_dir
end

-- List all files in notes directory
local function list_notes()
    local notes_dir = ensure_notes_dir()
    local files = {}

    -- Ensure glob is correctly called as a function
    local file_list = vim.fn.glob(notes_dir .. "/*.md", false, true)

    -- Ensure file_list is an iterable table (it should be a list of files)
    if type(file_list) == "table" then
        for _, file in ipairs(file_list) do
            table.insert(files, file)
        end
    elseif type(file_list) == "string" and file_list ~= "" then
        -- If vim.fn.glob returns a single string (not a table), insert it directly
        table.insert(files, file_list)
    end

    return files
end

-- Open selected note from Telescope
local function open_selected_note(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    if selection then
        vim.cmd("e " .. selection[1])
    end
end

-- Telescope Picker for Listing Notes
local function list_notes_picker()
    local files = list_notes()

    if #files == 0 then
        print("📂 No notes found!")
        return
    end

    pickers.new({}, {
        prompt_title = "📜 Notes",
        finder = finders.new_table({ results = files }),
        sorter = sorters.get_fuzzy_file(),
        attach_mappings = function(_, map)
            map("i", "<CR>", open_selected_note)
            map("n", "<CR>", open_selected_note)
            return true
        end,
    }):find()
end

-- Function to generate note filenames based on offset (e.g., today, yesterday, tomorrow)
local function get_note_filename(offset)
    local time = os.time() + (offset * 24 * 60 * 60)
    return os.date("%Y-%m-%d", time) .. ".md"
end

-- Generate date for header
local function extract_date_from_filename(filename)
    -- Match "YYYY-MM-DD" or "YY-M-D" format
    local year, month, day = filename:match("(%d%d%d%d)%-(%d%d?)%-(%d%d?)")

    -- If no match, try "YY-M-D" short format
    if not year then
        year, month, day = filename:match("(%d%d)%-(%d%d?)%-(%d%d?)")
        if year then
            year = "20" .. year -- Convert YY to YYYY
        end
    end

    if not year then return nil end

    return os.date("%A, %B %d, %Y", os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) }))
end

-- Check buffer and add date if empty
local function add_date_header_if_new()
    if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
        local filename = vim.fn.expand("%:t:r") -- Removes path & extension
        local formatted_date = extract_date_from_filename(filename)

        -- If the file is a custom note (not date-based), don't insert a date
        if formatted_date then
            local header = "# " .. formatted_date
            vim.api.nvim_buf_set_lines(0, 0, 0, false, { header, "" })
        end
    end
end


-- Function to confirm deletion
local function confirm_deletion(file_path)
    local prompt = "🗑️ Delete " .. file_path .. "? [y/N]: "
    local choice = vim.fn.input(prompt)

    if choice:lower() == "y" then
        os.remove(file_path)
        print("✅ Deleted: " .. file_path)
    else
        print("❌ Deletion cancelled.")
    end
end

-- Function to handle note deletion via Telescope
local function delete_selected_note(prompt_bufnr)
    local selection = require("telescope.actions.state").get_selected_entry()
    require("telescope.actions").close(prompt_bufnr)

    if selection then
        local file_path = selection[1]
        confirm_deletion(file_path)
    end
end

function M.setup()
    local notes_dir = ensure_notes_dir()

    -- Command: :NotesList (Lists all notes)
    vim.api.nvim_create_user_command("NotesList", function()
        if not has_telescope then
            print("❌ Telescope.nvim is not installed. Install it to use NotesList.")
            return
        end
        list_notes_picker()
    end, {})

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

    -- Command: :Notes (Opens general or specific date-based notes)
    vim.api.nvim_create_user_command("Notes", function(opts)
        local input = opts.args
        if input ~= "" then
            -- Get current year and month
            local current_year = os.date("%Y")
            local current_month = os.date("%m")

            -- Case 1: Single number (Day) → Assume current month
            if string.match(input, "^%d+$") then
                input = string.format("%s-%s-%02d", current_year, current_month, tonumber(input))

                -- Case 2: Month-Day → Assume current year
            elseif string.match(input, "^%d%d?%-%d%d?$") then
                local month, day = input:match("^(%d%d?)%-(%d%d?)$")
                input = string.format("%s-%02d-%02d", current_year, tonumber(month), tonumber(day))

                -- Case 3: Custom Notes (invalid date format)
            else
                print("📄 Creating custom note: " .. input)
            end

            -- Open the formatted date note or custom note
            vim.cmd("e " .. notes_dir .. "/" .. input .. ".md")
        else
            -- Open the general notes file if no argument is provided
            vim.cmd("e " .. notes_dir .. "/notes.md")
        end
        -- Add date header if it's a new file
        vim.defer_fn(add_date_header_if_new, 50) -- Delay execution slightly to ensure buffer is ready
    end, { nargs = "?" })

    -- Command: :NotesDelete - Select & delete a note via Telescope
    vim.api.nvim_create_user_command("NotesDelete", function()
        local files = list_notes()
        if #files == 0 then
            print("📂 No notes found!")
            return
        end

        require("telescope.pickers").new({}, {
            prompt_title = "🗑️ Select a Note to Delete",
            finder = require("telescope.finders").new_table({ results = files }),
            sorter = require("telescope.sorters").get_fuzzy_file(),
            attach_mappings = function(_, map)
                map("i", "<CR>", delete_selected_note) -- In insert mode
                map("n", "<CR>", delete_selected_note) -- In normal mode
                return true
            end,
        }):find()
    end, {})
end

return M

