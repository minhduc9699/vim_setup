# Phase 01: Quick Fixes (High ROI)

## Context
- Parent: [plan.md](./plan.md)
- Research: [tmux-zsh-optimization](./research/researcher-02-tmux-zsh-optimization.md)

## Overview
- **Priority:** P1
- **Effort:** 15 min
- **Status:** ✅ Complete (automated tasks done, manual validation pending)

Quick, low-risk fixes with immediate impact.

## Key Insights

1. **Duplicate plugin** - nerdcommenter loaded at lines 10 AND 23 in vimrc.bundles
2. **Platform mismatch** - xclip (Linux) on Darwin should be pbcopy
3. **Duplicate sources** - p10k.zsh and fzf.zsh sourced twice in zshrc

## Requirements

### Functional
- Remove duplicate plugin declaration
- Fix tmux clipboard for macOS
- Remove duplicate source lines

### Non-functional
- Zero breaking changes
- Zero new dependencies

## Related Code Files

| File | Action | Change |
|------|--------|--------|
| `vimrc.bundles:23` | Delete | Remove duplicate nerdcommenter |
| `tmux.conf:64` | Modify | Replace xclip with pbcopy |
| `zshrc:164` | Delete | Remove duplicate p10k source |
| `zshrc:166` | Delete | Remove duplicate fzf source |

## Implementation Steps

### 1. Remove duplicate nerdcommenter (vimrc.bundles)
```diff
- Plug 'preservim/nerdcommenter'  " Line 23 - DELETE
```
Keep line 10, delete line 23.

### 2. Fix tmux clipboard (tmux.conf)
```diff
- bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "xclip -i -f -selection primary | xclip -i -selection clipboard"
+ bind -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "pbcopy"
```

### 3. Remove duplicate zshrc sources (zshrc)
Delete these duplicate lines:
- Line 164: `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh` (duplicate of line 147)
- Line 166: `[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh` (duplicate of line 149)

## Todo List

- [x] Delete line 23 in vimrc.bundles (duplicate nerdcommenter)
- [x] Change xclip to pbcopy in tmux.conf line 64
- [x] Delete duplicate p10k source at line 164 in zshrc
- [x] Delete duplicate fzf source at line 166 in zshrc
- [ ] Reload tmux config: `tmux source ~/.tmux.conf`
- [ ] Test clipboard: copy in tmux, paste in macOS
- [ ] Test vim: `:PlugStatus` shows no duplicates

## Success Criteria

- [x] `grep -c nerdcommenter vimrc.bundles` returns 1
- [ ] tmux yank copies to macOS clipboard
- [x] No duplicate source commands in zshrc
- [ ] Nvim starts without errors

## Risk Assessment

| Risk | Probability | Mitigation |
|------|-------------|------------|
| None | - | Minimal changes, easy rollback |

## Next Steps

→ [Phase 02: tmux Enhancement](./phase-02-tmux-enhancement.md)
