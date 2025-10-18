/obj/overmap/tiled/fluff/event
	name = "base overmap object"
	desc = "How are you seeing this?"
	icon = 'code/game/content/factions/derelict/derelict.dmi/overmap/overmap.dmi'
	icon_state = "unidentified"

/obj/overmap/entity/fluff/event
	name = "base overmap object"
	desc = "How are you seeing this?"
	icon = 'code/game/content/factions/derelict/derelict.dmi/overmap/overmap.dmi'
	icon_state = "unidentified"

// Symbols

/obj/overmap/tiled/fluff/event/marker/hazard
	name = "hazard"
	scannable = FALSE
	known = TRUE
	icon_state = "hazard"

/obj/overmap/tiled/fluff/event/marker/waypoint
	name = "waypoint"
	scannable = FALSE
	known = TRUE
	icon_state = "waypoint"

/obj/overmap/tiled/fluff/event/marker/sos
	name = "distress signal"
	scannable = FALSE
	known = TRUE
	icon_state = "distress"

// Stations

/obj/overmap/entity/fluff/event/station/station1
	name = "Unidentified Structure"
	scanned_name = "Precursor Station"
	scanned_icon = "station1"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Orbital Structure][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Multiple anomalous energy signatures detected.
 Zero known lifesigns registered onboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b][/center]"}

/obj/overmap/entity/fluff/event/station/station2
	name = "Unidentified Structure"
	scanned_name = "Precursor Station"
	scanned_icon = "station2"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Orbital Structure][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Multiple anomalous energy signatures detected.
 Zero known lifesigns registered onboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b][/center]"}


/obj/overmap/entity/fluff/event/station/station3
	name = "Unidentified Structure"
	scanned_name = "Precursor Station"
	scanned_icon = "station3"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Orbital Structure][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Multiple anomalous energy signatures detected.
 Zero known lifesigns registered onboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b][/center]"}


/obj/overmap/entity/fluff/event/station/station4
	name = "Unidentified Structure"
	scanned_name = "Precursor Station"
	scanned_icon = "station4"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Orbital Structure][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Multiple anomalous energy signatures detected.
 Zero known lifesigns registered onboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b][/center]"}


/obj/overmap/entity/fluff/event/station/relay
	name = "Unidentified Structure"
	scanned_name = "Precursor Shield Projector"
	scanned_icon = "relay"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Shield Projector][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Significant energy signature detected within structure.
Zero known life signatures detected aboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b]"}

/obj/overmap/entity/fluff/event/station/defense
	name = "Unidentified Structure"
	scanned_name = "Precursor Defense Station"
	scanned_icon = "defense"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Defense Station][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]ALERT: MULTIPLE SIGNIFICANT ENERGY SIGNATURES DETECTED.[/b]
[b]!!DO NOT APPROACH!![/b]"}

/obj/overmap/entity/fluff/event/station/extraction_station
	icon = 'code/game/content/factions/derelict/derelict.dmi/overmap/48x48.dmi'
	icon_state = "extraction_station"
	name = "Titanic Station"
	scanned_name = "Precursor Megastructure"
	scanned_icon = "extraction_station"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Megastructure][/i]
[b]Class:[/b][i] [Megastructure][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b] [i]Unable to diagnose. Err$%%$%[/i]
[b]Recommendation:[/b] [i]!^(!%&#^%&![/i]

[b][i]Note from Temporal:[/i][/b] [i]This is troubling. The structure appears to be siphoning something from the Blackhole in the center of this system.
This vessels scanners are unable to parse the structure, likely due to its size. I am however detecting energy signatures from within.
It seems this is the end of the line. For our sake, I hope you are ready.[/i][/center]"}


// Ships

/obj/overmap/entity/fluff/event/ship/miner
	name = "Unidentified Vessel"
	scanned_name = "Precursor Mining Vessel"
	scanned_icon = "miner"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Mining Vessel][/i]
[b]Class:[/b][i] [Star-Vessel][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] [Rudimentary scans indicate that this vessel carries a high amount of low-power energy weaponry.
Minimal armor plating suggests that this starship is likely purpose-built for mineral extraction operations.
Zero known lifesigns detected onboard. Full automation possible, based on the Vessels continued operation.][/i]
[b]Recommendation: [Proceed As Normal.][/b][/center]
"}

// Planetary Bodies

/obj/overmap/entity/fluff/event/planet/standard
	name = "planetary body"
	scanned_name = "excavated husk"
	scanned_icon = "planet"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Planetary Body][/i]
[b]Class:[/b][i] [Natural][/i]
[b]Notice:[/b][i] [Planetary body shows evidence that it was originally much larger than current estimated size.
Large amount of planetary crust and internals missing. Signs of intentional excavation efforts present.][/i]
[b]Recommendation: [DO NOT LAND.][/b][/center]"}

/obj/overmap/entity/fluff/event/planet/alternate
	name = "planetary body"
	scanned_name = "excavated husk"
	scanned_icon = "planet"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Planetary Body][/i]
[b]Class:[/b][i] [Natural][/i]
[b]Notice:[/b][i] [Planetary body shows evidence that it was originally much larger than current estimated size.
Large amount of planetary crust and internals missing. Signs of intentional excavation efforts present.][/i]
[b]Recommendation: [DO NOT LAND.][/b][/center]"}

/obj/overmap/entity/fluff/event/planet/blackhole
	name = "Blackhole"
	known = TRUE
	icon_state = "blackhole"
	scanned_name = "Blackhole"
	scanned_icon = "blackhole"
	scanner_desc = @{"[center][b]Designation:[/b][i] [Blackhole][/i]
[b]Class:[/b][i] [Stellar-mass][/i]
[b]Notice:[/b][i] [As per regulations, all star vessels should retain a wide berth of twenty lightyears from any astronomical bodies identified as Blackholes.
This is due to the extreme amounts of radiation these astronomical bodies can output, along with the additional threats of extreme time dilation and obscene gravitational force.][/i]
[b]Recommendation: [RETAIN DISTANCE.][/b][/center]"}

// Landables

/obj/overmap/entity/visitable/sector/extraction_station
	icon = 'code/game/content/factions/derelict/derelict.dmi/overmap/48x48.dmi'
	icon_state = "extraction_station"
	name = "Precursor Megastructure"
	known = TRUE
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Megastructure][/i]
[b]Class:[/b][i] [Megastructure][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b] [i]Unable to diagnose. Err$%%$%[/i]
[b]Recommendation:[/b] [i]!^(!%&#^%&![/i]"}
	initial_generic_waypoints = list(
		"Superstructure Auxilary Hangar"
		)


/obj/overmap/entity/visitable/sector/station/relay
	name = "Precursor Shield Projector"
	icon = 'code/game/content/factions/derelict/derelict.dmi/overmap/overmap.dmi'
	icon_state = "relay"
	known = TRUE
	scanner_desc = @{"[center][b]Designation:[/b][i] [Precursor Shield Projector][/i]
[b]Class:[/b][i] [Artificial][/i]
[b]Transponder:[/b][i] [!#&%*#][/i]
[b]Notice:[/b][i] Significant energy signature detected within structure.
Zero known life signatures detected aboard.[/i]
[b]Recommendation: [PROCEED WITH CAUTION.][/b]"}
