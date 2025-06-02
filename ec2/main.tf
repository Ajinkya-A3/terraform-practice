resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "private_key" {

  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/key-pair/${var.key_name}.pem" # Save the private key to a file in the current module directory
  file_permission = "0600"

}
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_name # Replace with your actual key pair name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "${var.key_name}-key"
  }
}



resource "aws_instance" "example" {
  ami = var.ami_id # Replace with a valid AMI ID for your region

  instance_type = var.instance_type

  subnet_id = var.subnet_id

  user_data = file("user_data.sh")               # Ensure this file exists in the same directory
  key_name  = aws_key_pair.ec2_key_pair.key_name # Use the created key pair

  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # Attach the security group


  tags = {
    Name = var.instance_name
  }


}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (not recommended for production)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere (not recommended for production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"        # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }


}


