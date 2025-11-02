/datum/map_template/engine/rift
	abstract_type = /datum/map_template/engine/rift
	prefix = "maps/stations/rift/map_files/engines/"
	for_map = /datum/map/station/rift

/datum/map_template/engine/rift/rust
	name = "ProcEngine_Rift_Rust"
	desc = "R-UST Fusion Tokamak Engine"
	suffix = "rust.dmm"
	display_name = list("Budget Star", "Bane of Synthetics", "Glowy Field", "Funny Spinny EM Field", "Protean Rarity Enforcement")

/datum/map_template/engine/rift/supermatter
	name = "ProcEngine_Rift_Supermatter"
	desc = "Old Faithful Supermatter"
	suffix = "sme.dmm"
	display_name = list("Angry Rock", "The Forbidden Rock Candy", "Death Crystal", "Spicy Crystal", "Hypnotizing Stone")

// disabled because it only worked at all due to an atmos bug
// todo: proper simulation and math this shit out for joules released in total fuel
/*
/datum/map_template/engine/rift/burnchamber
	name = "ProcEngine_Rift_Burn"
	desc = "Burn Chamber Engine"
	suffix = "burn.dmm"
	display_name = list("Toxins Lab", "Build a Campfire", "100 Solarmoths", "Teshari's Bane", "Casting Fireball!")
*/
