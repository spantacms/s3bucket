variable "s3bucket_name" {
    description = " s3 bucket to be created"
    type = string
}
variable "bucketonoff" {
  description = " turn bucket creation on and off"
  type = bool
  default = true
}
variable "s3bucketacl" {
    description = " ACL for bucket , private recommended"
    type = string
    default = "private"
}
variable "bucketveronoff" {
  description = " versioning on the bucket true or false"
  type = bool
  default = false
}
variable "bucketlogonoff" {
  description = " bucket logging true or false. depend on bucket_log_s3_name variable "
  type = bool
  default = false
}
variable "bucketlifecyle" {
  description = "lifecycle of the bucket on and off"
  type = bool
  default = false
}
variable "kmskeyonoff" {
  description = "kms key enable ( true ) "
  type = bool
  default = false
}
variable "keydelwindow" {
    description = " kms key deletion time"
    type = string
    default = 7
}
variable "keyenabled" {
    description = " ksm key enabled true"
    type = bool
    default = false
}
variable "bucketveron" {
    description = " this is bucket versioning , Enabled , Disabled."
    type = string
    default = "Disabled"
}
variable "bucket_log_s3_name" {
  description = " logging bucket for creating bucket for bucket log"
  type        = string

}
variable "bucketlifecycleonoff" {
    description = " life cyle of the bucket true or false"
    type = bool
    default = false
}
