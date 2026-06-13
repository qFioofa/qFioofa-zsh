# Show autosuggestions automatically
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a9a9a9,underline"

# Use end of history for matching
ZSH_AUTOSUGGEST_STRATEGY=history

# Tab (^I) must do plain file/directory completion only — it must never accept
# or leave behind the grey history suggestion. We clear the suggestion whenever
# a completion widget runs, so pressing Tab gives clean bash-like completion.
# Accepting the whole suggestion is a separate key (Ctrl+Space, see .zshrc).
# NOTE: this list overrides the plugin default, so the defaults are spelled out
# below and the completion widgets are appended.
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
  # zsh-autosuggestions defaults:
  history-search-forward
  history-search-backward
  history-beginning-search-forward
  history-beginning-search-backward
  history-substring-search-up
  history-substring-search-down
  up-line-or-beginning-search
  down-line-or-beginning-search
  up-line-or-history
  down-line-or-history
  accept-line
  copy-earlier-word
  # completion widgets, so Tab never touches the suggestion:
  expand-or-complete
  expand-or-complete-prefix
  complete-word
  menu-complete
  menu-expand-or-complete
)
