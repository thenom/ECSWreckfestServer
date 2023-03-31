variable "admin_steam_ids" {
  description = "The list of steam IDs to make admin."
  type        = list(string)
  default = [
    "76561198012904643" # Me
  ]
}
