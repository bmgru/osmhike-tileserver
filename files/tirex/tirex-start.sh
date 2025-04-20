

#DEBUG="--debug"

# force it to show the start of processes
set -x

# it seems that if we add  --debug , the programs are started in foreground rather than background . So we add &
/usr/bin/tirex-backend-manager $DEBUG &
/usr/bin/tirex-master $DEBUG  &


