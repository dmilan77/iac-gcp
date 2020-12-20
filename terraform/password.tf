# resource "random_password" "argocdpassword" {
#   length = 16
#   special = true
#   override_special = "_%@"
# }
# output argocdpassword {
#   value       = random_password.argocdpassword.result
#   sensitive   = false
#   description = "description"
#   depends_on  = []
# }
