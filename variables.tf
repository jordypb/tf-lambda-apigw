variable "name" {}
variable "bucket_name" {}
variable "regionaws" {}
variable "profileaws" {}
variable "runtime" {}
variable "timeout" {
  type = number
}
variable "memory_size" {
  type = number
}

variable "environment" {}
variable "swagger"    {}
