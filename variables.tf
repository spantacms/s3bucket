variable "s3bucket_name" {
    type = string
}
variable "bucketonoff" {
  type = bool
  default = true
}
variable "s3bucketacl" {
    type = string
    default = "private"
}
variable "bucketveronoff" {
  type = bool
  default = false
}
variable "bucketlogonoff" {
  type = bool
  default = false
}
variable "bucketlifecyle" {
  type = bool
  default = false
}
variable "kmskeyonoff" {
  type = bool
  default = false
}
variable "keydelwindow" {
    type = string
    default = 7
}
variable "keyenable" {
    type = bool
    default = false
}

