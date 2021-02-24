/******************************************
  Provider Versions
 *****************************************/
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.30"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.30"
    }
  }
}

/******************************************
  Provider credential configuration
 *****************************************/
provider "google" {
  alias = "impersonate"

  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonate
  target_service_account = var.terraform_service_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "600s"
}

provider "google" {
  access_token = data.google_service_account_access_token.default.access_token
}

provider "google-beta" {
  access_token = data.google_service_account_access_token.default.access_token
}
