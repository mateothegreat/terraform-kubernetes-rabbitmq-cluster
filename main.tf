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

#                service = {
#
#                    spec = {
#
#                        ports = [
#
#                            {
#
#                                name     = "prometheus"
#                                protocol = "TCP"
#                                port     = 15692
#
#                            }
#
#                        ]
#
#                    }
#
#                }

                statefulSet = {

                    spec = {

                        template = {

                            metadata = {

                                labels = var.labels

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

            service = {

                type = "LoadBalancer"

                annotations = {

                    "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
                    "service.beta.kubernetes.io/aws-load-balancer-internal" = var.internal_cidrs

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

            rabbitmq = {

                envConfig = <<EOF
consumer_timeout = 3600000
EOF

                additionalPlugins = var.additional_plugins
                additionalConfig  = <<EOF
prometheus.return_per_object_metrics = true
default_user = ${ var.default_username }
default_pass = ${ var.default_password }
EOF

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
