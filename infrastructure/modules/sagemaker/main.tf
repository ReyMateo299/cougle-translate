# ── modules/sagemaker ────────────────────────────────────────────────────────
# Resources this module owns:
#
#   aws_sagemaker_domain
#   aws_sagemaker_user_profile
#
# A brand-new AWS account has no service-linked role for Studio, and the
# Domain fails to create with a service-linked role error. Fix it once in the
# console (IAM -> Roles -> Create Role -> AWS Service -> SageMaker -> SageMaker
# Studio) and re-apply. This creates AWSServiceRoleForAmazonSageMakerNotebooks;
# you only need to do it once per account.
#
# The Domain is also the slowest resource here by a wide margin -- several
# minutes to create and to delete. Factor that into apply/destroy timings.

# The Domain needs an execution role (default_user_settings.execution_role)
# and the security group from modules/vpc; both arrive as variables. See the
# module call in environments/dev/main.tf.

# TODO: implement the two resources above.
