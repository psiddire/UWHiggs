sleep 600
clean
rake Sys >& submit
bash < submit
sleep 1500
clean
rake SysBDT >& submit
bash < submit
sleep 1500
clean
