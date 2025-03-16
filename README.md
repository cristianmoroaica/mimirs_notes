# Neovim Plugin: mimirs_notes

A lightweight Neovim plugin for managing daily notes.

## 📦 Installation (Lazy.nvim)
```lua
{
    "cristianmoroaica/mimirs_notes",
    config = function()
        require("mimirs_notes").setup({
            notes_dir = "~/notes"
        })
    end
}

