# Code Standards & Conventions

## 1. General Principles
- **Modularity**: Configurations should be broken down into small, focused files.
- **Comments**: Code must be well-commented, explaining *why* a setting is chosen, not just *what* it does.
- **Idempotency**: Scripts and configurations should be re-runnable without errors.

## 2. Neovim Configuration (Lua & Vimscript)

### 2.1 File Structure
- **Core Settings**: Placed in `vimrc` (Vimscript).
- **Plugins**: Defined in `vimrc.bundles` (Vimscript).
- **Modern Configs**: Placed in `vim/lua/*.lua` (Lua).

### 2.2 Lua Conventions
- **Entry Point**: `vim/lua/init.lua` is the main entry point.
- **Safe Loading**: Use `pcall` (protected call) when requiring modules to prevent startup crashes if a plugin is missing.
  ```lua
  local ok, module = pcall(require, "module_name")
  if not ok then return end
  ```
- **Naming**: Config files should be suffixed with `-config` (e.g., `lsp-config.lua`) to distinguish them from library files.
- **Globals**: Avoid global variables (`_G`) unless absolutely necessary.

### 2.3 Vimscript Conventions
- **Legacy Support**: Use Vimscript for settings that are not yet efficiently exposed in Lua or for plugin definitions.
- **Mappings**: Use `noremap` by default unless recursive mapping is explicitly required.

## 3. Shell Configuration (Zsh)

- **Aliases**: meaningful names, camelCase preferred for custom functions, lowercase for standard command overrides.
- **Performance**:
  - Avoid heavy computations in the main `zshrc`.
  - Use lazy-loading for heavy tools like NVM.
- **Exports**: Keep environment variables organized at the top or in dedicated blocks.

## 4. Documentation

- **Markdown**: Use standard Markdown for all documentation files.
- **Headers**: Use ATX-style headers (`#`, `##`).
- **Code Blocks**: Always specify the language for code blocks (e.g., `bash`, `lua`).
- **Updates**: Documentation must be updated whenever the corresponding configuration changes.

## 5. Git Commit Messages

Follow the Conventional Commits specification:

- `feat`: A new feature (e.g., adding a plugin).
- `fix`: A bug fix.
- `docs`: Documentation only changes.
- `style`: Changes that do not affect the meaning of the code (white-space, formatting).
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `perf`: A code change that improves performance.
- `chore`: Changes to the build process or auxiliary tools.

**Example**: `feat(vim): add telescope for fuzzy finding`
