# Interview demo only. No compute or network interface is attached to this group.
# The open RDP ingress is intentional: the AWS Config managed rule
# restricted-common-ports reports it as NON_COMPLIANT. RiskLedger has no playbook
# entry for that rule, so the finding takes the generic AI draft route.
resource "aws_security_group" "unknown_demo" {
  name_prefix = "riskledger-unknown-demo-"
  description = "Disposable unattached security group for the RiskLedger unknown-finding demo"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Intentional open RDP rule for the RiskLedger unknown-finding demo"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                     = "riskledger-unknown-demo"
    environment              = "staging"
    criticality              = "low"
    owner                    = "riskledger-demo"
    "riskledger:demo-action" = "unknown"
    "riskledger:repo"        = "Crusty0/riskledger-live-demo-infra"
  }
}

output "unknown_security_group_id" {
  description = "AWS security group used for the unknown-finding demo"
  value       = aws_security_group.unknown_demo.id
}
