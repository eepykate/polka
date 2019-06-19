setopt prompt_subst
autoload -Uz add-zsh-hook

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
	! git diff --cached --quiet 2> /dev/null && FLAGS+=( "%{\e[35m%}S%{\e[0m%}" )
	! git diff --quiet 2> /dev/null && FLAGS+=( "%{\e[34m%}M%{\e[0m%}" )
	[[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]] && FLAGS+=( "%{\e[36m%}U%{\e[0m%}" )

	local -a GIT_INFO
	[[ -n "$GIT_STATUS" ]] && GIT_INFO+=( "$GIT_STATUS" )
	[[ -n ${DIVERGENCES} ]] && GIT_INFO+=( "${(j:-:)DIVERGENCES}" )
	[[ -n ${FLAGS} ]] && GIT_INFO+=( "${(j:-:)FLAGS}" )
	GIT_INFO+=( "$GIT_LOCATION" )
	GIT_INFO+=( "±" )
	echo "${(j: :)GIT_INFO}"
}

lastcommit() {
	lastcommit="$(git show -s --format=%at HEAD)"

	current_epoch="$(date +%s)"
	[[ -n $lastcommit ]] || return
	ts="$(( $current_epoch - $lastcommit ))" && tp="$(( $tp / 1000 ))" 
	[[ $ts -ge 5 ]] || return
	local H=$(($ts/60/60%24));   local M=$(($ts/60%60));   local S=$(($ts%60))
	if [[ $H -ne 0 ]]; then; timesincelastcommit="${H}h ${M}m ${S}s"; elif [[ $M -ne 0 ]]; then; timesincelastcommit="${M}m ${S}s"; else; timesincelastcommit="${S}s"; fi
	echo "$timesincelastcommit"
}

time_since_last_command() {
	unset time_passed tp 
	new_epoch="$(date +%s%3N)"
	[[ -n $epoch ]] || return
	tp="$(( $new_epoch - $epoch ))" && tp="$(( $tp / 1000 ))" 
	[[ $tp -ge 5 ]] || return
	local H=$(($tp/60/60%24));   local M=$(($tp/60%60));   local S=$(($tp%60))
	if [[ $H -ne 0 ]]; then; time_passed="${H}h ${M}m ${S}s"; elif [[ $M -ne 0 ]]; then; time_passed="${M}m ${S}s"; else; time_passed="${S}s"; fi
}

listdirs() {  dirs | grep -o "\(^~/\)\?\(^/\)\?[^/]*/[^/]*/[^/]*$" || dirs  }
ssh_info="$([[ "$SSH_CONNECTION" != '' ]] && echo "${USER}@$(hostname)   ")"
title() {  print -n -r $'\e]0;'$ssh_info$1$'\a'  }
title "$(dirs)"
# slight_chpwd() { title "$(dirs)" }
# slight_precmd() { title "$(dirs)"; time_since_last_command; unset epoch }
# slight_preexec() { title "$2"; epoch="$(date +%s%3N)" }
# add-zsh-hook chpwd slight_chpwd
# add-zsh-hook precmd slight_precmd
# add-zsh-hook preexec slight_preexec

color="4"
[[ $color = 1 ]] && false="3" || false="1"

PS1=$'%(?.%{\e[3${color};1m%}.%{\e[3${false};1m%})$(listdirs)%{\e[0m%} %(!.%{\e[33m%}%}.%{\e[0m%})❯%{\e[0m%} '
#RPS1=$'$(git_info)%{\e[0m%} %{\e[33m%}${time_passed}%{\e[0m%}'
