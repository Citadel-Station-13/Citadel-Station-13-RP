# Mapping

This is a quick little guide to where things are to be organized.

## _Shim

This is on the chopping board. Do not add anythere here, I just have no other place at the moment to put the files that are in there

## Away Missions

Store assets specific to a gateway in this folder though please just keep it to overmap effect stuff, specific special areas, and mob spawners. For things like special mobs, decals, etc put them in their proper areas, its a pain in the ass to track down stuff when we make subtypes of random stuff all over the place.

## Lateload files

Lateload files and such are now under the lateload folder. Currently there are four main ones but if there's a suitable reason to add a new one. If you are curious as to why they are called lateload files it is because the datums within them are intended to be loaded only after the main station file's been loaded, hence literally being 'late loaded'. It works based off the name of the chosen late load datum in combination with proper `/datum/map` setup.

```dm
	lateload_z_levels = list(
		list("Debris Field - Z1 Space"), // Debris Field
		list("Away Mission - Pirate Base"), // Pirate Base & Mining Planet
		list("ExoPlanet - Z1 Planet"),//Mining planet
		list("ExoPlanet - Z2 Planet"), // Rogue Exoplanet
		list("ExoPlanet - Z3 Planet"), // Desert Exoplanet
		list("ExoPlanet - Z4 Planet"), // Gaia Planet
		list("ExoPlanet - Z5 Planet"), // Frozen Planet
		list("Away Mission - Trade Port"), // Trading Post
		list("Away Mission - Lava Land", "Away Mission - Lava Land (East)"),
		list("Asteroid Belt 1","Asteroid Belt 2","Asteroid Belt 3","Asteroid Belt 4"),
	)
