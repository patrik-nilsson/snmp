#!/bin/bash
#Hämta informationen från UPS:en och stoppa in informationen i filen "Stuff"
Stuff="`snmpwalk -nO -m ALL -v2c -c public 172.20.80.204 $1 2>/dev/null | awk '{print $1,$4}'`"
if [ $? -gt 0 ]; then
        echo "Error in snmpwalk!"
        exit 4 
fi
#Sätt in de två värdena från "Stuff" i var sin fil; "things" och "values".

while read -r
do
	echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
	echo -n " "
done <<< "$Stuff"

exit 0

#echo $Stuff | awk '{print $1}' > things
#cat Stuff | awk '{print $2}' > values

#Nödvändiga variablar
Counter=1
Counter2=0
#Values=`cat values`
echo " "
#Loopen går genom filen "values", rad för rad, och hämtar varje gång data från motsvarande rad (Med hjälp av Counter variabeln) i filen "things". Sedan skriver loopen ut värdena efter varandra, separerade med ett kolon.
SaveIFS="$IFS"
#iIFS=''
#xit 0
IFS=''
for i in "$Stuff"; do
	IFS="$SaveIFS"
	#tings=`sed -n '{$Counter}p' things`
	#tings=`printf $i | awk '{print $Counter}'`	
	#others=`printf $i | awk '{print $Counter}'`
	echo -n "$i" | cat -A # | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
	echo -n " "
break
	#tings=`printf "$Stuff" | awk '{print $1}' | tail -n+$Counter  | head -n1 | sed 's/UPS-MIB::ups//'`
	#others=`printf "$Stuff" | awk '{print $2}'`
########if [ $Counter2 -lt 1 ]; then	
########	printf "$i:" | sed 's/UPS-MIB::ups//'
########	Counter2=$((Counter2+1))
########else
########	printf "$i "
########	Counter2=$((Counter2-1))
########fi
########Counter=$((Counter+2))
done
IFS="$SaveIFS"
echo " "
#Gammal kod som inte används direkt.
#snmpwalk -nO -m ALL -v2c -c public 172.20.80.204 $1 2>/dev/null | awk '{print $1}' > things
#Things=`cat things`
#for i in $Things; do
#	echo $i | sed 's/UPS-MIB::ups//'
#done

#Felhantering om man skriver in felaktigt värde vid start av skriptet.
exit 0
