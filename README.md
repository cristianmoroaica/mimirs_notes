<p align="center">
<img src="./mimir.png" width="150" height="150">
</p>

# 📓 Mimir’s Notes – A Simple Neovim Notes Plugin
*A lightweight Neovim plugin for managing daily, general, and relative notes.*

*Using a plugin to improve viewing Markdown files is recommended.*

*Telescope is necessary for listing and searching notes*

**Plugins to improve markdown readability:**

<a href="https://github.com/MeanderingProgrammer/render-markdown.nvim">MeanderingProgrammer/render-markdown.nvim</a>

<a href="https://github.com/lukas-reineke/headlines.nvim">lukas-reineke/headlines.nvim</a>

---

## 🚀 Features
- 📅 **`:Tnote`** – Opens **today’s note** (`YYYY-MM-DD.md`)
- ⏪ **`:Ynote`** – Opens **yesterday’s note** (`YYYY-MM-DD.md`)
- ⏩ **`:Tmnote`** – Opens **tomorrow’s note** (`YYYY-MM-DD.md`)
- 📜 **`:Notes`** – Opens **general notes** (`notes.md`)
- 📆 **`:Notes <date>`** – Opens a specific date-based note (`YYYY-MM-DD.md`)
- 📝 **`:Notes "custom name"`** – Creates or opens a custom-named note (`custom name.md`)
- 📑 **`:NotesList`** – Lists all notes.
- ☠️  **`:NotesDelete`** – Lists notes for deletion.
- 🏡 **Customizable directory** – Set your preferred notes location
- 🔄 **Supports various date formats** (single day, month-day, year-month-day, custom names)

---

## 📦 Installation

### **Lazy.nvim**
Add this to your **Neovim configuration (`lazy.lua` or `init.lua`)**:
```lua
{
    "cristianmoroaica/mimirs_notes.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("mimirs_notes").setup({
            notes_dir = "~/mynotes" -- Optional: Change default directory
        })
    end
}
```

### **Packer.nvim**
```lua
use {
    "cristianmoroaica/mimirs_notes.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("mimirs_notes").setup({
            notes_dir = "~/mynotes" -- Optional
        })
    end
}
```

---

## 🛠️ Usage
| **Command**  | **Description** |
|-------------|---------------|
| `:Tnote`    | Opens **today’s note** (`YYYY-MM-DD.md`) in `~/notes/`. If the file doesn't exist, it creates it. |
| `:Ynote`    | Opens **yesterday’s note** (`YYYY-MM-DD.md`) in `~/notes/`. |
| `:Tmnote`   | Opens **tomorrow’s note** (`YYYY-MM-DD.md`) in `~/notes/`. |
| `:Notes`    | Opens a **general notes file** (`notes.md`) in `~/notes/`. |
| `:Notes <date>` | Opens a **specific date-based note** (e.g., `:Notes 23` → opens `YYYY-MM-23.md`). |
| `:Notes "custom name"` | Creates or opens a **custom-named note** (e.g., `:Notes "Project Ideas"` → `~/notes/Project Ideas.md`). |
| `:NotesList` | Lists all notes. Allows filtering. Using Telescope |
| `:NotesDelete` | List notes. Select for deletion. Confirmation required. |

### **Examples**
 Open Neovim

 Type `:Tnote` → Creates/opens note for today `~/notes/YYYY-MM-DD.md`

 Type `:Ynote` → Opens yesterdays note `~/notes/YESTERDAY_DATE.md`

 Type `:Tmnote` → Opens tomorrow's note `~/notes/TOMORROW.md`

 Type `:Notes` → Opens `~/notes/notes.md`

 Type `:Notes 23` → Opens `~/notes/CURRENT_MONTH-23.md`

 Type `:Notes 3-15` → Opens `~/notes/CURRENT_YEAR-03-15.md`

 Type `:Notes 2024-03-15` → Opens `~/notes/2024-03-15.md`

 Type `:Notes s your_custom_note → Creates/opens `~/notes/your_custom_note.md`

 Type `:NotesList` → Opens Telescope window with all notes. Allows searching.

---

## ⚙️ Configuration
You can set a **custom notes directory**:
```lua
require("mimirs_notes").setup({
    notes_dir = "~/Documents/my_notes" -- Change default directory
})
```
By default, notes are stored in `~/notes/`.

---

## 🔍 Checking Your Notes Directory
To verify that the plugin is creating files correctly, run:
```sh
ls -l ~/notes
(For default dir location)
```
---

## ❓ Troubleshooting
| **Issue** | **Solution** |
|-----------|-------------|
| `:Tnote` doesn’t create the directory | Ensure `mkdir` permissions: `mkdir -p ~/notes` |
| `:Notes` or `:Tnote` doesn’t open files | Check if `vim.fn.mkdir()` is creating `~/notes/` properly |
