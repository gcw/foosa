variable "region" {
  type = string
  default = "us-west-2"
}

variable "parent_zone_name" {
  type = string
  default = "fooness.com"
}

variable "bucket_name" {
  type = string
  default = "www_fooness_com"

}

variable "access_log_bucket_name" {
  type = string
  default = "fooness-logz"
}

variable "origin_bucket" {
  type        = string
  default     = "fooness-origin"
  description = "Origin S3 bucket name"
}

variable "extra_logs_attributes" {
  type        = list(string)
  default     = ["logs"]
  description = "Additional attributes to put onto the log bucket label"
}

variable "log_prefix" {
  type        = string
  default     = "foones-logs"
  description = "Path of logs in S3 bucket"
}


variable "log_standard_transition_days" {
  type        = number
  description = "Number of days to persist in the standard storage tier before moving to the glacier tier"
  default     = 30
}


variable "log_glacier_transition_days" {
  type        = number
  description = "Number of days after which to move the data to the glacier storage tier"
  default     = 60
}

variable "log_expiration_days" {
  type        = number
  description = "Number of days after which to expunge the objects"
  default     = 90
}

variable "log_versioning_enabled" {
  type        = bool
  default     = false
  description = "When true, the access logs bucket will be versioned"
}

