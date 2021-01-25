resource "azurerm_resource_group" "devops" {
  name     = "Anh-DevOps"
  location = "Southeast Asia"
}

# module "jenkins_vm" {
#   source                        = "Azure/compute/azurerm"
#   # version                       = "3.4.0"
#   resource_group_name           = azurerm_resource_group.devops.name
#   location                      = azurerm_resource_group.devops.location
#   vm_hostname                   = "jenkins"
#   enable_ssh_key                = false
#   admin_username                = "matdecha"
#   admin_password                = "a130993310594W"
#   # ssh_key                       = "${var.public_key}"
#   # remote_port                   = "${var.vm_remote_port["SSH"]}"
#   vm_os_publisher               = "OpenLogic"
#   vm_os_offer                   = "CentOS"
#   vm_os_sku                     = "7.7"
#   allocation_method             = "Static"
#   vnet_subnet_id                = module.vnet.vnet_subnets[0]
#   delete_os_disk_on_termination = true
#   vm_size                       = "${var.vm_size[1]}"

#   tags = {
#     environment = "dev"
#   }

#   depends_on = [azurerm_resource_group.devops]
# }

module "webserver_vm" {
  source                        = "Azure/compute/azurerm"
  # version                       = "3.4.0"
  resource_group_name           = azurerm_resource_group.devops.name
  location                      = azurerm_resource_group.devops.location
  vm_hostname                   = "webserver"
  enable_ssh_key                = false
  admin_username                = "matdecha"
  admin_password                = "a130993310594W"
  # ssh_key                       = "${var.public_key}"
  # remote_port                   = "${var.vm_remote_port["SSH"]}"
  vm_os_publisher               = "OpenLogic"
  vm_os_offer                   = "CentOS"
  vm_os_sku                     = "7.7"
  allocation_method             = "Static"
  vnet_subnet_id                = module.vnet.vnet_subnets[1]
  delete_os_disk_on_termination = true
  vm_size                       = "${var.vm_size[1]}"

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group.devops]
}

module "vnet" {
  source = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.devops.name
  vnet_name           = "devops_vnet"
  address_space       = ["192.168.0.0/16"]
  subnet_prefixes     = ["192.168.0.0/24", "192.168.1.0/24"]
  subnet_names        = ["subnet_a", "subnet_b"]

  nsg_ids = {
    # subnet_a = module.jenkins_nsg.network_security_group_id
    subnet_b = module.webserver_nsg.network_security_group_id
  }

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group.devops]
}

# module "jenkins_nsg" {
#   source                = "Azure/network-security-group/azurerm"
#   resource_group_name   = azurerm_resource_group.devops.name
#   security_group_name   = "jenkins_nsg"
#   predefined_rules = [
#     {
#       name     = "SSH"
#       priority = "500"
#     }
#   ]
#   custom_rules = [
#     {
#       name                   = "Jenkins_8080"
#       priority               = "510"
#       direction              = "Inbound"
#       access                 = "Allow"
#       protocol               = "tcp"
#       destination_port_range = "8080"
#       description            = "Jenkins_8080"
#     }
#   ]

#   tags = {
#     environment = "dev"
#   }

#   depends_on = [azurerm_resource_group.devops]
# }

module "webserver_nsg" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = azurerm_resource_group.devops.name
  security_group_name   = "webserver-nsg-subnet"
  predefined_rules = [
    {
      name     = "SSH"
      priority = "100"
    },
    {
      name     = "HTTP"
      priority = "110"
    },
    {
      name     = "HTTPS"
      priority = "120"
    }
  ]
  # custom_rules = [
  #   {
  #     name                   = "phpmyadmin_3333"
  #     priority               = "530"
  #     direction              = "Inbound"
  #     access                 = "Allow"
  #     protocol               = "tcp"
  #     destination_port_range = "3333"
  #     description            = "phpmyadmin_3333"
  #   }
  # ]

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group.devops]
}