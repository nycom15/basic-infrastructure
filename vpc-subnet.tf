resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.my_subnet_cidr
  tags = {
    "Name" = "${var.my_env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.my_subnet_cidr
  tags = {
    "Name" = "${var.my_env_prefix}-subnet-1"
  }
}

resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    "Name" = "${var.my_env_prefix}-rtb"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    "Name" = "${var.my_env_prefix}-igw"
  }
}

resource "aws_route_table_association" "namertb-subnet-ass" {
  subnet_id = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}

########### using the default route table #################
/* resource "aws_default_route_table" "main-default-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    "Name" = "${var.my_env_prefix}-main-default-rtb"
  }
} */

resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    "Name" = "${var.my_env_prefix}-myapp-sg"
  }
}
data "aws_ami" "amazonLinux2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-*-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name = "terraform-key"
  public_key = "${file("~/.ssh/terraformkey.pub")}"
  
  tags = {
    "Name" = "mapp-server-key"
  }
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.amazonLinux2.id
  instance_type = var.my_instance_type
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.my_az
  associate_public_ip_address = true
  key_name = aws_key_pair.my_key_pair.key_name
  user_data = file("script.sh")

  tags = {
    Name = "myapp-server"
  }
}