# Auth backend
resource "vault_auth_backend" "userpass" {
  type = "userpass"

  tune {
    default_lease_ttl = "24h"
    max_lease_ttl     = "768h"
  }
}

# Policy for Developer
resource "vault_policy" "dev_policy" {
  name = "dev_policy"

  policy = <<EOT
path "ssh-client-signer/sign/dev-role"
{
  capabilities = ["create", "update"]
}
EOT
}

# Policy for Operator
resource "vault_policy" "ops_policy" {
  name = "ops_policy"

  policy = <<EOT
path "ssh-client-signer/sign/ops-role"
{
  capabilities = ["create", "update"]
}
EOT
}

# Create 'dev' user
resource "vault_generic_endpoint" "dev_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/dev"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${vault_policy.dev_policy.name}"],
  "password": "dev"
}
EOT
}

# Create 'ops' user
resource "vault_generic_endpoint" "ops_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/ops"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["${vault_policy.ops_policy.name}"],
  "password": "ops"
}
EOT
}