## How to run Terraform stack
 1. open local terminal/powershell
 2. Go to terraform directory
 3. Export AWS credentials based on your terminal type
        For Linux/MAC OS terminal,
        `export AWS_ACCESS_KEY_ID="SAMPLEID"
         export AWS_SECRET_ACCESS_KEY="SAMPLEKEY"
         export AWS_DEFAULT_REGION="us-east-2"`

        For Powershell,
        `$Env:AWS_ACCESS_KEY_ID="SAMPLEID"
         $Env:AWS_SECRET_ACCESS_KEY="SAMPLEID"
         $Env:AWS_DEFAULT_REGION="us-east-2"`
 4. Run Below TF commands to create stack
    `terraform init -backend-config="dev_env_backend.conf"
     terraform plan -out=tfplan -var-file="dev_env.tfvars"
     terraform apply -no-color -input=false tfplan
     terraform destroy -auto-approve -var-file="dev_env.tfvars"`