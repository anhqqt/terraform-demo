# output "jenkins_vm_public_ips" {
#   value = module.jenkins_vm.public_ip_address
# } 

# output "jenkins_vm_private_ips" {
#   value = module.jenkins_vm.network_interface_private_ip
# }

# output "jenkins_vm_url" {
#   value = "http://${element(module.jenkins_vm.public_ip_address, 0)}:8080"
# }

output "webserver-vm_public_ips" {
  value = module.webserver_vm.public_ip_address
} 

output "webserver-vm_private_ips" {
  value = module.webserver_vm.network_interface_private_ip
}

output "webserver-vm_url" {
  value = "http://${element(module.webserver_vm.public_ip_address, 0)}"
}

### The Ansible inventory file
# resource "local_file" "AnsibleInventory" {
#   content = templatefile("inventory.tmpl", {
#     jenkins-vm-ip = module.jenkins_vm.public_ip_address
#     webserver-vm-ip = module.webserver_vm.public_ip_address
#   })
#   filename = "../ansible-demo/hosts.txt"
# }