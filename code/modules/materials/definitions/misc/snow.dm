/datum/material/snow
	id = "snow"
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	icon_base = 'icons/turf/walls/solid.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_solid.dmi'
	icon_colour = "#FFFFFF"
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1

/datum/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	id = "snow_packed"
	name = "packed snow"
	flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = 'icons/turf/walls/stone.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_stone.dmi'
	icon_reinf_directionals = TRUE
	icon_colour = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1
