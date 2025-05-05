ui = true
disable_mlock = "true"

storage "raft" {
  node_id = "vault-${hostname}"
  path    = "/vault/data"
}

listener "tcp" {
  address = "[::]:8200"
  tls_disable = true
}

api_addr = "http://localhost:8200"
cluster_addr = "http://loclhost:8201"