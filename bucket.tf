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
  bucket = aws_s3_bucket.my_bucket.id
  acl    = var.bucketacl
}

#############################
# Enable bucket versioning
#############################
resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  count  = var.bucketveronoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id
}

#################################
# Enable server access logging
#################################
resource "aws_s3_bucket_logging" "my_bucket_logging" {
  count  = var.bucketlogonoff ? 1 : 0
  bucket = aws_s3_bucket.my_bucket.id

  target_bucket = var.access_logging_bucket_name
  target_prefix = "${var.s3bucket_name}/"
}

##########################################
# Enable default Server Side Encryption
##########################################
resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.my_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_s3_key.arn
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

  bucket = aws_s3_bucket.my_bucket.bucket

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
  bucket = aws_s3_bucket.my_protected_bucket.id

  # Block public access
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}