//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/prototype/guidebook_section/reagents
	title = "Reagents"
	id = "reagents"
	tgui_module = "TGUIGuidebookReagents"

/datum/prototype/guidebook_section/reagents/section_data()
	. = ..()
	var/list/reagents = list()
	var/list/reactions = list()
	for(var/id in SSchemistry.reagent_lookup)
		var/datum/reagent/reagent = SSchemistry.reagent_lookup[id]
		reagents[id] = reagent.tgui_guidebook_data()
	for(var/datum/chemical_reaction/reaction as anything in SSchemistry.chemical_reactions)
		reactions[reaction.id || "[reaction.name]" || "[reaction.type]"] = reaction.tgui_guidebook_data()
	.["reagents"] = reagents
	.["reactions"] = reactions
