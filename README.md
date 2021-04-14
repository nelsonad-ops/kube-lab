# kube-lab
Kubespray and terraform examples for setup

Prerequisites:
Terraform (v0.13.5+)</br>
Ansible (2.9.14) *Kubespray specific for me</br>
Python (3.6.9) *Kubespray specific for me</br>
vSphere Provider + vCenter Endpoint(7.0+)</br>
Ubuntu base VM template (12.04+)</br>
5x IPs (can be customized)</br>
Kubespray (2.15+)</br>
kubectl (1.15+)</br>

Installation:
1. Clone this repo and https://github.com/kubernetes-sigs/kubespray
2. Create your base template VM and include all prerequisite packages (defined in prereqs.yaml)
3. Customize provider.tf from the example to your environment admin credentials.
4. Customize cluster.tf to define your vSphere specific environment settings for network, storage, cluster, resource pool.
5. Customize inventory.ini to match your number and IP addresses of VMs.
6. ```Terraform plan``` to ensure syntax and compatibility from this kube-lab directory
7. ```Terraform apply``` to create VMs
8. SSH and ensure VMs are ready to go. Switch to your kubespray directory and ensure your file-path references your inventory.ini accurately.
9. ```ansible-playbook -i kube-lab/inventory.ini -b -v --ask-become-pass --ask-pass -c paramiko cluster.yml``` For me this takes ~45 minutes to complete.
10. ```ansible-playbook -i kube-lab/inventory.ini -b -v --ask-become-pass --ask-pass -c paramiko get-me-keys.yaml```
11. ```mv config.dev-0 ~/.kube/config``` Filename of the config should match your vm_name.
12. ```kubectl get nodes```

Your cluster should be ready to go!
