#!/bin/bash

set -x

vault write -field=signed_key ssh-client-signer/sign/dev-role public_key=@./dev.pub > ./signed_cert_dev.pub
vault write -field=signed_key ssh-client-signer/sign/ops-role public_key=@./ops.pub > ./signed_cert_ops.pub

