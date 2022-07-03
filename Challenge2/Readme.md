

    Challenge2 -  Query the Azure VM metadata and get the Json output
    
    1. Created an Azure Linux VM with Terraform.
    2. I had used custom data option in the azurerm_linux_virtual_machine.
    3. Passed the curl command for the VM metadata in custom data and  passed to json file (metatdata.json) which will be under /var/www/html
    4. We can query the metadata using webbrowser by using port 80 .Instead of logging into the server manually 
       we can query the metadata in json format over the browser
    
    **Please find the Screenshot for VM Custom data passed through Teraform in azurerm_linux_virtual_machine**
    
   
![image](https://user-images.githubusercontent.com/106945519/177028463-2e16fc19-2cb5-43ef-b28d-831a6d4186a4.png)


**    Please find the screenshot for getting the metadata from the browser.**


    
    
