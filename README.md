# 📓 Mimir’s Notes – A Simple Neovim Notes Plugin
*A lightweight Neovim plugin for managing daily, general, and relative notes.*

---

## 🚀 Features
- 📅 **`:Tnote`** – Opens **today’s note** (`YYYY-MM-DD.md`)
- ⏪ **`:Ynote`** – Opens **yesterday’s note** (`YYYY-MM-DD.md`)
- ⏩ **`:Tmnote`** – Opens **tomorrow’s note** (`YYYY-MM-DD.md`)
- 📜 **`:Notes`** – Opens **general notes** (`notes.md`)
- 🏡 **Customizable directory** – Set your preferred notes location
---

## 📦 Installation

### **Lazy.nvim**
Add this to your **Neovim configuration (`lazy.lua` or `init.lua`)**:
```lua
{
    "cristianmoroaica/mimirs_notes",
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
    "cristianmoroaica/mimirs_notes",
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

### **Example Workflow**
1️⃣ Open Neovim  
2️⃣ Type `:Tnote` → Creates/opens `~/notes/YYYY-MM-DD.md`  
3️⃣ Type `:Ynote` → Opens `~/notes/YESTERDAY.md`  
4️⃣ Type `:Tmnote` → Opens `~/notes/TOMORROW.md`  
5️⃣ Type `:Notes` → Opens `~/notes/notes.md`  

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
```
---

## ❓ Troubleshooting
| **Issue** | **Solution** |
|-----------|-------------|
| `:Tnote` doesn’t create the directory | Ensure `mkdir` permissions: `mkdir -p ~/notes` |
| `:Notes` or `:Tnote` doesn’t open files | Check if `vim.loop.fs_mkdir()` is creating `~/notes/` |
