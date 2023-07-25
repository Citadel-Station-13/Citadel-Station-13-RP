
// todo: put everything into their own files

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/datum/material/material = get_material()
	if(material)
		return material.name

/proc/material_display_name(name)
	var/datum/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

// Material definition and procs follow.
/datum/material
	abstract_type = /datum/material

	//? Core

	/**
	 * ID.
	 * Must be unique.
	 * Hardcoded materials can be looked up by typepath too and must never have their ids changed under the current implementation.
	 */
	var/id
	/// Unique name for use in indexing the list.
	var/name
	/// Prettier name for display.
	var/display_name
	var/use_name
	/// Various status modifiers.
	var/flags = 0
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

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

	//? Flags

	/// material flags
	var/material_flags = NONE
	/// material constraint flags - what we are considered
	var/material_constraints = NONE

	//? Attributes

	/// relative HP multiplier for something made out of this
	var/relative_integrity = 1
	/// relative reactivity multiplier for something made out of this
	/// * impacts fire/acid armor
	var/relative_reactivity = 1
	/// relative permeability multiplier for something made out of this
	/// * impacts permeability armor
	/// * impacts bomb armor a little bit
	/// * impacts acid armor
	var/relative_permeability = 1
	/// kinetic penetration resistance for something made out of this
	/// based on MATERIAL_RESISTANCE_ definesw
	/// * impacts sharp / blade damage
	/// * impacts kinetic penetration resistance
	/// * impacts bomb armor
	var/regex_this_hardness = 0
	/// kinetic scattering/dampening for something made out of this
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts kinetic damage resistance
	/// * impacts bomb armor
	var/toughness = 0
	/// how easily this material scatters energy
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts laser armor penetration resistance
	/// * impacts special energy armor
	/// * impacts exotic energy armor (minor)
	/// * slight modifier to radiation resist
	var/refraction = 0
	/// how easily this material absorbs regular energy blasts
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts laser armor
	/// * impacts special energy armor (minor)
	/// * very slight modifier to radiation resist
	var/absorption = 0
	/// for how easily this material deflects exotic energy
	/// based on MATERIAL_RESISTANCE_ defines
	/// * impacts special energy armor (minor)
	/// * impacts laser armor penetration resistance (moderate)
	/// * impacts anomaly armor
	var/nullification = 0
	/// relative density multiplier for how heavy this material is
	/// * impacts carry weight of things made out of this
	/// * impacts radiation armor (major)
	/// * impacts bomb armor
	var/relative_density = 0
	/// relative multiplier for how easily this material passes electricity
	/// * impacts conductivity
	/// * impacts usage as a conductor
	var/relative_conductivity = 0

	//? Traits
	/// Material traits - set to list of paths to instance on New / register.
	var/list/material_traits
	#warn hook traits

	#warn pain

	//! Attributes - legacy
	/// Delay in ticks when cutting through this wall.
	var/cut_delay = 0
	/// Radiation var. Used in wall and object processing to irradiate surroundings.
	var/radioactivity
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
	/// Objects without this var add NOCONDUCT to flags on spawn.
	var/conductive = 1
	/// How conductive the material is. Iron acts as the baseline, at 10.
	var/conductivity = null
	/// If set, object matter var will be a list containing these values.
	var/list/composite_material
	var/luminescence

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

	//? Economy
	/// Raw worth per cm3
	var/worth = 0
	/// economic category for this
	var/economic_category_material = ECONOMIC_CATEGORY_MATERIAL_DEFAULT

	//? Sounds
	/// melee sound on blunt force - getsfx compatible
	var/sound_melee_brute = 'sound/weapons/smash.ogg'
	/// melee sound on burn damage - getsfx compatible
	var/sound_melee_burn = 'sound/items/Welder.ogg'

	//? TGUI
	/// tgui icon key in icons/interface/materials.dm
	var/tgui_icon_key = "unknown"

/// Placeholders for light tiles and rglass.
/datum/material/proc/build_rod_product(mob/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
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


/datum/material/proc/build_wired_product(mob/living/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
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
/datum/material/proc/Initialize(_id, ...)
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

	return TRUE


/// This is a placeholder for proper integration of windows/windoors into the system.
/datum/material/proc/build_windows(mob/living/user, obj/item/stack/used_stack)
	return FALSE


/// Weapons handle applying a divisor for this value locally.
/datum/material/proc/get_blunt_damage()
	return weight //todo


/// Return the matter comprising this material.
/datum/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	else
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	return temp_matter


// As above.
/datum/material/proc/get_edge_damage()
	return hardness //todo


/// Snowflakey, only checked for alien doors at the moment.
/datum/material/proc/can_open_material_door(mob/living/user)
	return 1


/// Currently used for weapons and objects made of uranium to irradiate things.
/datum/material/proc/products_need_process()
	return (radioactivity>0) //todo



/// Places a girder object when a wall is dismantled, also applies reinforced material.
/datum/material/proc/place_dismantled_girder(turf/target, datum/material/reinf_material, datum/material/girder_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()
	if(girder_material)
		if(istype(girder_material, /datum/material))
			girder_material = girder_material.name
		G.set_material(girder_material)


/// General wall debris product placement.
/// Not particularly necessary aside from snowflakey cult girders.
/datum/material/proc/place_dismantled_product(turf/target, amount)
	place_sheet(target, amount)


/// Debris product. Used ALL THE TIME.
/datum/material/proc/place_sheet(turf/target, amount)
	if(stack_type)
		return new stack_type(target, ispath(stack_type, /obj/item/stack)? amount : null)

// As above.
/datum/material/proc/place_shard(turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name)


/// Used by walls and weapons to determine if they break or not.
/datum/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)


/datum/material/proc/combustion_effect(turf/T, temperature)
	return


/datum/material/proc/wall_touch_special(turf/simulated/wall/W, mob/living/L)
	return
