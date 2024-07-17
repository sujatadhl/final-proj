module "iam_codedeploy"{
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.40.0"
  create_role = true

  role_name         = "java-role-for-codedeploy"
  role_requires_mfa = false
  trusted_role_arns = [
    "arn:aws:iam::426857564226:root"
  ]
  create_custom_role_trust_policy = true
  custom_role_trust_policy= data.aws_iam_policy_document.custom_trust_policy.json
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  ]
  number_of_custom_role_policy_arns = 1
}  

module "iam_codebuild"{
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.40.0"
  create_role = true

  role_name         = "java-role-for-codebuild"
  role_requires_mfa = false
  trusted_role_arns = [
    "arn:aws:iam::426857564226:root"
  ]
  create_custom_role_trust_policy = true
  custom_role_trust_policy= data.aws_iam_policy_document.custom_trust_policy.json
  custom_role_policy_arns =[module.iam_policy_codebuild.arn]
  number_of_custom_role_policy_arns = 1
}  

module "iam_codepipeline"{
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.40.0"
  create_role = true

  role_name         = "java-role-for-codepipeline"
  role_requires_mfa = false
  trusted_role_arns = [
    "arn:aws:iam::426857564226:root"
  ]
  create_custom_role_trust_policy = true
  custom_role_trust_policy= data.aws_iam_policy_document.custom_trust_policy.json
  custom_role_policy_arns = [
  module.iam_policy_codepipeline.arn  ]
  number_of_custom_role_policy_arns = 1
}  

module "iam_policy_codebuild"{
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.name}-policy-for-codebuild"
  path        = "/"
 
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
         {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:us-east-1:426857564226:log-group:*",
                "arn:aws:logs:us-east-1:426857564226:log-group:/aws/codebuild/java:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterface",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateNetworkInterfacePermission"
            ],
            "Resource": "arn:aws:ec2:us-east-1:426857564226:network-interface/*"
            
        },
        {
            "Effect": "Allow",
           "Resource": [
      "arn:aws:s3:::java-artifact/java-cicd_pipeline/source_out/*"
    ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
        "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
                ],
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:426857564226:secret:*"
                ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-us-eas-1-*",
                "arn:aws:s3:::java-artifact/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:us-east-1:426857564226:report-group/java-*"
            ]
        }
    ]
  }
  EOF
}

data "aws_iam_policy_document" "custom_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}


module "iam_policy_codepipeline"{
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.name}-policy-for-codepipeline"
  path        = "/"
 
  policy = <<EOF
  {
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
         {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::java-artifacts",
                "arn:aws:s3:::java-artifacts/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
  EOF
}

