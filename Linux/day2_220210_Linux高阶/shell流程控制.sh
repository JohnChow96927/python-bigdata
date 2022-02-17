-----------------------------------------------------------
if else

if：
if condition
then
    command1 
    command2
    ...
    commandN 
fi
 
写成一行：if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi


if else：
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi

if else-if else：
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi

例子：
a=10
b=20
if [ $a == $b ]
then
   echo "a 等于 b"
elif [ $a -gt $b ]
then
   echo "a 大于 b"
elif [ $a -lt $b ]
then
   echo "a 小于 b"
else
   echo "没有符合的条件"
fi




---------------------------------------------------

case语句

echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac