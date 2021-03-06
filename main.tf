resource "kubernetes_manifest" "cluster" {

    provider = kubernetes-alpha

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

            rabbitmq = {

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
