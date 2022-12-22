# Bucket creation
########################
resource "aws_s3_bucket" "my_bucket" {
  count  = var.bucketonoff ? 1 : 0
  bucket = var.s3bucket_name
}

##########################
# Bucket private access
##########################
resource "aws_s3_bucket_acl" "my_bucket_acl" {
  count  = var.bucketonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].id
  acl    = var.s3bucketacl
}

#############################
# Enable bucket versioning
#############################
resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  count  = var.bucketonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].id
   versioning_configuration {
    status = var.bucketveron
  }
}
# Customer managed KMS key
###########################
resource "aws_kms_key" "kms_s3_key" {
    count  = var.kmskeyonoff ? 1 : 0
    description             = "Key to protect s3 data"
    key_usage               = "ENCRYPT_DECRYPT"
    deletion_window_in_days = var.keydelwindow
    is_enabled              = var.keyenabled
}

resource "aws_kms_alias" "kms_s3_key_alias" {
    count  = var.kmskeyonoff ? 1 : 0
    name          = "alias/s3-key"
    target_key_id = aws_kms_key.kms_s3_key[0].key_id
}


#################################
# Enable server access logging
#################################
resource "aws_s3_bucket_logging" "my_bucket_logging" {
  count  = var.bucketlogonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].id

  target_bucket = var.bucket_log_s3_name
  target_prefix = "${var.s3bucket_name}/"
}

##########################################
# Enable default Server Side Encryption
##########################################
resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_server_side_encryption" {
  count  = var.bucketonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].bucket

  rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_s3_key[0].arn
        sse_algorithm     = "aws:kms"
    }
  }
}

############################
# Creating Lifecycle Rule
############################
resource "aws_s3_bucket_lifecycle_configuration" "my_bucket_lifecycle_rule" {
  count  = var.bucketlifecycleonoff ? 1 : 0
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.my_bucket_versioning]

  bucket = aws_s3_bucket.my_bucket[0].bucket

  rule {
    id = "basic_config"
    status = "Enabled"

    filter {
      prefix = "config/"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }
    
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

########################
# Disabling bucket
# public access
########################
resource "aws_s3_bucket_public_access_block" "my_bucket_access" {
  count  = var.bucketonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket[0].id

  # Block public access
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}