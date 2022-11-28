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

	///Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/name = null
	///Description of the created object. If null it will use group_desc and name where applicable.
	var/desc = null
	///An item name before it is modified by various name-modifying procs
	var/item_name = null
	///ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/id = "id"
	///IDs of that techs the object originated from and the minimum level requirements.
	var/list/req_tech = list()
	///Flag as to what kind machine the design is built in. See defines.
	var/build_type = null
	///List of materials. Format: "id" = amount.
	var/list/materials = list()
	///List of chemicals.
	var/list/chemicals = list()
	///The path of the object that gets created.
	var/build_path = null
	///How many ticks it requires to build
	var/time = 6
	///Primarily used for Mech Fabricators, but can be used for anything.
	var/list/category = list()
	///Sorting order
	var/sort_string = "ZZZZZ"
	///Optional string that interfaces can use as part of search filters. See- item/borg/upgrade/ai and the Exosuit Fabs.
	var/search_metadata

/datum/design/New()
	if(!islist(category))
		log_runtime(EXCEPTION("Warning: Design [type] defined a non-list category. Please fix this."))
		category = list(category)
	item_name = name
	AssembleDesignInfo()

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

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(var/newloc, var/fabricator)
	return new build_path(newloc)

/datum/design/item
	build_type = PROTOLATHE

//Make sure items don't get free power
/datum/design/item/Fabricate()
	var/obj/item/I = ..()
	var/obj/item/cell/C = I.get_cell()
	if(C)
		C.charge = 0
		I.update_icon()
	if(istype(I, /obj/item/gun))
		var/obj/item/gun/G = I
		G.pin = null

	return I
