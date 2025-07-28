# Bang.nvim
Bang lets you configure global or buffer-local autocommands from within your current neovim session.
Commands are as of now bound to your current session, meaning they are removed when Neovim is closed.

## Important
This is a WIP and my first Neovim plugin, so expect bugs and rough edges.

## Installation
No configuration as of yet (will be added in the future).

### lazy.nvim
```lua
{
  "yuki9k/bang.nvim",
  opts = {}
}
```

## Usage
- `:Bang` Open Bang

## TODO
- Edit entries
- Save/load presets
- Add more events
- API
