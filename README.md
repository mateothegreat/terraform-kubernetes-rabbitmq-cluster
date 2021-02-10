# RabbitMQ @ Kubernetes

Deploy a RabbitMQ cluster on kubernetes using the RabbitmqOperator.

## Notes

* Use the label `spotinst.io/restrict-scale-down` to prevent right sizing.

## Implementation
```hcl
variable "cluster_name" {}
variable "aws_profile" {}
variable "aws_region" {}

#
# Use the s3 bucket for state management.
#
terraform {

    backend "s3" {

        profile = "mlfabric"
        region  = "us-east-1"
        bucket  = "mlfabric-devops-terraform-product-stack-states"

    }

}

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
module "rabbitmq-nontls" {

    source  = "app.terraform.io/MAA-ML-DEVOPS/rabbitmq-nontls/kubernetes"
    version = "1.0.18"

    host          = data.aws_eks_cluster.cluster.endpoint
    token         = data.aws_eks_cluster_auth.cluster.token
    image         = "rabbitmq:7-management"
    insecure      = true
    namespace     = "default"
    name          = "rabbitmq"
    internal_cidr = "0.0.0.0/0"
    limit_cpu     = "3"
    limit_memory  = "6Gi"
    replicas      = 1

    #
    # Restrict rabbitmq to running on nodes with this selector.
    #
    role = "infra"

    labels = {

        #
        # Prevent right sizing of the workload which causes rabbitmq
        # to be rescheduled if downsizing occurs.
        #
        "spotinst.io/restrict-scale-down" = true

    }

    users = [

        {

            username    = "<changeme>"
            password    = "<changeme>"
            vhost       = "/"
            tags        = "administrator"
            permissions = "'.*' '.*' '.*'"

        }

    ]

}
```
