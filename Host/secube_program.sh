serials=`st-info --probe | grep " serial" | tr -s ' ' | cut -d' ' -f3 | sed "s/3f/ff/" | tr '[:lower:]' '[:upper:]' `

mkdir -p programmingLogs

echo $serials

IFS_back=$IFS
IFS='
'

echo "Found $(echo $serials | wc -w) st-links"

for serial in $serials
do
  openocd -d3 -c "set serial $serial; source secube_program.tcl" &> "programmingLogs/$serial.log" &
done

IFS=$IFS_back

wait