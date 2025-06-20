
// -- Datums -- //

/obj/overmap/entity/visitable/sector/miaphus
	name = "Miaphus'irra"
	desc = "A former Tajaran penal colony turned NT client state."
	scanner_desc = @{"[i]Stellar Body[/i]: Miaphus'irra
[i]Class[/i]: H-Class Planet
[i]Habitability[/i]: Moderate (High Temperature)
[i]Population[/i]: 60,000
[i]Controlling Goverment[/i]: Hadii's Folly Confederation of Freeholds
[b]Relationship with NT[/b]: Nanotrasen Client Government.
[b]Relevant Contracts[/b]: Dangerous Wildlife Control (Natrik Region), System Self Defence Assistance."}

	icon_state = "globe"
	color = "#ffd300" //Sandy
	in_space = 0
	initial_generic_waypoints = list("beach_e", "beach_c", "beach_nw")
	initial_restricted_waypoints = list("Pirate Skiff" = list("pirate_hideout"))

	start_x	= 35
	start_y	= 40

/obj/effect/shuttle_landmark/premade/miaphus/piratehideout
	name = "Pirate Hideout"
	landmark_tag = "pirate_hideout"


//This is a special subtype of the thing that generates ores on a map
//It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/beachmine
	descriptor = "beach mine ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.5

//The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/beachmine/check_map_sanity()
	var/rare_count = 0
	var/surface_count = 0
	var/deep_count = 0

	// Increment map sanity counters.
	for(var/value in map)
		if(value < rare_val)
			surface_count++
		else if(value < deep_val)
			rare_count++
		else
			deep_count++
	// Sanity check.
	if(surface_count < 100)
		admin_notice("<span class='danger'>Insufficient surface minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(rare_count < 50)
		admin_notice("<span class='danger'>Insufficient rare minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else if(deep_count < 50)
		admin_notice("<span class='danger'>Insufficient deep minerals. Rerolling...</span>", R_DEBUG)
		return 0
	else
		return 1

// Note that if your map has step teleports, mobs may wander through them accidentally and not know how to get back
/obj/tether_away_spawner/beach_outside
	name = "Beach Outside Spawner" //Just a name
	faction = "beach_out" //Sets all the mobs to this faction so they don't infight
	atmos_comp = TRUE //Sets up their atmos tolerances to work in this setting, even if they don't normally (20% up/down tolerance for each gas, and heat)
	prob_spawn = 50 //Chance of this spawner spawning a mob (once this is missed, the spawner is 'depleted' and won't spawn anymore)
	prob_fall = 25 //Chance goes down by this much each time it spawns one (not defining and prob_spawn 100 means they spawn as soon as one dies)
	//guard = 40 //They'll stay within this range (not defining this disables them staying nearby and they will wander the map (and through step teleports))
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/passive/snake
	)

/obj/tether_away_spawner/beach_outside_friendly
	name = "Fennec Spawner"
	faction = "fennec"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 25
	//guard = 40
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/fennec
	)

/obj/tether_away_spawner/beach_cave
	name = "Beach Cave Spawner"
	faction = "beach_cave"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 40
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/frog = 6, //Frogs are 3x more likely to spawn than,
		/mob/living/simple_mob/vore/aggressive/deathclaw = 2, //these deathclaws are, with these values,
		/mob/living/simple_mob/animal/giant_spider = 4,
		/mob/living/simple_mob/vore/aggressive/giant_snake = 2,
		/mob/living/simple_mob/animal/giant_spider/webslinger = 2
	)

// These are step-teleporters, for map edge transitions
// This top one goes INTO the cave
/obj/effect/step_trigger/teleporter/away_beach_tocave/Initialize(mapload)
	. = ..()
	teleport_x = src.x //X is horizontal. This is a top of map transition, so you want the same horizontal alignment in the cave as you have on the beach
	teleport_y = 2 //2 is because it's putting you on row 2 of the map to the north
	teleport_z = z+1 //The cave is always our Z-level plus 1, because it's loaded after us

//This one goes OUT OF the cave
/obj/effect/step_trigger/teleporter/away_beach_tobeach/Initialize(mapload)
	. = ..()
	teleport_x = src.x //Same reason as bove
	teleport_y = world.maxy - 1 //This means "1 space from the top of the map"
	teleport_z = z-1 //Opposite of 'tocave', beach is always loaded as the map before us

// -- Turfs -- //

//These are just some special turfs for the beach water
/turf/simulated/floor/beach/coastwater
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/coastwater/Initialize(mapload)
	. = ..()
	add_overlay(image("icon"='icons/misc/beach.dmi',"icon_state"="water","layer"=MOB_LAYER+0.1))

//settlement


/obj/structure/barricade/miaphus/window
	name = "Wooden framed window"
	desc = "A window made with wood."
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	icon_state = "woodwindow"
	opacity = 1
	density = 1
	anchored = 1
	allow_unanchor = 1

/obj/structure/barricade/miaphus/tentleathercorner
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	name = "leather tent"
	icon_state = "leather_corner"
	opacity = TRUE

/obj/structure/barricade/miaphus/tentleatheredge
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	name = "leather tent"
	icon_state = "leather_edge"
	opacity = TRUE

/obj/structure/barricade/miaphus/tentclothcorner
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	name = "cotton tent"
	icon_state = "cloth_corner"
	opacity = TRUE

/obj/structure/barricade/miaphus/tentclothedge
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	name = "cotton tent"
	icon_state = "cloth_edge"
	opacity = TRUE

/obj/effect/floor_decal/sand
	name = "desert edge"
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	icon_state = "desertedge"

/obj/effect/floor_decal/sand/corner
	icon = 'icons/obj/structures/miaphus_structure.dmi'
	icon_state = "desertcorner"
