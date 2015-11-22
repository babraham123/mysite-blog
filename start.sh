NAME=myblog
USER=babraham
UID=myblog
MAINFILE=blog_server.js
LOGFILE=/var/log/forever/$NAME.log
OUTFILE=/var/log/forever/$NAME_stdout.log
ERRFILE=/var/log/forever/$NAME_stderr.log
LOGDIR=$(dirname $LOGFILE)
test -d $LOGDIR || mkdir -p $LOGDIR
cd /home/$USER/$NAME

forever start -a -l $LOGFILE -o $OUTFILE -e $ERRFILE --uid "$UID" $MAINFILE

forever list

