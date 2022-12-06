
/datum/material/debug
	name = "debugium"
	stack_type = /obj/item/stack/material/debug
	wall_icon = 'icons/turf/walls/debug.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_debug.dmi'
	color = "#FFFFFF"

/obj/item/stack/material/debug
	name = "debugium"
	icon_state = "debugium"
	default_type = "debugium"

// Adminspawn only, do not let anyone get this.
/datum/material/alienalloy
	name = "alienalloy"
	display_name = "durable alloy"
	stack_type = null
	color = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%

// Likewise.
/datum/material/alienalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	color = "#666666"

// Ditto.
/datum/material/alienalloy/dungeonium
	name = "dungeonium"
	display_name = "ultra-durable"
	wall_icon = 'icons/turf/walls/dungeon.dmi'
	color = "#FFFFFF"

/datum/material/alienalloy/bedrock
	name = "bedrock"
	display_name = "impassable rock"
	wall_icon = 'icons/turf/walls/rock.dmi'
	color = "#FFFFFF"

/datum/material/alienalloy/alium
	name = "alium"
	display_name = "alien"
	// wall_icon = "alien"
	table_icon = 'icons/turf/walls/metal.dmi'
	color = "#FFFFFF"
