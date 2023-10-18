/**
 * design datums for holding what lathes can print.
 *
 * relevant bitfields are in [code/__DEFINES/machines/lathe.dm]
 */
/datum/design
	/// Abstract type.
	abstract_type = /datum/design

	//? Design Data - Core
	/// Must be unique - id of design in CamelCase.
	var/id
	/// design flags - see [code/__DEFINES/datums/design.dm]
	var/design_flags = NONE
	/// how are we unlocked - see [code/__DEFINES/datums/design.dm]
	var/design_unlock = NONE
	/// is stack? autodetected.
	var/is_stack = FALSE
	/// max stack amount? autodetected.
	var/max_stack

	//? Design Data - UI
	/// name of design, shows in UIs. this is usually built from build_name. do *not* manually set this most of the time.
	var/name
	/// desc of design, shows in UIs. if null, it'll be auto-detected from the build_path if possible.
	var/desc
	/// overrides build_name for purposes of name generation.
	var/design_name
	/// category - string or list, or null; null results in undefined behavior depending on UI.
	var/category = "Misc"

	//? Build Data
	/// name of item before any name-generation is done. also shown in ui. if null, it'll be auto-detected from the build_path if possible.
	var/build_name
	/// desc of item before any desc-generation is done. also shown in ui. if null, it'll be auto-detected from the build_path if possible.
	var/build_desc
	/// type of what we build
	var/build_path
	/// types of lathes that can print us
	var/lathe_type = NONE
	/// time needed in deciseconds - for stacks, this is time *PER SHEET*.
	var/work = 5 SECONDS

	//? Build Costs
	/// list of materials needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/materials
	/// for variable-material designs: assoc list of key to amounts
	/// the key will be fed into print() during creation with the material id the user picked
	/// autodetected if null.
	/// this should obviously match material_parts on the /obj in question.
	var/list/material_parts
	/// Items needed, as ingredients list - see [code/__HELPERS/datastructs/ingredients.dm]
	var/list/ingredients
	/// list of reagents needed - typepath or id to amount. null to auto-detect from the object in question. list() for no cost (DANGEROUS).
	var/list/reagents
	// todo: reagent_parts?

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
		var/obj/item/stack/stack_path = build_path
		max_stack = initial(stack_path.max_amount)
	var/obj/item/instance = SSatoms.instance_atom_immediate(build_path)
	// lathe designs shouldn't be qdeleting, but incase someone puts in a random..
	if(QDELETED(instance))
		return
	// todo: maybe /obj/proc/detect_materials, TYPE_PROC_REF(/obj, detect_material_parts) ? this works fine for now tho.
	if(isnull(materials))
		if(!isnull(instance.materials))
			materials = instance.materials.Copy()
		if(!isnull(materials) && !isnull(instance.material_parts) && !isnull(instance.material_defaults))
			// subtract out the material defaults the instance itself added
			for(var/key in instance.material_parts)
				materials[instance.material_defaults[key]] -= instance.material_parts[key]
	if(isnull(material_parts))
		if(!isnull(instance.material_parts))
			material_parts = instance.material_parts.Copy()
	if(isnull(reagents))
		// if(!isnull(instance.reagents))
			// reagents = instance.reagents.Copy()
			// detected_materials = TRUE
		reagents = list() // nah no autodetect for now, reagents are way to ocomplicated
	if(!build_name)
		build_name = instance.name
	if(!build_desc)
		build_desc = instance.desc
	qdel(instance)

/datum/design/proc/generate()
	if(!name)
		name = generate_name(design_name || build_name)
	if(!desc)
		desc = generate_desc(design_name || build_name, build_desc)

/datum/design/proc/generate_name(template)
	return template

/datum/design/proc/generate_desc(template_name, template_desc)
	return template_desc

/**
 * Encodes data for [tgui/packages/tgui/interfaces/common/Design.tsx]
 */
/datum/design/proc/ui_data_list()
	return list(
		"name" = name,
		"desc" = desc,
		"id" = id,
		"work" = work,
		"category" = category,
		"materials" = length(materials)? materials : null,
		"material_parts" = length(material_parts)? material_parts : null,
		"reagents" = length(reagents)? reagents : null,
		"ingredients" = length(ingredients)? ingredients : null,
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
 *
 * @return created atom, or list of created atoms.
 */
/datum/design/proc/print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, cost_multiplier = 1)
	if(is_stack)
		var/stack_size = max_stack
		if(stack_size >= amount)
			. = new build_path(where, amount)
			on_print(., material_parts, ingredient_parts, reagent_parts, cost_multiplier)
		else
			. = list()
			var/safety = 0
			var/left = amount
			var/atom/made
			while(left)
				if(++safety > 50)
					CRASH("way too high")
				var/making = min(left, stack_size)
				made = new build_path(where, making)
				left -= making
				. += made
				on_print(made, material_parts, ingredient_parts, reagent_parts, cost_multiplier)
	else
		if(amount > 50)
			STACK_TRACE("way too high")
		if(amount == 1)
			. = new build_path(where)
			on_print(., material_parts, ingredient_parts, reagent_parts, cost_multiplier)
		else
			. = list()
			var/atom/made
			for(var/i in 1 to min(amount, 50))
				made = new build_path(where)
				on_print(made, material_parts, ingredient_parts, reagent_parts, cost_multiplier)
				. += made

/datum/design/proc/on_print(atom/created, list/material_parts, list/ingredient_parts, list/reagent_parts, cost_multiplier = 1)
	if(isobj(created))
		var/obj/O = created
		var/list/effective_materials = materials.Copy()
		for(var/key in material_parts)
			effective_materials[material_parts[key]] += src.material_parts[key]
		if(cost_multiplier != 1)
			for(var/key in effective_materials)
				effective_materials[key] *= cost_multiplier
		O.materials = effective_materials
		O.set_material_parts(material_parts)

/**
 * called when a lathe prints a design, instead of print()
 *
 * @params
 * * where - where to put the finished product
 * * fabricator - the lathe printing the product
 * * material_parts - assoc list of materials to use, based on the variable of the same name
 */
/datum/design/proc/lathe_print(atom/where, amount, list/material_parts, list/ingredient_parts, list/reagent_parts, obj/machinery/lathe/fabricator, cost_multiplier = 1)
	return print(where, amount, material_parts, ingredient_parts, reagent_parts, cost_multiplier)

//? legacy below

/**
 * for legacy lathes
 */
/datum/design/proc/legacy_print(atom/where, fabricator)
	return print(where, 1)
