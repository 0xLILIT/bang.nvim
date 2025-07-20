# Bang.nvim
Bang lets you register buffer-local commands that run automatically whenever the buffer is saved.
It makes it easy to execute arbitrary code tied to a specific buffer on write.

## Important
This is a WIP and my first Neovim plugin, so expect bugs and rough edges.

## Installation
No configuration needed as of yet (will probably be added in the future).

### lazy.nvim
```lua
{
  "yuki9k/bang.nvim",
  opts = {}
}
```

## Usage
- `:BangAdd {command}` Adds a command to the current buffer 
- `:BangClearBuffer` Clears all commands for the current buffer
- `:BangClearAll` Clears all commands for all buffers

## Examples
- `:BangAdd so` Source the file (useful for when working on configs or colorschemes)
- `:BangAdd !cp % expand('%:p:r') .. '_copy.' .. expand('%:e')` Creates a copy of the file next to the original
- `:BangAdd tsc` Runs the typescript compiler inside the root directory (The directory where you opened Neovim from)

## TODO
- Remove a specific command from the current buffer
- List buffers and commands
