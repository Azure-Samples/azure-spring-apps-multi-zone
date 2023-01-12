# Database module

## Database creation

The database is created with a random password that gets created. This password gets outputted and stored in the Key Vault. 

The database is also created with a `high availability` mode of `ZoneRedundant`. 

```terraform
resource "random_password" "password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = var.mysql_server_name
  resource_group_name = var.resource_group
  location            = var.location

  administrator_login    = var.admin_username
  administrator_password = random_password.password.result

  sku_name                     = "GP_Standard_D2ds_v4"
  version                      = "5.7"
  zone = 1
  storage {
    size_gb = 5120
  }
  delegated_subnet_id    = var.db_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id

  high_availability {
    mode = "ZoneRedundant"
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_zone_link]
}

resource "azurerm_mysql_flexible_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group
  server_name         = azurerm_mysql_flexible_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
```

## Network configuration

The database server gets created in the `database-subnet` of the virtual network. Additionaly proper DNS configuration within your virtual network, is also needed.

```terraform
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "private.mysql.database.azure.com"
  resource_group_name = var.resource_group
}
```

This DNS zone needs to be linked to the virtual network.

```terraform
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_link" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.virtual_network_id
}
```
