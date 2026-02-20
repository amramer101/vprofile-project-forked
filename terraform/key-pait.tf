resource "aws_key_pair" "ci_key_pair" {
  key_name   = "ci key pair"
  public_key = file("ci-key.pub")
}
