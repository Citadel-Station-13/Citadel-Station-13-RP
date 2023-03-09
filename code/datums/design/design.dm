/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/**
 * makes new datums for all hardcoded designs
 */
/proc/instantiate_all_hardcoded_designs()
	. = list()
	for(var/path in subtypesof(/datum/design))
		var/datum/design/D = path
		if(initial(D.abstract_type) == path)
			continue
		if(initial(D.id) == "id")
			continue
		D = new path
		. += D

///Datum for object designs, used in construction
/datum/design
	/// Abstract type.
	abstract_type = /datum/design

	/// Must be unique - identifier of design in CamelCase.
	var/identifier
	/// list of materials needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/materials
	/// list of reagents needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/reagents
	/// types of lathes that can print us
	var/lathe_type = NONE
	/// time needed in deciseconds
	var/work = 5 SECONDS

	/// type of what we build
	var/build_path

	/// name of design, shows in UIs. this is usually built from build_name. do *not* manually set this most of the time.
	var/name
	/// name of item before any name-generation is done. also shown in ui. if null, it'll be auto-detected from the build_path if possible.
	var/build_name
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

	if(!islist(category))
		log_runtime(EXCEPTION("Warning: Design [type] defined a non-list category. Please fix this."))
		category = list(category)
	item_name = name
	AssembleDesignInfo()

/datum/design/proc/autodetect()
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
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

/**
 * Return a new instance of the item for the design
 * This is called even before the fabricator can touch the item.
 */
/datum/design/proc/print(atom/where)
	return new build_path(where)

/**
 * called when a lathe prints a design, instead of print()
 *
 * @params
 * * where - where to put the finished product
 * * fabricator - the lathe printing the product
 * * utilizing - extra items used in the print, if applicable
 */
/datum/design/proc/lathe_print(atom/where, obj/machinery/lathe/fabricator, list/obj/item/utilizing)
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
