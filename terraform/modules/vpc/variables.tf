variable "vpc_cidr" {
   default = "10.1.0.0/16"
}

variable "basename" {
   description = "Prefix used for all resources names"
   default = "dev"
}

variable "subnet_list" {
   type = map
   default = {
      public-1 = {
         az = "us-east-2a"
         cidr = "10.1.1.0/24"
      }
      public-2 = {
         az = "us-east-2b"
         cidr = "10.1.2.0/24"
      }
      public-3 = {
         az = "us-east-2c"
         cidr = "10.1.3.0/24"
      }
      private-1 = {
         az = "us-east-2a"
         cidr = "10.1.4.0/24"
      }
      private-2 = {
         az = "us-east-2b"
         cidr = "10.1.5.0/24"
      }
      private-3 = {
         az = "us-east-2c"
         cidr = "10.1.6.0/24"
      }
   }
}