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

Based on the starter template for [💤 LazyVim](https://github.com/LazyVim/LazyVim).

## 🎓 LazyVim and General VIM Notes

Will contain a combination of snippets derived from LazyVim documentation and various VIM notes that include but aren't limited to its functionality, QoL, and quirks.


### 📂 File Structure

<pre>
~/.config/nvim
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── spec1.lua
│       ├── **
│       └── spec2.lua
└── init.lua
</pre>

### [📦 Plugin Configuration (Merge Rules)](https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-customizing-plugin-specs)
| **Property**     | **Default Merging Rule**                                                  |
|-------------------|--------------------------------------------------------------------------|
| `cmd`            | The list of commands will be extended with your custom commands.          |
| `event`          | The list of events will be extended with your custom events.              |
| `ft`             | The list of filetypes will be extended with your custom filetypes.        |
| `keys`           | The list of keymaps will be extended with your custom keymaps.            |
| `opts`           | Your custom options (`opts`) will be merged with the default options.     |
| `dependencies`   | The list of dependencies will be extended with your custom dependencies.  |
| Any other property | Will override the defaults.                                             |

For ft, event, keys, cmd and opts you can instead also specify a values function
that can make changes to the default values, or return new values to be used instead.

### References

| **Mode**                      | **Identifier** |
|-------------------------------|----------------|
| Normal Mode                   | `n`            |
| Insert Mode                   | `i`            |
| Character-wise Visual Mode    | `v`            |
| Line-wise Visual Mode         | `V`            |
| Block-wise Visual Mode        | `^V` (Ctrl-v)  |
| Replace Mode                  | `R`            |
| Virtual Replace Mode          | `Rv`           |
| Command-Line Mode             | `c`            |
| Terminal Mode                 | `t`            |
| Operator-Pending Mode         | `o`            |
| Select Mode                   | `s`            |
| Ex-Mode                       | `!`            |

### Tips and Tricks (Normal VIM friendly)

- Yanking an entire file: `:%y+`
  - `+` is a register that is tied to the system clipboard.

## Python

Reference for [PyLsp LazyVim Configuration](https://www.reddit.com/r/neovim/comments/14316t9/help_me_to_get_the_best_python_neovim_environment/)

- Blob for PyLSP and Ruff heavily customized in the context of LazyVim.

### Pyright and BasedPyright Stubs

[Using Microsoft python-type-stubs with Pyright](https://jaewonchung.me/technical/Using-Microsoft-python-type-stubs-with-Pyright/)

Essentially:

1. Add python-type-stubs as a git submodule under the directory stubs:

```bash
cd proj
# Assuming you have GitHub SSH authentication set up.
git submodule add git@github.com:microsoft/python-type-stubs stubs
```

2. Point to stubs
  - Using `pyrproject.toml`
  ```toml
  [tool.pyright]
  stubPath = "./stubs/stubs"
  ```
  - If not `pyporject.toml`, must have `pyrightconfig.json` in root of workspace
  ```json
  {
    "stubPath": "./stubs/stubs"
  }
  ```

3. To update: `git submodule update`
