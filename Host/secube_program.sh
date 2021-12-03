serials=`st-info --probe | grep openocd | cut -d' ' -f2-`

mkdir -p programmingLogs

IFS_back=$IFS
IFS='
'

echo "Found $(echo $serials | wc -w) st-links"

for serial in $serials
do
  openocd -c "set serial $serial; source secube_program.tcl" &> "programmingLogs/$serial.log" &
done

IFS=$IFS_back

wait