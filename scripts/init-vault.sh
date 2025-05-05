#!/bin/sh

while ! nc -z localhost 8200; do sleep 1; done

# Initialize
if [ ! -f /vault/data/vault-init ]; then
  vault operator init -key-shares=1 -key-threshold=1 > /vault/data/keys.txt
  touch /vault/data/vault-init
fi

UNSEAL_KEY=$(grep 'Unseal Key 1:' /vault/data/keys.txt | awk '{print $4}')
ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/data/keys.txt | awk '{print $4}')

# Unseal and setup 
vault operator unseal $UNSEAL_KEY
export VAULT_ADDR='http://127.0.0.1:8200'
vault login $ROOT_TOKEN

# Enable secrets
vault secrets enable -path=resources kv-v2

# Apply policieS
for policy in $(ls /vault/policies/*.hcl); do
  policy_name=$(basename $policy .hcl)
  vault policy write $policy_name $policy
done

# Configure LDAP
vault auth enable ldap

vault write auth/ldap/config \
    url="ldap://ldap.bbl-internal.com:389" \
    userdn="BBL\\%s" \
    userattr="sAMAccountName" \
    discoverdn=false \
    insecure_tls=true \
    starttls=false \
    groupfilter="(memberOf=%s)" \
    groupdn="dc=bbl-internal,dc=com" \
    groupattr="memberOf" \
    binddn="" \
    bindpass="" \
    userfilter="(sAMAccountName=%s)"

vault write auth/ldap/groups/devops policies=devops
vault write auth/ldap/groups/quicks policies=quicks

# Setup logs
mkdir -p /vault/audit
vault audit enable file file_path=/vault/audit/audit.log
