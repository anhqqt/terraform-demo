resource "azurerm_resource_group" "devops" {
  name     = "Anh-DevOps"
  location = "Southeast Asia"
}

module "jenkins-vm" {
  source                        = "Azure/compute/azurerm"
  resource_group_name           = azurerm_resource_group.devops.name
  location                      = azurerm_resource_group.devops.location
  vm_hostname                   = "jenkins"
  admin_username                = "matdecha"
  ssh_key                       = "${var.public_key}"
  # remote_port                   = "${var.vm_remote_port["SSH"]}"
  vm_os_publisher               = "OpenLogic"
  vm_os_offer                   = "CentOS"
  vm_os_sku                     = "7.7"
  allocation_method             = "Static"
  vnet_subnet_id                = module.vnet.vnet_subnets[0]
  delete_os_disk_on_termination = true
  vm_size                       = "${var.vm_size[1]}"

  tags = {
    environment = "dev"
  }
}

module "webserver-vm" {
  source                        = "Azure/compute/azurerm"
  resource_group_name           = azurerm_resource_group.devops.name
  location                      = azurerm_resource_group.devops.location
  vm_hostname                   = "webserver"
  admin_username                = "matdecha"
  ssh_key                       = "${var.public_key}"
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
}

module "vnet" {
  source = "Azure/vnet/azurerm"
  resource_group_name = azurerm_resource_group.devops.name
  vnet_name           = "devops-vnet"
  address_space       = ["192.168.0.0/16"]
  subnet_prefixes     = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
  subnet_names        = ["subnet-a", "subnet-b", "subnet-c"]

  nsg_ids = {
    subnet-a = module.jenkins-nsg.network_security_group_id
    subnet-b = module.webserver-nsg.network_security_group_id
  }

  tags = {
    environment = "dev"
  }
}

module "jenkins-nsg" {
  source                = "Azure/network-security-group/azurerm"
  version               = "3.0.0"
  resource_group_name   = azurerm_resource_group.devops.name
  security_group_name   = "jenkins-nsg"
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    }
  ]
  custom_rules = [
    {
      name                   = "Jenkins_8080"
      priority               = "510"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "8080"
      description            = "Jenkins_8080"
    }
  ]

  tags = {
    environment = "dev"
  }
}

module "webserver-nsg" {
  source                = "Azure/network-security-group/azurerm"
  version               = "3.0.0"
  resource_group_name   = azurerm_resource_group.devops.name
  security_group_name   = "webserver-nsg"
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    },
    {
      name     = "HTTP"
      priority = "510"
    },
    {
      name     = "HTTPS"
      priority = "520"
    }
  ]
  custom_rules = [
    {
      name                   = "phpmyadmin_3333"
      priority               = "530"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "3333"
      description            = "phpmyadmin_3333"
    }
  ]

  tags = {
    environment = "dev"
  }
}