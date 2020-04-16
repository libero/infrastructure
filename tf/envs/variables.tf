variable "region" {
  default = "us-east-1"
  description = "The AWS region."
}

variable "env" {
  description = "Environment: unstable, demo, ..."
}

variable "map_users" {
  default = [
    {
      userarn  = "arn:aws:iam::540790251273:user/GiorgioSironi"
      username = "GiorgioSironi"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::540790251273:user/DanielHaarhoff"
      username = "DanielHaarhoff"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::540790251273:user/ChrisWilkinson"
      username = "ChrisWilkinson"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::540790251273:user/ChrisWilkinson"
      username = "PeterHooper"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::540790251273:user/TravisCI"
      username = "TravisCI"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::540790251273:user/GithubActions"
      username = "GithubActions"
      groups   = ["system:masters"]
    },
  ]
  description = "IAM users that can access the cluster"
}
