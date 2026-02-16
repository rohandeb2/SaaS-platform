# US East 1 Recorder
resource "aws_config_configuration_recorder" "primary" {
  provider = aws.us_east_1
  name     = "${var.name_prefix}-us-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                = true
    include_global_resource_types = true # Record global IAM once here
  }
}

resource "aws_config_configuration_recorder_status" "primary" {
  provider   = aws.us_east_1
  name       = aws_config_configuration_recorder.primary.name
  is_enabled = true
}

# EU West 1 Recorder
resource "aws_config_configuration_recorder" "secondary" {
  provider = aws.eu_west_1
  name     = "${var.name_prefix}-eu-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                = true
    include_global_resource_types = false # Do not duplicate global records
  }
}

resource "aws_config_configuration_recorder_status" "secondary" {
  provider   = aws.eu_west_1
  name       = aws_config_configuration_recorder.secondary.name
  is_enabled = true
}
