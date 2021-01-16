# AWS Lambda deployment via Terraform Demo

This is a demo to deploy aws lambda via Terraform.


## Prerequisites
- nodejs 12.x
- yarn
- terraform 0.14.4
- aws

## Code structure
```
├── README.md
├── deployment
│         ├── main.tf
│         ├── outputs.tf
│         └── variables.tf
├── package.json
├── src
│         └── index.ts
├── tsconfig.json
└── yarn.lock
 ```
`deployment`: terraform source code

`src`: aws lambda code 

## How to deploy
```
cd deployment/
terraform init
terraform deploy -auto-prove
```