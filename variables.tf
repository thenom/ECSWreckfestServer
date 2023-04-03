variable "admin_steam_ids" {
  description = "The list of steam IDs to make admin."
  type        = list(string)
  default     = []
}

variable "server_password" {
  description = "The server password to be asked on terraform apply"
  type        = string
}

variable "server_name" {
  description = "The name for the running server"
  type        = string
}

variable "welcome_message" {
  description = "The welcome message for the server"
  type        = string
  default     = "Start your engines!"
}

variable "udp_ports" {
  description = "List of UDP ports to setup for the service"
  type        = set(string)
  default = [
    "27016",
    "33540"
  ]
}

variable "tcp_ports" {
  description = "List of TCP ports to setup for the service"
  type        = set(string)
  default = [
  ]
}

variable "tcp_udp_ports" {
  description = "List of TCP/UDP ports to setup for the service"
  type        = set(string)
  default = [
    "27015"
  ]
}

variable "lb_name" {
  description = "The name opf the load balancer to setup the TG and Listener for the above ports"
  type        = string
  default     = "main-2a"
}

variable "source_cidr_blocks" {
  description = "The CIDR block sources to add to the allowed ingress"
  type        = set(string)
}

variable "subnet_ids" {
  description = "The list of subnet ID's to deploy to"
  type        = set(string)
}
