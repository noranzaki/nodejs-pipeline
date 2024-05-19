resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name       = "elasticache-subnet-group"
  subnet_ids = [ module.network.subnets["private1"].id  ]
}

resource "aws_elasticache_cluster" "my_elasticache_cluster" {
    cluster_id           = "my-elasticache-cluster"
    engine               = "redis"
    engine_version       = "6.x"
    node_type            = "cache.t3.micro"
    num_cache_nodes      = 1
    subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_group.name
    security_group_ids   = [aws_security_group.elasticache_sg.id]
}