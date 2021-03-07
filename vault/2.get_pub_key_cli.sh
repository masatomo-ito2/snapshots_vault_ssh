#!/bin/bash

set -x

vault read -field=public_key ssh-client-signer/config/ca 
