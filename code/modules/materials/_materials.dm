/**
 *! MATERIAL DATUMS
 *
 * This data is used by various parts of the game for basic physical properties and behaviors
 * of the metals/materials used for constructing many objects. Each var is commented and should be pretty
 * self-explanatory but the various object types may have their own documentation. ~Z
 *
 *? PATHS THAT USE DATUMS
 *  * /turf/simulated/wall
 *  * /obj/item/material
 *  * /obj/structure/barricade
 *  * /obj/item/stack/material
 *  * /obj/structure/table
 *
 *? VALID ICONS
 *  * WALLS
 *  - * stone
 *  - * metal
 *  - * solid
 *  - * resin
 *  - * ONLY WALLS
 *  - - * cult
 *  - - * hull
 *  - - * curvy
 *  - - * jaggy
 *  - - * brick
 *  - - * REINFORCEMENT
 *  - - - * reinf_over
 *  - - - * reinf_mesh
 *  - - - * reinf_cult
 *  - - - * reinf_metal
 *  * DOORS
 *  - * stone
 *  - * metal
 *  - * resin
 *  - * wood
 */

/// Assoc list containing all material datums indexed by name.
var/list/name_to_material

/**
 * Returns the material the object is made of, if applicable.
 * Will we ever need to return more than one value here? Or should we just return the "dominant" material.
 */
/obj/proc/get_material()
	return null

/// mostly for convenience.
/obj/proc/get_material_name()
	var/datum/material/material = get_material()
	if(material)
		return material.name

/// Builds the datum list get_material_name()
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake)
		return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/datum/material) - /datum/material)
		var/datum/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1


/// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	return name_to_material[name]


/proc/material_display_name(name)
	var/datum/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null


//! Material definition and procs follow.
/datum/material
	//! Intrisics
	/// Unique name for use in indexing the list.
	var/name
	/// A short description of the material. Not used anywhere, yet...
	var/desc = "its..stuff."
	/// What the material is indexed by in the SSmaterials.materials list. Defaults to the type of the material.
	var/id

	/// Prettier name for display.
	var/display_name
	var/solid_name
	var/gas_name
	var/liquid_name
	var/use_name
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

	//! Flags
	/// Bitflags that influence how SSmaterials handles this material.
	var/init_flags = MATERIAL_INIT_MAPLOAD
	/// Various material properties.
	var/material_flags = NONE
	/// Various status modifiers. //! DEPRECATED
	var/legacy_flags = NONE

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

	//! Appearance
	/// Base color of the material, is used for greyscale. Item isn't changed in color if this is null.
	var/color
	/// Base alpha of the material, is used for greyscale icons.
	var/alpha = 255
	/// Is the material transparent? 0.5< makes transparent walls/doors.
	var/opacity = 1

	//! Icons
	/// Icon to use when the material is used with a wall.
	var/wall_icon = 'icons/turf/walls/solid.dmi'
	/// Reinforcement icon to use for walls.
	var/wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	/// Icon to use when the material is used with a table.
	var/table_icon = 'icons/obj/structures/tables/solid.dmi'
	/// Icon to use when the material is used with a bench.
	var/bench_icon = 'icons/obj/structures/benches/solid.dmi'
	/// Do we have directional reinforced states on walls?
	var/icon_reinf_directionals = FALSE
	/// Will stacks made from this material pass their colors onto objects?
	var/pass_stack_colors = FALSE

	/// Door base icon tag. See header.
	var/door_icon_base = "metal"

	/// Reinforcement state to use for tables.
	var/table_state_reinf = "reinf"

	/// What texture icon state to overlay.
	var/texture_layer_icon_state
	/// A cached icon for the texture filter.
	var/cached_texture_filter_icon

	//! Sounds
	/// Can be used to override the sound items make, lets add some SLOSHing.
	var/item_sound_override
	/// Can be used to override the stepsound a turf makes. MORE SLOOOSH!
	var/turf_sound_override

	//! Attributes
	/// Delay in ticks when cutting through this wall.
	var/cut_delay = 0
	/// Radiation var. Used in wall and object processing to irradiate surroundings.
	var/radioactivity
	/// K, point at which the material catches on fire.
	var/ignition_point
	/// K, walls will take damage if they're next to a fire hotter than this
	var/melting_point = 1800

	/// General-use HP value for products. //! DEPRECATED
	var/integrity = 150
	///This is a modifier for force, and resembles the strength of the material
	var/strength_modifier = 1
	///This is a modifier for integrity, and resembles the strength of the material
	var/integrity_modifier = 1

	/// How well this material works as armor.  Higher numbers are better, diminishing returns applies.
	var/protectiveness = 10
	/// How reflective to light is the material?  Currently used for laser reflection and defense.
	var/reflectivity = 0
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
	/// Radiation resistance, which is added on top of a material's weight for blocking radiation. Needed to make lead special without superrobust weapons.
	var/radiation_resistance = 0
	/// Research level for stacks.
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1)

	/// This is the amount of value per 1 unit of the material.
	var/value_per_unit = 0

	//! Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/created_fulltile_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	//! Damage values.
	/// Prob of wall destruction by hulk, used for edge damage in weapons.  Also used for bullet protection in armor.
	var/hardness = 60
	/// Determines blunt damage/throw_force for weapons.
	var/weight = 20

	/// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	/// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	/// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	/// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"


/** Handles initializing the material.
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

	if(texture_layer_icon_state)
		cached_texture_filter_icon = icon('icons/materials/composite.dmi', texture_layer_icon_state)

	return TRUE

/// This proc is called when the material is added to an object.
/datum/material/proc/on_applied(atom/source, amount, material_flags)
	if(material_flags & MATERIAL_COLOR) //Prevent changing things with pre-set colors, to keep colored toolboxes their looks for example
		if(color) //Do we have a custom color?
			source.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		if(alpha)
			source.alpha = alpha
		if(texture_layer_icon_state)
			ADD_KEEP_TOGETHER(source, MATERIAL_SOURCE(src))
			source.add_filter("material_texture_[name]",1,layering_filter(icon=cached_texture_filter_icon,blend_mode=BLEND_INSET_OVERLAY))

	if(alpha < 255)
		source.opacity = FALSE
	if(material_flags & MATERIAL_ADD_PREFIX)
		source.name = "[name] [source.name]"

	if(isobj(source)) //objs
		on_applied_obj(source, amount, material_flags)

	else if(istype(source, /turf)) //turfs
		on_applied_turf(source, amount, material_flags)

	source.update_appearance()

	source.mat_update_desc(src)

/// This proc is called when a material updates an object's description.
/atom/proc/mat_update_desc(datum/material/mat)
	return

///This proc is called when the material is added to an object specifically.
/datum/material/proc/on_applied_obj(obj/o, amount, material_flags)
	if(material_flags & MATERIAL_AFFECT_STATISTICS)
		var/new_max_integrity = CEILING(o.max_integrity * integrity_modifier, 1)
		// o.modify_max_integrity(new_max_integrity)
		o.max_integrity = new_max_integrity
		// o.force *= strength_modifier
		// o.throwforce *= strength_modifier
	/*
		var/list/temp_armor_list = list() //Time to add armor modifiers!

		if(!istype(o.armor))
			return
		var/list/current_armor = o.armor?.getList()

		for(var/i in current_armor)
			temp_armor_list[i] = current_armor[i] * armor_modifiers[i]
		o.armor = getArmor(arglist(temp_armor_list))
	*/

	if(!isitem(o))
		return
	var/obj/item/item = o

	/*
	if(material_flags & MATERIAL_GREYSCALE)
		var/worn_path = get_greyscale_config_for(item.greyscale_config_worn)
		var/lefthand_path = get_greyscale_config_for(item.greyscale_config_inhand_left)
		var/righthand_path = get_greyscale_config_for(item.greyscale_config_inhand_right)
		item.set_greyscale(
			new_worn_config = worn_path,
			new_inhand_left = lefthand_path,
			new_inhand_right = righthand_path
		)
	*/

	if(!item_sound_override)
		return
	item.hitsound = item_sound_override
	// item.usesound = item_sound_override
	item.mob_throw_hit_sound = item_sound_override
	item.equip_sound = item_sound_override
	item.pickup_sound = item_sound_override
	item.drop_sound = item_sound_override

/datum/material/proc/on_applied_turf(turf/T, amount, material_flags)
	/*
	if(isopenturf(T))
		if(turf_sound_override)
			var/turf/open/O = T
			O.footstep = turf_sound_override
			O.barefootstep = turf_sound_override
			O.clawfootstep = turf_sound_override
			O.heavyfootstep = turf_sound_override
	if(alpha < 255)
		T.AddElement(/datum/element/turf_z_transparency)
	*/
	return


/// Placeholders for light tiles and rglass.
/datum/material/proc/build_rod_product(mob/user, obj/item/stack/used_stack, obj/item/stack/target_stack)
	if(!rod_product)
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]"))
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
		to_chat(user, SPAN_WARNING("You cannot make anything out of \the [target_stack]"))
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		to_chat(user, SPAN_WARNING("You need five wires and one sheet of [display_name] to make anything useful."))
		return

	used_stack.use(5)
	target_stack.use(1)
	to_chat(user, SPAN_NOTICE("You attach wire to the [name]."))
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)


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


/// Return the hardness of this material.
/datum/material/proc/get_edge_damage()
	return hardness //todo


/// Snowflakey, only checked for alien doors at the moment.
/datum/material/proc/can_open_material_door(mob/living/user)
	return TRUE


/// Currently used for weapons and objects made of uranium to irradiate things.
/datum/material/proc/products_need_process()
	return (radioactivity>0) //todo


/// Used by walls when qdel()ing to avoid neighbor merging.
/datum/material/placeholder
	name = "placeholder"


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


/**
 * General wall debris product placement.
 * Not particularly necessary aside from snowflakey cult girders.
 */
/datum/material/proc/place_dismantled_product(turf/target, amount)
	place_sheet(target, amount)


/// Debris product. Used ALL THE TIME.
/datum/material/proc/place_sheet(turf/target, amount)
	if(stack_type)
		return new stack_type(target, ispath(stack_type, /obj/item/stack)? amount : null)


/// Debris product. Used ALL THE TIME.
/datum/material/proc/place_shard(turf/target)
	if(shard_type)
		return new /obj/item/material/shard(target, src.name)


/// Used by walls and weapons to determine if they break or not.
/datum/material/proc/is_brittle()
	return !!(legacy_flags & MATERIAL_BRITTLE)


/datum/material/proc/combustion_effect(turf/T, temperature)
	return


/datum/material/proc/wall_touch_special(turf/simulated/wall/W, mob/living/L)
	return
