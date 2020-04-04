### Authenticate to AWS

Before configuring AWS CLI as EKS at this time is only available in US East (N. Virginia) and US West (Oregon)
In below example we will be using US West (Oregon) "us-west-2"

```sh
aws configure
```

## Creating terraform IAM account with access keys and access policy

1st step is to setup terraform admin account in AWS IAM

### Create IAM terraform User

```sh
aws iam create-user --user-name terraform
```

### Add to newly created terraform user IAM admin policy

> NOTE: For production or event proper testing account you may need tighten up and restrict access for terraform IAM user


```sh
aws iam attach-user-policy --user-name terraform --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
```

### Create access keys for the user

> NOTE: This Access Key and Secret Access Key will be used by terraform to manage infrastructure deployment

```sh
aws iam create-access-key --user-name terraform
```

### update terraform.tfvars file with access and security keys for newly created terraform IAM account


## Creating back-end storage for tfstate file in AWS S3

Once we have terraform IAM account created we can proceed to next step creating dedicated bucket to keep terraform state files

### Create terraform state bucket

> NOTE: Change name of the bucker, name should be unique across all AWS S3 buckets

```sh
aws s3 mb s3://terraform-state-mini-maya --region ap-southeast-1
```

### Enable versioning on the newly created bucket

```sh
aws s3api put-bucket-versioning --bucket terra-state-bucket --versioning-configuration Status=Enabled
```
