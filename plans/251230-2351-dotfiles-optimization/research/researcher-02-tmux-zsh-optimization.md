# tmux & zsh Optimization Research (macOS)

**Date:** 2025-12-30 | **Target:** macOS Darwin 25.2.0

---

## 1. tmux Clipboard (macOS: pbcopy vs xclip)

### Modern Config (tmux 3.2+)
```bash
# ~/.tmux.conf - Native OSC 52 integration
set -g set-clipboard on
set -s copy-command 'pbcopy'  # macOS (Linux: xclip/wl-copy)
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
```

**Key Points:**
- `reattach-to-user-namespace` deprecated for tmux 3.2+
- OSC 52 works across SSH (copies remote → local clipboard)
- iTerm2: Enable in Preferences → General → Selection
- WezTerm: Native support, no config needed

---

## 2. tmux-256color vs screen-256color

| Feature | tmux-256color | screen-256color |
|---------|---------------|-----------------|
| Italics | ✅ Full | ❌ Shows as reverse |
| True color | ✅ + overrides | ⚠️ Limited |
| Undercurl | ✅ + terminfo | ❌ No |

### Recommended Config
```bash
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
```

**Verdict:** Use `tmux-256color`. `screen-256color` breaks italics + undercurl.

---

## 3. Undercurl Support (LSP Diagnostics)

Requires: Terminal support (WezTerm/iTerm2/Alacritty) + tmux passthrough + Neovim config

```bash
# ~/.tmux.conf - Undercurl escape sequences
set -g default-terminal "tmux-256color"
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
```

**Test:**
```bash
printf '\e[4:3mUndercurl\e[0m\n'
```

---

## 4. NVM Lazy-Loading (zsh Fast Startup)

### Problem
Standard NVM init: **200-500ms** startup penalty

### Solution A: Manual Lazy-Load
```zsh
# ~/.zshrc
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}
# Repeat for npm, npx
```
**Result:** ~400ms → ~50ms

### Solution B: Switch Tools

| Tool | Startup | Lang | Notes |
|------|---------|------|-------|
| **fnm** | 1-2ms | Rust | Fastest, auto-switch |
| **volta** | 2-5ms | Rust | Toolchain mgmt |
| **nvm** | 100-400ms | Bash | Legacy |

**2025 Rec:** Migrate to `fnm` (200x faster)
```bash
brew install fnm
# ~/.zshrc: eval "$(fnm env --use-on-cd)"
```

---

## 5. Zsh Startup Optimization

### Profiling
```zsh
# Method 1: zprof (function-level)
zmodload zsh/zprof  # top of .zshrc
zprof               # bottom of .zshrc

# Method 2: Benchmark
time zsh -i -c exit
```

### Optimization Techniques

| Technique | Impact | How |
|-----------|--------|-----|
| Lazy-load plugins | **High** | `zinit ice wait lucid` |
| Defer NVM/pyenv | **High** | Wrapper functions |
| Async prompt | **High** | Starship/p10k instant |
| Compile .zshrc | Medium | `zcompile ~/.zshrc` |
| Remove dupes $PATH | Low | `typeset -U path` |

### Example: zinit Turbo
```zsh
# Deferred, non-blocking load
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
```

**Target:** < 100ms startup

---

## Summary

### tmux
- `tmux-256color` > `screen-256color` (italics/undercurl)
- `set-clipboard on` + `copy-command 'pbcopy'`
- Add undercurl overrides for LSP
- Verify terminal supports OSC 52 + undercurl

### zsh
- Profile with `zprof`
- Lazy-load NVM **or** switch to fnm (1-2ms vs 400ms)
- Use async prompt (Starship/p10k)
- Defer non-critical plugins (zinit turbo)
- Target < 100ms startup

### Node Mgmt
- **Best perf:** fnm
- **Best features:** volta
- **Keep NVM?** Must lazy-load

---

## Sources

- tmux clipboard macOS (OSC 52, pbcopy integration)
- Terminal capabilities (tmux-256color, undercurl, italics)
- NVM lazy-loading patterns, fnm/volta alternatives
- zsh profiling (zprof, benchmarking techniques)

Web searches conducted 2025-12-30.
