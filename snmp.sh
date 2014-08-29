#!/bin/bash
#Hämta informationen från UPS:en och stoppa in informationen i filen "Stuff"
Stuff="$(snmpwalk -nO -m ALL -v2c -c public 172.20.80.204 2>/dev/null)"
Exitret=0
case $1 in
status)
	
Var=$(echo "$Stuff" | grep -E '(BatteryStatus|InputLineBads)')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
		echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
		echo -n " "
#Denna if-sats varnar om batteriet börjar ta slut.
		if [[ $REPLY == *upsBatteryStatus* ]]; then
			if [[ $REPLY != *batteryNormal* ]]; then
				echo "Battery is running Low!"
				Exitret=2
			fi
		fi
	done <<< "$Var"
;;
capacity)

Var=$(echo "$Stuff" | grep -E '(SecondsOnBattery|Estimated)' | awk '{print $1,$4,$5}')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
		echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
		echo -n " "
	done <<< "$Stuff"
;;
battery)

Var=$(echo "$Stuff" | grep -E '(BatteryVoltage|BatteryCurrent|BatteryTemp)' | awk '{print $1,$4}')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
	#Dessa if-satser kan ändras, tas bort eller läggas till ytterligare för att ta bort onödiga extra-siffror. 
	#Till exempel skrivs volten (i detta fallet) ut med en nolla för mycket
	#(för att det egentligen står 457.0 men punkten kommer inte med, så det blir 4570...).
		if [[ $REPLY == *upsBatteryVoltage* ]]; then
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/' -e s'/.$//'
			echo -n " "
		else
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
			echo -n " "
		fi
	done <<< "$Stuff"
;;
input)

Var=$(echo "$Stuff" | grep -E '(InpuetFrequency|InputVoltage|InputCurrent)' | awk '{print $1,$4}')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
		if [[ $REPLY == *upsInputFrequency* ]]; then
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/' -e s'/.$//'
			echo -n " "
		else
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
			echo -n " "
		fi
	done <<< "$Stuff"
;;
output)

Var=$(echo "$Stuff" | grep -E '(upsOutputVoltage|upsOutputCurrent|upsOutputPower|upsOutputPercentLoad|upsOutputFrequency)' | awk '{print $1,$4}')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
		if [[ $REPLY == *OutputPower* || $REPLY == *OutputFrequency* ]]; then
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/' -e s'/.$//'
			echo -n " "
		else
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
			echo -n " "
		fi
	done <<< "$Stuff"
;;
bypass)

Var=$(echo "$Stuff" | grep -E '(BypassFrequency|BypassVoltage)' | awk '{print $1,$4}')
	while read -r
	do
	#Cacti - Hämta data från "Stuff" och skriv ut den utan viss text och med mellanrum utbytande till kolon. Allt på en rad.
		if [[ $REPLY == *BypassFrequency* ]]; then
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/' -e s'/.$//'
			echo -n " "
		else
			echo -n "$REPLY" | sed -e 's/UPS-MIB::ups//' -e 's/ /:/'
			echo -n " "
		fi
	done <<< "$Stuff"
;;

*)
	echo "Invalid or Missng Argument!"
	exit 4
;;

esac
exit $Exitret
