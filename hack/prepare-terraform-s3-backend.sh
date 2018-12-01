#!/usr/bin/env bash

set +euo pipefail

export BUCKET_NAME='com.faizhasim.terraform'
export DYNAMODB_TABLE='terraform-locks'

create-bucket() {
  if aws s3api head-bucket --bucket "$1" 2>/dev/null; then
    echo Bucket $1 already exist. Skipping creation.
  else
    aws s3api create-bucket --acl private --bucket $1 --region ap-southeast-1 --create-bucket-configuration LocationConstraint=ap-southeast-1
    echo Bucket $1 created.
  fi
}

create-dynamodb() {
  if aws dynamodb describe-table --table-name 2>/dev/null; then
    echo Table $1 already exist. Skipping creation.
  else
    aws dynamodb create-table --table-name $1 \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --provisioned-throughput 'ReadCapacityUnits=1,WriteCapacityUnits=1'
    echo Table $1 created.
  fi
}

create-bucket $BUCKET_NAME
create-dynamodb $DYNAMODB_TABLE
