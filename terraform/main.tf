terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_vpc" "default" {
  default = true
}

# Interview demo only. No compute or network interface is attached to this group.
# The open ingress is intentional: AWS Config should report it as NON_COMPLIANT,
# then RiskLedger should propose a pull request removing this block.
resource "aws_security_group" "pr_demo" {
  name_prefix = "riskledger-pr-demo-"
  description = "Disposable unattached security group for RiskLedger PR demo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Intentional open SSH rule for RiskLedger live demo"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                     = "riskledger-pr-demo"
    environment              = "staging"
    criticality              = "low"
    owner                    = "riskledger-demo"
    "riskledger:demo-action" = "pr"
    "riskledger:repo"        = "Crusty0/riskledger-live-demo-infra"
  }
}

output "security_group_id" {
  description = "AWS security group used for the PR demo"
  value       = aws_security_group.pr_demo.id
}
