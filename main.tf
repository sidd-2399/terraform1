
# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "sidd-bucket-s3-1-1"  # Change this to a unique bucket name
  
}

# Create an IAM user with full permissions to the S3 bucket
resource "aws_iam_user" "s3_user" {
  name = "s3-full-access-user"
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name = "s3-full-access-policy"
  user = aws_iam_user.s3_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "${aws_s3_bucket.my_bucket.arn}",
        "${aws_s3_bucket.my_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}


# Create a security group allowing inbound connections on ports 80 and 443
resource "aws_security_group" "my_security_group" {
  name        = "my-security-group"
  description = "Allow inbound connections on ports 80 and 443"
  vpc_id      = "vpc-0de696d9ab4409762" 
  
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances
resource "aws_instance" "my_instance" {
  count         = 2
  ami           = "ami-0230bd60aa48260c6"  # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = "subnet-0d7a079f04802860c"

vpc_security_group_ids = [aws_security_group.my_security_group.id]

}
