/mob/living/simple_mob/animal/eldritch
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/mobs/32x32.dmi'
	iff_factions = MOB_IFF_FACTION_ELDRITCH_CULT
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/inert/astar
	maxHealth = 999999
	health = 999999
	movement_base_speed = 10 / 2
	vision_innate = /datum/vision/baseline/species_tier_3
	taser_kill = FALSE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/animal/eldritch/death()
	..(null,"<span class='hypnophrase'>warps and shifts as its form collapses in on itself, producing a noise which your mind cannot hope to comprehend.</span>")
	ghostize()
	qdel(src)


/mob/living/simple_mob/animal/eldritch/fragment
	name = "<span class='hypnophrase'>Fragment</span>"
	desc = "A mass of shifting shadow that shifts and morphs, as if it is struggling to stay bound within reality."

	density = FALSE
	invisibility = 26
	see_invisible = 26

	icon_living = "fragment"
	icon_state = "fragment"
	icon_rest = "fragment"



/mob/living/simple_mob/animal/eldritch/entity
	name = "<span class='hypnophrase'>Entity</span>"
	desc = "A pillar of umbra mass that pulses with lights which your eyes can't make sense of. The longer you stare, the more your surroundings seem to shift."
	var/next_phase_shift = 0

	icon_living = "entity"
	icon_state = "entity"
	icon_rest = "entity"
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/mobs/32x48.dmi'

	density = 1
	maxHealth = 500
	health = 500

/mob/living/simple_mob/animal/eldritch/skinstealer
	name = "<span class='hypnophrase'>Abomination</span>"
	desc = "A mockery of skin and flesh with a pair of wings that arches from its back. Its form incessantly shifts and molts, taking on new visuals every time you dare to look its way."

	ui_icons = 'icons/mob/screen1_construct.dmi'
	hand_count = 2
	hand_form = "hands"
	humanoid_hands = TRUE

	icon_living = "skinstealer"
	icon_state = "skinstealer"
	icon_rest = "skinstealer"
	icon = 'code/game/content/factions/eldritch/eldritch.dmi/mobs/31x42.dmi'

	density = 1
	maxHealth = 700
	health = 700
