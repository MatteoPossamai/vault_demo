auth "ldap" {
  url = "ldap://your-ldap-server:389"
  userattr = "sAMAccountName"
  userdn = "OU=Users,DC=example,DC=com"
  groupdn = "OU=Groups,DC=example,DC=com"
  groupattr = "cn"
  binddn = "CN=vault-service,OU=Service Accounts,DC=example,DC=com"
  bindpass = "your-service-account-password"
  
  # Map LDAP groups to Vault policies
  groupfilter = "(member={{.UserDN}})"
  
  # Default policy for all authenticated users
  default_lease_ttl = "24h"
  max_lease_ttl = "72h"
}