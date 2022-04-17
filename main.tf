resource "kubernetes_manifest" "cluster" {

    manifest = {

        "apiVersion" = "rabbitmq.com/v1beta1"
        "kind"       = "RabbitmqCluster"

        "metadata" = {

            "namespace" = var.namespace
            "name"      = var.name
            "labels"    = var.labels

        }

        "spec" = {
            override = {

                service = {

                    spec = {

                        ports = [

                            {

                                name     = "management-http"
                                protocol = "TCP"
                                port     = 15672

                            },
                            {

                                name     = "tcp"
                                protocol = "TCP"
                                port     = 5672

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

                            spec = {

                                containers = [

                                    {

                                        name = "rabbitmq"

                                        ports = [

                                            {
                                                name          = "tcp"
                                                containerPort = 5672

                                            },
                                            {

                                                name          = "management"
                                                containerPort = 15672

                                            }

                                        ]

                                    }

                                ]

                            }

                            #                            spec = {
                            #
                            #                                containers = [
                            #
                            #                                    {
                            #
                            #                                        name = "rabbitmq"
                            #
                            #                                        ports = [
                            #
                            #                                            {
                            #
                            #                                                name          = "prometheus"
                            #                                                protocol      = "TCP"
                            #                                                containerPort = 15692
                            #
                            #                                            }
                            #
                            #                                        ]
                            #
                            #                                    }
                            #
                            #                                ]
                            #
                            #                            }

                        }

                    }

                }

            }

            #            service = {
            #
            #                type = "ClusterIP"
            #
            #            }

            replicas = var.replicas
            image    = var.image

            #            service = {
            #
            #                ports = [
            #
            #                    {
            #
            #                        protocol = "TCP"
            #                        port     = 5672
            #
            #                    }
            #
            #                ]
            #
            #            }
            #            service = {
            #
            #                type = "LoadBalancer"
            #
            #                annotations = {
            #
            #                    "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
            #                    "service.beta.kubernetes.io/aws-load-balancer-internal" = var.internal_cidrs
            #
            #                }
            #
            #            }

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


            persistence = {

                storageClassName = var.storage_class_name
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

            rabbitmq = {

                additionalPlugins = var.additional_plugins
                additionalConfig  = <<EOF
prometheus.return_per_object_metrics = true
consumer_timeout = 3600000
default_user = ${ var.default_username }
default_pass = ${ var.default_password }
EOF

            }

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
