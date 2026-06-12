# Show autosuggestions automatically
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a9a9a9,underline"

# Use end of history for matching
ZSH_AUTOSUGGEST_STRATEGY=history

# Tab no longer touches the autosuggestion — it just completes files in the
# current directory (bash-like). Accepting the autosuggestion is a separate key
# (Ctrl+Space), and Ctrl+Right accepts it word-by-word. Those bindings live in
# .zshrc, where Tab is re-applied *after* fzf-tab loads (fzf-tab rebinds ^I).
