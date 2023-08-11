/* 
  Aqui definimos:
    - La versión de Terraform
    - Donde se almacena el tfstate
*/

terraform {
  required_version = "~> 1.3.5" 

  required_providers { # TODO
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.12"
    }
  }

  backend "local" {
    #path = "${path.module}/state/terraform.tfstate"  
  }
  # provider "kind" {}

  # data "aws_ami" "miami" {
  #   //get ami arn
  # }

  # resource "aws_ami" "random" {
  #   ami_id = aws_ami.name.miami.arn
  # }

  # required_providers { # TODO
  #   aws = {
  #     source  = "hashicorp/aws"
  #     version = "4.32.0"
  #   }
  # }
}

  # backend "s3" {
  #   bucket         = "igz-aws-training-terraform-state"
  #   key            = "terraform.tfstate"
  #   region         = "eu-west-1"
  #   dynamodb_table = "igz-aws-training-terraform-state-locks"
  #   encrypt        = true
  # }
  
    resource "kind_cluster" "default" {
    name = var.cluster_name

    kind_config {
      api_version = "kind.x-k8s.io/v1alpha4"
      kind        = "Cluster"
      node {
        role = "control-plane"
      }
    }
  }
