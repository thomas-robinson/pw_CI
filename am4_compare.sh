#!/bin/sh

i=1
n=154

while [ ${i} -le ${n} ]
 do
  fname=`sed -n ${i}p /contrib/file_list_am4.txt`
  diff ${1}/${fname} ${2}/${fname} 
  i=$[${i}+1]
 done
