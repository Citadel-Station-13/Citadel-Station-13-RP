/**
 * struct holding onmob rendering data and acts as middleware between
 * the sprite accessory + rendering data on it, and the
 * mob holding it.
 */
/datum/sprite_accessory_data
	/// reference to accessory
	var/datum/sprite_accessory/accessory

	/// emissive enabled? to enable, set 1 to 100 for percentage.
	var/emissives = 0
	/// layer swapped? set to wanted index e.g. 0 1, 2, etc.
	var/layerswapping = 0
	/// gradient
