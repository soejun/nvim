# Refactoring with nvim-kickstart

Basically, we want to port over our preferences into `nvim-kickstart-modular` so our configuration is
more maintainable and future proof.
[New Nvim Config](https://github.com/soejun/kickstart-modular.nvim)

## Primary Goals
- More universal bindings for easier transition between regular `vim` and `neovim`
- Easier to add different LSP servers
- Easier to add and maintain additional plugins
- Improve performance

## Guidelines

- Try to extend but not overwrite the default keybindings of `nvim-kickstart`, the intent is to relearn our bindings to that our experience is more universal.
- This is an special regards to our base bindings i.e `split-window`, we should use the default bindings moving forward.

```md
-  splitting windows

CTRL-W s _CTRL-W_s_
CTRL-W S _CTRL-W_S_
CTRL-W CTRL-S _CTRL-W_CTRL-S_
CTRL-W CTRL-V _CTRL-W_CTRL-V_
```

- This also means we should rebind our current binding for `save`.
- Port only what is necessary, there exists a lot of auto commands that we have that we don't need.
  - In addition, this will get rid of a lot of our icons that we don't use.
- The `LazyVim` distro is a good resource

### Plugins of Note/Complexity When Porting

1. `nvim-navic`
2. `nvim-cmp`
3. `nvim-ufo`

- This might be less of an issue since neovim now supports built in folding.
- It should follow then that any `vim.opt` related to folding should be taken a look at

4. `mini.nvim` - My current understanding is that this bundles many quality of life plugins together
5. `nvim-lualine`
6. `nvim-lsp`
7. `mason`
8. `bufferline`
9. `toggleterm`
10. `neodev`
