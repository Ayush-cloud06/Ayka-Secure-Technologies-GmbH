locals {

  group_memberships = {

    Tier0 = [
      "emp-001@ayushgta175outlook.onmicrosoft.com",
      "admin-emp-002@ayushgta175outlook.onmicrosoft.com"
    ]

    Tier1 = [
      "emp-001@ayushgta175outlook.onmicrosoft.com",
      "emp-002@ayushgta175outlook.onmicrosoft.com",
      "emp-003@ayushgta175outlook.onmicrosoft.com",
      "emp-004@ayushgta175outlook.onmicrosoft.com",
      "emp-013@ayushgta175outlook.onmicrosoft.com",
      "emp-014@ayushgta175outlook.onmicrosoft.com"
    ]

    Tier2 = [
      "emp-005@ayushgta175outlook.onmicrosoft.com",
      "emp-006@ayushgta175outlook.onmicrosoft.com",
      "emp-007@ayushgta175outlook.onmicrosoft.com",
      "emp-008@ayushgta175outlook.onmicrosoft.com",
      "emp-009@ayushgta175outlook.onmicrosoft.com",
      "emp-010@ayushgta175outlook.onmicrosoft.com",
      "emp-011@ayushgta175outlook.onmicrosoft.com",
      "emp-012@ayushgta175outlook.onmicrosoft.com",
      "emp-015@ayushgta175outlook.onmicrosoft.com",
      "emp-016@ayushgta175outlook.onmicrosoft.com",
      "emp-017@ayushgta175outlook.onmicrosoft.com",
      "emp-018@ayushgta175outlook.onmicrosoft.com",
      "emp-019@ayushgta175outlook.onmicrosoft.com",
      "emp-020@ayushgta175outlook.onmicrosoft.com",
      "emp-021@ayushgta175outlook.onmicrosoft.com",
      "emp-022@ayushgta175outlook.onmicrosoft.com",
      "emp-023@ayushgta175outlook.onmicrosoft.com",
      "emp-024@ayushgta175outlook.onmicrosoft.com"
    ]

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
