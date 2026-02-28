resource "azuread_conditional_access_policy" "tier0_mfa" {
  display_name = "CA - Tier0 - Require MFA"
  state        = "enabled"

  conditions {
    users {
      included_groups = [
        var.tier_groups["tier0"].id
      ]

      excluded_users = [
        var.break_glass_user_id
      ]
    }

    applications {
      included_applications = ["All"]
    }

    client_app_types = [
      "browser",
      "mobileAppsAndDesktopClients"
    ]
  }

  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}
