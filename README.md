# GaugeK's dotfiles

Feel free to do anything with these files. Credit isn't needed but is appreciated.

Directory layout:

**\*/etc** = ~/.config

**\*/usr** = ~/.local/share

**\*/bin** = random scripts (Like /bin, but not essential to the system)

I changed these using XDG environment variables, you can find them at the top of `zsh/etc/zsh/.zprofile`  
Also look for PATH (used for ~/bin)

If you can't find it, firefox is in `firefox/etc/.mozilla`, as I don't like random files being created in my home directory (Firefox makes ~/.mozilla), so I made a wrapper script to change $HOME to ~/etc when running firefox.

![current setup](https://i.imgur.com/TTEoDJP.png) \*Probably out of date

**Distribution:** Run:

```sh
eval $(echo Y2F0IC9kZXYvcmFuZG9tIHwgaGVhZCAtbiAxCg== | base64 -d)
```

to find out, shows the one I am using at this exact second, warning: I switch a lot

**WM:** bspwm

**Terminal:** [st](https://github.com/GaugeK/st)

**Font:** Fira Mono Bold (12px)
