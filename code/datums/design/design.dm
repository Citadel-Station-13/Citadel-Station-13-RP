/**
 * design datums for holding what lathes can print.
 *
 * relevant bitfields are in [code/__DEFINES/machines/lathe.dm]
 */
/datum/design
	/// Abstract type.
	abstract_type = /datum/design

	/// Must be unique - identifier of design in CamelCase.
	var/identifier
	/// types of lathes that can print us
	var/lathe_type = NONE
	/// how are we unlocked
	var/design_unlock = NONE
	/// time needed in deciseconds - for stacks, this is time *PER SHEET*.
	var/work = 5 SECONDS
	/// is stack? autodetected.
	var/is_stack = FALSE

	/// name of item before any name-generation is done. also shown in ui. if null, it'll be auto-detected from the build_path if possible.
	var/build_name
	/// type of what we build
	var/build_path

	/// list of materials needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/materials
	/// for variable-material designs: assoc list of key to amounts
	/// the key will be fed into print() during creation with the material id the user picked
	//  * warning * - using this will not play nicely with auto-detection.
	//  set materials list yourself if you use this.
	var/list/material_parts
	/// list of reagents needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/reagents
	// todo: reagent_parts?

	/// name of design, shows in UIs. this is usually built from build_name. do *not* manually set this most of the time.
	var/name
	/// desc of design, shows in UIs. if null, it'll be auto-detected from the build_path if possible.
	var/desc
	/// category - string or list, or null; null results in undefined behavior depending on UI.
	var/category = "Misc"

	//? legacy
	///IDs of that techs the object originated from and the minimum level requirements.
	var/list/req_tech = list()

/datum/design/New()
	autodetect()
	generate()

/datum/design/proc/autodetect()
	if(ispath(build_path, /obj/item/stack))
		is_stack = TRUE
	#warn handle non-build-path'd ones
	var/obj/item/instance
	if(isnull(materials))
		if(isnull(instance))
			instance = new build_path
		#warn impl
	if(isnull(reagents))
		reagents = list() // nah no autodetect for now.
	if(!name)
		if(isnull(instance))
			instance = new build_path
	if(!desc)
		if(isnull(instance))
			instance = new build_path

/datum/design/proc/generate()
	generate_name()

/datum/design/proc/generate_name()
	name = build_name || name

/datum/design/proc/ui_data_list()
	return list(
		"full_name" = name,
		"name" = build_name,
		"id" = id,
	)
	#warn Design.tsx, how to handle materials / reagents?

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	#warn nuke from orbit
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	#warn nuke from orbit
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	#warn nuke from orbit
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

/**
 * Return a new instance of the item for the design
 * This is called even before the fabricator can touch the item.
 *
 * @params
 * * where - where to put the finished product
 * * fabricator - the lathe printing the product
 */
/datum/design/proc/print(atom/where, list/material_parts)
	return new build_path(where)

/**
 * called when a lathe prints a design, instead of print()
 *
 * @params
 * * where - where to put the finished product
 * * fabricator - the lathe printing the product
 * * material_parts - assoc list of materials to use, based on the variable of the same name
 */
/datum/design/proc/lathe_print(atom/where, list/material_parts, obj/machinery/lathe/fabricator)
	return print(where)

//? legacy below

/**
 * for legacy lathes
 */
/datum/design/proc/legacy_print(atom/where, fabricator)
	return print(where)

/**
 * legacy science designs
 */
/datum/design/science
	build_type = PROTOLATHE

//Make sure items don't get free power
/datum/design/science/print(atom/where)
	var/obj/item/I = ..()
	var/obj/item/cell/C = I.get_cell()
	if(C)
		C.charge = 0
		I.update_icon()
	if(istype(I, /obj/item/gun))
		var/obj/item/gun/G = I
		G.pin = null

	return I
