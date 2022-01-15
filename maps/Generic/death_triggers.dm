// These seem to be the same on both triumph and tether. Consoladating them cleans things up a bit

/obj/effect/step_trigger/lost_in_space
	var/deathmessage = "You drift off into space, floating alone in the void until your life support runs out."

/obj/effect/step_trigger/lost_in_space/Trigger(var/atom/movable/A) //replacement for shuttle dump zones because there's no empty space levels to dump to
	if(ismob(A))
		to_chat(A, "<span class='danger'>[deathmessage]</span>")
	qdel(A)

/obj/effect/step_trigger/lost_in_space/bluespace
	deathmessage = "Everything goes blue as your component particles are scattered throughout the known and unknown universe."
	var/last_sound = 0

/obj/effect/step_trigger/lost_in_space/bluespace/Trigger(A)
	if(world.time - last_sound > 5 SECONDS)
		last_sound = world.time
		playsound(src, 'sound/effects/supermatter.ogg', 75, 1)
	if(ismob(A) && prob(5))//lucky day
		var/destturf = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),pick(GLOB.using_map.station_levels))
		new /datum/teleport/instant(A, destturf, 0, 1, null, null, null, 'sound/effects/phasein.ogg')
	else
		return ..()

// Tether's tram (Or if someone else makes a map with a tram)
/obj/effect/step_trigger/lost_in_space/tram
	deathmessage = "You fly down the tunnel of the tram at high speed for a few moments before impact kills you with sheer concussive force."
// Triumph's shuttle (Or again if someone else wants to use this for another map)
/obj/effect/step_trigger/lost_in_space/shuttle
	deathmessage = "You fly out of the shuttle at high speed for a few moments before you see the last hopes of your survival fade away."
