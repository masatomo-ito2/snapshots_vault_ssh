#! /bin/bash

set -x

echo "Dev role"

vault write ssh-client-signer/roles/dev-role -<<EOF
{
  "allow_user_certificates": true,
  "allowed_users": "dev",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "dev",
  "ttl": "1m30s"
}
EOF
