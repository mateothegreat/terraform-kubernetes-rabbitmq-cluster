# RabbitMQ @ Kubernetes with TLS

Deploy a RabbitMQ cluster on kubernetes with 
TLS support.

```hcl
module "ca" {

    source  = "app.terraform.io/MAA-ML-DEVOPS/ca/tls"
    version = "1.0.1"

    organization            = "test org"
    common_name             = "test name"
    ca_certificate_path     = "out"
    ca_key_path             = "out"
    client_certificate_path = "out"
    client_key_path         = "out"
    clients                 = [ "one", "two" ]
    expire_hours            = 86400 * 365

}

module "rabbitmq-tls" {

    source  = "app.terraform.io/MAA-ML-DEVOPS/rabbitmq-tls/kubernetes"
    version = "1.0.0"

    host          = "kubernetes api url"
    token         = "kubernetes api token"
    insecure      = true
    namespace     = "default"
    name          = "rabbitmq"
    internal_cidr = ""
    ca_cert_pem   = module.ca.ca_public_key

    users = [

        {

            username = "someadmin"
            password = "changeme"
            vhost = "/"
            tags = "administrator"
            permissions = "'.*' '.*' '.*'"

        },
        {

            username = "someuser"
            password = "changeme"
            vhost = "/somevhost"
            tags = ""
            permissions = "'.*' '.*' '.*'"

        }


    ]

}
```
