/turf/simulated/wall
	description_info = "You can build a wall by using metal sheets and making a girder, then adding more metal or plasteel."

/turf/simulated/wall/get_description_interaction(mob/user)
	var/list/results = list()
	if(integrity < integrity_max)
		results += "[desc_panel_image("welder", user)]to repair."

	if(isnull(construction_stage) || !material_reinf)
		results += "[desc_panel_image("welder", user)]to deconstruct if undamaged."
	else
		switch(construction_stage)
			if(6)
				results += "[desc_panel_image("wirecutters", user)]to begin deconstruction."
			if(5)
				results += list(
					"[desc_panel_image("screwdriver", user)]to continue deconstruction.",
					"[desc_panel_image("wirecutters", user)]to reverse deconstruction."
					)
			if(4)
				results += list(
					"[desc_panel_image("welder", user)]to continue deconstruction.",
					"[desc_panel_image("screwdriver", user)]to reverse deconstruction."
					)
			if(3)
				results += "[desc_panel_image("crowbar", user)]to continue deconstruction."
			if(2)
				results += "[desc_panel_image("wrench", user)]to continue deconstruction."
			if(1)
				results += "[desc_panel_image("welder", user)]to continue deconstruction."
			if(0)
				results += "[desc_panel_image("crowbar", user)]to finish deconstruction."
	return results
