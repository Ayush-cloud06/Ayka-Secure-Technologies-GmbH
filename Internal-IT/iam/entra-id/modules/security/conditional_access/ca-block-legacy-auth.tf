/*This blocks old protocols like:
IMAP
POP
Basic Auth
Old Outlook clients
*/
resource "azuread_conditional_access_policy" "block_legacy_auth" {

  display_name = "CA-Block-Legacy-Authentication"

  state = "enabled"

  conditions {
    client_app_types = [
      "exchangeActiveSync",
      "other"
    ]

    applications {
      included_applications = ["All"]
    }

    users {
      included_users = ["All"]
      excluded_users = [
        var.break_glass_user_id
      ]
    }
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["block"]
  }
}
