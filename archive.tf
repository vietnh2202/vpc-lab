# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "my-vpc"
#   }
# }
# resource "aws_subnet" "public" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/20"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "my-public-subnet"
#   }
# }

# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.128.0/20"
#   availability_zone = "us-east-1a"
#   tags = {
#     Name = "my-private-subnet"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id
#   tags = {
#     Name = "my-internet-gateway"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }
#   tags = {
#     Name = "my-public-route-table"
#   }
# }

# resource "aws_route_table_association" "public" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }

# ######### ALB Configuration
# resource "aws_lb" "main" {
#   name               = "my-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public.id]

#   tags = {
#     Name = "my-alb"
#   }
# }

# resource "aws_security_group" "alb_sg" {
#   name        = "my-alb-sg"
#   description = "Allow HTTP traffic"
#   vpc_id      = aws_vpc.main.id

#   dynamic "ingress" {
#     for_each = var.wifi_ips
#     content {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = ["${ingress.value}/32"]
#     }
#   }
# }

# ######### ECS Cluster Configuration
# resource "aws_ecs_cluster" "main" {
#   name = "my-ecs-cluster"

#   tags = {
#     Name = "my-ecs-cluster"
#   }
# }

# resource "aws_ecs_task_definition" "main" {
#   family                   = "my-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["EC2"]

#   container_definitions = jsonencode([
#     {
#       name      = "nginx"
#       image     = "public.ecr.aws/nginx/nginx:stable-alpine"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80######### ALB Configuration
# resource "aws_lb" "main" {
#   name               = "my-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public.id]

#   tags = {
#     Name = "my-alb"
#   }
# }

# resource "aws_security_group" "alb_sg" {
#   name        = "my-alb-sg"
#   description = "Allow HTTP traffic"
#   vpc_id      = aws_vpc.main.id

#   dynamic "ingress" {
#     for_each = var.wifi_ips
#     content {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks = ["${ingress.value}/32"]
#     }
#   }
# }

# ######### ECS Cluster Configuration
# resource "aws_ecs_cluster" "main" {
#   name = "my-ecs-cluster"

#   tags = {
#     Name = "my-ecs-cluster"
#   }
# }

# resource "aws_ecs_task_definition" "main" {
#   family                   = "my-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["EC2"]

#   container_definitions = jsonencode([
#     {
#       name      = "nginx"
#       image     = "public.ecr.aws/nginx/nginx:stable-alpine"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp"
#         }
#       ]
#     }
#   ])
# }
#           protocol      = "tcp"
#         }
#       ]
#     }
#   ])
# }

# VPC Endpoints for ECS
# resource "aws_vpc_endpoint" "ecs" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecs"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.ecs_sg.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ecs-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecs_agent" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecs-agent"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.ecs_sg.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ecs-agent-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecs-telemetry" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecs-telemetry"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.ecs_sg.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ecs-telemetry-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_api" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecr.api"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.ecs_sg.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ecr-api-endpoint"
#   }
# }

# resource "aws_vpc_endpoint" "ecr_dkr" {
#   vpc_id              = module.vpc.vpc_id
#   service_name        = "com.amazonaws.${var.region}.ecr.dkr"
#   vpc_endpoint_type   = "Interface"
#   subnet_ids          = [module.vpc.private_subnets[0]]
#   security_group_ids  = [aws_security_group.ecs_sg.id]
#   private_dns_enabled = true

#   tags = {
#     Name = "ecr-dkr-endpoint"
#   }
# }