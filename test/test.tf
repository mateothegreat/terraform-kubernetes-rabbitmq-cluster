provider "kubernetes" {

    config_path = "~/.kube/config"

}

module "rabbitmq-nontls" {

    source = "../"

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
