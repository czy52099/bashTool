#!/bin/sh
# get log

function logget()
{
    logfile=$1
    tmpcmd=cmd`date +%Y%m%d%H%M%S`
    echo grep -n \'$keywordtmp\' "$logfile.log |grep $kybg|head -n1|awk -F" \':\' \'{print \$1}\'>$tmpcmd
    num=`bash $tmpcmd`
    rm -f $tmpcmd
    rm -f gcmd
    if expr "$num" : "[0-9]*$" >&/dev/null; then
        FILE_NAME=`basename ${logfile}`_`date -d "$keywordtmp" +%Y%m%d%H%M`.log
        tail +$num $logfile.log > $FILE_NAME
    else
        echo "no data"
    fi
}
function keywordck()
{
    logname=$1
    grep -l "$keyword"  $logname.log
    ecd=$?
    maxtime=`date -d "$keyword $timein minutes" +'%Y/%m/%d %H:%M'`
    keywordtmp=$keyword
    time1=`date -d "$keywordtmp" +'%s'`
    time2=`date -d "$maxtime" +'%s'`
    while [ $ecd -ne 0 ]
    do
        keywordtmp=`date -d "$keywordtmp 1 minutes" +'%Y/%m/%d %H:%M'`
        time1=`date -d "$keywordtmp" +'%s'`
        ckkk=`expr $time2 - $time1`
        echo grep -l \"$keywordtmp\" $logname.log > gcmd
        bash gcmd
        ecd=$?
        if [ $time1 -gt $time2 ]
        then
            echo $logname.log is no exitst in $timein min.
            break
        fi
    done
    if [ $time1 -lt $time2 ]
    then
        logget $logname
    fi
    rm -f gcmd
}
export keyword=$1
if [ -z "$keyword" ]
then
    echo 'reset'
    exit 1
fi
date -d "$keyword" +%'Y/%m/%d %H:%M'
if [ $? -ne 0 ]
then
    echo 'rest'
    exit 1
fi
export timein=5
export kybg=$2
ls *log|sed 's/.log//' > files
while read filename
do
    keywordck $filename
done < files
rm -rf files
