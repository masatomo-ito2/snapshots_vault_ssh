#! /bin/bash


set -x

echo "Ops role"

vault write ssh-client-signer/roles/ops-role -<<EOF
{
  "allow_user_certificates": true,
  "allowed_users": "ops",
  "default_extensions": [
    {
      "permit-pty": ""
    }
  ],
  "key_type": "ca",
  "default_user": "ops",
  "ttl": "1m0s"
}
EOF 
