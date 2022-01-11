serials=`st-info --probe | grep "hla-serial" | tr -s ' ' | cut -d' ' -f3`



mkdir -p programmingLogs


IFS_back=$IFS
IFS='
'

echo "Found $(echo $serials | wc -w) st-links"

for serial in $serials
do
  serial_read=$(echo $serial | sed 's/[^[:xdigit:]]//g')
  echo $serial_read
  openocd -c "set serial $serial; set serial_read $serial_read; source secube_program.tcl" &> "programmingLogs/$serial_read.log" &
done

IFS=$IFS_back

wait