// Ranged, and capable of flight.

/datum/category_item/catalogue/technology/hoverpod
	name = "Voidcraft - Hoverpod"
	desc = "This small space-capable craft can accomodate one pilot and up to two passengers, depending on its equipment. \
	The Hoverpod's trademark round design and bright white coloration are easily recognizable to spacefarers. The design \
	has been in use for nearly two centuries, and has remained largely consistent. Developed to address short ranged transport \
	of crew nad cargo in EVA, the Hoverpod is a niche vehicle. Due to its reduced size and maneuverability, the Hoverpod saw \
	frequent use in situations where a shuttle was deemed too cumbersome. Thanks to their ability to enter airlocks, Hoverpods \
	have acted as a bridge between EVA in space suits and travelling within proper spacecraft. In recent times, however, the \
	Hoverpod has begun to show its age. Newer solutions that address the same niche have begun to come to the forefront. \
	In spite of this, the Hoverpod remains a cheap and reliable favorite across the Frontier."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/mecha/hoverpod
	name = "hover pod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite. It has a jury-rigged welder-laser."
	catalogue_data = list(/datum/category_item/catalogue/technology/hoverpod)
	icon_state = "engineering_pod"
	movement_sound = 'sound/machines/hiss.ogg'
	wreckage = /obj/structure/loot_pile/mecha/hoverpod

	maxHealth = 150
	hovering = TRUE // Can fly.

	projectiletype = /obj/projectile/beam
	base_attack_cooldown = 2 SECONDS

	var/datum/effect_system/ion_trail_follow/ion_trail

/mob/living/simple_mob/mechanical/mecha/hoverpod/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged

/mob/living/simple_mob/mechanical/mecha/hoverpod/Initialize(mapload)
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()
	return ..()

/mob/living/simple_mob/mechanical/mecha/hoverpod/Process_Spacemove(var/check_drift = 0)
	return TRUE
