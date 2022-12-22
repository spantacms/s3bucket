# Customer managed KMS key
###########################
resource "aws_kms_key" "kms_s3_key" {
    count  = var.kmskeyonoff ? 1 : 0
    description             = "Key to protect s3 data"
    key_usage               = "s3 data encryption"
    deletion_window_in_days = var.keydelwindow
    is_enabled              = var.keyenabled
}

resource "aws_kms_alias" "kms_s3_key_alias" {
    name          = "alias/s3-key"
    target_key_id = aws_kms_key.kms_s3_key.key_id
}