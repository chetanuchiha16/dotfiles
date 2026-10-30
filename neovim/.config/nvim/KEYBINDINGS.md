# Neovim & Neovide Keybindings Cheatsheet

> **Leader Key:** `<Space>` (All `<leader>` shortcuts start by pressing the Spacebar)

---

## 1. Project Navigation & File Search

| Shortcut | Description | Plugin / Provider |
| :--- | :--- | :--- |
| `<leader><leader>` | **Find files** in current project | Fzf-Lua |
| `<leader>/` | **Live Grep** (search text across all files) | Fzf-Lua |
| `<leader>,` | **Switch open buffers** | Fzf-Lua |
| `<leader>fr` | **Resume** last file/grep search | Fzf-Lua |
| `<leader>fp` | **Projects picker** (switch workspaces) | Snacks.picker |
| `<leader>fs` | **Saved sessions** / workspaces | Auto-session |
| `<leader>sr` | **Project Search & Replace** (VS Code style UI) | grug-far.nvim |
| `<leader>sf` | **File Search & Replace** (scoped to current file) | grug-far.nvim |
| `<leader>sw` | **Search & Replace word under cursor** | grug-far.nvim |
| Visual `<leader>sr` | **Search & Replace visual selection** | grug-far.nvim |
| `<leader>e` | **Toggle File Explorer** (sidebar tree) | Snacks.explorer |
| `-` | **Open Oil file manager** (edit filesystem like a buffer) | Oil.nvim |

### Inside Search & Replace (`<leader>sr` / `<leader>sf`):
- **Inputs:** `Search:`, `Replace:`, `Files:` (glob filter e.g. `src/**`, `*.py`), `Flags:`
- **VS Code Equivalent Flags in `Flags:` field:**
  - `Alt + C` (Match Case) &rarr; Type `-s` in `Flags:`
  - `Alt + W` (Whole Word) &rarr; Type `-w` in `Flags:`
  - `Alt + R` (Plain String / No Regex) &rarr; Type `-F` in `Flags:`
  - Combine easily: e.g. `-sw` for whole word + case sensitive
- **Replace All:** `<localleader>r` (or `<Space>r`) executes replacement across all matches
- **Sync Line:** `<localleader>l` (or `<Space>l`) syncs only the current line under cursor back to file
- **Sync All:** `<localleader>s` (or `<Space>s`) syncs all remaining lines back to files (use after deleting lines with `dd`)
- **Refresh:** `<localleader>f` (or `<Space>f`) re-runs search & refreshes results
- **Help:** `g?` toggles the full built-in keybindings cheatsheet inside the buffer
- `<Enter>` on any match: Jump to that file and line
- `q` or `<Esc>`: Close floating search window

### Inside the File Explorer (`<leader>e`):
- `Ctrl + c` : **Set folder as workspace** (changes working directory to folder under cursor)
- `.` (dot) : **Focus view** on folder under cursor
- `<BS>` (Backspace) : **Go up** to parent directory
- `a` : **Create** new file (or folder if ending in `/`)
- `r` : **Rename** file/folder
- `d` : **Delete** file/folder
- `H` : **Toggle hidden files** (dotfiles)
- `I` : **Toggle ignored files** (`.gitignore`)

---

## 2. LSP, IntelliSense & Code Intelligence

| Shortcut | Description | Action |
| :--- | :--- | :--- |
| `K` | **Hover Documentation** (types, docstrings, signature) | `vim.lsp.buf.hover()` *(Press twice to enter window)* |
| `<C-LeftMouse>` | **Go to Definition** (like VS Code Ctrl+Click) | `vim.lsp.buf.definition()` |
| `gd` | **Go to Definition** (fuzzy picker if multiple) | Fzf-Lua LSP |
| `grr` | **Find References** across project | Fzf-Lua LSP |
| `gri` | **Find Implementations** (interfaces/traits) | Fzf-Lua LSP |
| `gra` | **Code Actions** (quick fixes, refactoring) | Fzf-Lua LSP |
| `<leader>D` | **Show Diagnostics float** (error/warning details) | `vim.diagnostic.open_float()` |
| `<leader>th` | **Toggle Inlay Hints** (Rust / TypeScript type annotations) | `vim.lsp.inlay_hint` |

---

## 3. Autocompletion & Suggestions (`blink.cmp`)

*Triggered automatically while typing in Insert mode:*

| Shortcut | Description |
| :--- | :--- |
| `<C-n>` or `<Down>` | **Next suggestion** (move down list) |
| `<C-p>` or `<Up>` | **Previous suggestion** (move up list) |
| `<C-y>` | **Accept suggestion** |
| `<C-e>` | **Close suggestions menu** |
| `<C-space>` | **Trigger completion** manually |

---

## 4. Editing, Comments & Multi-Cursor

| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + /` (or `Ctrl + _`) | Normal / Visual | **Toggle comment** line or selection (VS Code style) |
| `Alt + j` / `Alt + Down` | Normal / Visual / Insert | **Move line/selection down** |
| `Alt + k` / `Alt + Up` | Normal / Visual / Insert | **Move line/selection up** |
| `Alt + d` | Normal | **Multi-cursor:** select word / next occurrence |
| `Ctrl + Shift + l` | Normal | **Multi-cursor:** select all occurrences (VS Code style) |
| `Ctrl + Down` / `Ctrl + Up` | Normal | **Multi-cursor:** add vertical cursor column down/up |
| `<leader>cp` | Normal | **Copy absolute path** of current file |
| `<leader>cr` | Normal | **Copy relative path** of current file |

### Multi-Cursor Workflow (`vim-visual-multi`):
1. **Selecting:**
   - Put cursor on word and press `Alt + d` (repeating adds more matches) or `Ctrl + Shift + l` (all matches).
   - `q` : **Skip** next match.
   - `Q` : **Remove** current cursor.
2. **Editing:**
   - `c` : **Replace** selection (enters Insert mode; type replacement across all cursors).
   - `i` / `a` : **Insert** before / after selections.
   - `d` : **Delete** selections.
   - `~` : **Toggle case** (uppercase/lowercase).
3. **Exiting:**
   - `<Esc>` : Exit Insert mode.
   - `<Esc>` (again) : Clear all cursors and return to single-cursor mode.

---

## 5. Surround Text Objects (`nvim-surround`)

Manipulate quotes, brackets, parentheses, and HTML/XML tags around words, lines, or selections.

| Mode | Shortcut | Action | Example |
| :--- | :--- | :--- | :--- |
| **Normal (Add)** | `ys{motion}{char}` | **Add** surrounding delimiter around motion | `ysiw"` on `word` → `"word"` |
| **Normal (Add Line)** | `yss{char}` | **Add** surrounding delimiter around entire line | `yss"` → `"entire line"` |
| **Normal (Change)** | `cs{old}{new}` | **Change** surrounding delimiter to another | `cs"'` on `"word"` → `'word'` |
| **Normal (Delete)** | `ds{char}` | **Delete** surrounding delimiter | `ds"` on `"word"` → `word` |
| **Visual (Add)** | `S{char}` | **Add** delimiter around highlighted text | Select `text`, press `S)` → `(text)` |

### Practical Examples:
* `ysiw)` : Surround inner word with parentheses → `(word)`
* `ysiw"` : Surround inner word with double quotes → `"word"`
* `ysiw'` : Surround inner word with single quotes → `'word'`
* `ysiw}` : Surround inner word with curly braces → `{word}`
* `cs"'` : Change `"word"` to `'word'`
* `cs'"` : Change `'word'` to `"word"`
* `cs)]` : Change `(word)` to `[word]`
* `ds"` : Delete quotes from `"word"` → `word`
* `ds)` : Delete parens from `(word)` → `word`
* `dsf` : **Delete surrounding function call**: `func(something)` → `something`
* `csf` : **Change surrounding function name**: `func(something)` → prompt for new func name
* `dst` : Delete surrounding HTML/XML tag: `<div>hello</div>` → `hello`
* `cst<p>` : Change surrounding tag to `<p>`

> **Spacing Tip:**
> - Closing delimiter `)` `]` `}` adds **no space**: `(word)`
> - Opening delimiter `(` `[` `{` adds **an extra space inside**: `( word )`

---

## 6. Precise Deletions & Text Objects (`dt`, `df`, `di`, `da`)

Perform surgical edits and deletions without manually selecting text or backspacing.

### A. "Till" (`t`) and "Find" (`f`) Motions
*Operates from cursor position up to the target character on the line. Targets **any character**: symbols (`(`, `=`, `,`), quotes, letters, numbers, or spaces (`f<Space>`).*

| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `dt)` | **Delete till `)`** | Deletes from cursor **up to** `)` (leaves `)` intact). Great for clearing remaining arguments in `foo(a, |b, c)`. |
| `ct)` | **Change till `)`** | Deletes up to `)` and enters **Insert mode** immediately. |
| `yt)` | **Yank till `)`** | Copies text from cursor up to `)` into clipboard. |
| `dt,` | **Delete till `,`** | Deletes up to next comma. |
| `df)` | **Delete through `)`** | Deletes from cursor up to **and including** `)`. |
| `df,` | **Delete through `,`** | Deletes from cursor through the comma. |
| `cf)` / `cf"` | **Change through char** | Deletes through `)` or `"` and drops into Insert mode. |
| `yf"` / `yf)` | **Yank through char** | Copies text from cursor through `"` or `)`. |
| `vf)` / `vf"` | **Select through char** | Visually highlights text from cursor through `)` or `"`. |
| `dT(` / `dF(` | **Delete back till / through `(`** | Deletes backwards from cursor up to or through `(`. |
| `T{char}` | **Backward till** | Jumps backward to one character after `{char}`. |
| `;` / `,` | **Repeat search forward / backward** | Repeats the last `f`, `F`, `t`, or `T` jump. |
| `{N}f{char}` | **Count jump** | Jump to N-th occurrence (e.g. `2f,` jumps to 2nd comma; `d2f,` deletes through 2nd comma). |

---

### B. Text Objects: "Inside" (`i`) vs "Around" (`a`)
*Works anywhere inside the enclosure — cursor does **not** have to be on the delimiter:*

| Target | Inside (`di...` / `ci...`) | Around (`da...` / `ca...`) |
| :--- | :--- | :--- |
| **Parentheses `(...)`** | `di)` or `dib` *(clears inside parens)* | `da)` or `dab` *(deletes parens + contents)* |
| **Double Quotes `"..."`** | `di"` *(clears string contents)* | `da"` *(deletes string including quotes)* |
| **Single Quotes `'...'`** | `di'` *(clears string contents)* | `da'` *(deletes string including quotes)* |
| **Curly Braces `{...}`** | `di}` or `diB` *(clears block body)* | `da}` or `daB` *(deletes braces + body)* |
| **Square Brackets `[...]`** | `di]` *(clears array/slice contents)* | `da]` *(deletes brackets + contents)* |
| **HTML/XML Tags `<tag>...</tag>`** | `dit` *(clears tag contents)* | `dat` *(deletes entire tag + contents)* |
| **Words** | `diw` *(deletes word only)* | `daw` *(deletes word + trailing space)* |

> **Pro Tip with `c` (Change):**
> Replace `d` with `c` (e.g. `ci)`, `ci"`, `ct)`) to delete and instantly drop into **Insert mode** ready to type your replacement.

---

### C. Line & Block Yanking / Copying (`yy`, `2yy`, `y'a`)

| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `yy` | **Yank line** | Copies current line into clipboard. |
| `2yy` / `{N}yy` | **Yank N lines** | Copies 2 (or N) lines downward from cursor (e.g. `2yy` or `2y<Down>`). |
| `y'a` | **Yank to mark `a`** | Copies all lines between cursor and mark `a` (linewise). |
| `y$` / `Y` | **Yank to line end** | Copies from cursor to end of the line. |
| `yw` / `y2w` | **Yank word(s)** | Copies current word or next 2 words. |
| `p` / `P` | **Paste** | Paste after (`p`) or before (`P`) cursor. |

---

## 7. Fast Navigation & Motions (No More `jjjj` / `llll`)

### A. Horizontal Movement (Within a line)
| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `w` / `b` | **Word jump** | Jump to start of next / previous word. |
| `W` / `B` | **Big Word jump** | Jump across code symbols (`::`, `->`, `.`), jumping strictly by whitespace. |
| `e` | **End of word** | Jump to end of current/next word. |
| `f{char}` | **Find character forward** | Jumps directly to `{char}` (e.g. `f(` lands right on the paren). |
| `F{char}` | **Find character backward** | Jumps backward to `{char}`. |
| `;` / `,` | **Repeat character jump** | Repeats last `f`/`t` search forward / backward. |
| `^` / `$` | **Line start / end** | `^` jumps to first non-blank character; `$` jumps to line end. |
| `0` | **Column 0** | Jumps to absolute line start. |

---

### B. Vertical Movement (Across screen & file)
| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `Ctrl + d` / `Ctrl + u` | **Half-page scroll** | Smoothly scroll down / up half a screen. |
| `}` / `{` | **Paragraph / Block jump** | Jump down / up to the next empty line (skips entire functions/blocks). |
| `H` / `M` / `L` | **Screen Extremes** | Jump to **H**igh (top), **M**iddle, or **L**ow (bottom) of visible screen. |
| `zz` | **Center screen** | Recenter view so cursor line is in the middle of the screen (`zt` = top, `zb` = bottom). |
| `{number}G` | **Line number jump** | Jump directly to line number (e.g. `87G` jumps to line 87). |
| `gg` / `G` | **File Top / Bottom** | `gg` jumps to line 1; `G` jumps to last line. |
| `%` | **Matching Bracket** | Jump between matching `()`, `{}`, or `[]`. |

---

### C. Search & Jump History
| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `*` / `#` | **Word under cursor** | Jump to next / previous occurrence of word under cursor. |
| `/{pattern}` | **Quick search** | Type 2–3 letters + `<Enter>` to jump to any visible word. `n` = next, `N` = prev. |
| `Esc` / `Ctrl + [` | **Clear search highlight** | Dismiss `/` search highlights instantly. |
| `Ctrl + o` | **Jump Back** | Jump back to previous cursor position (across definitions, searches, files). |
| `Ctrl + i` | **Jump Forward** | Jump forward in jump list history. |
| `gi` | **Resume Insert** | Jump to last place you were inserting text and drop into Insert mode. |

---

### D. Marks & Quick Bookmarks (`ma`, `'a`, `` `a ``)

| Shortcut | Action | What it does |
| :--- | :--- | :--- |
| `ma` (or `m{a-z}`) | **Set mark** | Sets bookmark `a` at cursor. (Lowercase = file-local, Uppercase `mA` = global). |
| `'a` | **Jump to mark line** | Jumps to start of line of mark `a`. |
| `` `a `` | **Jump to exact mark** | Jumps to exact line and column where mark `a` was set. |
| `y'a` | **Yank to mark** | Copies all lines between cursor and mark `a`. |
| `d'a` | **Delete to mark** | Deletes all lines between cursor and mark `a`. |
| `:delmarks a` | **Remove mark** | Deletes mark `a` (`:delm!` clears all lowercase marks in file). |
| `:marks` | **List marks** | Lists all active marks (or browse with `:FzfLua marks`). |

---

## 8. Buffer & Tab Management

| Shortcut | Description |
| :--- | :--- |
| `Ctrl + PageDown` | **Next buffer / tab** |
| `Ctrl + PageUp` | **Previous buffer / tab** |
| `<leader>x` | **Close active buffer** |

---

## 9. Window Splits & Navigation

| Shortcut | Description |
| :--- | :--- |
| `Ctrl + h` | Focus **left window** |
| `Ctrl + l` | Focus **right window** |
| `Ctrl + j` | Focus **lower window** |
| `Ctrl + k` | Focus **upper window** |
| `:vsplit` / `:split` | Create vertical / horizontal split |
| `:close` | Close current window split |

---

## 10. Integrated Terminal

| Shortcut | Mode | Description |
| :--- | :--- | :--- |
| `Ctrl + \`` (Ctrl + Backtick) | Normal / Terminal | **Toggle floating terminal** in project root |
| `<leader>ag` / `Alt + a` | Normal / Terminal | **Toggle Antigravity (`agy`)** (`<leader>ag` in Normal, `Alt + a` in Terminal) |
| `<leader>fT` | Normal | **Open terminal in a new Tab** |
| `Double Ctrl + [` / `Double Esc` | Terminal | **Exit terminal mode** to scroll/navigate |
| `Single Ctrl + [` / `Esc` | Terminal | **Send Escape** directly to CLI app (`agy`, `lazygit`, etc.) |
| `Ctrl + LeftClick` | Terminal | **Open file path or link** clicked in terminal directly |

---

## 11. Git Integration

| Shortcut | Description |
| :--- | :--- |
| `<leader>gg` | **Open LazyGit** full terminal UI |
| `<leader>gd` | **Diffview Open** (VS Code-like git staging and file diffs) |
| `<leader>gh` | **Git File History** (commits modifying current file) |
| `<leader>gH` | **Git Project History** (all commits) |
| `<leader>gl` | **Git Line History** (blame/log for current line or visual selection) |
| `<leader>gb` | **Git Browse** (open current file/repo on GitHub) |
| `<leader>gp` / `<leader>gP` | **Publish to GitHub** (VS Code style Private/Public picker) |
| `<leader>ru` | **CodeDiff:** unstaged changes |
| `<leader>rm` | **CodeDiff:** diff against `main` branch |
| `<leader>rh` | **CodeDiff:** diff against previous commit (`HEAD~1`) |

---

## 12. Debugging (DAP)

| Shortcut | Action |
| :--- | :--- |
| `<leader>b` | **Toggle Breakpoint** |
| `<leader>dc` | **Continue / Start debugging** |
| `<leader>dq` | **Terminate debugger** |
| `<leader>dr` | **Open Debug REPL** console |
| `<leader>dl` | **Run last debug configuration** |
| `<leader>dh` | **Debug hover** (inspect variable value) |
| `<Down>` | **Step Over** |
| `<Right>` | **Step Into** |
| `<Left>` | **Step Out** |
| `<Up>` | **Restart Frame** |

---

## 13. Neovide GUI Extras

* **Workspace Restore:** Restores previous workspace and window size automatically on launch.
* **Font scaling:** In Neovide, use `Ctrl + +` / `Ctrl + -` to dynamically increase or decrease font size.
* **Cheatsheet Shortcut:** `<leader>?` opens this cheatsheet directly inside Neovim.
