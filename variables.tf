variable "vm_size" {
    type    = "list"
    default = ["Standard_B1s", "Standard_B2s"]
}

variable "vm_remote_port" {
    type    = "map"
    default = {
        "SSH" = "22"
        "RDP" = "3389"
    }
}


variable "public_key" {
    type    = "string"
    default = ".ssh/id_rsa.pub"
}