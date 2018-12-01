
terraform init -backend-config="bucket=com.faizhasim.terraform" -backend-config="key=2018-12-01-terraform.tfstate" -backend-config="region=ap-southeast-1" -backend=true -force-copy -get=true -input=false
