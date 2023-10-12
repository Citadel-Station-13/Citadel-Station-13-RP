/**
 * flat entity: spawns specific paths, loot, or structures at specific locations.
 */
/datum/map_layer/entity/flat
	/// list(list(x, y, what), ...); what is path of map template
	var/list/place_templates
	/// list(list(x, y, what), ...); what can be path to mob | obj, path to /datum/prototype/struct/loot(pack|table)
	/// done after structures.
	var/list/place_entities

#warn impl all
