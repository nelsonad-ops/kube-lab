# kube-lab
Kubespray and terraform examples for setup

Prerequisites:
Terraform (v0.13.5+)
Ansible (ansible 2.9.14)
Python (3.6.9)
vSphere Provider + vCenter Endpoint
Ubuntu base VM template (12.04+)
5x IPs (can be customized)
Kubespray (2.15+)
kubectl (1.15+)

Installation:
1. Clone this repo and https://github.com/kubernetes-sigs/kubespray
2. Create your base template VM and include all prerequisite packages (defined in prereqs.yaml)
3. Customize provider.tf from the example to your environment admin credentials.
4. Customize cluster.tf to define your vSphere specific environment settings for network, storage, cluster, resource pool.
5. Customize inventory.ini to match your number and IP addresses of VMs.
6. ```Terraform plan``` to ensure syntax and compatibility
7. ```Terraform apply``` to create VMs
8. SSH and ensure VMs are ready to go.
9. ```ansible-playbook -i inventory.ini -b -v --ask-become-pass --ask-pass -c paramiko cluster.yml``` For me this takes ~45 minutes to complete.
10. ```ansible-playbook -i inventory/mycluster/inventory.ini -b -v --ask-become-pass --ask-pass -c paramiko get-me-keys.yaml```
11. ```mv config.dev-0 ~/.kube/config``` Filename of the config should match your vm_name.
12. ```kubectl get nodes```

Your cluster should be ready to go!
