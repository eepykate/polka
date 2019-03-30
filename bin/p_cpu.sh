#!/usr/bin/env bash

printf "<span font='FontAwesome 10'></span> "     #   
top -bn1 | grep "Cpu(s)" | \
	sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
	awk '{print 100 - $1"%"}'
