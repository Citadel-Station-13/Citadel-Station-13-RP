//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/**
 * Detected / specified connector.
 */
/datum/jigsaw_template_connector
	/// x offset from lower left
	var/x_offset
	/// y offset from lower left
	var/y_offset
	/// Direction facing
	/// * Connectors can only connect to other connectors facing the opposite direction.
	var/direction
	var/width
	var/margin

GLOBAL_LIST_EMPTY(jigsaw_template_cache)

/proc/fetch_cached_jigsaw_template(datum/jigsaw_template/path)
	if(istype(path))
		return path
	else if(isnull(path))
		return null

	if(GLOB.jigsaw_template_cache[path])
		return GLOB.jigsaw_template_cache[path]

	var/datum/jigsaw_template/template = new path
	GLOB.jigsaw_template_cache[path] = template

	return template

/proc/unload_cached_jigsaw_templates()
	for(var/path in GLOB.jigsaw_template_cache)
		var/datum/jigsaw_template/template = GLOB.jigsaw_template_cache[path]
		template.unload_cache()

/datum/jigsaw_template
	/// the name of this template, used for debugging and referencing in other templates.
	var/name = "Dungeon Fragment"
	/// path on disk
	var/path

	/// display name
	/// * defaults to name
	/// * appended to the jigsaw generator's name for area names
	var/display_name

	/// parsed map if held
	var/datum/dmm_parsed/parsed

	/**
	 * Are we fully convex?
	 * * Fully convex means there are no non-skipover turfs more 'outside'
	 *   on any side than a connector.
	 * * Fully convex templates can be planned out without actually loading,
	 *   and are the only things allowed in the first phase of jigsaw generation.
	 */
	var/convex = FALSE

	/**
	 * Connectors with locations.
	 * * Supports auto-detection if nulled.
	 */
	var/list/datum/jigsaw_template_connector/connectors = null

#warn impl

/datum/jigsaw_template/proc/unload_cache()
	parsed = null

/datum/jigsaw_template/proc/load_cached()
	parsed = new(path)
