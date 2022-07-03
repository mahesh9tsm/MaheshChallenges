
**Challenge1 - Created Simple 4 Tier Environment using Terraform**

1. I have used Terraform to build the setup.
2. Created Vnet and 4 subnets (web,app,db and bastion subnet)
3. Created two VM's for each web,app, db VM's with availbility zones used meta argument count to create multiple VMs.
4. No public ip was provided to the VM's , VM's will be accessed through Bastion VM which is created with Public IP.
5. Created External Load balancer which connects to webvms and two Internal Load balancer for APP and DB VM's load Balancing

**Please find the 4 tier Architecture Design**

![image](https://user-images.githubusercontent.com/106945519/177029324-faafa818-f7e0-448f-97c2-a804086c9048.png)


**Please find the screenshots,related to resources created in Azure through Terraform**

![image](https://user-images.githubusercontent.com/106945519/177030129-7302ce2d-5f50-44ce-a841-6528a93e3ae3.png)
![image](https://user-images.githubusercontent.com/106945519/177030146-ddd4bd79-2e53-4a5b-a35d-117f9ab22fdc.png)
![image](https://user-images.githubusercontent.com/106945519/177030166-7d27ef56-026b-46b7-9028-9379e5f7f181.png)



