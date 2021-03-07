#!/bin/bash


if [ $# -ne 2 ]
	then
		echo 'Needs to supply argument'
		echo '  $1 = <hostname or ip>'
		echo '  $2 = <username>'
		exit 1
fi

set -x
ssh -i ./signed_cert_${2}.pub -i ./${2} ${2}@${1}
