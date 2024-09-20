# first-poste-delivery-example
A first delivery example from Poste. 

# Repository structure
The Repository is structured in the following way:
  - example-complete folder: it contains the example completed and ready to be deployed;
  - example-todo folder: it contains the same terraform code of the previous one but still to be completed..

# How to run the example
Clone the repository locally on your laptop, then move to one of the three folders, in this example will be executed the example-complete project:
```
cd first-poste-delivery-example/example-complete.
```
The first time it's going to run Terraform within a project, and every time the init.tf file will be modified (changing the terraform version or the provider used), it's necessary to run the following command to initialize and configure the environment, letting Terraform download all the necessary dependencies.  
```
terraform init
```
As soon as everything will be initialized, then it will be possible to run the first terraform plan and see what comes out with the output. This time the command change because it has to be passed the tfvars file as argument, in this way the user is able to pass different variables based on the environment that has to be deployed. The command looks like the following:
> If running on Windows
```
terraform plan -var-file collaudo.tfvars
```
> If running on Linux
```
terraform plan -var-file=collaudo.tfvars
```
Once you'll feel confident and sure about what terraform plans to deploy on the Cloud infrastructure, you'll be ready to run the apply and start the deploy, just running:
> If running on Windows
```
terraform apply -var-file collaudo.tfvars
```
> If running on Linux
```
terraform apply -var-file=collaudo.tfvars
```
To destroy everything was created by the apply command, just execute the following command:
> If running on Windows
```
terraform destroy -var-file collaudo.tfvars
```
> If running on Linux
```
terraform destroy -var-file=collaudo.tfvars
```
