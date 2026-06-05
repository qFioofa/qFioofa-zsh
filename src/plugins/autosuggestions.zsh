# Show autosuggestions automatically
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a9a9a9,underline"

# Use end of history for matching
ZSH_AUTOSUGGEST_STRATEGY=history

# Tab accepts the current autosuggestion; falls back to normal completion when
# there is no suggestion to accept.
_autosuggest_tab_complete() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle expand-or-complete
  fi
}
zle -N _autosuggest_tab_complete
bindkey '^I' _autosuggest_tab_complete
