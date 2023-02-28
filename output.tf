output "my-server-pbip" {
  description = "the public ip of the app server"
  value = aws_instance.myapp-server.public_ip
}