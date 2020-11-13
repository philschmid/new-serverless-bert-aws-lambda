# provider 
provider "aws" {
	region                  = "eu-central-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "serverless-bert"
}

# get all available availability zones

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.default.id
}

# EFS File System

resource "aws_efs_file_system" "efs" {
  creation_token = "serverless-bert"
}

# Access Point 

resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.efs.id
}

# Mount Targets

resource "aws_efs_mount_target" "efs_targets" {
  for_each = data.aws_subnet_ids.subnets.ids
  subnet_id      = each.value
  file_system_id = aws_efs_file_system.efs.id
}

# 
# SSM Parameter for serverless
#

resource "aws_ssm_parameter" "efs_access_point" {
  name      = "/efs/accessPoint/id"
  type      = "String"
  value     = aws_efs_access_point.access_point.id
  overwrite = true
}