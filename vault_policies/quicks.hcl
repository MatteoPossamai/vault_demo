path "resources/quicks*" {
    capabilities = ["create", "update", "patch", "read", "delete", "list"]
}

path "resources/*" {
  capabilities = ["deny"]
}