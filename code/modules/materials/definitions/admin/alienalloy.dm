// Adminspawn only, do not let anyone get this.
/datum/prototype/material/alienalloy
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
	hardness = MATERIAL_RESISTANCE_EXTREME
	toughness = MATERIAL_RESISTANCE_EXTREME
	refraction = MATERIAL_RESISTANCE_EXTREME
	absorption = MATERIAL_RESISTANCE_EXTREME
	nullification = MATERIAL_RESISTANCE_EXTREME
	density = 8 * 0.5
	relative_conductivity = 0

// Likewise.
// todo: kill with fire
/datum/prototype/material/alienalloy/elevatorium
	id = "elevatorium"
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

// Ditto.
// todo: KILL WITH FIRE
/datum/prototype/material/alienalloy/dungeonium
	id = "dungeonium"
	name = "dungeonium"
	display_name = "ultra-durable metal"
	icon_base = 'icons/turf/walls/dungeon.dmi'
	icon_colour = "#FFFFFF"

/datum/prototype/material/alienalloy/bedrock
	id = "bedrock"
	name = "bedrock"
	display_name = "impassable rock"
	icon_base = 'icons/turf/walls/natural.dmi'
	icon_colour = COLOR_ASTEROID_ROCK

/datum/prototype/material/alienalloy/alium
	id = "abductor_alloy"
	name = "alium"
	display_name = "alien"
	icon_colour = "#FFFFFF"
