# Shell and history options.

HISTSIZE=2000
SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"

setopt APPEND_HISTORY          # Append rather than replace the history file.
setopt SHARE_HISTORY           # Import and append history across sessions.
setopt HIST_IGNORE_SPACE       # Ignore commands beginning with a space.
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicates when adding a command.
setopt HIST_SAVE_NO_DUPS       # Do not write duplicate entries.
setopt HIST_IGNORE_DUPS        # Ignore consecutive duplicate entries.
setopt HIST_FIND_NO_DUPS       # Skip duplicates during history searches.
setopt HIST_EXPIRE_DUPS_FIRST  # Expire duplicates first when trimming history.
setopt BANG_HIST               # Enable history expansion with !.
