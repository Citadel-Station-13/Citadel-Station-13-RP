// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	material_outer = /datum/prototype/material/alienalloy/dungeonium

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	icon = 'icons/turf/walls/natural.dmi'
	material_outer = /datum/prototype/material/alienalloy/bedrock
	block_tele = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

/turf/simulated/wall/solidrock/attackby()
	return
