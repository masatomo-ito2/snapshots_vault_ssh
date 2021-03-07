#!/bin/bash

if [ $# -ne 1 ]
	then
		echo 'Needs to supply argument'
		echo '  $1 = <vault_username>'
	else	
		set -x
		unset VAULT_ADDR
		unset VAULT_NAMESPACE
		unset VAULT_TOKEN
		export VAULT_ADDR=https://vault-cluster.vault.11eaf0ae-df46-699b-81b5-0242ac110015.aws.hashicorp.cloud:8200
		export VAULT_NAMESPACE=admin
		export VAULT_TOKEN=$(vault login -field=token -method=userpass username=${1} password=${1})
		set +x
		vault token lookup
fi

