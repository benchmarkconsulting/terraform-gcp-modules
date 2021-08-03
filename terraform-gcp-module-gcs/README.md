# Terraform GCS Module

This module handles compute creation in gcp
The resources/services/activations/deletions that this module will create/trigger are:
- Create google_storage_bucket
- Create google_storage_bucket_iam_member


## Compatibility

This module is meant for use with Terraform 0.14.

## Usage

```hcl
module "foundation-bucket-remotebackend" {
  source = "../../../modules-gcp/module-gcs"

  name       = "foundation-bucket-remotebackend"
  project_id = module.shared-services-host-project.project_id
  location   = "northamerica-northeast1"
  depends_on = [module.shared-services-host-project]
  iam_members = [{
    role   = "roles/storage.admin"
    member = "user:matt.cole@benchmarkcorp.com"
    group  = "group:gcp-organization-admins@univeris.com"
  }]
}
```

## Variable Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admins | IAM-style members who will be granted roles/storage.objectAdmin on all buckets. | `list(string)` | `[]` | no |
| bucket\_admins | Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket admins. | `map(string)` | `{}` | no |
| bucket\_creators | Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket creators. | `map(string)` | `{}` | no |
| bucket\_hmac\_key\_admins | Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket HMAC Key admins. | `map(string)` | `{}` | no |
| bucket\_policy\_only | Disable ad-hoc ACLs on specified buckets. Defaults to true. Map of lowercase unprefixed name => boolean | `map(bool)` | `{}` | no |
| bucket\_storage\_admins | Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket storage admins. | `map(string)` | `{}` | no |
| bucket\_viewers | Map of lowercase unprefixed name => comma-delimited IAM-style per-bucket viewers. | `map(string)` | `{}` | no |
| cors | Map of maps of mixed type attributes for CORS values. See appropriate attribute types here: https://www.terraform.io/docs/providers/google/r/storage_bucket.html#cors | `any` | `{}` | no |
| creators | IAM-style members who will be granted roles/storage.objectCreators on all buckets. | `list(string)` | `[]` | no |
| encryption\_key\_names | Optional map of lowercase unprefixed name => string, empty strings are ignored. | `map(string)` | `{}` | no |
| folders | Map of lowercase unprefixed name => list of top level folder objects. | `map(list(string))` | `{}` | no |
| force\_destroy | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map(bool)` | `{}` | no |
| hmac\_key\_admins | IAM-style members who will be granted roles/storage.hmacKeyAdmin on all buckets. | `list(string)` | `[]` | no |
| labels | Labels to be attached to the buckets | `map(string)` | `{}` | no |
| lifecycle\_rules | List of lifecycle rules to configure. Format is the same as described in provider documentation https://www.terraform.io/docs/providers/google/r/storage_bucket.html#lifecycle_rule except condition.matches\_storage\_class should be a comma delimited string. | <pre>set(object({<br>    # Object with keys:<br>    # - type - The type of the action of this Lifecycle Rule. Supported values: Delete and SetStorageClass.<br>    # - storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule.<br>    action = map(string)<br><br>    # Object with keys:<br>    # - age - (Optional) Minimum age of an object in days to satisfy this condition.<br>    # - created_before - (Optional) Creation date of an object in RFC 3339 (e.g. 2017-06-13) to satisfy this condition.<br>    # - with_state - (Optional) Match to live and/or archived objects. Supported values include: "LIVE", "ARCHIVED", "ANY".<br>    # - matches_storage_class - (Optional) Comma delimited string for storage class of objects to satisfy this condition. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, STANDARD, DURABLE_REDUCED_AVAILABILITY.<br>    # - num_newer_versions - (Optional) Relevant only for versioned objects. The number of newer versions of an object to satisfy this condition.<br>    condition = map(string)<br>  }))</pre> | `[]` | no |
| location | Bucket location. | `string` | `"EU"` | no |
| names | Bucket name suffixes. | `list(string)` | n/a | yes |
| prefix | Prefix used to generate the bucket name. | `string` | n/a | yes |
| project\_id | Bucket project id. | `string` | n/a | yes |
| set\_admin\_roles | Grant roles/storage.objectAdmin role to admins and bucket\_admins. | `bool` | `false` | no |
| set\_creator\_roles | Grant roles/storage.objectCreator role to creators and bucket\_creators. | `bool` | `false` | no |
| set\_hmac\_key\_admin\_roles | Grant roles/storage.hmacKeyAdmin role to hmac\_key\_admins and bucket\_hmac\_key\_admins. | `bool` | `false` | no |
| set\_storage\_admin\_roles | Grant roles/storage.admin role to storage\_admins and bucket\_storage\_admins. | `bool` | `false` | no |
| set\_viewer\_roles | Grant roles/storage.objectViewer role to viewers and bucket\_viewers. | `bool` | `false` | no |
| storage\_admins | IAM-style members who will be granted roles/storage.admin on all buckets. | `list(string)` | `[]` | no |
| storage\_class | Bucket storage class. | `string` | `"MULTI_REGIONAL"` | no |
| versioning | Optional map of lowercase unprefixed name => boolean, defaults to false. | `map(bool)` | `{}` | no |
| viewers | IAM-style members who will be granted roles/storage.objectViewer on all buckets. | `list(string)` | `[]` | no |
| website | Map of website values. Supported attributes: main\_page\_suffix, not\_found\_page | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket | Bucket resource (for single use). |
| buckets | Bucket resources as list. |
| buckets\_map | Bucket resources by name. |
| name | Bucket name (for single use). |
| names | Bucket names. |
| names\_list | List of bucket names. |
| url | Bucket URL (for single use). |
| urls | Bucket URLs. |
| urls\_list | List of bucket URLs. |


## Info 

https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

## Argument Reference

- name - (Required) The name of the bucket.
force_destroy - (Optional, Default: false) When deleting a bucket, this boolean option will delete all contained objects. If you try to delete a bucket that contains objects, Terraform will fail that run.

- location - (Optional, Default: 'US') The GCS location

- project - (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

- storage_class - (Optional, Default: 'STANDARD') The Storage Class of the new bucket. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.

- lifecycle_rule - (Optional) The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted. Structure is documented below.

- versioning - (Optional) The bucket's Versioning configuration.

- website - (Optional) Configuration if the bucket acts as a website. Structure is documented below.

- cors - (Optional) The bucket's Cross-Origin Resource Sharing (CORS) configuration. Multiple blocks of this type are permitted. Structure is documented below.

- retention_policy - (Optional) Configuration of the bucket's data retention policy for how long objects in the bucket should be retained. Structure is documented below.

- labels - (Optional) A map of key/value label pairs to assign to the bucket.

- logging - (Optional) The bucket's Access & Storage Logs configuration.

- encryption - (Optional) The bucket's encryption configuration.

- requester_pays - (Optional, Default: false) Enables Requester Pays on a storage bucket.

- bucket_policy_only - (Deprecated, Default: false) Enables Bucket Policy Only access to a bucket. This field will be removed in the next major release of the provider.

- uniform_bucket_level_access - (Optional, Default: false) Enables Uniform bucket-level access access to a bucket.

The lifecycle_rule block supports:

- action - (Required) The Lifecycle Rule's action configuration. A single block of this type is supported. Structure is documented below.

- condition - (Required) The Lifecycle Rule's condition configuration. A single block of this type is supported. Structure is documented below.

The action block supports:

- type - The type of the action of this Lifecycle Rule. Supported values include: Delete and SetStorageClass.

- storage_class - (Required if action type is SetStorageClass) The target Storage Class of objects affected by this Lifecycle Rule. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE.