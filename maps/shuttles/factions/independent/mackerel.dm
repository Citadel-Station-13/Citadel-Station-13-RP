DECLARE_SHUTTLE_TEMPLATE(/factions/independent/)
#warn impl


// Map template for spawning the shuttle
/datum/map_template/shuttle/overmap/generic/mackerel_stationhopper
	name = "OM Ship - Mackerel Stationhopper (new Z)"
	desc = "A small personnel transport shuttle."
	suffix = "mackerel_sh.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/generic/mackerel_lightcargo
	name = "OM Ship - Mackerel Light Cargo (new Z)"
	desc = "A small light cargo transport shuttle."
	suffix = "mackerel_lc.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/generic/mackerel_heavycargo
	name = "OM Ship - Mackerel Heavy Cargo (new Z)"
	desc = "A small secure cargo transport shuttle."
	suffix = "mackerel_hc.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/generic/mackerel_heavycargo_skel
	name = "OM Ship - Mackerel Heavy Cargo Spartanized (new Z)"
	desc = "A small heavy cargo transport shuttle."
	suffix = "mackerel_hc_skel.dmm"
	annihilate = TRUE

/datum/map_template/shuttle/overmap/generic/mackerel_lightcargo_wreck
	name = "OM Ship - Mackerel Light Cargo Wreck (new Z)"
	desc = "A small light cargo transport shuttle, struck by... something. Ouch."
	map_path = "maps/submaps/level_specific/debrisfield_vr/mackerel_lc_wreck.dmm"
	annihilate = TRUE

// The shuttle's area(s)
/area/shuttle/mackerel_sh
	name = "\improper Mackerel Stationhopper"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_lc
	name = "\improper Mackerel Light Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_hc
	name = "\improper Mackerel Heavy Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_hc_skel
	name = "\improper Mackerel Heavy Cargo Spartan"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_hc_skel_cockpit
	name = "\improper Mackerel Heavy Cargo Cockpit"
	icon_state = "purple"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_hc_skel_eng
	name = "\improper Mackerel Heavy Cargo Engineering"
	icon_state = "yellow"
	requires_power = 1
	has_gravity = 0

/area/shuttle/mackerel_lc_wreck
	name = "\improper Wrecked Mackerel Light Cargo"
	icon_state = "green"
	requires_power = 1
	has_gravity = 0

// The 'shuttle'
/datum/shuttle/autodock/overmap/mackerel_sh
	name = "Mackerel Stationhopper"
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_lc
	name = "Mackerel Light Cargo"
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_hc
	name = "Mackerel Heavy Cargo"
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_hc_skel
	name = "Mackerel Heavy Cargo Spartan"
	ceiling_type = /turf/simulated/floor/reinforced/airless

/datum/shuttle/autodock/overmap/mackerel_lc_wreck
	name = "Mackerel Light Cargo II"
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_sh
	name = "ITV Mackerel I"
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc
	name = "ITV Mackerel II"
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc
	name = "ITV Mackerel III"
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_hc_skel
	name = "ITV Mackerel IV"
/obj/effect/shuttle_landmark/shuttle_initializer/mackerel_lc_wreck
	name = "ITV Mackerel II KIA"
// The 'ship'
/obj/overmap/entity/visitable/ship/landable/mackerel_sh
	scanner_name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Phlake
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	color = "#3366FF"
	vessel_mass = 1000
	shuttle = "Mackerel Stationhopper"

/obj/overmap/entity/visitable/ship/landable/mackerel_lc
	scanner_name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phishy Business
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	color = "#0099FF"
	vessel_mass = 1000
	shuttle = "Mackerel Light Cargo"

/obj/overmap/entity/visitable/ship/landable/mackerel_hc
	scanner_name = "Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Pharma
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	color = "#33CCCC"
	vessel_mass = 1500
	shuttle = "Mackerel Heavy Cargo"

/obj/overmap/entity/visitable/ship/landable/mackerel_hc_skel
	scanner_name = "Mackerel-class Transport (Spartanized)"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Pond
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	color = "#33CCCC"
	vessel_mass = 1500
	shuttle = "Mackerel Heavy Cargo Spartan"

/obj/overmap/entity/visitable/ship/landable/mackerel_lc_wreck
	scanner_name = "Wrecked Mackerel-class Transport"
	scanner_desc = @{"[i]Registration[/i]: ITV Phish Phood
[i]Class[/i]: Small Shuttle Wreck
[i]Transponder[/i]: Not Transmitting
[b]Notice[/b]: Critical Damage Sustained"}
	color = "#0099FF"
	vessel_mass = 1000
	shuttle = "Mackerel Light Cargo II"

#warn map
