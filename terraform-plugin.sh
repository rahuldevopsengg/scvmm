#!/bin/bash

###################################################################
#                                                                 #
#      Upgrade kernel to apply latest security updates.           #
#                                                                 #
###################################################################

sudo apt-get update
sudo apt-get -y upgrade

###################################################################
#                                                                 #
#      Install zip and wget package.                              #
#                                                                 #
###################################################################

sudo apt-get install unzip
sudo apt-get install wget

###################################################################
#                                                                 #
#     If condition will check whether Terraform is install or not.#
#     If not installed then terraform will installed.             #
#                                                                 #
###################################################################


a="$(terraform --version)"
if [$a==Terraform v0.12.2*]
then
mkdir Terraform
cd Terraform
wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip
unzip terraform_0.12.2_linux_amd64.zip
sudo mv terraform /usr/local/bin/
sudo snap install terraform
else
wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
sudo tar -xvf go1.12.6.linux-amd64.tar.gz
sudo mv go /usr/local

###################################################################
#                                                                 #
#  Now you need to setup Go language environment variables for    #
#  your project.                                                  #
#   Commonly you need to set 3 environment variables as GOROOT,   #
#   GOPATH and PATH.                                              #
#   GOROOT is the location where Go package is installed on your  #
#   system.                                                       #
#                                                                 #
###################################################################

mkdir -p $HOME/Projects/scvmm
echo -e export GOROOT=/usr/local/go >> ~/.profile
echo -e export GOPATH=$HOME/Projects/scvmm >> ~/.profile
echo -e export PATH=$GOPATH/bin:$GOROOT/bin:$PATH >> ~/.profile
source /root/.profile
cd $HOME/Projects/scvmm

####################################################################
#                                                                  #
#Git clobe will copy all .go file from github repostory to local   #
#machine.                                                          #
#                                                                  #
####################################################################

git clone https://github.com/rahuldevopsengg/scvmm.git
mv scvmm/* .
rm -rf scvmm
mkdir -p /usr/local/go/src
git clone https://github.com/rahuldevopsengg/terraform.git
mkdir -p  /usr/local/go/src/github.com/hashicorp
mv terraform /usr/local/go/src/github.com/hashicorp/
echo -e export PATH=$GOPATH/bin:$GOROOT/bin:$PATH >> ~/.profile
source /root/.profile
go build -o terraform-provider-scvmm
sudo snap install terraform
terraform init
terraform plan
fi
