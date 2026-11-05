# Thisbit BYOC on S3 (`thisbit-byoc-s3`)

Base Terraform configuration to provision a private **AWS S3** bucket (with `prevent_destroy = true`, public access blocked, AES-256 encryption, and a least-privilege IAM policy scoped exclusively to `studio-media/*` and `voice-reviews/*`) for [Thisbit Corporate (BYOC)](https://thisbit.ai).

> Using **Cloudflare R2**, **Hetzner Object Storage**, **MinIO**, **DigitalOcean Spaces**, or **Backblaze B2**? Any S3-compatible bucket works directly on the [Thisbit Integrations page](https://thisbit.ai/dashboard/integrations.html#key-vault-card) by entering your bucket name, region (or `auto`), S3 endpoint URL, and bucket-scoped access keys.

## Quickstart

### Option A: Drop into an Existing Terraform Repo

```hcl
module "thisbit_s3" {
  source      = "github.com/awowIO/thisbit-byoc-s3"
  bucket_name = "thisbit-voice-cauchy"
  region      = "eu-west-1"
}
```

### Option B: Standalone Clone & Apply

```sh
git clone https://github.com/awowIO/thisbit-byoc-s3.git
cd thisbit-byoc-s3
cp terraform.tfvars.example terraform.tfvars   # set bucket_name and region

terraform init
terraform apply
```

Then copy the outputs into [**Thisbit → Integrations → External location (S3)**](https://thisbit.ai/dashboard/integrations.html#key-vault-card):

```sh
terraform output -raw thisbit_s3_bucket
terraform output -raw thisbit_access_key_id
terraform output -raw thisbit_secret_access_key
```
