remote_state_key    = "layer1/infrastructure.tfstate"
remote_state_bucket = "ecs-fargate-terraform-remote-state"

ecs_domain_name      = "test.com"
ecs_cluster_name     = "Main-Ecs-Cluster"
internet_cidr_blocks = "0.0.0.0/0"
