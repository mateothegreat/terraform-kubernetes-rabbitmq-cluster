variable "host" {

    type        = string
    description = "url to cluster api"

}

variable "token" {

    type        = string
    description = "api token"

}

variable "insecure" {

    type        = bool
    description = "skip ssl certificate verification"
    default     = false

}

variable "namespace" {

    type        = string
    description = "cluster namespace"

}

variable "name" {

    type        = string
    description = "cluster name"

}

variable "role" {

    type        = string
    description = "run on on nodes matching selector"

}

variable "image" {

    type        = string
    description = "docker image"
    default     = "rabbitmq:3-management"

}

variable "cookie" {

    type        = string
    description = "rabbitmq cookie string"
    default     = "changeme"

}

variable "limit_cpu" {

    type        = string
    description = "cpu limit"
    default     = "1000m"

}

variable "limit_memory" {

    type        = string
    description = "memory limit"
    default     = "2Gi"

}

variable "users" {

    type = list(object({

        username    = string
        password    = string
        vhost       = string
        tags        = string
        permissions = string

    }))

    description = "list of users with permissions to create"

}

variable "replicas" {

    type        = number
    description = "number of replica pods"
    default     = 1

}

variable "storage_gb" {

    type        = number
    description = "storage size in gb"
    default     = 10

}

variable "service" {

    description = "service annotations"

    default = {

        type = "LoadBalancer"

        annotations = {

            "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"

        }

    }

}

variable "persistence" {

    type        = map
    description = "persistence object definition"
    default     = {

        storageClassName = "gp2"
        storage          = "10Gi"

    }

}

variable "additional_plugins" {

    type        = list(string)
    description = "plugins to install"
    default     = [ "rabbitmq_management", "rabbitmq_top", "rabbitmq_shovel", "rabbitmq_prometheus" ]

}

variable "labels" {

    type        = map
    description = "labels"
    default     = null

}
