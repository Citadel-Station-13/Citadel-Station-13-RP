
/area/asteroid					// -- TLE
	name = "\improper Moon"
	icon_state = "asteroid"
	requires_power = 0
	sound_env = ASTEROID

/area/asteroid/cave				// -- TLE
	name = "\improper Moon - Underground"
	icon_state = "cave"
	requires_power = 0
	sound_env = ASTEROID

/area/asteroid/artifactroom
	name = "\improper Moon - Artifact"
	icon_state = "cave"
	sound_env = SMALL_ENCLOSED

/area/asteroid/rogue
	var/asteroid_spawns = list()
	var/mob_spawns = list()
	var/shuttle_area //It would be neat if this were more dynamic, but eh.

/area/asteroid/rogue/zone1
	name = "Asteroid Belt Zone 1"
	icon_state = "red2"

/area/asteroid/rogue/zone2
	name = "Asteroid Belt Zone 2"
	icon_state = "blue2"

/area/asteroid/rogue/zone3
	name = "Asteroid Belt Zone 3"
	icon_state = "blue2"

/area/asteroid/rogue/zone4
	name = "Asteroid Belt Zone 4"
	icon_state = "red2"
