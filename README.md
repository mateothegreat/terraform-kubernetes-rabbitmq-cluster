# RabbitMQ @ Kubernetes

Deploy a RabbitMQ cluster on kubernetes using the RabbitmqOperator.

## Notes

* Use the label `spotinst.io/restrict-scale-down` to prevent right sizing.

## Implementation

```hcl
#
# Use the s3 bucket for state management.
#
terraform {

    backend "s3" {}

}

#
# Get kubernetes cluster info.
#
data "aws_eks_cluster" "cluster" {

    #
    # mlfabric k8 cluster specifically for github action runners.
    #
    name = var.cluster_name

}

#
# Retrieve authentication for kubernetes from aws.
#
data "aws_eks_cluster_auth" "cluster" {

    #
    # mlfabric k8 cluster specifically for github action runners.
    #
    name = var.cluster_name

}

#
# Install the rabbitmq cluster object.
#
variable "aws_profile" {}
variable "aws_region" {}

#
# Retrieve authentication for kubernetes from aws.
#
provider "aws" {

    profile = var.aws_profile
    region  = var.aws_region

}

#
# Get kubernetes cluster info.
#
data "aws_eks_cluster" "cluster" {

    name = var.cluster_name

}

#
# Retrieve authentication for kubernetes from aws.
#
data "aws_eks_cluster_auth" "cluster" {

    name = var.cluster_name

}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[ 0 ].data)
}

#
# Install the rabbitmq cluster object.
#
module "rabbitmq-nontls" {

    source  = "app.terraform.io/MAA-ML-DEVOPS/rabbitmq-cluster/kubernetes"
    version = "2.0.7"

    namespace        = "default"
    name             = "rabbitmq"
    internal_cidrs   = "8.0.0.224/32"
    limit_cpu        = "7"
    limit_memory     = "15Gi"
    replicas         = 3
    default_username = "rabbitmq"
    default_password = "supersecret"
    
    #
    # Restrict rabbitmq to running on nodes with this selector.
    #
    role             = "infra"

    labels = {

        #
        # Prevent right sizing of the workload which causes rabbitmq
        # to be rescheduled if downsizing occurs.
        #
        "spotinst.io/restrict-scale-down" = "true"

    }

}

```
