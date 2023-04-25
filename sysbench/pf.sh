#!/bin/sh

oc port-forward  -n lujs --address localhost "$(oc get service -n lujs --selector="planetscale.com/component=vtctld,planetscale.com/cluster=example" -o name | head -n1)" 15000 15999 &
process_id1=$!
oc port-forward  -n lujs --address localhost "$(oc get service -n lujs --selector="planetscale.com/component=vtgate,planetscale.com/cluster=example,!planetscale.com/cell" -o name | head -n1)" 15306:3306 &
process_id2=$!
oc port-forward  -n lujs --address 10.253.122.33 "$(oc get service -n lujs --selector="planetscale.com/component=vtadmin,planetscale.com/cluster=example" -o name | head -n1)" 14000:15000 14001:15001 &
process_id3=$!
sleep 2
echo "You may point your browser to http://localhost:15000, use the following aliases as shortcuts:"
echo 'alias vtctlclient="vtctlclient --server=localhost:15999 --logtostderr"'
echo 'alias mysql="mysql -h 127.0.0.1 -P 15306 -u user"'
echo "Hit Ctrl-C to stop the port forwards"
wait $process_id1
wait $process_id2
wait $process_id3
echo "end pf script!!!"

