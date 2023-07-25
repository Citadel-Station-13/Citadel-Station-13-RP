// Adminspawn only, do not let anyone get this.
/datum/material/alienalloy
	name = "alienalloy"
	id = "alien_alloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.

	relative_integrity = 2
	relative_reactivity = 0
	relative_permeability = 0
	regex_this_hardness = MATERIAL_RESISTANCE_EXTREME
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_EXTREME
	absorption = MATERIAL_RESISTANCE_EXTREME
	nullification = MATERIAL_RESISTANCE_EXTREME
	relative_density = 0.5
	relative_conductivity = 0

// Likewise.
// todo: kill with fire
/datum/material/alienalloy/elevatorium
	id = "elevatorium"
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

// Ditto.
// todo: KILL WITH FIRE
/datum/material/alienalloy/dungeonium
	id = "dungeonium"
	name = "dungeonium"
	display_name = "ultra-durable metal"
	icon_base = 'icons/turf/walls/dungeon.dmi'
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/bedrock
	id = "bedrock"
	name = "bedrock"
	display_name = "impassable rock"
	icon_base = 'icons/turf/walls/rock.dmi'
	icon_colour = "#FFFFFF"

/datum/material/alienalloy/alium
	id = "abductor_alloy"
	name = "alium"
	display_name = "alien"
	icon_colour = "#FFFFFF"
