# ── modules/vpc ──────────────────────────────────────────────────────────────
# Resources this module owns:
#
#   aws_vpc
#   aws_subnet                      public only (no private subnets / NAT yet)
#   aws_internet_gateway
#   aws_route_table
#   aws_route_table_association
#   aws_security_group
#
# Name everything from var.project and var.environment. Never hardcode a
# project-environment literal anywhere under modules/.
#
# Example of the naming pattern expected:
#
#   resource "aws_vpc" "this" {
#     cidr_block = var.vpc_cidr
#     tags       = { Name = "${var.project}-${var.environment}-vpc" }
#   }

# TODO: implement the six resources above.
