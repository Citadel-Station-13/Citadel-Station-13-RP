//
//	This file overrides settings on upstream simple animals to turn on vore behavior
//

/*
## For anything that previously inhertited from: /mob/living/simple_mob/hostile/vore ##

  	vore_active = 1
  	icon = 'icons/mob/vore.dmi'

## For anything that previously inhertied from: /mob/living/simple_mob/hostile/vore/large ##

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

/mob/living/simple_mob/animal/space/bear
	icon = 'icons/mob/vore.dmi'
	icon_state = "spacebear"
	icon_living = "spacebear"
	icon_dead = "spacebear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/bear/hudson
	name = "Hudson"

/mob/living/simple_mob/animal/space/bear/brown
	icon = 'icons/mob/vore.dmi'
	name = "brown bear"
	icon_state = "brownbear"
	icon_living = "brownbear"
	icon_dead = "brownbear-dead"
	icon_gib = "bear-gib"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/carp
	icon = 'icons/mob/vore.dmi'
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/carp/large
	vore_icons = 0
/mob/living/simple_mob/animal/space/carp/large/huge
	vore_icons = 0
/mob/living/simple_mob/animal/space/carp/holographic
	vore_icons = 0

/mob/living/simple_mob/animal/passive/cat
	//specific_targets = 0 // Targeting UNLOCKED

/mob/living/simple_mob/animal/passive/cat/fluff

/mob/living/simple_mob/animal/passive/fox

/mob/living/simple_mob/fox/fluff

/mob/living/simple_mob/animal/space/goose

/mob/living/simple_mob/animal/passive/penguin


/mob/living/simple_mob/hostile/carp/pike

/mob/living/simple_mob/animal/space/carp/holographic
	vore_icons = 0

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
