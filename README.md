# RabbitMQ @ Kubernetes with TLS

Deploy a RabbitMQ cluster on kubernetes with 
TLS support.

```hcl
module "rabbitmq-nontls" {

  source  = "app.terraform.io/MAA-ML-DEVOPS/rabbitmq-nontls/kubernetes"
  version = "1.0.0"

  host          = "changeme"
  token         = "changeme"
  insecure      = true
  namespace     = "default"
  name          = "rabbitmq"
  internal_cidr = "0.0.0.0/0"

  users = [

    {

      username    = "rabbitmq"
      password    = "agaeq14"
      vhost       = "/"
      tags        = "administrator"
      permissions = "'.*' '.*' '.*'"

    },
    {

      username    = "someuser"
      password    = "changeme"
      vhost       = "/somevhost"
      tags        = ""
      permissions = "'.*' '.*' '.*'"

    }

  ]

}
```
