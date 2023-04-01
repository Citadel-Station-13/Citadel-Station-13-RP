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
	/// design flags - see [code/__DEFINES/machines/lathe.dm]
	var/design_flags = NONE
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
	/// desc of item before any desc-generation is done. also shown in ui. if null, it'll be auto-detected from the build_path if possible.
	var/build_desc
	/// type of what we build
	var/build_path

	/// list of materials needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/materials
	/// for variable-material designs: assoc list of key to amounts
	/// the key will be fed into print() during creation with the material id the user picked
	/// autodetected if null.
	var/list/material_parts
	/// list of reagents needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/reagents
	// todo: reagent_parts?
	#warn items

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
	if(isnull(build_path))
		return
	if(ispath(build_path, /obj/item/stack))
		is_stack = TRUE
	var/obj/item/instance = new build_path
	if(isnull(materials))
		materials = instance.materials?.Copy()
		if(!isnull(materials) && !isnull(instance.material_parts) && !isnull(instance.material_defaults))
			for(var/key in instance.material_parts)
				materials[instance.material_defaults[key]] -= instance.material_parts[key]
	if(isnull(material_parts))
		material_parts = instance.material_parts?.Copy()
	if(isnull(reagents))
		reagents = list() // nah no autodetect for now.
	if(!build_name)
		build_name = instance.name
	if(!build_desc)
		build_desc = instance.desc
	if(!isnull(instance))
		qdel(instance)

/datum/design/proc/generate()
	if(!name)
		name = generate_name(build_name)
	if(!desc)
		desc = generate_desc()

/datum/design/proc/generate_name(template)
	return template

/datum/design/proc/generate_desc(template)
	return template

/datum/design/proc/ui_data_list()
	return list(
		"name" = name,
		"desc" = desc,
		"id" = identifier,
		"materials" = materials,
		"material_parts" = material_parts,
		"reagents" = reagents,
		"resultItem" = list(
			"name" = build_name,
			"desc" = build_desc,
		),
	)

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
/datum/design/proc/legacy_print(atom/where, fabsricator)
	return print(where)
