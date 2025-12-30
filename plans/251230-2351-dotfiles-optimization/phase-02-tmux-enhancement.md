# Phase 02: tmux Enhancement

## Context
- Parent: [plan.md](./plan.md)
- Research: [tmux-zsh-optimization](./research/researcher-02-tmux-zsh-optimization.md)
- Depends: [Phase 01](./phase-01-quick-fixes.md)

## Overview
- **Priority:** P1
- **Effort:** 20 min
- **Status:** Pending

Upgrade tmux terminal settings for modern Neovim features.

## Key Insights

1. `screen-256color` breaks italics and undercurl
2. `tmux-256color` + overrides required for LSP diagnostics undercurl
3. Focus events help vim detect window focus changes
4. tmux 3.2+ has native clipboard support

## Requirements

### Functional
- Switch to tmux-256color
- Enable undercurl support
- Add focus events for vim
- Add native clipboard config

### Non-functional
- Must work with iTerm2/WezTerm
- No breaking changes to existing workflow

## Related Code Files

| File | Action | Change |
|------|--------|--------|
| `tmux.conf:10` | Modify | Change screen-256color → tmux-256color |
| `tmux.conf:8` | Add | Undercurl overrides |
| `tmux.conf` | Add | Focus events, clipboard settings |

## Architecture

```
tmux.conf changes:
├── Terminal type: tmux-256color (was screen-256color)
├── Terminal overrides:
│   ├── RGB true color
│   ├── Undercurl (Smulx)
│   └── Colored underline (Setulc)
├── Focus events: on
└── Native clipboard: set-clipboard on
```

## Implementation Steps

### 1. Update terminal settings (lines 6-10)

Replace current terminal config:
```bash
# True colors mode
# Add truecolor support
set-option -ga terminal-overrides ",*:Tc"
# Default terminal is 256 colors
set -g default-terminal "screen-256color"
```

With enhanced config:
```bash
# Terminal settings
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Undercurl support (for LSP diagnostics)
set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
```

### 2. Add focus events (after line 72)
```bash
# Focus events for vim integration
set-option -g focus-events on
```

### 3. Add native clipboard (near line 60)
```bash
# Native clipboard (tmux 3.2+)
set -g set-clipboard on
```

### 4. Verify tmux version supports these features
```bash
tmux -V  # Should be 3.2+
```

## Todo List

- [ ] Backup current tmux.conf
- [ ] Change default-terminal to tmux-256color
- [ ] Add RGB terminal override
- [ ] Add undercurl overrides (Smulx, Setulc)
- [ ] Add focus-events on
- [ ] Add set-clipboard on
- [ ] Reload: `tmux source ~/.tmux.conf`
- [ ] Test italics: `echo -e "\e[3mitalic\e[0m"`
- [ ] Test undercurl: `printf '\e[4:3mUndercurl\e[0m\n'`
- [ ] Test LSP diagnostics in Neovim show curly underlines

## Success Criteria

- [ ] `tmux show -g default-terminal` returns `tmux-256color`
- [ ] Italics render correctly (not as reverse video)
- [ ] Undercurl renders as curly line (not straight)
- [ ] LSP warnings show colored undercurl in Neovim
- [ ] Focus events work (`:checkhealth` in nvim shows no warnings)

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Terminal not in terminfo | Low | No italics | Compile tmux-256color terminfo |
| Old tmux version | Low | Missing features | Upgrade tmux via brew |

## Security Considerations

None - these are cosmetic/UX changes.

## Next Steps

→ [Phase 03: zsh Optimization](./phase-03-zsh-optimization.md)
