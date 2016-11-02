---
title       : C7N re:Invent
subtitle    : Demo Policies
author      : Mandeep Bal
url: {lib: "."}
framework: revealjs
revealjs:
  theme: moon
  center: "true"
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
--- .class #id

## Tag Compliance - EC2
``` yaml
  - name: ec2-tag-compliance-mark
    resource: ec2
    filters:
      - "tag:maid_status": absent
      - or:
        - "tag:BillingCode": absent
        - "tag:Dept": absent
    actions:
      - type: mark-for-op
        op: terminate
        days: 1

  - name: ec2-tag-compliance-unmark
    resource: ec2
    filters:
      - type: marked-for-op
        op: terminate
      - "tag:BillingCode": not-null
      - "tag:Dept": not-null
    actions:
      - type: unmark

  - name: ec2-tag-compliance-terminate
    resource: ec2
    filters:
      - type: marked-for-op
        op: terminate
    actions:
      - terminate
```

---

## Tag Compliance - RDS
``` yaml
  - name: rds-tag-compliance-mark
    resource: rds
    filters:
      - type: marked-for-op
        op: delete
      - or:
        - "tag:BillingCode": absent
        - "tag:Dept": absent
    actions:
      - type: mark-for-op
        op: delete
        days: 1

  - name: rds-tag-compliance-unmark
    resource: rds
    filters:
      - type: marked-for-op
        op: delete
      - "tag:BillingCode": not-null
      - "tag:Dept": not-null
    actions:
      - unmark

  - name: rds-tag-compliance-terminate
    resource: rds
    filters:
      - type: marked-for-op
        op: delete
    actions:
      - delete
```

---

## RDS - Access Policy
``` yaml
  - name: rds-PubliclyAccessible
    resource: rds
    filters:
      - PubliclyAccessible: true
    actions:
      - delete
```

---

## RDS - Encryption Policy
``` yaml
  - name: rds-Unencrypted
    resource: rds
    filters:
      - StorageEncrypted: false
    actions:
      - delete
```

---

## EBS - Orphan Volume Cleanup
``` yaml
  - name: ebs-unattached-unencrypted
    resource: ebs
    filters:
      - Attachments: []
      - State: available
    actions:
      - type: delete
```

---

## S3 - Access Control
``` yaml
  - name: deny-s3-global-access
    resource: s3
    filters:
      - type: global-grants
    actions:
      - type: delete-global-grants
```
