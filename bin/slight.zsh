setopt prompt_subst
autoload -U colors && colors

git_info() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}
    local AHEAD="%{$fg[cyan]%}⇡NUM%{$reset_color%}"
    local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
    local MERGING="%{$fg[yellow]%}⚡︎%{$reset_color%}"
    local UNTRACKED="%{$fg[cyan]%}U%{$reset_color%}"
    local MODIFIED="%{$fg[blue]%}M%{$reset_color%}"
    local STAGED="%{$fg[magenta]%}S%{$reset_color%}"

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
    [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%{\033[38;5;15m%}$GIT_LOCATION%{$reset_color%}" )
    GIT_INFO+=( "%{\033[38;5;15m%}±" )
    echo "${(j: :)GIT_INFO}"
}

listdirs() {  dirs | grep -o "\(^~/\)\?\(^/\)\?[^/]*/[^/]*/[^/]*$" || dirs  }
ssh_info="$([[ "$SSH_CONNECTION" != '' ]] && echo "${USER}@$(hostname)   ")"
title() {  print -n -r $'\e]0;'$ssh_info$1$'\a'  }
title "$(dirs)"
chpwd() { title "$(dirs)" }
precmd() { title "$(dirs)" }
preexec() { title "$2" }

PS1='%(?.%{$fg[blue]%}.%{$fg[red]%})$(listdirs)%{$reset_color%} %(!.%{$fg[yellow]%}.%{$fg[default]%})❯%{$reset_color%} '
RPS1='$(git_info)%{$reset_color%}'
