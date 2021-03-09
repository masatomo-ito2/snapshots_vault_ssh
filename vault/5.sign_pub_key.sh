#!/bin/bash

set -x

# sign for dev
vault write -field=signed_key ssh-client-signer/sign/dev-role public_key=@./dev.pub > ./signed_cert_dev.pub

# sign for ops
vault write -field=signed_key ssh-client-signer/sign/ops-role public_key=@./ops.pub > ./signed_cert_ops.pub

