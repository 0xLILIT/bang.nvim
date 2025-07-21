# Bang.nvim
Bang lets you register buffer-local EX commands that run automatically after a buffer write.
Commands run on the BufWritePost event by default.

## Important
This is a WIP and my first Neovim plugin, so expect bugs and rough edges.

## Installation
No configuration needed as of yet (will be added in the future).

### lazy.nvim
```lua
{
  "yuki9k/bang.nvim",
  opts = {}
}
```

## Usage
- `:Bang {command}` or `:BangAdd {command}` Adds a command to the current buffer 
- `:BangList` List all commands in the current buffer
- `:BangListAll` List all commands for all buffers
- `:BangClearBuffer` Clears all commands for the current buffer
- `:BangClearAll` Clears all commands for all buffers

## Examples
Please note that all commands are run inside the root directory by default.

- `:Bang so`
- `:Bang lua vim.b.last_saved = os.date()`

## TODO
- Remove specific commands    
- Choose event to trigger on



