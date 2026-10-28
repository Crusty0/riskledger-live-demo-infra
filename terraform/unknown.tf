# Interview demo only. No compute or network interface is attached to this group.
resource "aws_security_group" "unknown_demo" {
  name_prefix = "riskledger-unknown-demo-"
  description = "Disposable unattached security group for the RiskLedger unknown-finding demo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "RDP access restricted to the private network"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Name                     = "riskledger-unknown-demo"
    environment              = "staging"
    "riskledger:demo-action" = "unknown"
    "riskledger:repo"        = "Crusty0/riskledger-live-demo-infra"
  }
}

output "unknown_security_group_id" {
  description = "AWS security group used for the unknown-finding demo"
  value       = aws_security_group.unknown_demo.id
}
