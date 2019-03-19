setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
    [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.%{$fg[red]%}.%{$fg[yellow]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:' || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

    # Exit if not inside a Git repository
    ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

    # Git branch/tag, or name-rev if on detached head
    local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

    local AHEAD="%{$fg[cyan]%}⇡NUM%{$reset_color%}"
    local BEHIND="%{$fg[cyan]%}⇣NUM%{$reset_color%}"
    local MERGING="%{$fg[magenta]%}⚡︎%{$reset_color%}"
    local UNTRACKED="%{$fg[cyan]%}*%{$reset_color%}"
    local MODIFIED="%{$fg[blue]%}*%{$reset_color%}"
    local STAGED="%{$fg[magenta]%}*%{$reset_color%}"

    local -a DIVERGENCES
    local -a FLAGS

    local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
    fi

    local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
    fi

    local GIT_DIR="$( git rev-parse --git-dir 2> /dev/null)"
    if [ -n $GIT_DIR ] && [[ -f $GIT_DIR/MERGE_HEAD ]]; then
        FLAGS+=( "$MERGING" )
    fi

    if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        FLAGS+=( "$UNTRACKED" )
    fi

    if ! git diff --quiet 2> /dev/null; then
        FLAGS+=( "$MODIFIED" )
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        FLAGS+=( "$STAGED" )
    fi

    local -a GIT_INFO
    [ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
    [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
    [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
    GIT_INFO+=( "%{\033[38;5;15m%}$GIT_LOCATION%{$reset_color%}" )
    GIT_INFO+=( "%{\033[38;5;15m%}±" )
    echo "${(j: :)GIT_INFO}"
}

# Set the title to either the directory or the active program
title() {
    [[  $DISABLE_AUTO_TITLE == true ]] && return
  
	# Don't set title over serial console.
 	case $TTY in
	    /dev/tty[0-9]*) return;;
	esac

    print -n -r $'\e]0;'${hostname}$1$'\a'
}

# Displays the last 3 parent dirs in the current path
listdirs() {
    dirs | grep -o "\(^~/\)\?\(^/\)\?[^/]*/[^/]*/[^/]*$" || dirs 
}

# Sets the title to the current directory or the name of the current application
title "$(dirs)"
chpwd() { title "$(dirs)" }
precmd() { title "$(dirs)" }
preexec() { title "$2" }

# ❯

## Two Liner
#PS1='%(?.%{$fg_bold[blue]%}.%{$fg_bold[red]%})%1{│%}%{$reset_color%} $(ssh_info)%{$fg[blue]%}%~%u $(git_info)
#%(?.%{$fg_bold[blue]%}.%{$fg_bold[red]%})│%{$reset_color%} %(!.#.$)%{$reset_color%} '

## One Liner
# Has the current directory and # if you're root, $ if not on the left, with git info on the right
PS1='%(?.%{$fg[blue]%}.%{$fg[red]%})$(listdirs)%{$reset_color%} %(!.#.$)%{$reset_color%} '
RPS1='$(git_info)%{$reset_color%}'
