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

/datum/jigsaw_template_pattern

#warn emplace

/**
 * rectangular bounding box over the template. the template is lower-left
 * aligned to this box.
 *
 * * width / height is in alignment multiples
 * * this is for 'south' facing orientation.
 */
/datum/jigsaw_template_pattern/rectangular
	abstract_type = /datum/jigsaw_template_pattern/rectangular
	var/width
	var/height

/datum/jigsaw_template_pattern/rectangular/one_by_one
	width = 1
	height = 1
	var/list/south_match
	var/list/north_match
	var/list/east_match
	var/list/west_match

/datum/jigsaw_template_pattern/rectangular/two_by_two
	width = 2
	height = 2

/datum/jigsaw_template_pattern/rectangular/three_by_three
	width = 3
	height = 3

/datum/jigsaw_template
	/// the name of this template, used for debugging and referencing in other templates.
	var/name = "Dungeon Fragment"
	/// path on disk
	var/path
	/// alignment
	/// * alignment is the minimum size and must be a multiple of the actual size.
	/// * generations must only use templates with the same alignment.
	/// * templates are emplaced with one tile of overlap for their alignment.
	var/alignment = 8
	/// pattern
	var/datum/jigsaw_template_pattern/pattern

	/// display name
	/// * defaults to name
	/// * appended to the jigsaw generator's name for area names
	var/display_name

	/// parsed map if held
	var/datum/dmm_parsed/parsed

	/**
	 * Did auto-measure happen yet?
	 */
	var/scanned = FALSE

	/**
	 * Connectors with locations.
	 * * Supports auto-detection if nulled.
	 */
	var/list/datum/jigsaw_template_connector/connectors = null

	var/static/scan_ignore_typecache = cached_typecacheof(list(
		/area/template_noop,
		/turf/template_noop,
		/obj/jigsaw_connector,
	))
	var/static/scan_interesting_zebra_typecache = zebra_typecacheof(list(
		/obj/jigsaw_connector = /obj/jigsaw_connector,
	))

/datum/jigsaw_template/proc/unload_cache()
	parsed = null

/datum/jigsaw_template/proc/load_cached()
	if(parsed)
		return
	parsed = new(path)

/**
 * * Implicitly loads cached.
 */
/datum/jigsaw_template/proc/scan()
	if(scanned)
		return
	scanned = TRUE

	load_cached()

	var/datum/dmm_scan/scan = new
	var/datum/dmm_scan_params/scan_params = new

	scan_params.trivial_typecache = scan_ignore_typecache
	scan_params.zebra_typecache_of_interest = scan_interesting_zebra_typecache

	scan.scan(parsed, scan_params)

	#warn impl
