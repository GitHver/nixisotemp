
# Terminal navigation

Before you go any further, it is best to get a bit more familiar with the terminal, as to not get lost when trying to navigate your system

### Why use the terminal



### File managers - Yazi

Yazi is a very advanced, batteries included terminal file manager. A good terminal file manager can change the terminal experience from tedious to blissful. Since all a Unix system is is files and directories (not really), having a good way to navigate files is a must

Yazi comes with tons of integrations with modern terminal utils like zoxide and fzf. It even has image previews (provided that your terminal environment supports it).

You can press `o` to open files with their default method (edit, unzip, view, etc), `.` to show hidden files, `a` to create files (if it ends in `/` the it becomes a directory), `r` to rename files, `Space` to toggle select files, `y`, `p` and `x` to yank (copy), paste and cut respectively, with the capital versions `Y` and `X` undoing their selections. `q` is to quit.

### Text editors - Helix

Helix, a "post-modern modal text editor", is a great terminal text editor for beginners and power-users alike. With it being a 'modal' text editor, it has modes. When you open Helix it starts on `NORMAL` mode, where you can do many things such as use `x` to select lines, `d` to delete under the cursor or the current selection, `o` and `O` to create new lines below and above respectively, `Space` then `f` to open the file picker fuzzy finder and many more.

Helix has many modes, but the most important on is of course `INSERT` mode. you can enter it by pressing `i` or `a` to insert or append the current character, or with `I` or `A` to got to the start or the end of the current line.

To exit, press `Escape`  to go back to `NORMAL` mode and the hit `:` to start a command at the bottom line. The command to exit is `:q`, short for `:quit`. To save changes `:w`, short for `:write` writes the current changes to the file. If you need to exit without saving changes then use`:q!`. To save and exit `:wq` or `:x` is the shorthand for `:write-quit`.

### Multiplexers - zellij

Right now you are in a Zellij session, you can see it by the text instructions at the bottom. Zellij is a terminal multiplexer program, allowing you to have multiple panes (terminal instances) making multitasking and just usage in general more easy and understandable.

press `alt`+`n` to create a new pane, you use `alt`+(`←↓↑→` or `HJKL`) to move between panes. `ctrl`+`p` goes into pane mode where you can press `x` to close the pane you are currently on. Just cycle through the modes available to see all options you can use. `ctrl`+`g` locks the interface, stopping Zellij from taking any other input, so if a program you use has conflicting keybinds, you can disable Zellij for to interact with the other program as Zellij always takes priority.

### Navigation tools

#### ls - eza

#### cd - zoxide

#### grep - ripgrep

#### fuzzy finder

### Others

#### fetch

#### btop

#### pipes