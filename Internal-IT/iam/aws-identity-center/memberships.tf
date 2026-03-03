locals {
  group_memberships = {
    Tier0 = [
      "admin-emp-002@ayushgta175outlook.onmicrosoft.com"
    ]

    Tier1 = [
      "emp-001@ayushgta175outlook.onmicrosoft.com"
    ]

    Tier2 = []
  }
}

data "aws_identitystore_user" "users" {
  for_each = toset(flatten(values(local.group_memberships)))

  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
}

resource "aws_identitystore_group_membership" "memberships" {
  for_each = {
    for item in flatten([
      for group, users in local.group_memberships : [
        for user in users : {
          key   = "${group}-${user}"
          group = group
          user  = user
        }
      ]
      ]) : item.key => {
      group = item.group
      user  = item.user
    }
  }

  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]

  group_id  = aws_identitystore_group.groups[each.value.group].group_id
  member_id = data.aws_identitystore_user.users[each.value.user].user_id
}
