#!/usr/bin/env bash
cd ..

sudo apt update

project_location=/workspaces/Terraform_s3_website

sudo apt install wget -y
sudo apt install unzip -y

sudo wget https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_amd64.zip

sudo unzip terraform_1.6.2_linux_amd64.zip

sudo mv terraform /usr/local/bin

cd $project_location

