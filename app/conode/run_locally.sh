#!/bin/bash

DBG=${2:-1}
KEY_DIR=local_keys
KEYS=$KEY_DIR/key
HOSTLIST=$KEY_DIR/hostlist
NUMBER=${1:-2}
rm -f $HOSTLIST

rm -rf $KEY_DIR
mkdir $KEY_DIR

for a in $( seq 1 $NUMBER ); do
  PORT=$(( 2000 + ( $a - 1 ) * 10 ))
  ./conode keygen localhost:$PORT -key $KEYS$a
done
cat $KEYS*.pub >> $HOSTLIST

./conode build $HOSTLIST

for a in $( seq 2 $NUMBER ); do
  ./conode -debug $DBG run -key $KEYS$a &
done
./conode -debug $DBG run -key ${KEYS}1
