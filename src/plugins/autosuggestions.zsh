# Show autosuggestions automatically
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a9a9a9,underline"

# Use end of history for matching
ZSH_AUTOSUGGEST_STRATEGY=history

# Tab accepts the current autosuggestion; otherwise falls back to fzf-tab's
# completion menu when available, or plain completion as a last resort.
# NOTE: the actual `bindkey '^I' ...` lives in .zshrc and is applied *after*
# fzf-tab loads (fzf-tab rebinds ^I itself), so it must not be bound here.
_autosuggest_tab_complete() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  elif (( ${+widgets[fzf-tab-complete]} )); then
    zle fzf-tab-complete
  else
    zle expand-or-complete
  fi
}
zle -N _autosuggest_tab_complete
