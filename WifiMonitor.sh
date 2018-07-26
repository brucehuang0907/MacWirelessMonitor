

clear

#Define colors
color=('\033[31m' '\033[33m' '\033[32m' '\033[36m')
DefaultColor='\033[0m'
HeaderColor='\033[7;49;96m'
SSIDFilter=""

  echo "Notes
1. To show only the interested SSID, run the script followed by SSID's name.
2. -55dBm above for all service and vehicles , -67dBm above for all other clients
3. Log file output at ./wifilog.txt
4. Ctrl+C to quit
5. Refresh every 6-7s"

# echo "${color[1]}You need admin right to run the script, your password needed to run 'sudo airport'.
# Input your password below,${DefaultColor[1]}"
read -rsp "Press any key to start or Ctrl-C to quit..." -n1 key

#Main loop
while [[ $key != "q" && $key != "Q" ]]
do


#Retrieve current connection information
  i=0
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | \
    sed -E 's/[[:space:]]+//g' > $TMPDIR/wifitemp10
  while IFS=":" read -r C1 C2
  do
    CurConnection[$i]=$C2
    (( i++ ))
  done < $TMPDIR/wifitemp10

  if [[ -n "$1" ]]
  then
    SSIDFilter="$1"
  fi

#Scan all SSID
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s "$SSIDFilter" > $TMPDIR/wifitemp20
  timestamp=$(date +"%H:%M:%S")
  date=$(date +"%y-%m-%d")

  cat $TMPDIR/wifitemp20 | egrep -v "SSID" | \
    egrep -e "$SSIDFilter"  | \
    sed -E 's/^[[:space:]]+//g' | \
    sed -E 's/[[:space:]]+/;/g' > $TMPDIR/wifitemp21
  #sort -t ";" -r -n -k3 $TMPDIR/wifitemp21 -o $TMPDIR/wifitemp22
  #cat $TMPDIR/wifitemp
  i=0
  max=0
  while IFS=";" read -r C1 C2 C3 C4 C5 C6 C7
  do
    #To handle SSID with space, wasn't done beautifully.
    ifMacC2=$(echo ${C2} | egrep -c -E '[a-z0-9]{2}(:[a-z0-9]{2}){5}')
    ifMacC3=$(echo ${C3} | egrep -c -E '[a-z0-9]{2}(:[a-z0-9]{2}){5}')
    ifMacC4=$(echo ${C4} | egrep -c -E '[a-z0-9]{2}(:[a-z0-9]{2}){5}')
    if [[ $ifMacC2 == 1 ]]
    then
      SSID[$i]="$C1"
      AP[$i]="$C2"
      RSSI[$i]="$C3"
      CHANNEL[$i]="$C4"
    elif [[ $ifMacC3 == 1 ]]
    then
      SSID[$i]="$C1 $C2"
      AP[$i]="$C3"
      RSSI[$i]="$C4"
      CHANNEL[$i]="$C5"
    elif [[ $ifMacC4 == 1 ]]
    then
      SSID[$i]="$C1 $C2 $C3"
      AP[$i]="$C4"
      RSSI[$i]="$C5"
      CHANNEL[$i]="$C6"
    else
      AP[$i]=""
    fi
    #echo "$i"
    (( i++ ))
  done < $TMPDIR/wifitemp21

  if [[ $i -lt 26 ]]; then
    max=$(( $i - 1 ))
  else
    max=25
  fi

  for i in $(seq 0 1 $max)
  do
    if [[ -n ${AP[$i]} ]]; then
      echo "${AP[$i]};${RSSI[$i]};${CHANNEL[$i]};${SSID[$i]}"
    fi
  done  > $TMPDIR/wifitemp22

  sort -t ";" -r -n -k2 $TMPDIR/wifitemp22 -o $TMPDIR/wifitemp23

  i=0
  while IFS=";" read -r C1 C2 C3 C4
  do
    AP[$i]="$C1"
    RSSI[$i]="$C2"
    CHANNEL[$i]="$C3"
    SSID[$i]="$C4"
    (( i++ ))
  done  < $TMPDIR/wifitemp23

  #Refresh display
  clear


#Descriptions
  echo "Monitoring Wi-Fi, sort AP by signal strength, $date, $timestamp"
  echo "P: Pause, Q: Quit, F: Enter a SSID to filter."
  printf "Current connection, AP:${color[0]}%s$DefaultColor, %sdBm, %sMbps, Noise:%sdB\n" ${CurConnection[11]} ${CurConnection[0]} ${CurConnection[7]} ${CurConnection[2]}
  echo "Connected;$timestamp;${CurConnection[11]};${CurConnection[0]};${CurConnection[7]};${CurConnection[2]}" >> wifilog.txt


#Header
  printf "$HeaderColor%-18s %-4s %-8s %-12s %-25s$DefaultColor\n" "AP" "dBm" "Channel" "Time" "SSID"

#Datas, ./wifilog.txt as alternative data output
  if [[ -z head ]]; then
    echo -e "Monitoring Wi-Fi, $date, $timestamp"
    echo "AP;dBm;Channel;Time;SSID" >> wifilog.txt
    head="done"
  fi
  for i in $(seq 0 1 $max)
  do
    if [[ -n ${AP[$i]} ]]; then
      if [[ i -lt 3 ]]; then
        printf "${color[i]}%-18s %-4s %-8s %-12s %-25s $DefaultColor \n"  "${AP[$i]}" "${RSSI[$i]}" "${CHANNEL[$i]}" "$timestamp" "${SSID[$i]}"
        echo "${AP[$i]};${RSSI[$i]};${CHANNEL[$i]};$timestamp;${SSID[$i]}"  >> wifilog.txt
      else
        printf "${color[3]}%-18s %-4s %-8s %-12s %-25s$DefaultColor\n"  "${AP[$i]}" "${RSSI[$i]}" "${CHANNEL[$i]}" "$timestamp" "${SSID[$i]}"
        echo "${AP[$i]};${RSSI[$i]};${CHANNEL[$i]};$timestamp;${SSID[$i]}"  >> wifilog.txt
      fi
    fi
  done

  read -t 3 key
  case "$key" in
    [pP])
      echo "Paused for 5 mins, press any key to continue...."
      read -t 300 key
      key=""
      ;;
    [fF])
      read -t 10 -p "Enter SSID to filter:" SSIDFilter
      key=""
      ;;
  esac
done
