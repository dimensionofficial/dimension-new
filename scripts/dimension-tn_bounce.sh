#!/bin/bash
#
#
# arglist will be passed to the node's command line. First with no modifiers
# then with --hard-replay-blockchain and then a third time with --delete-all-blocks
#
# the data directory and log file are set by this script. Do not pass them on
# the command line.
#
# in most cases, simply running is sufficient.
#

pushd $EOSIO_HOME

if [ ! -f programs/nodeon/nodeon ]; then
    echo unable to locate binary for nodeon
    exit 1
fi

config_base=etc/eosio/node_
if [ -z "$EOSIO_NODE" ]; then
    DD=`ls -d ${config_base}[012]?`
    ddcount=`echo $DD | wc -w`
    if [ $ddcount -ne 1 ]; then
        echo $HOSTNAME has $ddcount config directories, bounce not possible. Set environment variable
        echo EOSIO_NODE to the 2-digit node id number to specify which node to bounce. For example:
        echo EOSIO_NODE=06 $0 \<options\>
        cd -
        exit 1
    fi
    OFS=$((${#DD}-2))
    export EOSIO_NODE=${DD:$OFS}
else
    DD=${config_base}$EOSIO_NODE
    if [ ! \( -d $DD \) ]; then
        echo no directory named $PWD/$DD
        cd -
        exit 1
    fi
fi
if [ ! -f programs/nodeon/nodeon ]; then
    echo unable to locate binary 
    
fi

bash $EOSIO_HOME/scripts/dimension-tn_down.sh
bash $EOSIO_HOME/scripts/dimension-tn_up.sh "$*"
