
**Challenge1 - Created Simple 4 Tier Environment**

1. I have used Terraform to build the setup.
2. Created Vnet and 4 subnets (web,app,db and bastion subnet)
3. Created two VM's for each web,app, db VM's with availbility zones used meta argument count to create multiple VMs.
4. No public ip was provided to the VM's , VM's will be accessed through Bastion VM which is created with Public IP.
5. Created External Load balancer which connects to webvms and two Internal Load balancer for APP and DB VM's load Balancing

**Please find the 4 tier Architecture Design**

![image](https://user-images.githubusercontent.com/106945519/177029324-faafa818-f7e0-448f-97c2-a804086c9048.png)


**Please find the screenshots,related to resources created in Azure through Terraform**


