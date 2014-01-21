#!/bin/sh


targetFile=/etc/security/limits.conf

nofilehard="hard nofile 65536"
nofilesoft="soft nofile 65536"
corehard="hard core unlimited"
coresoft="soft core unlimited"
stackhard="hard stack 32768"
stacksoft="soft stack 32768"

profileFile=/etc/profile
echo "ulimit -u 10000" >> $profileFile

while read currentline
do
if [[ $currentline == *$nofilehard* ]]
then
	foundnofilehard=TRUE
	continue
fi 
if [[ $currentline == *$nofilesoft* ]]
then
        foundnofilesoft=TRUE
        continue
fi
if [[ $currentline == *$corehard* ]]
then
        foundcorehard=TRUE
        continue
fi
if [[ $currentline == *$coresoft* ]]
then
        foundcoresoft=TRUE
        continue
fi
if [[ $currentline == *$stackhard* ]]
then
        foundstackhard=TRUE
        continue
fi
if [[ $currentline == *$stacksoft* ]]
then
        foundstacksoft=TRUE
        continue
fi
done < $targetFile

cp $targetFile $targetFile.BAK

if [[ $foundnofilehard == TRUE ]]
then
	echo found entry do nothing
else
	echo \* $nofilehard >> $targetFile
fi
if [[ $foundnofilesoft == TRUE ]]
then
        echo found entry do nothing
else
        echo \* $nofilesoft >> $targetFile
fi
if [[ $foundcorehard == TRUE ]]
then
        echo found entry do nothing
else
        echo \* $corehard >> $targetFile
fi

if [[ $foundcoresoft == TRUE ]]
then
        echo found entry do nothing
else
        echo \* $coresoft >> $targetFile
fi
if [[ $foundstackhard == TRUE ]]
then
        echo found entry do nothing
else
        echo \* $stackhard >> $targetFile
fi
if [[ $foundstacksoft == TRUE ]]
then
        echo found entry do nothing
else
        echo \* $stacksoft >> $targetFile
fi

