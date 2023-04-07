terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

  




provider "ibm" {
  generation = 2
  region = "us-south"

}
resource "ibm_is_vpc" "vpc1" {
  name = "myvpc"
}
resource "ibm_is_subnet" "subnet1" {
  name                     = "subnet-1"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = "us-south-1"
  total_ipv4_address_count = 256
}

resource "ibm_is_subnet" "subnet2" {
  name                     = "subnet-2"
  vpc                      = ibm_is_vpc.vpc1.id
  zone                     = "us-south-2"
  total_ipv4_address_count = 256
}

resource "ibm_container_vpc_cluster" "cluster" {
  name              = "vpcks"
  vpc_id            = ibm_is_vpc.vpc1.id
  flavor            = "bx2.4x16"
  worker_count      = 1
  kube_version="1.25.8"
  resource_group_id="1a94f5c9081d48d0885227df98898f18"
 
  zones {
    subnet_id = ibm_is_subnet.subnet1.id
    name      = "us-south-1"
  }
}

resource "ibm_container_vpc_worker_pool" "cluster_pool" {
  cluster           = ibm_container_vpc_cluster.cluster.id
  worker_pool_name  = "mywp"
  flavor            = "bx2.2x8"
  vpc_id            = ibm_is_vpc.vpc1.id
  worker_count      = 1
  zones {
    name      = "us-south-2"
    subnet_id = ibm_is_subnet.subnet2.id
  }
}
