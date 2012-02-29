#!/bin/bash
# 

## options
OPTIND=1
while getopts hnvVdq opt ; do
   case "$opt" in
        h) usage; exit;;
        v) VERBOSE=1;;
        d) DEBUG=1;;
        q) QUIET=1;;
        n) TESTING=1;;
        V) echo "$(basename $0) - $VERSION"; exit;;
   esac
done
shift $(($OPTIND - 1))
 
function do_debug () { [ $DEBUG ] && echo "[debug] $@" >&2 || false; }
#do_debug bla bla in debug
#do_debug mode debug || echo mode not debug
 
function do_err () { cal=`caller 0`;echo "E: (line: $cal) $@" >&2; exit 1;  }
#do_err This is an error test
 
function do_warn () { echo "E: $@";  }
#do_warn This is an error test
 
function do_print () { [ -z $QUIET ] && echo "$@"; }
#do_print this is a test
 
function do_printf () { [ -z $QUIET ] && printf "$@"; }
#do_printf "%10s_%20s_%-10s_%s\n" this is a test

# MAIN ####################################################

URL="http://erep.cyberp.fr/top.php?forum=1&groupe=13"
DIR=~/perso/webgames/erepublik/topp51
TIMERETRY="5 minutes"
DATE="$(date +%Y%m%d-%H%M)"
FILE="$DIR/$DATE"
LOG=$DIR/log

if test ! -d $DIR
then
    mkdir -p $DIR
    test $? -ne 0 && do_err "Can't create dir '$DIR'"
fi

do_debug FILE=$FILE
do_debug LOG=$LOG

wget --quiet --output-document=$FILE $URL

if test $? -eq 0
then
    echo "[$DATE] get top DONE" >> $LOG
    do_debug wget DONE
else
    echo "[$DATE] get top FAILED ... retry in $TIMERETRY" >> $LOG
    do_debug wget FAILED
    rm -f $FILE
    at now + $TIMERETRY <<< "$0"
    do_debug $(atq)
fi




