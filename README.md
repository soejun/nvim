<h1 align="center">Neovim Config</h1>
<div align="center"><p>
    <a href="https://github.com/wchan-dev/nvim/pulse">
      <img src="https://img.shields.io/github/last-commit/wchan-dev/nvim" alt="Last commit"/>
    </a>
    <a href="https://github.com/wchan-dev/nvim/issues">
      <img src="https://img.shields.io/github/issues/wchan-dev/nvim.svg?style=flat-square&label=Issues&color=F05F40" alt="Github issues"/>
    </a>
    </a>
    <a href="https://github.com/wchan-dev/nvim/blob/LICENSE">
      <img src="https://img.shields.io/github/license/wchan-dev/nvim?style=flat-square&logo=MIT&label=License" alt="License"/>
    </a>
</div>

~~I'm using LazyVim in another repo for the foreseeable future, this was fun to learn though. Til next time!~~

Oh we're so back.

Based on the starter template for [LazyVim](https://github.com/LazyVim/LazyVim).

## File Structure

<pre>
~/.config/nvim
├── docs        <- notes (see below)
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── spec1.lua
│       ├── **
│       └── spec2.lua
└── init.lua
</pre>

## Notes

Deep-dives, root-cause analyses, and reference cards live in [docs/](docs/README.md) —
one topic per file, indexed there. Highlights:

- [How LazyVim merges plugin opts & why lua_ls types wouldn't resolve](docs/lazydev-word-gated-types.md)
- [snacks grep pickers: live vs fuzzy](docs/grep-vs-ripgrep-pickers.md)
