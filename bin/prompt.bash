red="\e[31m"
grn="\e[32m"
ylw="\e[33m"
cyn="\e[36m"
blu="\e[34m"
prp="\e[35m"
bprp="\e[35;1m"
rst="\e[0m"
bold="\e[1m"


git_info() {
    git rev-parse 2> /dev/null || return

    AHEAD="${cyn}⇡${NUM_AHEAD}${rst}"
    BEHIND="${cyn}⇣${NUM_BEHIND}${rst}"
    MERGING="${prp}︎⚡${rst}"
    UNTRACKED="${blu}*${rst}"
    MODIFIED="${blu}*${rst}"
    STAGED="${cyn}*${rst}"
    FLAGS=""
    DIVERGENCES=""


    # print the git branch  
    BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ "$BRANCH" = "HEAD" ]; then
        BRANCH="no branch"
    else
        BRANCH="$BRANCH"
    fi  

    NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_AHEAD" -gt 0 ]; then
        DIVERGENCES+=" ${AHEAD}${NUM_AHEAD}"
     fi

    NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
    if [ "$NUM_BEHIND" -gt 0 ]; then
        DIVERGENCES+=" ${BEHIND}${NUM_BEHIND}"
    fi

    if ! git diff --quiet 2> /dev/null; then
        FLAGS+=" ${MODIFIED}"
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        FLAGS+=" ${STAGED}"
    fi

    GIT_INFO="\033[38;5;15m±"
    GIT_INFO="${GIT_INFO} \033[38;5;15m${BRANCH}${rst}"
    #[ -n "$GIT_STATUS" ] && GIT_INFO+=( "$GIT_STATUS" )
    [[ -n "${DIVERGENCES}" ]] && GIT_INFO+="${DIVERGENCES}"
    [[ -n "${FLAGS}" ]] && GIT_INFO+="${FLAGS}"
    echo -e "${GIT_INFO}"
}


PS1='$(
    [ $? -eq 0 ] && color=4 || color=1
    [ -z "${PWD##$HOME*}" ] && pwd="~${PWD#$HOME}" || pwd="$PWD"

    printf "\[\e[0;3%sm\]$pwd\[\e[0m\] %s%s" "$color" "$(git_info)" " \$ "
)'

#    printf "\033[;3%sm$pwd\033[m %s%s" "$color" "$(git_info)" "\$ "


#printf "\033[1;3%sm│\033[m %s%s\n" "$color" "$pwd"
#printf "\033[1;3%sm│\033[m " "$color"


#PS1='$(
#    [ $? -eq 0 ] && color=4 || color=1;
#    [ -z "${PWD##$HOME*}" ] && pwd="~${PWD#$HOME}" || pwd="$PWD")\
#\e[0;3${color}m${pwd}\e[0;34m $(git_info) \e[0;34m\$ '
