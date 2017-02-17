To solve the annoying problem of xfce4-power-manager not sleep the os
while lid close:

xfconf-query -c xfce4-power-manager -p
/xfce4-power-manager/logind-handle-lid-switch -n -t bool -s false
