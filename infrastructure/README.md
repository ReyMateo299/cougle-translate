# infrastructure/ — Terraform

Terraform for the COUGle Translate platform. The modules are scaffolded: every
file declares its variables and outputs, and each `main.tf` lists the
resources it owns, but the resources are not implemented yet.

Check that it is clean before and after changes:

```bash
cd environments/dev
terraform init
terraform fmt -check -recursive ../..   # no output = pass
terraform validate                      # exits 0
```

## Layout

```
modules/vpc/        aws_vpc, aws_subnet (public only), aws_internet_gateway,
                    aws_route_table, aws_route_table_association, aws_security_group
modules/storage/    aws_s3_bucket + public_access_block, versioning,
                    server_side_encryption_configuration, aws_s3_object x4
modules/iam/        one aws_iam_role (MLEngineer trust), one aws_iam_policy,
                    one aws_iam_role_policy_attachment
modules/sagemaker/  aws_sagemaker_domain, aws_sagemaker_user_profile
environments/dev/   real AWS (remote state in S3 + DynamoDB lock)
environments/local/ LocalStack (vpc, storage, iam only); see its README
```

Keep each module to its own resources.

## Naming

**No hardcoded names.** This should return nothing:

```bash
grep -rn '"cougle-translate-dev"' infrastructure/modules/
```

Build names from `var.project` and `var.environment`, and give every variable
a `description`.

The data bucket is the one name that also needs the account ID, because S3
bucket names are global across all AWS accounts. Read it from the caller
inside `modules/storage`:

```hcl
data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.project}-${var.environment}-data-${data.aws_caller_identity.current.account_id}"
}
```

The same line yields `cougle-translate-dev-data-<your account>` on AWS and
`cougle-translate-local-data-000000000000` on LocalStack with no special-casing.
