provider "kubernetes" {

    alias = "this"

    host     = var.host
    token    = var.token
    insecure = var.insecure

}

provider "kubernetes-alpha" {

    alias = "this"

    host     = var.host
    token    = var.token
    insecure = var.insecure

}

resource "kubernetes_manifest" "cluster" {

    provider = kubernetes-alpha.this

    manifest = {

        "apiVersion" = "rabbitmq.com/v1beta1"
        "kind"       = "RabbitmqCluster"

        "metadata" = {

            "namespace" = var.namespace
            "name"      = var.name

        }

        "spec" = {

            replicas = var.replicas
            image    = "rabbitmq:3-management"

            rabbitmq = {

                additionalPlugins = [ "rabbitmq_management", "rabbitmq_top", "rabbitmq_shovel" ]

            }

            service = {

                type = "LoadBalancer"

                annotations = {

                    "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
                    "service.beta.kubernetes.io/aws-load-balancer-internal" = var.internal_cidr

                }


            }

            persistence = {

                storageClassName = "gp2"
                storage          = "${ var.storage_gb }Gi"

            }

            resources = {

                requests = {

                    cpu    = var.limit_cpu
                    memory = var.limit_memory

                }

                limits = {

                    cpu    = var.limit_cpu
                    memory = var.limit_memory

                }

            }

        }

    }

}

resource "null_resource" "readywait" {

    provisioner "local-exec" {

        command = "sleep 10 && kubectl rollout status statefulset/${ var.name }-rabbitmq-server"

    }

}

resource "null_resource" "adduser" {

    depends_on = [ null_resource.readywait ]

    count = length(var.users)

    provisioner "local-exec" {

        command = "kubectl exec -n ${ var.namespace } ${ var.name }-rabbitmq-server-0 -it -- rabbitmqctl add_user '${ var.users[ count.index ].username }' '${ var.users[ count.index ].password }' && kubectl exec -n ${ var.namespace } ${ var.name }-rabbitmq-server-0 -it -- rabbitmqctl set_user_tags '${ var.users[ count.index ].username }' '${ var.users[ count.index ].tags }' && kubectl exec -n ${ var.namespace } ${ var.name }-rabbitmq-server-0 -it -- rabbitmqctl set_permissions -p / '${ var.users[ count.index ].username }' ${ var.users[ count.index ].permissions }"

    }

}
