//
//	This file overrides settings on upstream simple animals to turn on vore behavior
//

/*
## For anything that previously inhertited from: /mob/living/simple_mob/hostile/vore ##

  	vore_active = 1
  	icon = 'icons/mob/vore.dmi'

## For anything that previously inhertied from: /mob/living/simple_mob/hostile/vore/large ##

	vore_active = 1
	icon = 'icons/mob/vore64x64.dmi'
	old_x = -16
	old_y = -16
	pixel_x = -16
	pixel_y = -16
	vore_pounce_chance = 50
*/

//
// Okay! Here we go!
//

/mob/living/simple_mob/animal/space/alien
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenohunter"
	icon_living = "xenohunter"
	icon_dead = "xenohunter-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/drone
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenodrone"
	icon_living = "xenodrone"
	icon_dead = "xenodrone-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/sentinel
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenosentinel"
	icon_living = "xenosentinel"
	icon_dead = "xenosentinel-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/queen
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenoqueen"
	icon_living = "xenoqueen"
	icon_dead = "xenoqueen-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/queen/empress
	vore_active = 1
	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	vore_capacity = 3
	vore_pounce_chance = 75

/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	icon = 'icons/mob/vore64x64.dmi'
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	vore_icons = FALSE

/mob/living/simple_mob/animal/space/bear
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/bear/hudson
	name = "Hudson"

/mob/living/simple_mob/animal/space/bear/brown
	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	name = "brown bear"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/carp
	icon = 'icons/mob/vore.dmi'
	vore_active = 1
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/carp/large
	vore_icons = 0
/mob/living/simple_mob/animal/space/carp/large/huge
	vore_icons = 0
/mob/living/simple_mob/animal/space/carp/holographic
	vore_icons = 0

/mob/living/simple_mob/animal/passive/cat
	vore_active = 1
	//specific_targets = 0 // Targeting UNLOCKED
	vore_max_size = RESIZE_TINY

/mob/living/simple_mob/animal/passive/cat/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be catfood
	vore_standing_too = TRUE //gonna get pounced

/mob/living/simple_mob/animal/passive/fox
	vore_active = 1
	vore_max_size = RESIZE_TINY

/mob/living/simple_mob/fox/fluff
	vore_ignores_undigestable = 0
	vore_pounce_chance = 100
	vore_digest_chance = 0 // just use the toggle
	vore_default_mode = DM_HOLD //can use the toggle if you wanna be foxfood
	vore_standing_too = TRUE // gonna get pounced

/mob/living/simple_mob/animal/space/goose
	vore_active = 1
	vore_max_size = RESIZE_SMALL

/mob/living/simple_mob/animal/passive/penguin
	vore_active = 1
	vore_max_size = RESIZE_SMALL


/mob/living/simple_mob/hostile/carp/pike
	vore_active = 1

/mob/living/simple_mob/animal/space/carp/holographic
	vore_icons = 0
	vore_digest_chance = 0
	vore_absorb_chance = 0

// Override stuff for holodeck carp to make them not digest when set to safe!
/mob/living/simple_mob/animal/space/carp/holographic/init_vore()
	. = ..()
	var/safe = (faction == "neutral")
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.digest_mode = safe ? DM_HOLD : vore_default_mode

/mob/living/simple_mob/animal/space/carp/holographic/set_safety(var/safe)
	. = ..()
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		B.digest_mode = safe ? DM_HOLD : vore_default_mode

/mob/living/simple_mob/animal/passive/mouse
	faction = "mouse" //Giving mice a faction so certain mobs can get along with them.
