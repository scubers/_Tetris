#!/bin/bash

name=$(ls |grep "podspec"|sed "s/\.podspec//g")

target_file="./$name/Classes/Core/$name.h"

echo "// 自动生成全部头文件" > $target_file

for file in $(find ./$name/Classes/Core -regex ".*\.h$"|sed "s/.*\///g");
do
    echo "#import <$name/$file>" >> $target_file

done