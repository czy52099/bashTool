#!/bin/sh
# curCsv.sh
# パラメータ1：ファイル名、 パラメータ2：作成したいデータ数
# inputファイルには改行しない
# 実行例：./curCsv.sh ファイル名 200
export file_name=$1
export datas=$2
function curreCsv(){
    kyomei=0
    while [ $kyomei -ne $datas ]
    do
        cat test.data >> $file_name
        echo '' >> $file_name
        kyomei=`expr 1 + $kyomei`
    done
}
if [ -z "$file_name" ]
then
    echo 'filename reset'
    exit 1
fi
if [ -s header.txt ]
then
    cat header.txt > $file_name
    echo '' >> $file_name
else
    echo 'header.txt no data'
    exit 1
fi
if [ -s test.data ]
then
    curreCsv
else
    echo 'test.data no data'
    exit 1
fi
