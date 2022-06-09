# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

/*==========================
      AWS ECS Service
===========================*/

resource "aws_ecs_service" "ecs_service" {
  name                              = var.name
  cluster                           = var.ecs_cluster_id
  task_definition                   = var.arn_task_definition
  desired_count                     = var.desired_tasks
  health_check_grace_period_seconds = var.seconds_health_check_grace_period
  launch_type                       = "FARGATE"
  enable_execute_command            = true

  # rolling deployment specific configuration
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  network_configuration {
    security_groups = [var.arn_security_group]
    subnets         = [var.subnets_id[0], var.subnets_id[1]]
  }

  load_balancer {
    target_group_arn = var.arn_target_group
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = var.deployment_controller
  }

  lifecycle {
    # to avoid changes generated by autoscaling or new CodeDeploy changes
    ignore_changes = [desired_count, task_definition, load_balancer]
  }

}