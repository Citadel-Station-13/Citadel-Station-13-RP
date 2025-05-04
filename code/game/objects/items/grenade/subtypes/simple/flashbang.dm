/obj/item/grenade/simple/flashbang
	name = "flashbang"
	icon_state = "flashbang"
	item_state = "flashbang"
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	worth_intrinsic = 35
	var/max_range = 10 //The maximum range possible, including species effect mods. Cuts off at 7 for normal humans. Should be 3 higher than your intended target range for affecting normal humans.
	var/banglet = 0

/obj/item/grenade/simple/flashbang/on_detonate(turf/location, atom/grenade_location)
	..()
	for(var/obj/structure/closet/L in hear(max_range, location))
		if(locate(/mob/living/carbon, L))
			for(var/mob/living/carbon/M in L)
				bang(location, M)

	for(var/mob/living/carbon/M in hear(max_range, location))
		bang(location, M)

	for(var/obj/structure/blob/B in hear(max_range - 2,location))       		//Blob damage here
		var/damage = round(30 / (get_dist(B, location) + 1))
		if(B.overmind)
			damage *= B.overmind.blob_type.burn_multiplier
		B.adjust_integrity_blob(-damage)

	new /obj/effect/particle_effect/sparks(location)
	new /obj/effect/particle_effect/smoke/illumination(location, 5, 30, 30, "#FFFFFF")

/obj/item/grenade/simple/flashbang/proc/bang(var/turf/T , var/mob/living/carbon/M)					// Added a new proc called 'bang' that takes a location and a person to be banged.
	to_chat(M, "<span class='danger'>BANG</span>")						// Called during the loop that bangs people in lockers/containers and when banging
	playsound(T, 'sound/effects/bang.ogg', 50, 1, 30)		// people in normal view.  Could theroetically be called during other explosions.
																	// -- Polymorph

	//Checking for protections
	var/eye_safety = 0
	var/ear_safety = 0
	if(iscarbon(M))
		eye_safety = M.eyecheck()
		ear_safety = M.get_ear_protection()

	//Flashing everyone
	var/mob/living/carbon/human/H = M
	var/flash_effectiveness = 1
	var/bang_effectiveness = 1
	if(ishuman(M))
		flash_effectiveness = H.species.flash_mod
		bang_effectiveness = H.species.sound_mod
	if(eye_safety < 1 && get_dist(M, T) <= round(max_range * 0.7 * flash_effectiveness))
		M.flash_eyes()
		M.Confuse(2 * flash_effectiveness)
		M.afflict_paralyze(20 * 5 * flash_effectiveness)

	//Now applying sound
	if((get_dist(M, T) <= round(max_range * 0.3 * bang_effectiveness) || src.loc == M.loc || src.loc == M))
		if(ear_safety > 0)
			M.Confuse(2)
			M.afflict_paralyze(20 * 1)
		else
			M.Confuse(10)
			M.afflict_paralyze(20 * 3)
			if ((prob(14) || (M == src.loc && prob(70))))
				M.ear_damage += rand(1, 10)
			else
				M.ear_damage += rand(0, 5)
				M.ear_deaf = max(M.ear_deaf,15)

	else if(get_dist(M, T) <= round(max_range * 0.5 * bang_effectiveness))
		if(!ear_safety)
			M.Confuse(8)
			M.ear_damage += rand(0, 3)
			M.ear_deaf = max(M.ear_deaf,10)

	else if(!ear_safety && get_dist(M, T) <= (max_range * 0.7 * bang_effectiveness))
		M.Confuse(4)
		M.ear_damage += rand(0, 1)
		M.ear_deaf = max(M.ear_deaf,5)

	//This really should be in mob not every check
	if(ishuman(M))
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if (E && E.damage >= E.min_bruised_damage)
			to_chat(M, "<span class='danger'>Your eyes start to burn badly!</span>")
			if(!banglet && !(istype(src , /obj/item/grenade/simple/flashbang/clusterbang)))
				if (E.damage >= E.min_broken_damage)
					to_chat(M, "<span class='danger'>You can't see anything!</span>")
	if (M.ear_damage >= 15)
		to_chat(M, "<span class='danger'>Your ears start to ring badly!</span>")
		if(!banglet && !(istype(src , /obj/item/grenade/simple/flashbang/clusterbang)))
			if (prob(M.ear_damage - 10 + 5))
				to_chat(M, "<span class='danger'>You can't hear anything!</span>")
				M.sdisabilities |= SDISABILITY_DEAF
	else if(M.ear_damage >= 5)
		to_chat(M, "<span class='danger'>Your ears start to ring!</span>")

/obj/item/grenade/simple/flashbang/Destroy()
	walk(src, 0) // Because we might have called walk_away, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/item/grenade/simple/flashbang/on_inv_pickup(mob/wearer, datum/inventory/inventory, inv_op_flags, datum/event_args/actor/actor)
	. = ..()
	walk(src, NONE)

/obj/item/grenade/simple/flashbang/stingbang
	name = "stingbang"
	desc = "A hand held grenade, with an adjustable timer, perfect for stopping riots and playing morally unthinkable pranks."
	icon_state = "timeg"

	var/fragment_types = list(/obj/projectile/bullet/pellet/fragment/rubber, /obj/projectile/bullet/pellet/fragment/rubber/strong)
	var/num_fragments = 45  //total number of fragments produced by the grenade
	var/spread_range = 6 // for above and below, see code\game\objects\items\weapons\grenades\explosive.dm

/obj/item/grenade/simple/flashbang/stingbang/on_detonate(turf/location, atom/grenade_location)
	..()
	shrapnel_explosion(num_fragments, spread_range, fragment_types)

/obj/item/grenade/simple/flashbang/stingbang/shredbang
	name = "shredbang"
	desc = "A hand held grenade, with an adjustable timer, perfect for handling unruly citizens and getting detained by government officials."
	fragment_types = list(/obj/projectile/bullet/pellet/fragment, /obj/projectile/bullet/pellet/fragment/strong, /obj/projectile/bullet/pellet/fragment)

/obj/item/grenade/simple/flashbang/clusterbang//Created by Polymorph, fixed by Sieve
	desc = "Use of this weapon may constiute a war crime in your area, consult your local Facility Director."
	name = "clusterbang"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang"
	var/can_repeat = TRUE		// Does this thing drop mini-clusterbangs?
	var/min_banglets = 4
	var/max_banglets = 8

/obj/item/grenade/simple/flashbang/clusterbang/on_detonate(turf/location, atom/grenade_location)
	..()
	var/numspawned = rand(min_banglets, max_banglets)
	var/again = 0

	if(can_repeat)
		for(var/more = numspawned, more > 0, more--)
			if(prob(35))
				again++
				numspawned--

	for(var/do_spawn = numspawned, do_spawn > 0, do_spawn--)
		new /obj/item/grenade/simple/flashbang/cluster(location)//Launches flashbangs
		playsound(location, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	for(var/do_again = again, do_again > 0, do_again--)
		new /obj/item/grenade/simple/flashbang/clusterbang/segment(location)//Creates a 'segment' that launches a few more flashbangs
		playsound(location, 'sound/weapons/armbomb.ogg', 75, 1, -3)

/obj/item/grenade/simple/flashbang/clusterbang/segment
	desc = "A smaller segment of a clusterbang. Better run."
	name = "clusterbang segment"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "clusterbang_segment"
	can_repeat = FALSE
	banglet = TRUE

/obj/item/grenade/simple/flashbang/clusterbang/segment/Initialize(mapload)
	. = ..()

	icon_state = "clusterbang_segment_active"

	var/stepdist = rand(1,4)//How far to step
	var/temploc = src.loc//Saves the current location to know where to step away from
	walk_away(src,temploc,stepdist)//I must go, my people need me

	var/dettime = rand(15,60)
	spawn(dettime)
		detonate()

/obj/item/grenade/simple/flashbang/cluster
	banglet = TRUE

/obj/item/grenade/simple/flashbang/cluster/Initialize(mapload)
	. = ..()

	icon_state = "flashbang_active"

	var/stepdist = rand(1,3)
	var/temploc = src.loc
	walk_away(src,temploc,stepdist)

	var/dettime = rand(15,60)
	spawn(dettime)
		detonate()
