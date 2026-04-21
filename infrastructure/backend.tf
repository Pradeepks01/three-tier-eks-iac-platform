# =============================================================================
# Terraform Remote State Backend — S3
# =============================================================================
# Stores the Terraform state file in an S3 bucket for team collaboration
# and state locking. You MUST create the S3 bucket before running
# `terraform init`.
#
# Prerequisites:
#   1. Create the S3 bucket:  aws s3 mb s3://<your-bucket-name> --region <region>
#   2. Enable versioning:     aws s3api put-bucket-versioning \
#                               --bucket <your-bucket-name> \
#                               --versioning-configuration Status=Enabled
# =============================================================================

terraform {
  backend "s3" {
    bucket = "<YOUR_S3_BUCKET_NAME>"       # TODO: Replace with your S3 bucket name
    key    = "three-tier-eks/terraform.tfstate"
    region = "us-west-2"                   # TODO: Replace with your region
  }
}
