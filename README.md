# Bang.nvim
Bang lets you configure global or buffer-local autocommands from within your current neovim session.
Commands are as of now bound to your current session, meaning they are removed when Neovim is closed.

## Important
This is a WIP and my first Neovim plugin, so expect bugs and rough edges.

## Installation
### lazy.nvim
```lua
{
  "frxja/bang.nvim",
  dependencies= {"MunifTanjim/nui.nvim"},
  opts = {}
}
```

## Usage
- `:Bang` Open Bang

## TODO (If I feel like it)
- Edit entries
- Save/load presets
- Add more events
- API
