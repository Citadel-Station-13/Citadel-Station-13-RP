/**
 * Startup hook.
 * Called in world.dm when the server starts.
 */
/legacy_hook/startup

/**
 * Roundstart hook.
 * Called in gameSSticker.dm when a round starts.
 */
/legacy_hook/roundstart

/**
 * Roundend hook.
 * Called in gameSSticker.dm when a round ends.
 */
/legacy_hook/roundend

/**
 * Death hook.
 * Called in death.dm when someone dies.
 * Parameters: var/mob/living/carbon/human, var/gibbed
 */
/legacy_hook/death

/**
 * Cloning hook.
 * Called in cloning.dm when someone is brought back by the wonders of modern science.
 * Parameters: var/mob/living/carbon/human
 */
/legacy_hook/clone

/**
 * Debrained hook.
 * Called in brain_item.dm when someone gets debrained.
 * Parameters: var/obj/item/organ/brain
 */
/legacy_hook/debrain

/**
 * Borged hook.
 * Called in robot_parts.dm when someone gets turned into a cyborg.
 * Parameters: var/mob/living/silicon/robot
 */
/legacy_hook/borgify

/**
 * Podman hook.
 * Called in podmen.dm when someone is brought back as a Diona.
 * Parameters: var/mob/living/carbon/alien/diona
 */
/legacy_hook/harvest_podman

/**
 * Payroll revoked hook.
 * Called in Accounts_DB.dm when someone's payroll is stolen at the Accounts terminal.
 * Parameters: var/datum/money_account
 */
/legacy_hook/revoke_payroll

/**
 * Account suspension hook.
 * Called in Accounts_DB.dm when someone's account is suspended or unsuspended at the Accounts terminal.
 * Parameters: var/datum/money_account
 */
/legacy_hook/change_account_status

/**
 * Crate sold hook.
 * Called in supplyshuttle.dm when a crate is sold on the shuttle.
 * Parameters: var/obj/structure/closet/crate/sold, var/area/shuttle
 */
/legacy_hook/sell_crate

/**
 * Supply Shuttle sold hook.
 * Called in supplyshuttle.dm when the shuttle contents are sold.
 * This hook is called _before_ the crates are processed for normal
 * phoron/metal sale (and before the sell_crate hooks)
 * Parameters: var/area/area_shuttle
 */
/legacy_hook/sell_shuttle
