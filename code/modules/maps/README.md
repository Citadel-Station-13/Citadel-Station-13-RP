# Mapping

This is a quick little guide to where things are to be organized. 

# _Shim

This is on the chopping board. Do not add anythere here, I just have no other place at the moment to put the files that are in there

## Away Missions

Store assets specific to a gateway in this folder though please just keep it to overmap effect stuff, specific special areas, and mob spawners. For things like special mobs, decals, etc put them in their proper areas, its a pain in the ass to track down stuff when we make subtypes of random stuff all over the place.

## Lateload files

Lateload files and such are now under the lateload folder. Currently there are four main ones but if there's a suitable reason to add a new one. If you are curious as to why they are called lateload files it is because the datums within them are intended to be loaded only after the main station file's been loaded, hence literally being 'late loaded'. It works based off the name of the chosen late load datum in combination with proper `/datum/map` setup.
/*
	lateload_z_levels = list(
		list("Debris Field - Z1 Space"), // Debris Field
		list("Away Mission - Pirate Base"), // Vox Pirate Base & Mining Planet
		list("ExoPlanet - Z1 Planet"),//Mining planet
		list("ExoPlanet - Z2 Planet"), // Rogue Exoplanet
		list("ExoPlanet - Z3 Planet"), // Desert Exoplanet
		list("ExoPlanet - Z4 Planet"), // Gaia Planet
		list("ExoPlanet - Z5 Planet"), // Frozen Planet
		list("Away Mission - Trade Port"), // Trading Post
		list("Away Mission - Lava Land", "Away Mission - Lava Land (East)"),
		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4")
	)
*/
This is what the list should look like under your `/datum/map` setup. Make sure you list these out in the order you are defining your z levels otherwise you're going to get wonky behavior. 

## Misc Maps

For now contains just a few things. If at all possible avoid using this if at all possible unless you are making a map that's A: Not a gateway map; B: Not on the overmap; C: Is not intended to be a submap template. 

## Overmap

This is where you should put the overmap data for your map if applicable. For `extra_z_levels = list()` and `levels_for_distress = list()` you will need to add those in to your map define file as they require z levels to be indexed before initiating. Only use `extra_z_levels = list()` if you are intending to utilize map transition effects rather than just portals (use portals its much easier) or if you want to have ship landing markers on z levels besides the one you're place the `/obj/effect/overmap/visitable/sector/` into. 

## Templates

Contains all the templates for submaps, shuttles, and such. These are used for a number of things including submap seeding, admin spawning, etc.

## TG 

Contains the root `/datum/map_template` definitions and a lot of the code that handles map_templates. Do not touch unless you know what you are doing otherwise you will break stuff

## Turf Makers

Contains all the turf maker macros used in various maps. Eventually will be culled in favor of just having turfs that automatically detect the atmos on the z level they're on and substitute their gas string for that. For now we get to deal with turf maker spagetti
