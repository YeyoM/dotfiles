# Dotfiles Setup Notes

Repo location: `~/code/dotfiles`
Symlink manager: GNU Stow
Target flag: always run stow with `-t ~` (or `-t $HOME`), since the repo lives under `~/code`, not directly in `$HOME`.

---

## Status

| Tool | Migrated? | Notes |
|---|---|---|
| tmux | ✅ Done | `plugins/` gitignored, TPM reinstalled via `prefix + I` |
| i3 | ⬜ Not yet | |
| neovim | ✅ Done | |
| kitty | ✅ Done | |
| rofi | ✅ Done | |
| zsh | ✅ Done | |
| spicetify | ✅ Done | |
| polybar | ⬜ Not yet | |
| picom | ✅ Done | |

---

## Config path reference

| Tool | Real config path | Watch out for |
|---|---|---|
| **tmux** | `~/.config/tmux/tmux.conf` | `plugins/` dir is TPM clones — gitignored, not tracked |
| **i3** | `~/.config/i3/config` | Often references polybar/picom in `exec_always` lines — test both together |
| **neovim** | `~/.config/nvim/` | Plugin manager data lives in `~/.local/share/nvim/`, `~/.local/state/nvim/`, `~/.cache/nvim/` — don't move those, just gitignore them |
| **kitty** | `~/.config/kitty/kitty.toml` (or `.yml` on older installs) | Single file usually, low risk |
| **rofi** | `~/.config/rofi/config.rasi` + theme files | Themes are often separate `.rasi` files in the same folder — grab the whole dir |
| **zsh** | `~/.zshrc` (home-level, not XDG) | If using oh-my-zsh, the framework itself lives in `~/.oh-my-zsh/` — don't move that, just track `.zshrc`; gitignore `.zsh_history` / `.zcompdump*` |
| **spicetify** | `~/.config/spicetify/` | Has a `Themes/` folder (fine to track); spicetify has its own install/patch process, keep that separate from stow |
| **polybar** | `~/.config/polybar/` | Usually `config.ini` + a `launch.sh` — check the launch script for hardcoded paths |
| **picom** | `~/.config/picom/picom.conf` | Single file usually, low risk |

---

## Repo structure

```
dotfiles/
├── install.sh
├── README.md
├── .gitignore
├── tmux/
│   └── .config/tmux/tmux.conf
├── i3/
│   └── .config/i3/config
├── nvim/
│   └── .config/nvim/
├── kitty/
│   └── .config/kitty/kitty.toml
├── rofi/
│   └── .config/rofi/
├── zsh/
│   └── .zshrc
├── spicetify/
│   └── .config/spicetify/
├── polybar/
│   └── .config/polybar/
└── picom/
    └── .config/picom/picom.conf
```

---

## Root `.gitignore` (current)

```gitignore
# tmux — plugin manager clones (installed via TPM, not tracked)
tmux/.config/tmux/plugins/

# zsh
zsh/.zsh_history
zsh/.zcompdump*

# nvim — plugin manager data & caches, not the config itself
nvim/.local/share/nvim/
nvim/.local/state/nvim/
nvim/.cache/nvim/

# general local/machine-specific overrides — never commit secrets
*.local
.env

# OS/editor noise
.DS_Store
*.swp
*~
```

Add to this list as you migrate each tool and notice new cache/plugin/secret paths.

---

## The repeatable migration loop (per tool)

1. **Find the real config path** — check `~/.config/<tool>` first; a few tools (zsh) use a home-level dotfile instead.
2. **Check for plugin/cache/data subfolders before moving anything** — nvim, zsh frameworks, and spicetify all generate or clone extra content that shouldn't be tracked.
3. **`mkdir -p`** the mirrored path inside `~/code/dotfiles/<tool>/...`
4. **`mv`** the real config into that path (whole folder if it's directory-based).
5. **Update root `.gitignore`** for anything identified in step 2.
6. **Run `stow -v -t ~ <tool>`** from the repo root — read the verbose output.
7. **Verify with `readlink -f`** on the original path — it should resolve into the dotfiles repo.
8. **Actually use the tool** (restart it / reload its config) before committing.
9. **Commit**: `git add <tool>/ && git commit -m "add <tool> config via stow"`

---

## Suggested order for remaining tools

1. **kitty** — single file, near-zero risk
2. **picom** — single file, near-zero risk
3. **zsh** — home-level dotfile, watch for oh-my-zsh framework path
4. **rofi** — folder with theme files, still low complexity
5. **neovim** — more moving parts (plugin manager cache dirs)
6. **spicetify** — has its own patch/install process separate from stow
7. **i3 + polybar together** — save for last since they're interdependent; test both after migrating

---

## Verification checklist (after each migration)

- [ ] `readlink -f <real path>` resolves into `~/code/dotfiles/...`
- [ ] Tool starts/reloads with no errors
- [ ] Edit a value through the symlinked path and confirm it takes effect live
- [ ] `git status` shows only the expected files staged (no plugin/cache dirs)
- [ ] Commit

---

## Still to do

- [ ] Write `install.sh` (package install list + stow loop with `-t $HOME` baked in) — do this **after** all tools are migrated, once the real folder structure is known
- [ ] Write `README.md` with setup instructions + a screenshot of the final desktop
- [ ] Add a bootstrap step for TPM (`git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`) and spicetify's own installer inside `install.sh`
