/obj/item/rig
	name = "rig control module"
	desc = "A control module for some kind of suit."

	//* Activation
	/// activation state
	var/activation_state = RIG_ACTIVATION_OFFLINE

	//* Pieces
	/// list of /datum/component/rig_piece's
	var/list/datum/component/rig_piece/piece_components
	/// direct access cache to the items held by those pieces
	var/list/obj/item/piece_items

	//* Theme
	/// The theme we're using - set to path to load at init
	var/datum/rig_theme/theme
	/// Is our theme initialized?
	var/theme_initialized = FALSE

#warn impl all
