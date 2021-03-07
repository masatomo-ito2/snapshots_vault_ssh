#!/bin/bash

set -x

curl -H "X-Vault-Namespace: admin" -X GET ${VAULT_ADDR}/v1/ssh-client-signer/public_key 
