/datum/controller/subsystem/spatial_effects/proc/run_concussion_blast(turf/location, radius)
	// -- book-keeping --
	log_effect_invocation("concussion_blast", args)
	// --     end      --

	if(is_below_sound_pressure(location))
		location.visible_message("<span class='notice'>Whump.</span>")
		return
	playsound(location, 'sound/effects/bang.ogg', 75, 1, -3)
	for(var/mob/living/L in orange(location, radius))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			to_chat(H, "<span class='critical'>WHUMP.</span>")

			var/ear_safety = 0

			H.get_ear_protection()

			var/bang_effectiveness = H.species.sound_mod

			if((get_dist(H, location) <= round(radius * 0.3 * bang_effectiveness) || location == H.loc || location == H))
				if(ear_safety > 0)
					H.Confuse(2)
				else
					H.Confuse(8)
					H.afflict_paralyze(20 * 1)
					if ((prob(14) || (H == location && prob(70))))
						H.ear_damage += rand(1, 10)
					else
						H.ear_damage += rand(0, 5)
						H.ear_deaf = max(H.ear_deaf,15)

			else if(get_dist(H, location) <= round(radius * 0.5 * bang_effectiveness))
				if(!ear_safety)
					H.Confuse(6)
					H.ear_damage += rand(0, 3)
					H.ear_deaf = max(H.ear_deaf,10)


			else if(!ear_safety && get_dist(H, location) <= (radius * bang_effectiveness))
				H.Confuse(4)
				H.ear_damage += rand(0, 1)
				H.ear_deaf = max(H.ear_deaf,5)

			if(H.ear_damage >= 15)
				to_chat(H, "<span class='danger'>Your ears start to ring badly!</span>")

				if(prob(H.ear_damage - 5))
					to_chat(H, "<span class='danger'>You can't hear anything!</span>")
					H.sdisabilities |= SDISABILITY_DEAF
			else if(H.ear_damage >= 5)
				to_chat(H, "<span class='danger'>Your ears start to ring!</span>")
