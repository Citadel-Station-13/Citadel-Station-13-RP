/datum/unit_test/research_designs_shall_be_unique

/datum/unit_test/research_designs_shall_be_unique/Run()
	var/list/ids = list()
	var/list/build_paths = list()

	for(var/design_type in typesof(/datum/design) - /datum/design)
		var/datum/design/design = design_type
		if(initial(design.id) == "id")
			continue

		group_by(ids, design, initial(design.id))
		group_by(build_paths, design, initial(design.build_path))

	number_of_issues(ids, "IDs")
	number_of_issues(build_paths, "Build Paths")

	return TRUE

/datum/unit_test/research_designs_shall_be_unique/proc/group_by(list/entries, datum/design/entry, value)
	var/designs = entries[value]
	if(!designs)
		designs = list()
		entries[value] = designs

	designs += entry

/datum/unit_test/research_designs_shall_be_unique/proc/number_of_issues(list/entries, type)
	for(var/value in entries)
		var/list/list_of_designs = entries[value]
		if(list_of_designs.len > 1)
			Fail("[type] - The following entries have the same value - [value]: " + english_list(list_of_designs))

/datum/unit_test/research_designs_have_valid_materials

/datum/unit_test/research_designs_have_valid_materials/Run()
	var/number_of_issues = 0

	for(var/design_type in typesof(/datum/design) - /datum/design)
		var/datum/design/design = design_type
		if(initial(design.id) == "id")
			continue
		design = new design_type() // Unfortunately we have to actually instantiate to get a list.

		for(var/material_name in design.materials)
			var/datum/material/material = get_material_by_name(material_name)
			if(!material)
				Fail("The entry [design_type] has invalid material type [material_name]")
				number_of_issues++

		for(var/reagent_name in design.chemicals)
			if(!(reagent_name in SSchemistry.chemical_reagents))
				Fail("The entry [design_type] has invalid chemical type [reagent_name]")
				number_of_issues++

	return TRUE
