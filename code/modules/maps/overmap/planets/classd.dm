/obj/effect/overmap/visitable/sector/classd
	name = "Class D Moon"
	desc = "A rocky planet with radioactive hazards abundant."
	scanner_desc = @{"[i]Stellar Body[/i]:
[i]Class[/i]: D-Class Planet
[i]Habitability[/i]: Extremely Low (Low Temperature, Toxic Atmosphere, Radioactive Hazards)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	in_space = 0
	color = "#eaa17c"
	initial_generic_waypoints = list("classd_east","classd_west","classd_north","classd_south")

// Shuttle landing area waypoints

/obj/effect/shuttle_landmark/premade/classd/east
	name = "Class D - Eastern Zone"
	landmark_tag = "classd_east"

/obj/effect/shuttle_landmark/premade/classd/west
	name = "Class D - Western Zone"
	landmark_tag = "classd_west"

/obj/effect/shuttle_landmark/premade/classd/north
	name = "Class D - Northern Zone"
	landmark_tag = "classd_north"

/obj/effect/shuttle_landmark/premade/classd/south
	name = "Class D - Southern Zone"
	landmark_tag = "classd_south"

///Ore Seeding

//This is a special subtype of the thing that generates ores on a map
//It will generate more rich ores because of the lower numbers than the normal one
/datum/random_map/noise/ore/classd
	descriptor = "classd ore distribution map"
	deep_val = 0.6 //More riches, normal is 0.7 and 0.8
	rare_val = 0.5

//The check_map_sanity proc is sometimes unsatisfied with how AMAZING our ores are
/datum/random_map/noise/ore/classd/check_map_sanity(mapload)
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

// -- Objs -- //
// Two mob spawners that are placed on the map that spawn some mobs!
// They keep track of their mob, and when it's dead, spawn another (only if nobody is looking)
// Note that if your map has step teleports, mobs may wander through them accidentally and not know how to get back
/obj/tether_away_spawner/beach_outside
	name = "Beach Outside Spawner" //Just a name
	faction = "beach_out" //Sets all the mobs to this faction so they don't infight
	atmos_comp = TRUE //Sets up their atmos tolerances to work in this setting, even if they don't normally (20% up/down tolerance for each gas, and heat)
	prob_spawn = 100 //Chance of this spawner spawning a mob (once this is missed, the spawner is 'depleted' and won't spawn anymore)
	prob_fall = 25 //Chance goes down by this much each time it spawns one (not defining and prob_spawn 100 means they spawn as soon as one dies)
	//guard = 40 //They'll stay within this range (not defining this disables them staying nearby and they will wander the map (and through step teleports))
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/frog = 6, //Frogs are 3x more likely to spawn than,
		/mob/living/simple_mob/vore/aggressive/deathclaw = 2, //these deathclaws are, with these values,
		/mob/living/simple_mob/animal/giant_spider = 4,
		/mob/living/simple_mob/vore/aggressive/giant_snake = 2,
		/mob/living/simple_mob/animal/giant_spider/webslinger = 2
	)

/obj/tether_away_spawner/classd/crater
	name = "Class D Crater Spawner"
	faction = "crater"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 30
	//guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound = 1,
		/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi = 3,
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 2
	)

