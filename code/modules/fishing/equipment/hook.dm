/// Multipilier to the fishing weights of anything that's not a fish nor a dud
/// for the magnet hook.
#define MAGNET_HOOK_BONUS_MULTIPLIER 5
/// Multiplier for the fishing weights of fish for the rescue hook.
#define RESCUE_HOOK_FISH_MULTIPLIER 0

/obj/item/fishing_hook
	name = "simple fishing hook"
	desc = "A simple fishing hook."
	icon = 'icons/modules/fishing/hook.dmi'
	icon_state = "hook"
	w_class = WEIGHT_CLASS_TINY

	var/fishing_hook_traits = NONE
	/// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"
	/// What subtype of `/obj/item/chasm_detritus` do we fish out of chasms? Defaults to `/obj/item/chasm_detritus`.
	// var/chasm_detritus_type = /obj/item/chasm_detritus

/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), additive. Is applied after
 * `get_hook_bonus_multiplicative()`.
 */
/obj/item/fishing_hook/proc/get_hook_bonus_additive(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_ADDITIVE

/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), multiplicative. Is applied before
 * `get_hook_bonus_additive()`.
 */
/obj/item/fishing_hook/proc/get_hook_bonus_multiplicative(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE

/**
 * Is there a reason why this hook couldn't fish in target_fish_source?
 * If so, return the denial reason as a string, otherwise return `null`.
 *
 * Arguments:
 * * target_fish_source - The /datum/fish_source we're trying to fish in.
 */
/obj/item/fishing_hook/proc/reason_we_cant_fish(datum/fish_source/target_fish_source)
	return null

/obj/item/fishing_hook/magnet
	name = "magnetic hook"
	desc = "Won't make catching fish any easier, but it might help with looking for other things."
	icon_state = "treasure"
	rod_overlay_icon_state = "hook_treasure_overlay"
	// chasm_detritus_type = /obj/item/chasm_detritus/restricted/objects

/obj/item/fishing_hook/magnet/get_hook_bonus_multiplicative(fish_type, datum/fish_source/source)
	if(fish_type == FISHING_DUD || ispath(fish_type, /obj/item/fish))
		return ..()
	// We multiply the odds by five for everything that's not a fish nor a dud
	return MAGNET_HOOK_BONUS_MULTIPLIER

/obj/item/fishing_hook/shiny
	name = "shiny lure hook"
	icon_state = "gold_shiny"
	fishing_hook_traits = FISHING_HOOK_SHINY
	rod_overlay_icon_state = "hook_shiny_overlay"

/obj/item/fishing_hook/weighted
	name = "weighted hook"
	icon_state = "weighted"
	fishing_hook_traits = FISHING_HOOK_WEIGHTED
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing_hook/rescue
	name = "rescue hook"
	desc = "An unwieldy hook meant to help with the rescue of those that have fallen down in chasms. You can tell there's no way you'll catch any fish with this, and that it won't be of any use outside of chasms."
	icon_state = "rescue"
	rod_overlay_icon_state = "hook_rescue_overlay"
	// chasm_detritus_type = /obj/item/chasm_detritus/restricted/bodies

// This hook can only fish in chasms.
/obj/item/fishing_hook/rescue/reason_we_cant_fish(datum/fish_source/target_fish_source)
	if(istype(target_fish_source, /datum/fish_source/chasm))
		return ..()
	return "The hook on your fishing rod wasn't meant for traditional fishing, rendering it useless at doing so!"

/obj/item/fishing_hook/rescue/get_hook_bonus_multiplicative(fish_type, datum/fish_source/source)
	// Sorry, you won't catch fish with this.
	if(ispath(fish_type, /obj/item/fish))
		return RESCUE_HOOK_FISH_MULTIPLIER
	return ..()

/obj/item/fishing_hook/bone
	name = "bone hook"
	desc = "a simple hook carved from sharpened bone"
	icon_state = "hook_bone"

#undef MAGNET_HOOK_BONUS_MULTIPLIER
#undef RESCUE_HOOK_FISH_MULTIPLIER
