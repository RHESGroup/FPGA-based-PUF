secubes=`ls /dev | grep ttyUSB`

mkdir -p FPGAprogrammingLogs

IFS_back=$IFS
IFS='
'

echo "Found $(echo $secubes | wc -w) secubes"

for secube in $secubes
do
  python3.7 fpga_prog.py "/dev/$secube" &> "FPGAprogrammingLogs/$secube.log" &
done

IFS=$IFS_back

wait