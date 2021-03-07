#!/bin/bash


if [ $# -ne 1 ]
	then
		echo 'Needs to supply argument'
		echo '  $1 = <public cert key>'
		exit 1
fi

set -x
ssh-keygen -Lf ${1}
 
