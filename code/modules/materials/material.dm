
// todo: put everything into their own files

// Material definition and procs follow.
/datum/prototype/material
	abstract_type = /datum/prototype/material

	//* Core *//
	/// Name for debugging purposes; not player-facing.
	var/name

	//* Identification *//
	/// Player-facing name. Always used.
	var/display_name

	// todo: reevaluate
	var/use_name
	// todo: reevaluate
	var/sheet_singular_name = "sheet"
	// todo: reevaluate
	var/sheet_plural_name = "sheets"

	//! Shards/tables/structures
	/// Path of debris object.
	var/shard_type = SHARD_SHRAPNEL
	/// Related to above.
	var/shard_icon
	/// Can shards be turned into sheets with a welder?
	var/shard_can_repair = 1
	/// Holder for all recipes usable with a sheet of this material.
	var/list/recipes
	/// Fancy string for barricades/tables/objects exploding.
	var/destruction_desc = "breaks apart"

	//! Icons
	/// Colour applied to products of this material.
	var/icon_colour
	/// Wall and table base icon tag. See header.
	var/icon_base = 'icons/turf/walls/solid_wall.dmi'
	/// Overlay used.
	var/icon_reinf = 'icons/turf/walls/solid_wall_reinforced.dmi'
	var/wall_stripe_icon = 'icons/turf/walls/wall_stripe.dmi'
	/// Door base icon tag.
	var/door_icon_base = "metal"
	/// Table base icon tag.
	var/table_icon_base = "metal"
	var/table_reinf_icon_base = "reinf_over"

	/// Do we have directional reinforced states on walls?
	var/icon_reinf_directionals = FALSE
	/// Research level for stacks.
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1)
	/// Will stacks made from this material pass their colors onto objects?
	var/pass_stack_colors = FALSE

	//* Armor
	/// caching of armor. text2num(significance)_[mob_armor? 1 : 0] = armor datum instance
	var/tmp/list/armor_cache = list()

	//* Attacks
	/// melee stats cache. text2num(mode)_text2num(significance) = list(stats)
	var/tmp/list/melee_cache = list()

	//* Attributes
	/// relative HP multiplier for something made out of this
	var/relative_integrity = 1

	/// kinetic penetration resistance for something made out of this
	/// based on MATERIAL_RESISTANCE_ definesw
	/// * impacts sharp / blade damage
	/// * impacts kinetic penetration resistance
	/// * impacts bomb armor
	var/hardness = MATERIAL_RESISTANCE_NONE
	/// kinetic scattering/dampening for something made out of this
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts blunt / crush damage
	/// * impacts kinetic damage resistance
	/// * impacts bomb armor
	var/toughness = MATERIAL_RESISTANCE_NONE

	/// how easily this material scatters energy
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts laser armor penetration resistance
	/// * impacts special energy armor
	/// * impacts exotic energy armor (minor)
	/// * slight modifier to radiation resist
	var/refraction = MATERIAL_RESISTANCE_NONE
	/// how easily this material absorbs regular energy blasts
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts laser armor
	/// * impacts special energy armor (minor)
	/// * very slight modifier to radiation resist
	var/absorption = MATERIAL_RESISTANCE_NONE
	/// for how easily this material deflects exotic energy
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts special energy armor (minor)
	/// * impacts laser armor penetration resistance (moderate)
	/// * impacts anomaly armor
	/// * impacts radiation armor
	var/nullification = MATERIAL_RESISTANCE_NONE

	/// density in g/cm3
	///
	/// * impacts carry weight of things made out of this
	/// * impacts radiation armor (major)
	/// * impacts bomb armor
	/// * impacts blunt / crush damage
	/// * impacts sharp / blade damage (minor)
	/// * impacts kinetic damage resistance (minor)
	var/density = 8 * 1
	/// weight multiplier - allowing for materials that behave like a high-density material but are light
	/// * basically, low values = high density stats without the penalties from weight
	var/weight_multiplier = 1

	/// relative multiplier for how easily this material passes electricity
	/// '1' is an arbitrary value, probably 'the conductivity of high quality power lines'
	/// * impacts conductivity
	/// * impacts usage as a conductor
	var/relative_conductivity = 0
	/// relative reactivity multiplier for something made out of this
	/// * impacts fire/acid armor
	var/relative_reactivity = 1
	/// relative permeability multiplier for something made out of this
	/// * impacts permeability armor
	/// * impacts bomb armor a little bit
	/// * impacts acid armor
	var/relative_permeability = 1

	//* Flags
	/// material flags
	var/material_flags = NONE
	/// material constraint flags - what we are considered
	var/material_constraints = NONE

	//* Icon *//
	/// Icon file. This is used for many miscellaneous states defined here.
	var/icon
	/// Count, from 1 to N, of stack states.
	/// * If 3, and there's a stack of 50, we'll be `stack-1` from 1 to around 17, `stack-2`
	///   from 18 to around 35, and `stack-3` for the rest.
	/// * If null, no stack states are provided.
	/// * If provided, a raw `stack` state should always be provided for on-map and in-UI previews.
	var/icon_stack_count

	//* Traits
	/// Material traits - set to list of paths to instance on New / register; associate them to their initial data.
	var/list/material_traits
	/// Material trait sensitivity hooks - total
	var/material_trait_flags
	/// String material tags - used for autoselect/UI things, mostly
	/// e.g material_tags = list("my epic material")
	/// some common ones are defined in \__DEFINES\materials\misc.dm
	var/list/material_tags

	//! Attributes - legacy
	/// Delay in ticks when cutting through this wall.
	var/cut_delay = 0
	/// K, point at which the material catches on fire.
	var/ignition_point
	/// K, walls will take damage if they're next to a fire hotter than this
	var/melting_point = 1800
	/// Is the material transparent? 0.5< makes transparent walls/doors.
	var/opacity = 1
	/// Only used by walls currently.
	var/explosion_resistance = 5
	/// Objects that respect this will randomly absorb impacts with this var as the percent chance.
	var/negation = 0
	/// Objects that have trouble staying in the same physical space by sheer laws of nature have this. Percent for respecting items to cause teleportation.
	var/spatial_instability = 0
	/// If set, object matter var will be a list containing these values.
	var/list/composite_material
	var/is_fusion_fuel

	//! Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/created_fulltile_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	//! Damage values.

	/// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	/// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	/// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	/// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"

	//* Stacking *//
	/// amount per sheet / whatever
	var/sheet_amount = SHEET_MATERIAL_AMOUNT

	//* Economy *//
	/// Raw worth per cm3
	var/worth = 0
	/// economic category for this
	var/economic_category_material = ECONOMIC_CATEGORY_MATERIAL_DEFAULT

	//* Sounds *//
	/// melee sound on blunt force - getsfx compatible
	var/sound_melee_brute = 'sound/weapons/smash.ogg'
	/// melee sound on burn damage - getsfx compatible
	var/sound_melee_burn = 'sound/items/Welder.ogg'

	//* TGUI *//
	/// tgui icon key in icons/interface/materials.dm
	var/tgui_icon_key = "unknown"

/// Placeholders for light tiles and rglass.
/datum/prototype/material/proc/build_rod_product(mob/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]."))
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need one rod and one sheet of [display_name] to make anything useful."))
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/datum/prototype/material/proc/build_wired_product(mob/living/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
	if(!wire_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]."))
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need five wires and one sheet of [display_name] to make anything useful."))
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, SPAN_NOTICE("You attach wire to the [name]."))
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)

/**
 * Handles initializing the material.
 *
 * Arugments:
 * - _id: The ID the material should use. Overrides the existing ID.
 */
/datum/prototype/material/proc/Initialize(_id, ...)
	if(_id)
		id = _id
	else if(isnull(id))
		id = type

	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!shard_icon)
		shard_icon = shard_type

	init_traits()

	return TRUE

/datum/prototype/material/serialize()
	. = ..()
	var/list/serialized_traits = list()
	// use type directly - we don't care about update stability.
	for(var/datum/prototype/material_trait/trait in material_traits)
		serialized_traits[trait.type] = list(
			"trait" = trait.serialize(),
			"data" = material_traits[trait],
		)
	.["traits"] = serialized_traits

/datum/prototype/material/deserialize(list/data)
	. = ..()
	var/list/deserializing_traits = .["traits"]
	for(var/path in deserializing_traits)
		var/resolved = text2path(path)
		if(!ispath(resolved, /datum/prototype/material_trait))
			continue
		var/list/data_list = deserializing_traits[path]
		var/datum/prototype/material_trait/trait = new resolved
		trait.deserialize(data_list["trait"])
		material_traits[trait] = data_list["data"]

/// This is a placeholder for proper integration of windows/windoors into the system.
/datum/prototype/material/proc/build_windows(mob/living/user, obj/item/stack/used_stack)
	return FALSE

/// Snowflakey, only checked for alien doors at the moment.
/datum/prototype/material/proc/can_open_material_door(mob/living/user)
	return 1

/// Places a girder object when a wall is dismantled, also applies reinforced material.
/datum/prototype/material/proc/place_dismantled_girder(turf/target, datum/prototype/material/material_reinf, datum/prototype/material/material_girder)
	var/obj/structure/girder/G = new(target, material_girder, material_reinf)
	return G

/// General wall debris product placement.
/// Not particularly necessary aside from snowflakey cult girders.
/datum/prototype/material/proc/place_dismantled_product(turf/target, amount)
	place_sheet(target, amount)

/// Debris product. Used ALL THE TIME.
/datum/prototype/material/proc/place_sheet(turf/target, amount)
	if(stack_type)
		return new stack_type(target, ispath(stack_type, /obj/item/stack)? amount : null)

// As above.
/datum/prototype/material/proc/place_shard(turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name)

/datum/prototype/material/proc/combustion_effect(turf/T, temperature)
	return

/datum/prototype/material/proc/wall_touch_special(turf/simulated/wall/W, mob/living/L)
	return

//* traits & trait hooks *//

/datum/prototype/material/proc/init_traits()
	for(var/i in 1 to length(material_traits))
		var/key = material_traits[i]
		var/val = material_traits[key]
		if(ispath(key))
			var/datum/prototype/material_trait/fetched = RSmaterial_traits.fetch(key)
			material_traits[i] = fetched
			material_traits[fetched] = val
