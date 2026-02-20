cloud-platform/
│
├── aws-organization/
│   ├── provider.tf
│   ├── organization.tf
│   ├── outputs.tf
│   └── README.md
│
├── ou-structure/
│   ├── ous.tf
│   ├── outputs.tf
│   └── README.md
│
├── scp/
│   ├── policies/
│   │   ├── deny-root-usage.json
│   │   ├── deny-disable-cloudtrail.json
│   │   └── restrict-regions.json
│   ├── scp.tf
│   ├── attachments.tf
│   └── README.md
│
└── landing-zone/
    ├── provider.tf
    ├── security-account.tf
    ├── dev-account.tf
    ├── prod-account.tf
    └── README.md