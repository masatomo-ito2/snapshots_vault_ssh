# VaultによるリモートアクセスのためのSigned SSHを活用する


### 2021年3月9日に行われたHashiCorp Snapshotのデモです。 

#### スライドは[こちら](https://docs.google.com/presentation/d/1Lfovi1_jDxWD71_BLK9FZT4KhCyM-hPVSU5M-xHW28I/edit?usp=sharing)

## Prerequisite

- Vault cluster
- Terraform
  - AWSへのクレデンシャル
  - Azureへのクレデンシャル

## Steps

1. Vault setup

* Secret engineの設定
  * `vault secrets enable -path=ssh-client-signer ssh `

* CAの設定
  * vault write ssh-client-signer/config/ca generate_signing_key=true 


2. Terraformを実行

```shell
cd terraform
terraform apply
```

* AWSのVPCはみなさんの環境のものを指定してください。
* AzureのResouce groupはみなさんの環境のものを指定してください。
* AWSとAzureのクレデンシャルを設定してくださいね。
  * Azureのクレデンシャル設定方法
    * https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure
  * AWSのクレデンシャル設定方法
    * https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication
* Vault providerのために、Vaultのクレデンシャルも設定してくださいね。
    * Vaultのクレデンシャルの設定方法
      * https://registry.terraform.io/providers/hashicorp/vault/latest/docs#address
      * `VAULT_ADDR`、`VAULT_TOKEN`、`VAULT_NAMESPACE`など

3. Vaultディレクトリにあるスクリプトを順に実行

`0.enable_secret_engine.sh` と `1.configure_vault_ca.sh` はステップ１で行っているので実行しなくでもいいです。






