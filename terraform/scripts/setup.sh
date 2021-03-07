#! /bin/bash

set  -x
exec > >(tee /tmp/tf-user-data.log|logger -t _bootstrap ) 2>&1

logger() {
    DT=$(date '+%Y/%m/%d %H:%M:%S')
    echo "$DT $0: $1"
}

logger "running"

echo set -o vi >> /home/ubuntu/.bashrc

# Add dev and ops user
adduser --gecos "" --disabled-password dev
adduser --gecos "" --disabled-password ops

# Get Vault CA key (public key)
curl -o /etc/ssh/trusted-user-ca-keys.pem \
     -H "X-Vault-Namespace: ${tpl_vault_namespace}" \
     -X GET \
     ${tpl_vault_addr}/v1/ssh-client-signer/public_key

# Add vault ca key to trusted CA store
echo TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem >> /etc/ssh/sshd_config

# Restart sshd
systemctl restart sshd