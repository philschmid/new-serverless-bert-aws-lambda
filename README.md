# This the Repository for my [Configure the serverless.yaml, add EFS, and set up an API Gateway for inference](https://google.com) article

You can read this article on my blog at [Configure the serverless.yaml, add EFS, and set up an API Gateway for inference](https://google.com)
This repository is the result of the article and you can use it if you don´t want you build it yourself.

## Getting started

To use this repository to deploy your serverless Question-Answering API you have to run.

**you need terraform, serverless framework installed and set up. You also need an IAM user called "serverless-bert" configured** You can read my article on how to do this.

**1. create infrastructure**

```bash
terraform apply
```

**2. install Python dependencies on EFS**

```bash
pip3 install efsync
```

configure the efsync.yaml

```bash
aws efs describe-file-systems --creation-token serverless-bert --profile serverless-bert
```

-> extract filesystem id

```bash
aws efs describe-mount-targets --file-system-id <filesystem-id> --profile serverless-bert
```

-> extract one subnet_Id

```bash
efsync -cf efsync.yaml
```

**3. Download model**

```bash
pip3 install torch==1.5.0 transformers==3.4.0
```

```bash
python3 ./function/get_model.py
```

**4. Configure serverless.yaml**

```bash
aws efs describe-mount-targets --file-system-id <filesystem-id> --profile serverless-bert
```

-> extract subnet_ids

```bash
aws ec2   describe-security-groups --filters Name=description,Values="default VPC security group"   --profile serverless-bert
```

-> extract secruity group id

**5. Deploy the function**

```bash
serverless deploy --aws-profile serverless-bert
```
