//Concussion, or 'dizzyness' grenades.

/obj/item/grenade/concussion
	name = "concussion grenade"
	desc = "A polymer concussion grenade, optimized for disorienting personnel without causing large amounts of injury."
	icon_state = "concussion"
	item_state = "grenade"

	var/blast_radius = 5

/obj/item/grenade/concussion/detonate()
	..()
	concussion_blast(get_turf(src), blast_radius)
	qdel(src)
	return

/obj/proc/concussion_blast(atom/target, var/radius = 5)
	var/turf/T = get_turf(target)
	if(is_below_sound_pressure(T))
		visible_message("<span class='notice'>Whump.</span>")
		return
	playsound(src.loc, 'sound/effects/bang.ogg', 75, 1, -3)
	if(istype(T))
		for(var/mob/living/L in orange(T, radius))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				to_chat(H, "<span class='critical'>WHUMP.</span>")

				var/ear_safety = 0

				H.get_ear_protection()

				var/bang_effectiveness = H.species.sound_mod

				if((get_dist(H, T) <= round(radius * 0.3 * bang_effectiveness) || src.loc == H.loc || src.loc == H))
					if(ear_safety > 0)
						H.Confuse(2)
					else
						H.Confuse(8)
						H.Weaken(1)
						if ((prob(14) || (H == src.loc && prob(70))))
							H.ear_damage += rand(1, 10)
						else
							H.ear_damage += rand(0, 5)
							H.ear_deaf = max(H.ear_deaf,15)

				else if(get_dist(H, T) <= round(radius * 0.5 * bang_effectiveness))
					if(!ear_safety)
						H.Confuse(6)
						H.ear_damage += rand(0, 3)
						H.ear_deaf = max(H.ear_deaf,10)


				else if(!ear_safety && get_dist(H, T) <= (radius * bang_effectiveness))
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
			/* Until someone can come up with a better thing to have happen to borgs like a stun or something this is getting commented out
			if(istype(L, /mob/living/silicon/robot))
				var/mob/living/silicon/robot/R = L
				if(L.client)
				to_chat(R, "<span class='critical'>Gyroscopic failure.</span>")
			*/
	return

/obj/item/grenade/concussion/frag
	name = "concussion-frag grenade"
	desc = "A polymer and steel concussion grenade, optimized for disorienting personnel and being accused of war crimes."
	icon_state = "conc-frag"
	var/fragment_types = list(/obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment/strong, /obj/item/projectile/bullet/pellet/fragment/rubber, /obj/item/projectile/bullet/pellet/fragment/rubber/strong)
	var/num_fragments = 40  //total number of fragments produced by the grenade
	var/spread_range = 5 // for above and below, see code\game\objects\items\weapons\grenades\explosive.dm

/obj/item/grenade/concussion/frag/detonate()
	var/turf/O = get_turf(src)
	if(!O)
		return
	src.fragmentate(O, num_fragments, spread_range, fragment_types)
	..()
