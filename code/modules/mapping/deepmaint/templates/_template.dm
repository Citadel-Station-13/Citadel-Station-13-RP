/datum/map_template/submap/deepmaint
	abstract_type = /datum/map_template/submap/deepmaint
	prefix = "maps/submaps/deepmaint/"

	// -- MAPPERS - SET THESE VARS --
	// Check code/__DEFINES/mapping/deepmaint.dm for values
	/// name
	name = "unnamed deepmaint dungeon"
	/// unique id
	var/id = "deepmaint_"
	/// danger
	var/danger = DEEPMAINT_DANGER_HARMFUL
	/// rarity
	var/rarity = DEEPMAINT_RARITY_BASICS
	/// put directive flags in here - see [code/__DEFINES/mapping/deepmaint.dm]
	var/directives = NONE
	/// deepmaint type
	var/template_type = DEEPMAINT_TYPE_ABOVEGROUND | DEEPMAINT_TYPE_UNDERGRONUD
	/// deepmaint theme
	var/template_theme = DEEPMAINT_THEME_GENERIC
	/// allowed spawns per total dungeon
	var/allowed_spawns_per = INFINITY
	/// allowed spawns globally
	var/allowed_spawns_all = INFINITY
