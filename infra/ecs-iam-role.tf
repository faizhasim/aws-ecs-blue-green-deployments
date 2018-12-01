locals {
  name = "simple-service"
  path = "/ecs/"
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

data "aws_iam_policy_document" "ecs-iam-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs-iam-role" {
  name                  = "${local.name}"
  assume_role_policy    = "${data.aws_iam_policy_document.ecs-iam-role.json}"
  force_detach_policies = false
  path                  = "${local.path}"
  description           = "IAM Role for ECS Blue Green thingy"
}

resource "aws_iam_instance_profile" "ecs-iam-role" {
  name       = "${format("%s-%s", local.name, "instance-profile")}"
  path       = "${local.path}"
  role       = "${aws_iam_role.ecs-iam-role.name}"
  depends_on = ["aws_iam_role.ecs-iam-role"]
}

resource "aws_iam_role_policy_attachment" "ecs-iam-role" {
  count      = "${length(local.policy_arn)}"
  role       = "${aws_iam_role.ecs-iam-role.name}"
  policy_arn = "${local.policy_arn[count.index]}"
}
