export times=0 delay=0.1 limit=5
c='zsh -ic "true"'
#c='dash -c "/bin/sleep 0.05"'

echo "ms, ${times}x, ${delay}s between"
echo "cmd: [terminal] $c"
while read -r line; do
	eval $line
	sleep 0.1
done << EOF | sed -e 's/\x1b\[[0-9;]*m//g' -e 's/|/()/' -e 's/ *|.*//' -e 's/()/|/' | sort -V | column -t
#timetest xterm -e $c
#timetest urxvt -e $c
#timetest defaultst -e $c
timetest st -e $c
timetest wezterm start -- $c
#timetest alacrappy -e $c
#timetest xfce4-terminal -x $c
#timetest kitty $c
#timetest tilix -e $c
#timetest konsole -e $c
#timetest terminator -e '$c'
EOF
