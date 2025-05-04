path "resources/devops/*" {
    capabilities = ["create", "update", "patch", "read", "delete", "list"]
}

path "resources/*" {
  capabilities = ["deny"]
}

