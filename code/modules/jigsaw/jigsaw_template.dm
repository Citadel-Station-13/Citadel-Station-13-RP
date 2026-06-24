//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

GLOBAL_LIST_EMPTY(jigsaw_template_cache)

/proc/fetch_cached_jigsaw_template(datum/jigsaw_template/resolvable)
	if(istype(resolvable))
		return resolvable
	else if(isnull(resolvable))
		return null

	if(GLOB.jigsaw_template_cache[resolvable])
		return GLOB.jigsaw_template_cache[resolvable]

	if(!ispath(resolvable))
		return null

	var/datum/jigsaw_template/template = new resolvable
	GLOB.jigsaw_template_cache[resolvable] = template

	return template

/proc/unload_cached_jigsaw_templates()
	for(var/path in GLOB.jigsaw_template_cache)
		var/datum/jigsaw_template/template = GLOB.jigsaw_template_cache[path]
		template.unload_cache()

/**
 * A template for jigsaw generation.
 * * Templates are a multiple of alignment in width/height, plus one for border. This is
 *   determined by its pattern.
 * * Templates are assumed to be mapped in to SOUTH orientation.
 * * Templates are loaded in with their lower left tile (after taking into account any offsets)
 *   aligned relative to the south direction. If it's rotated, the alignment rotates with it.
 */
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
	#warn impl
	/// cached resultant pattern
	var/tmp/datum/jigsaw_pattern/resultant_pattern

	/// Offset the actual load from the lower-left (direction relative) of
	/// the aligned pattern.
	/// * This is in tiles, not alignment multiples.
	var/offset_x = 0
	/// Offset the actual load from the lower-left (direction relative) of
	/// the aligned pattern.
	/// * This is in tiles, not alignment multiples.
	var/offset_y = 0

	/// display name
	/// * defaults to name
	/// * appended to the jigsaw generator's name for area names
	var/display_name

	/**
	 * List of budget entries that must be consuemd to place us.
	 */
	var/list/custom_budgets = list()

	/// parsed map if held
	var/datum/dmm_parsed/parsed

/datum/jigsaw_template/proc/prepare()
	return

/datum/jigsaw_template/proc/unload_cache()
	parsed = null

/datum/jigsaw_template/proc/load_cached()
	if(parsed)
		return
	parsed = new(path)

/datum/jigsaw_template/override
	name = null
	path = null
	alignment = null

	offset_x = null
	offset_y = null

	display_name = null

	custom_budgets = null

	/**
	 * * Can be path, instance, or ID.
	 * * (ID isn't implemented yet.)
	 */
	var/datum/jigsaw_template/template

/datum/jigsaw_template/override/prepare()
	var/datum/jigsaw_template/resolved = fetch_cached_jigsaw_template(template)
	if(!resolved)
		CRASH("Invalid template override: [template]")
	resolved.prepare()

	if(isnull(src.name))
		src.name = resolved.name
	if(isnull(src.path))
		src.path = resolved.path
	if(isnull(src.alignment))
		src.alignment = resolved.alignment

	if(isnull(src.offset_x))
		src.offset_x = resolved.offset_x
	if(isnull(src.offset_y))
		src.offset_y = resolved.offset_y

	if(isnull(src.display_name))
		src.display_name = resolved.display_name

	if(isnull(src.custom_budgets))
		src.custom_budgets = resolved.custom_budgets.Copy()
