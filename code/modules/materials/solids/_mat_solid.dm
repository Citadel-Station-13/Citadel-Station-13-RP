/datum/material/solid
	name = null
	melting_point = 1000
	// boiling_point = 30000
	// molar_mass = 0.232 //iron Fe3O4
	// latent_heat = 6120 //iron
	door_icon_base = "stone"
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	// default_solid_form = /obj/item/stack/material/brick
	abstract_type = /datum/material/solid

/datum/material/solid/Initialize()
	if(!liquid_name)
		liquid_name = "molten [name]"
	if(!gas_name)
		gas_name = "vaporized [name]"
	// if(!ore_compresses_to)
	// 	ore_compresses_to = type
	. = ..()
