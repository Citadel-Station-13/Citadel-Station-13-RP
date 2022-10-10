/**
 * struct holding onmob rendering data and acts as middleware between
 * the sprite accessory + rendering data on it, and the
 * mob holding it.
 */
// todo: rename to sprite_accessory, rename sprite_accessorry to sprite_accessory_meta
/datum/sprite_accessory_data
	/// reference to accessory
	var/datum/sprite_accessory/accessory
	#warn coloration
	/// emissive enabled? to enable, set 1 to 100 for percentage.
	var/emissives = 0
	/// layer swapped? set to wanted index e.g. 0 1, 2, etc.
	var/layerswapping = 0
	/// addons
	var/list/datum/sprite_accessory_addon/addons

/datum/sprite_accessory_data/proc/render_mob_appearance(mob/M)

/datum/sprite_accessory_data/proc/render_mob_emissives(mob/M)
	if(!accessory.emissives_allowed || !emissives)
		return
