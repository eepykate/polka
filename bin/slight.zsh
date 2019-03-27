setopt prompt_subst

git_info() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}
    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    local GIT_DIR="$( git rev-parse --git-dir 2> /dev/null)"
    local -a DIVERGENCES
    local -a FLAGS

    [[ "$NUM_AHEAD" -gt 0 ]] && DIVERGENCES+=( "%{\e[36m%}⇡%{\e[0m%}$NUM_AHEAD" )
    [[ "$NUM_BEHIND" -gt 0 ]] && DIVERGENCES+=( "%{\e[36m%}⇣%{\e[0m%}$NUM_BEHIND" )
    [[ -n $GIT_DIR ]] && [[ -f $GIT_DIR/MERGE_HEAD ]] && FLAGS+=( "%{\e[33m%}⚡︎%{\e[0m%}" )
    [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]] && FLAGS+=( "%{\e[36m%}U%{\e[0m%}" )
    ! git diff --quiet 2> /dev/null && FLAGS+=( "%{\e[34m%}M%{\e[0m%}" )
    ! git diff --cached --quiet 2> /dev/null && FLAGS+=( "%{\e[35m%}S%{\e[0m%}" )

    local -a GIT_INFO
    [[ -n "$GIT_STATUS" ]] && GIT_INFO+=( "$GIT_STATUS" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "$GIT_LOCATION" )
    GIT_INFO+=( "±" )
    echo "${(j: :)GIT_INFO}"
}

time_since_last_command() {
    unset time_passed
    new_epoch="$(date +%s%3N)"
    [[ -n $epoch ]] && time_passed="$(( $new_epoch - $epoch ))" && time_passed="$(( $time_passed / 1000 ))" 
    #[[ $time_passed -ge 5 ]] && echo "$time_passed"
}

listdirs() {  dirs | grep -o "\(^~/\)\?\(^/\)\?[^/]*/[^/]*/[^/]*$" || dirs  }
ssh_info="$([[ "$SSH_CONNECTION" != '' ]] && echo "${USER}@$(hostname)   ")"
title() {  print -n -r $'\e]0;'$ssh_info$1$'\a'  }
title "$(dirs)"
chpwd() { title "$(dirs)" }
precmd() { title "$(dirs)"; time_since_last_command; unset epoch }
preexec() { title "$2"; epoch="$(date +%s%3N)" }

PS1=$'%(?.%{\e[34m%}.%{\e[31;1m%})$(listdirs)%{\e[0m%} %(!.%{\e[33m%}%}.%{\e[0m%})❯%{\e[0m%} '
RPS1=$'$(git_info)%{\e[0m%}$([[ $time_passed -ge 5 ]] && printf "%s" "\%\{\e[33m\%\} ${time_passed}s")'
