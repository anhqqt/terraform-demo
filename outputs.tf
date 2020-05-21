output "jenkins_vm_public_ips" {
  value = module.jenkins-vm.public_ip_address
} 

# output "jenkins_vm_private_ips" {
#   value = module.jenkins-vm.network_interface_private_ip
# }

output "jenkins_vm_url" {
  value = "http://${element(module.jenkins-vm.public_ip_address, 0)}:8080"
}

output "webserver-vm_public_ips" {
  value = module.webserver-vm.public_ip_address
} 

# output "webserver-vm_private_ips" {
#   value = module.webserver-vm.network_interface_private_ip
# }

output "webserver-vm_url" {
  value = "http://${element(module.webserver-vm.public_ip_address, 0)}"
}
