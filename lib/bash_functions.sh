minutes_since_last_commit() {
  now=`date +%s`
  last_commit=`git log --pretty=format:'%at' -1`
  seconds_since_last_commit=$((now-last_commit))
  minutes_since_last_commit=$((seconds_since_last_commit/60))
  echo $minutes_since_last_commit
}

grb_git_prompt() {
  local g="$(__gitdir)"
  if [ -n "$g" ]; then
    local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
    if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 31 ]; then
      COLOR=${RED}
    elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
      COLOR=${YELLOW}
    else
      COLOR=${GREEN}
    fi
    local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m${BRIGHT_CYAN}"
    # The __git_ps1 function inserts the current git branch where %s is
    local GIT_PROMPT=$(__git_ps1 "(${SINCE_LAST_COMMIT}|%s)")
    echo ${GIT_PROMPT}
  fi
}

rvm_version() {
  local RVM=`~/.rvm/bin/rvm-prompt i v g`
  echo ${RVM//ruby-/}
}

set_prompt() {
  export PS1="${BRIGHT_BLUE}\w${BRIGHT_CYAN}$(grb_git_prompt) ${BRIGHT_YELLOW}\$(rvm_version) ${YELLOW}\$ ${NORMAL}"
}
