//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? initialized by SSearly_init due to icon ops
//  maybe a serializable/persistable repository someday idfk
GLOBAL_LIST_EMPTY(holofabricator_templates)

/proc/init_holofabricator_templates()
	var/list/built = list()
	GLOB.holofabricator_templates = built
	for(var/datum/holofabricator_template/path as anything in subtypesof(/datum/holofabricator_template))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/holofabricator_template/creating = new path
		creating.initialize()
		built += creating
	tim_sort(built, /proc/cmp_holofabricator_templates)

#define HOLOFABRICATOR_MODE_CONSTRUCT 1
#define HOLOFABRICATOR_MODE_REPAIR 2
#define HOLOFABRICATOR_MODE_DECONSTRUCT 3

//? Projector

/**
 * new RCDs
 */
ITEM_AUTO_BINDS_SINGLE_INTERFACE_TO_VAR(/obj/item/stream_projector/holofabricator, interface)
/obj/item/stream_projector/holofabricator
	name = "holofabricator"
	desc = "A precise triage tool used by many frontier engineers. Uses materials from a loaded cartridge \
	to rapidly fabricate a generated holotemplate."
	icon = 'icons/items/stream_projector/holofabricator.dmi'
	icon_state = "projector"

	// todo: proper cataloguing fluff desc system
	description_fluff = "Despite having been around for hundreds of years, holofabricators are still a novel, alpha-stage concept \
	being iterated upon by many scientists across the galaxy. While not as reliable as traditional methods of construction, they nonetheless \
	make for a coveted item on many installations due to the ease of which they can perform emergency triage and the rapid prototyping of rooms. \
	<br>A holofabricator constructs a prefab by generating a hardlight template with its guide projector, then filling it \
	in with confined particular beams. Unfortunately, the resulting fabrication tends to be noticeably less weaker than \
	a conventional construction of the same design - it seems science has yet to nullify one of the core weaknesses of \
	3d-printing technologies. \
	<br>Deconstruction is performed instead by abrasively blasting a target with a particulate beam. Only some materials and \
	designs are weak enough to be sliced apart this way; deconstructed matter can normally be recycled or disposed of as an installation \
	sees fit."

	#warn impl

	/// inserted matter cartridge
	var/obj/item/polyfill_cartridge/inserted_cartridge
	/// selected template
	var/datum/holofabricator_template/selected_template
	/// k-v part-to-material choices for current template
	var/list/selected_materials
	/// selected pattern for current template; null for default
	var/selected_pattern
	/// k-v options list selected for current template
	var/list/selected_options
	/// chosen access ids for current template, if applicable
	var/list/selected_access
	/// chosen direction
	var/selected_direction = SOUTH
	/// interface to draw from if provided
	var/datum/item_interface/interface
	/// we're in deconstruction mode
	var/deconstruction_mode = FALSE
	/// what cell type we start with
	var/cell_type = /obj/item/cell/super
	/// base work done per second
	var/work_speed = 1 SECONDS
	/// max distance
	var/maximum_distance = 10
	/// no-penalty distance
	var/no_penalty_distance = 1
	/// multiplier to distance for divisor when outisde of no_penalty_distance
	var/distance_divisor_multiplier = 0.5
	/// watts used per second
	var/power_draw = POWER_USAGE_HOLOFABRICATOR
	/// things actually being worked on; used to allow for 'fast' ops when something
	/// needs less work than SSprocessing's process interval.
	/// if something isn't in this list, it won't be process()'d
	var/list/atom/processing_targets

#warn impl all

/obj/item/stream_projector/holofabricator/Initialize(mapload)
	. = ..()
	init_cell_slot(cell_type)
	obj_cell_slot.legacy_use_device_cells = FALSE
	obj_cell_slot.remove_yank_offhand = TRUE
	obj_cell_slot.remove_yank_context = TRUE

/obj/item/stream_projector/holofabricator/examine(mob/user, dist)
	. = ..()
	if(!isnull(obj_cell_slot.cell))
		. += SPAN_NOTICE("Its cell has [round(obj_cell_slot.cell.percent())]% charge remaining.")
	else if(!isnull(interface))
		. += SPAN_WARNING("Its cell is missing.")

	#warn matter

/obj/item/stream_projector/holofabricator/examine_more(mob/user)
	. = ..()
	. += SPAN_RED("Things constructed with holofabricators do not have the same structural integrity as things built by conventional means.")
	. += SPAN_RED("Transfer efficiency is lowered quadratically with a target's distance from the applied holofabricator.")

/obj/item/stream_projector/holofabricator/update_icon(updates)
	cut_overlays()
	. = ..()
	var/amount = inserted_cartridge?.get_ratio() * 10
	if(amount)
		amount = CEILING(amount, 1)
		add_overlay("projector-[amount]", TRUE)

/obj/item/stream_projector/holofabricator/valid_target(atom/entity)
	return isatom(entity)

/obj/item/stream_projector/holofabricator/try_lock_target(atom/entity, datum/event_args/actor/actor, silent)
	var/turf/where_we_are = get_turf(src)
	var/turf/where_they_are = get_turf(entity)
	if(get_dist(where_we_are, where_they_are) > maximum_distance)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("That is out of range."),
				target = src,
			)
		return FALSE
	return ..()

/obj/item/stream_projector/holofabricator/setup_target_visuals(atom/entity)
	var/datum/beam/beam = create_stretched_beam(src, entity, icon = 'icons/items/stream_projector/holofabricator.dmi', icon_state = "beam-double", collider_type = /atom/movable/beam_collider)
	active_targets[entity] = beam
	RegisterSignal(beam, COMSIG_BEAM_REDRAW, PROC_REF(on_beam_redraw))
	RegisterSignal(beam, COMSIG_BEAM_CROSSED, PROC_REF(on_beam_crossed))

/obj/item/stream_projector/holofabricator/proc/on_beam_redraw(datum/beam/source)
	var/atom/movable/target = source.beam_target
	if(get_dist(src, target) > maximum_distance)
		drop_target(target)
	var/turf/where_we_are = get_turf(src)
	var/turf/where_they_are = get_turf(target)
	if(where_we_are?.z != where_they_are?.z)
		drop_target(target)

/obj/item/stream_projector/holofabricator/proc/on_beam_crossed(datum/beam/source, atom/what)
	if(what.pass_flags_self & ATOM_PASS_CLICK)
		return
	if(!what.density)
		return
	drop_target(source.beam_target)

/obj/item/stream_projector/holofabricator/teardown_target_visuals(atom/entity)
	var/datum/beam/beam = active_targets[entity]
	QDEL_NULL(beam)

/obj/item/stream_projector/holofabricator/attack_hand(mob/user, list/params)
	if(user.is_holding_inactive(src))
		if(isnull(inserted_cartridge))
			user.action_feedback(SPAN_WARNING("[src] has no vial loaded."), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.put_in_hands_or_drop(inserted_cartridge)
		user.action_feedback(SPAN_NOTICE("You remove [inserted_cartridge] from [src]."), src)
		var/obj/item/polyfill_cartridge/old_cartridge = inserted_cartridge
		inserted_cartridge = null
		playsound(src, 'sound/weapons/empty.ogg', 50, FALSE)
		update_icon()
		on_cartridge_swap(old_cartridge, null)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/stream_projector/holofabricator/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/polyfill_cartridge))
		var/obj/item/polyfill_cartridge/cartridge = I
		if(!user.transfer_item_to_loc(cartridge, src))
			user.action_feedback(SPAN_WARNING("[cartridge] is stuck to your hand!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/polyfill_cartridge/old_cartridge = inserted_cartridge
		inserted_cartridge = cartridge
		if(!isnull(old_cartridge))
			user.action_feedback(SPAN_NOTICE("You quickly swap [old_cartridge] with [cartridge]."), src)
			user.put_in_hands_or_drop(old_cartridge)
		else
			user.action_feedback(SPAN_NOTICE("You insert [cartridge] into [src]."), src)
		playsound(src, 'sound/weapons/autoguninsert.ogg', 50, FALSE)
		update_icon()
		on_cartridge_swap(old_cartridge, cartridge)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/stream_projector/holofabricator/process(delta_time)
	#warn impl
	#warn a way to do 'fast' processed for things with less than delta-time work.

/obj/item/stream_projector/holofabricator/transform_target_lock(atom/target)
	if(isturf(target))
		#warn impl
	else if(isobj(target))
		if(istype(target, /obj/structure/holofabricator_construction))
			pass()
		else
			pass()
		#warn impl
	else if(ismob(target))
		return null
	else
		CRASH("what?")

/obj/item/stream_projector/holofabricator/proc/on_cartridge_swap(obj/item/polyfill_cartridge/old_cartridge, obj/item/polyfill_cartridge/new_cartridge)
	return

/obj/item/stream_projector/holofabricator/proc/toggle_deconstruction_mode(new_state)
	drop_all_targets()
	deconstruction_mode = new_state

/obj/item/stream_projector/holofabricator/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["materialContext"] = SSmaterials.tgui_materials_context()
	#warn impl

/obj/item/stream_projector/holofabricator/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	#warn impl

/obj/item/stream_projector/holofabricator/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Holofabricator")
		ui.open()

/obj/item/stream_projector/holofabricator/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	#warn impl

/proc/cmp_holofabricator_templates(datum/holofabricator_template/A, datum/holofabricator_template/B)
	if(A.priority != B.priority)
		return B.priority - A.priority
	return sorttext(A.name, B.name)

//? Frame Object

/**
 * 'frame' of an object, that solidifies into the object itself at a certain point
 */
/obj/structure/holofabricator_construction
	name = "hardlight template"
	desc = "A partially assembled template for something, likely formed with a holofabricator."

	/// template
	var/datum/holofabricator_template/template
	/// selected pattern in template, if any
	var/pattern
	/// options
	var/list/options
	/// selected materials
	var/list/materials
	/// our polyfill material
	var/datum/material/structure
	/// work required
	var/work_required
	/// work remaining
	var/work_remaining
	/// locked holofabricators
	var/list/obj/item/stream_projector/holofabricator/affecting = list()

/obj/structure/holofabricator_construction/Initialize(mapload, datum/holofabricator_template/template, pattern, list/options, list/materials, list/req_access, list/req_one_access)
	. = ..()
	#warn impl

	src.req_access = req_access
	src.req_one_access = req_one_access

/obj/structure/holofabricator_construction/proc/work_on(obj/item/stream_projector/holofabricator/fabricator, amount)
	work_remaining = max(0, work_remaining - amount)
	if(!work_remaining)
		template.finalize(src, loc, options, materials)
		qdel(src)
	#warn impl

/obj/structure/holofabricator_construction/proc/attached(obj/item/stream_projector/holofabricator/fabricator)
	affecting += fabricator

/obj/structure/holofabricator_construction/proc/detached(obj/item/stream_projector/holofabricator/fabricator)
	affecting -= fabricator

#warn impl all

//? Repair Field

/**
 * visual / effect handler for repairs
 * created on entities when targeted by a holofabricator
 */
/datum/component/holofabricator_field
	/// affecting fabricators
	var/list/obj/item/stream_projector/holofabricator/affecting = list()

/datum/component/holofabricator_field/Destroy()
	#warn rid visuals
	return ..()

/datum/component/holofabricator_field/RegisterWithParent()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	init_or_assert_visuals()
	return ..()

/datum/component/holofabricator_field/proc/init_or_assert_visuals()
	#warn impl

/datum/component/holofabricator_field/proc/attached(obj/item/stream_projector/holofabricator/fabricator)
	affecting += fabricator

/datum/component/holofabricator_field/proc/detached(obj/item/stream_projector/holofabricator/fabricator)
	affecting -= fabricator
	if(!length(affecting))
		qdel(src)

#warn impl all

//? Templates

/**
 * rcd templates
 */
/datum/holofabricator_template
	/// our name
	var/name = "unkw (?)"
	/// templates are sorted by priority, ascending, then name
	var/priority = 0
	/// template category
	var/category = "Miscellaneous"

	/// typepath of object
	var/build_path
	#warn sigh how to dela with patterns like airlocks??
	/// patterns, please use pattern builder system
	var/datum/holofabricator_template_patterns/patterns
	/// material choices - list of keys
	var/list/material_parts
	/// options - please use option builder system.
	var/datum/holofabricator_template_options/options
	/// work required (baseline)
	var/work_required = 3 SECONDS
	/// has directions
	var/has_directions = FALSE
	/// has access settings
	var/has_access = FALSE
	/// spritesheet icon
	var/spritesheet_icon
	/// spritesheet prefix
	var/spritesheet_prefix

/**
 * initializes and generates icons
 */
/datum/holofabricator_template/proc/initialize()
	options = construct_options(new /datum/holofabricator_template_options)
	patterns = construct_patterns(new /datum/holofabricator_template_patterns)
	#warn impl

/**
 * constructs options datum
 */
/datum/holofabricator_template/proc/construct_options(datum/holofabricator_template_options/options)
	return options
/**
 * constructs patterns datum
 */
/datum/holofabricator_template/proc/construct_patterns(datum/holofabricator_template_patterns/patterns)
	return patterns

/datum/holofabricator_template/proc/tgui_template_data()
	return list(
		"name" = name,
		"priority" = priority,
		"category" = category,
		"materialParts" = material_parts,
		"patterns" = patterns.tgui_template_patterns(),
		"options" = options.tgui_template_options(),
	)

#warn a way to adapt to things, ergo 'there's already a low wall but we want to also make a low wall'

/**
 * create the work in progress construction object
 */
/datum/holofabricator_template/proc/create(atom/where, list/options, list/materials)
	return new /obj/structure/holofabricator_construction(where, src, options, materials)

/**
 * finalize a construction object
 *
 * we will not delete the construction object!
 *
 * @params
 * * in_progress - the thing being made
 */
/datum/holofabricator_template/proc/finalize(obj/structure/holofabricator_construction/in_progress)
	var/obj/created = create(in_progress.loc, in_progress.pattern, in_progress.options, in_progress.materials, in_progress.req_access, in_progress.req_one_access)
	return created

/datum/holofabricator_template/proc/instantiate(atom/where, pattern, list/options, list/materials, list/req_access, list/req_one_access)
	return new build_path(where)

/datum/holofabricator_template_options

/datum/holofabricator_template_options/proc/tgui_template_options()
	return list(

	)

/datum/holofabricator_template_options/proc/with_color_option(key, name)

#warn impl all

/datum/holofabricator_template_patterns

/datum/holofabricator_template_patterns/proc/tgui_template_patterns()
	return list(
	)

/**
 * todo: someday when shit isn't slow, we should just auto-generate these things instead :/
 */
/datum/holofabricator_template_patterns/proc/with_pattern(name, id, preview_state)

#warn impl all

//? Template Implementations ?//

/datum/holofabricator_template/structure
	category = "Structure"
	spritesheet_icon = 'icons/items/stream_projector/holofabricator-structures.dmi'

/datum/holofabricator_template/structure/wall
	#warn impl
	work_required = 3 SECONDS
	#warn wall

/datum/holofabricator_template/structure/wall/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/structure/floor
	#warn impl
	work_required = 0.25 SECONDS
	#warn plating

/datum/holofabricator_template/structure/floor/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/structure/airlock
	#warn impl
	work_required = 5 SECONDS
	spritesheet_icon = 'icons/items/stream_projector/holofabricator-airlocks.dmi'
	#warn airlock, airlock-glass, hatch, hatch-glass, external
	#warn options for colors

/datum/holofabricator_template/structure/airlock/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/structure/full_window
	#warn impl
	work_required = 2.5 SECONDS
	#warn window, window-reinf

/datum/holofabricator_template/structure/full_window/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/structure/low_wall
	#warn impl
	work_required = 1 SECONDS
	#warn low-wall

/datum/holofabricator_template/structure/low_wall/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/furniture
	category = "Furniture"
	spritesheet_icon = 'icons/items/stream_projector/holofabricator-furniture.dmi'

/datum/holofabricator_template/furniture/table
	#warn impl
	work_required = 1 SECONDS
	#warn table, table-reinf, table-frame

/datum/holofabricator_template/furniture/table/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/furniture/office_chair
	#warn impl
	work_required = 1 SECONDS
	#warn office-chair-white, office-chair-dark

/datum/holofabricator_template/furniture/office_chair/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/furniture/stool
	#warn impl
	work_required = 1 SECONDS
	#warn stool

/datum/holofabricator_template/furniture/stool/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

/datum/holofabricator_template/furniture/bed
	#warn impl
	work_required = 1 SECONDS
	#warn bed, bed-double

/datum/holofabricator_template/furniture/bed/construct_patterns(datum/holofabricator_template_patterns/patterns)
	. = ..()
	#warn impl

// todo: frame refactor

// /datum/holofabricator_template/standing_frame
// 	category = "Frame (Floor)"

// /datum/holofabricator_template/wall_frame
// 	category = "Frame (wall)"

//? Materials

/**
 * A special polyfill material usable for most templates.
 */
/datum/material/polyfill
	id = "holofab-polyfill"
	name = "Structural Polyfill"

	relative_integrity = 1
	density = 8
	relative_conductivity = 1
	relative_permeability = 0
	relative_reactivity = 0.75
	hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_HIGH
	refraction = MATERIAL_RESISTANCE_LOW
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE

/datum/material/polyfill/generate_recipes()
	return list()

#undef HOLOFABRICATOR_MODE_CONSTRUCT
#undef HOLOFABRICATOR_MODE_DECONSTRUCT
#undef HOLOFABRICATOR_MODE_REPAIR
