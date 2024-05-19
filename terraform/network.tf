module "network"{

    source="./network"
    vpc_cidr= var.vpc_cidr
    subnets  = var.subnets
}