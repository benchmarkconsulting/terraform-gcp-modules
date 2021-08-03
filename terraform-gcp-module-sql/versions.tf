terraform {
  required_version = ">= 0.13"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 2.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.53"
    }
  }
}
