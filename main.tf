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
            "labels"    = var.labels

        }

        "spec" = {

            replicas = var.replicas
            image    = var.image

            affinity = {

                nodeAffinity = {

                    requiredDuringSchedulingIgnoredDuringExecution = {

                        nodeSelectorTerms = [

                            {

                                matchExpressions = [

                                    {

                                        key      = "role"
                                        operator = "In"
                                        values   = [ var.role ]

                                    }

                                ]

                            }

                        ]

                    }

                }

            }

            override = {

                clientService = {

                    spec = {

                        ports = [

                            {

                                name     = "prometheus"
                                protocol = "TCP"
                                port     = 15692

                            }

                        ]

                    }

                }

                statefulSet = {

                    spec = {

                        template = {

                            metadata = {

                                labels = var.labels

                            }

                            spect = {

                                containers = [

                                    {

                                        name = "rabbitmq"

                                        ports = [

                                            {

                                                name          = "prometheus"
                                                protocol      = "TCP"
                                                containerPort = 15692

                                            }

                                        ]

                                    }

                                ]

                            }

                        }

                    }

                }

            }

            rabbitmq = {

                additionalPlugins = var.additional_plugins
                additionalConfig = "prometheus.return_per_object_metrics = true"

            }

            service = var.service

            persistence = var.persistence

            resources = {

                requests = {

                    cpu    = var.request_cpu
                    memory = var.request_memory

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

        command = "sleep 30 && kubectl --server=\"${ var.host }\" --token=\"${ var.token }\" rollout status statefulset/${ var.name }-server"

    }

}

resource "null_resource" "adduser" {

    depends_on = [ null_resource.readywait ]

    count = length(var.users)

    provisioner "local-exec" {

        command = "kubectl --server=\"${ var.host }\" --token=\"${ var.token }\" exec -n ${ var.namespace } ${ var.name }-server-0 -it -- rabbitmqctl add_user '${ var.users[ count.index ].username }' '${ var.users[ count.index ].password }' && kubectl exec -n ${ var.namespace } ${ var.name }-server-0 -it -- rabbitmqctl set_user_tags '${ var.users[ count.index ].username }' '${ var.users[ count.index ].tags }' && kubectl exec -n ${ var.namespace } ${ var.name }-server-0 -it -- rabbitmqctl set_permissions -p / '${ var.users[ count.index ].username }' ${ var.users[ count.index ].permissions }"

    }

}
