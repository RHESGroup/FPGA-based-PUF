secubes=`ls /dev | grep ttyUSB`

mkdir -p puf_test_Logs

IFS_back=$IFS
IFS='
'

echo "Found $(echo $secubes | wc -w) secubes"

for secube in $secubes
do
  python3.7 -u puf_test.py "/dev/$secube" &> "puf_test_Logs/$secube.log" &
done

IFS=$IFS_back

wait