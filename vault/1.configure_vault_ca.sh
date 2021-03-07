#!/bin/bash

set -x

vault write ssh-client-signer/config/ca generate_signing_key=true 
