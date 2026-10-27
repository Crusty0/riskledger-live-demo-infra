# RiskLedger live PR demo infrastructure

This repository contains one deliberately noncompliant AWS security group in `eu-west-2`. It is **unattached** to any instance or network interface. AWS Config's `restricted-ssh` rule should detect its open SSH ingress, and RiskLedger should open a pull request that removes that ingress block from `terraform/main.tf`.

The security group exists only for a controlled interview demo. The pull request is the proposed infrastructure change; RiskLedger does not merge it or apply it to AWS.

## Deploy the disposable group

Use the local AWS profile for the RiskLedger demo account and keep the Terraform state on your own machine. The state and variable files are ignored by Git.

```sh
cd terraform
AWS_PROFILE=riskledger-admin tofu init
AWS_PROFILE=riskledger-admin tofu plan
AWS_PROFILE=riskledger-admin tofu apply
AWS_PROFILE=riskledger-admin tofu output security_group_id
```

The configuration creates only one security group in the account's default VPC. It creates no EC2 instance, IP address, load balancer, or NAT gateway. Check that the group has no associated network interfaces before using it as a demo target.

## Repeat or clean up

For another PR demonstration, keep `main` with the intentional open SSH rule, close the previous demo PR if needed, and trigger a fresh AWS Config evaluation. To remove the group, run `AWS_PROFILE=riskledger-admin tofu destroy` from the same directory **with the original local state present**. Review the plan before confirming. Do not delete the local state while the group still exists.

The separate containment demo uses another disposable security group; it is not managed by this Terraform configuration.
