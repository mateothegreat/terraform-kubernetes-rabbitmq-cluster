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

variable "request_cpu" {

    type        = string
    description = "cpu request"
    default     = "1000m"

}

variable "request_memory" {

    type        = string
    description = "memory request"
    default     = "2Gi"

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

        type = "ClusterIP"

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
    default     = [

        "rabbitmq_management",
        "rabbitmq_top",
        "rabbitmq_shovel",
        "rabbitmq_prometheus",
        "rabbitmq_peer_discovery_k8s"

    ]

}

variable "labels" {

    type        = map
    description = "labels"
    default     = null

}

variable "default_username" {

    type = string
    description = "username to create"
    default = null

}

variable "default_password" {

    type = string
    description = "password to set"
    default = null

}
