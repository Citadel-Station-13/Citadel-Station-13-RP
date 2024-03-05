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
	var/obj/item/matter_cartridge/inserted_cartridge
	/// selected template
	var/datum/holofabricator_template/selected_template
	/// interface to draw from if provided
	var/datum/item_interface/interface
	/// we're in deconstruction mode
	var/deconstruction_mode = FALSE

#warn impl all

/obj/item/stream_projector/holofabricator/examine(mob/user, dist)
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

/obj/item/stream_projector/holofabricator/setup_target_visuals(atom/entity)
	var/datum/beam/beam = create_stretched_beam(src, entity, icon = 'icons/items/stream_projector/holofabricator.dmi', icon_state = "beam-double", collider_type = /atom/movable/beam_collider)
	active_targets[entity] = beam

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
		var/obj/item/matter_cartridge/old_cartridge = inserted_cartridge
		inserted_cartridge = null
		playsound(src, 'sound/weapons/empty.ogg', 50, FALSE)
		update_icon()
		on_cartridge_swap(old_cartridge, null)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/stream_projector/holofabricator/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(istype(I, /obj/item/matter_cartridge))
		var/obj/item/matter_cartridge/cartridge = I
		if(!user.transfer_item_to_loc(cartridge, src))
			user.action_feedback(SPAN_WARNING("[cartridge] is stuck to your hand!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		var/obj/item/matter_cartridge/old_cartridge = inserted_cartridge
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

/obj/item/stream_projector/holofabricator/process()
	#warn impl

/obj/item/stream_projector/holofabricator/transform_target_lock(atom/target)
	if(isturf(target))
		#warn impl
	else if(isobj(target))
		#warn impl
	else if(ismob(target))
		return null
	else
		CRASH("what?")

/obj/item/stream_projector/holofabricator/proc/on_cartridge_swap(obj/item/matter_cartridge/old_cartridge, obj/item/matter_cartridge/new_cartridge)
	return

/proc/cmp_holofabricator_templates(datum/holofabricator_template/A, datum/holofabricator_template/B)
	if(A.priority != B.priority)
		return B.priority - A.priority
	return sorttext(A.name, B.name)

//? Templates

/**
 * rcd templates
 */
/datum/holofabricator_template
	/// our name
	var/name = "unkw (?)"
	/// templates are sorted by priority, ascending, then name
	var/priority = 0
	/// tgui module to load for options
	var/tgui_module = "HolofabTemplateSimple"

/**
 * initializes and generates icons
 */
/datum/holofabricator_template/proc/initialize()
	#warn impl

#warn impl all

/datum/holofabricator_template/wall
	name = "Walls"

/datum/holofabricator_template/floor
	name = "Floors"

/datum/holofabricator_template/structure
	name = "Structure"
	priority = 10

/datum/holofabricator_template/airlock
	name = "Airlock"

/datum/holofabricator_template/standing_frame
	name = "Frame (Floor)"

/datum/holofabricator_template/wall_frame
	name = "Frame (wall)"

/datum/holofabricator_template/window
	name = "Window"

/datum/holofabricator_template/divider
	name = "Dividers"

//? Materials

/**
 * A special polyfill material usable for most templates.
 */
/datum/material/polyfill
	id = "holofab-polyfill"
	name = "Structural Polyfill"

/datum/material/polyfill/generate_recipes()
	return list()

#undef HOLOFABRICATOR_MODE_CONSTRUCT
#undef HOLOFABRICATOR_MODE_DECONSTRUCT
#undef HOLOFABRICATOR_MODE_REPAIR
