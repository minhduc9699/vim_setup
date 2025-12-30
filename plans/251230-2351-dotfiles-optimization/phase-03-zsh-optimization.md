# Phase 03: zsh Optimization

## Context
- Parent: [plan.md](./plan.md)
- Research: [tmux-zsh-optimization](./research/researcher-02-tmux-zsh-optimization.md)
- Depends: [Phase 01](./phase-01-quick-fixes.md)

## Overview
- **Priority:** P1
- **Effort:** 20 min
- **Status:** Pending

Optimize zsh startup time via NVM lazy-loading.

## Key Insights

1. Standard NVM init adds 200-500ms to startup
2. Lazy-loading reduces this to ~50ms (first use triggers load)
3. Alternative: fnm (1-2ms) or volta (2-5ms) - but bigger change
4. Current zshrc has duplicate source lines (fixed in Phase 1)

## Requirements

### Functional
- Implement NVM lazy-loading
- Maintain nvm, node, npm, npx functionality
- Auto-switch node versions still works

### Non-functional
- Shell startup < 100ms
- No breaking changes to workflow
- First node command may have 200-400ms delay (acceptable)

## Related Code Files

| File | Action | Change |
|------|--------|--------|
| `zshrc:160-161` | Modify | Replace eager NVM load with lazy wrapper |
| `zshrc:172` | Modify | Include in lazy-load |

## Architecture

```
Current flow:
zshrc → load nvm.sh (400ms) → shell ready

New flow:
zshrc → define stubs (0ms) → shell ready
     └→ first node/npm/nvm call → load nvm.sh → execute command
```

## Implementation Steps

### 1. Profile current startup (baseline)
```bash
time zsh -i -c exit
# Or for function-level analysis:
# Add `zmodload zsh/zprof` at top, `zprof` at bottom of zshrc
```

### 2. Replace NVM loading block (lines 160-172)

Current code:
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
...
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
```

Replace with lazy-load version:
```bash
# NVM Lazy Loading (saves ~300ms startup)
export NVM_DIR="$HOME/.nvm"

# Lazy load wrapper functions
_load_nvm() {
  unset -f nvm node npm npx yarn pnpm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { _load_nvm && nvm "$@"; }
node() { _load_nvm && node "$@"; }
npm() { _load_nvm && npm "$@"; }
npx() { _load_nvm && npx "$@"; }
yarn() { _load_nvm && yarn "$@"; }
pnpm() { _load_nvm && pnpm "$@"; }
```

### 3. Verify startup improvement
```bash
time zsh -i -c exit  # Should be ~200-300ms faster
```

### 4. Test node commands work
```bash
node --version
npm --version
nvm ls
```

## Todo List

- [ ] Record baseline: `time zsh -i -c exit`
- [ ] Replace NVM block with lazy-load version
- [ ] Remove line 172 (bash_completion - now in lazy loader)
- [ ] Source new zshrc: `source ~/.zshrc`
- [ ] Verify startup improvement
- [ ] Test `node --version` works
- [ ] Test `npm install` works
- [ ] Test `nvm use` works
- [ ] Test `npx` works

## Success Criteria

- [ ] `time zsh -i -c exit` < 200ms (from ~400-500ms)
- [ ] `node --version` returns correct version
- [ ] `nvm use 18` works
- [ ] `npm install` works in projects
- [ ] No errors on shell startup

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| First node call slow | Expected | 200-400ms once | Acceptable tradeoff |
| Scripts using node at startup | Low | May fail | Add explicit load in script |
| Completion not working | Low | Minor UX | Completion loads on first use |

## Alternative: Migrate to fnm

If lazy-loading isn't enough, consider fnm (1-2ms):
```bash
# Install
brew install fnm

# Replace NVM block with:
eval "$(fnm env --use-on-cd)"

# Migrate node versions
fnm install 18
fnm use 18
fnm default 18
```

**Note:** This is a bigger change, keep as fallback option.

## Next Steps

→ [Phase 04: Neovim Consolidation](./phase-04-neovim-consolidation.md)
