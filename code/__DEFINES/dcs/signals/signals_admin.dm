/**
 *! ## Admin Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! Admin helps
/// From /datum/admin_help/RemoveActive().
/// Fired when an adminhelp is made inactive either due to closing or resolving.
////#define COMSIG_ADMIN_HELP_MADE_INACTIVE "admin_help_made_inactive"

/// Called when the player replies. From /client/proc/cmd_admin_pm().
////#define COMSIG_ADMIN_HELP_REPLIED "admin_help_replied"
