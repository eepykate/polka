setopt prompt_subst

git_info() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}
    local AHEAD="%{\e[36m%}⇡NUM%{\e[0m%}"
    local BEHIND="%{\e[36m%}⇣NUM%{\e[0m%}"
    local MERGING="%{\e[33m%}⚡︎%{\e[0m%}"
    local UNTRACKED="%{\e[36m%}U%{\e[0m%}"
    local MODIFIED="%{\e[34m%}M%{\e[0m%}"
    local STAGED="%{\e[35m%}S%{\e[0m%}"

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    local GIT_DIR="$( git rev-parse --git-dir 2> /dev/null)"
    local -a DIVERGENCES
    local -a FLAGS

    [[ "$NUM_AHEAD" -gt 0 ]] && DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
    [[ "$NUM_BEHIND" -gt 0 ]] && DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
    [[ -n $GIT_DIR ]] && [[ -f $GIT_DIR/MERGE_HEAD ]] && FLAGS+=( "$MERGING" )
    [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]] && FLAGS+=( "$UNTRACKED" )
    ! git diff --quiet 2> /dev/null && FLAGS+=( "$MODIFIED" )
    ! git diff --cached --quiet 2> /dev/null && FLAGS+=( "$STAGED" )

    local -a GIT_INFO
    [[ -n "$GIT_STATUS" ]] && GIT_INFO+=( "$GIT_STATUS" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%{\e[0m%}$GIT_LOCATION" )
    GIT_INFO+=( "%{\e[0m%}±" )
    echo "${(j: :)GIT_INFO}"
}

listdirs() {  dirs | grep -o "\(^~/\)\?\(^/\)\?[^/]*/[^/]*/[^/]*$" || dirs  }
ssh_info="$([[ "$SSH_CONNECTION" != '' ]] && echo "${USER}@$(hostname)   ")"
title() {  print -n -r $'\e]0;'$ssh_info$1$'\a'  }
title "$(dirs)"
chpwd() { title "$(dirs)" }
precmd() { title "$(dirs)" }
preexec() { title "$2" }

PS1=$'%(?.%{\e[34m%}.%{\e[31m%})$(listdirs)%{\e[0m%} %(!.%{\e[33m%}%}.%{\e[0m%})❯%{\e[0m%} '
RPS1=$'$(git_info)%{\e[0m%}'
