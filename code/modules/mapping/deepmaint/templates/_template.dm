/datum/map_template/submap/deepmaint
	abstract_type = /datum/map_template/submap/deepmaint
	prefix = "maps/submaps/deepmaint/"
	domain = "deepmaint"

	/**
	 * -- MAPPERS - SET THESE VARS --
	 * Check code/__DEFINES/mapping/deepmaint.dm for values
	 * ID - ENSURE THIS IS SOME FORM OF deepmaint_*
	 * Optimally, something like
	 * - spacestation_rnd
	 * - spacestation_medbay
	 * - underground_icecave
	 * - underground_cave
	 * - underground_cave2
	 */
	name = "Unnamed Deepmaint Template"
	desc = "A deepmaint template."
	id = "example"
	/// danger
	var/danger = DEEPMAINT_DANGER_HARMFUL
	/// rarity
	var/rarity = DEEPMAINT_RARITY_BASICS
	/// put directive flags in here - see [code/__DEFINES/mapping/deepmaint.dm]
	var/directives = NONE
	/// deepmaint type
	var/deepmaint_type = DEEPMAINT_TYPE_ABOVEGROUND | DEEPMAINT_TYPE_UNDERGRONUD
	/// deepmaint theme
	var/deepmaint_theme = DEEPMAINT_THEME_GENERIC
	/// allowed spawns per total dungeon
	var/allowed_spawns_per = INFINITY
	/// allowed spawns globally
	var/allowed_spawns_all = INFINITY
