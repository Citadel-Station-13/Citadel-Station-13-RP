/datum/category_item/catalogue/fauna/feral_alien
	name = "Feral Xenomorph"
	desc = "Xenomorphs are a widely recognized and rightfully feared scourge \
	across the Frontier. Some Xenomorph hives lose a connection to the greater \
	Hive structure, and become less coordinated, though no less dangerous. \
	Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/feral_alien)

// Obtained by scanning all Aliens.
/datum/category_item/catalogue/fauna/all_feral_aliens
	name = "Collection - Feral Xenomorphs"
	desc = "You have scanned a large array of different types of Xenomorph, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_SUPERHARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/feral_alien/hunter,
		/datum/category_item/catalogue/fauna/feral_alien/drone,
		/datum/category_item/catalogue/fauna/feral_alien/sentinel,
		/datum/category_item/catalogue/fauna/feral_alien/sentinel/praetorian,
		/datum/category_item/catalogue/fauna/feral_alien/queen,
		/datum/category_item/catalogue/fauna/feral_alien/queen/empress,
		/datum/category_item/catalogue/fauna/feral_alien/queen/empress/mother
		)

/datum/category_item/catalogue/fauna/feral_alien/hunter
	name = "Feral Xenomorph - Hunter"
	desc = "Hunters are one of the generalized combat morphs used \
	by the Hive offensively. Capable of moving at great speed and \
	tracking prey effectively in the dark, Hunters instinctively maim \
	instead of kill. Their disabled prey are usually hauled back to the \
	Hive as hosts for fresh Facehuggers. Without the Hive's direction, \
	Hunters will seek to capture less frequently. Kill on sight."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/space/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_living = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"
	icon_rest = "alienh_sleep"
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/hunter)

	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 100
	health = 100
	randomized = TRUE

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_sharp = TRUE
	attack_edge = TRUE
	taser_kill = 0

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	meat_amount = 3
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	hide_amount = 2
	hide_type = /obj/item/stack/xenochitin

/datum/category_item/catalogue/fauna/feral_alien/drone
	name = "Feral Xenomorph - Drone"
	desc = "The adult form of the Xenomorph, the drone's iconic \
	morphology and biological traits make it easily identifiable across \
	the Frontier. Feared for its prowess, the Drone is a sign that an even \
	larger threat is present: a Xenomorph Hive. When their connection to the \
	Hive has been disrupted, Drones exhibit less construction activity and \
	revert to a defensive Kill on sight."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_living = "aliend_running"
	icon_dead = "aliend_l"
	icon_rest = "aliend_sleep"
	health = 100
	melee_damage_lower = 15
	melee_damage_upper = 15
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/drone)

/datum/category_item/catalogue/fauna/feral_alien/sentinel
	name = "Feral Xenomorph - Sentinel"
	desc = "Sentinels serve as defensive units for the Hive. Possessing \
	a powerful neurotoxic venom, Sentinels are able to spit this toxin at \
	range with alarming accuracy and control. Designed to repel assaults, \
	the Sentinel serves the dual purpose of weakening aggressors so they may \
	be more easily collected to host future generations. When disconnected \
	from the Hive, Sentinel behavior remains almost exactly the same. Kill \
	on sight."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_living = "aliens_running"
	icon_dead = "aliens_l"
	icon_rest = "aliens_sleep"
	health = 220
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/sentinel)

/datum/category_item/catalogue/fauna/feral_alien/sentinel/praetorian
	name = "Feral Xenomorph - Praetorian"
	desc = "The Xenomorph Praetorian is not often seen amongst \
	standard Xeno incursions. Spawned in large Hives to serve as \
	bodyguards to an Empress, the Praetorian clade are powerful, and \
	nightmarishly effective in close combat. Spotting a Praetorian in \
	the field is often grounds to call for an immediate withdrawal and \
	orbital bombardment. On the rare occasions where Praetorians are \
	cut off from the greater Hive, they remain formidable foes and will \
	die to protect their Queen. Kill on sight."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	name = "alien praetorian"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "prat_s"
	icon_living = "prat_s"
	icon_dead = "prat_dead"
	icon_rest = "prat_sleep"
	maxHealth = 400
	health = 400
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/sentinel/praetorian)

	base_pixel_x = -16
	icon_dimension_y = 64
	icon_dimension_x = 64

	meat_amount = 5

	mod_min = 80
	mod_max = 150

/datum/category_item/catalogue/fauna/feral_alien/queen
	name = "Feral Xenomorph - Queen"
	desc = "When a Drone reaches a certain level of maturity, she may \
	evolve into a Queen, if there is no functioning Hive nearby. The Queen \
	is erroneously considered the ultimate end point of Xenomorph evolution. \
	The Queen is responsible for laying eggs, which will spawn more Facehuggers, \
	and therefore eventually more Xenomorphs. As such, she bears a significant \
	strategic value to the Hive, and will be defended ferociously. Queens are \
	imbued with substantial psionic power which lets them direct their Hive, but \
	when they are cut off from the larger Xenomorph Hivemind, they may experience \
	a form of shock which reverts them into a Drone's mindstate. Kill on sight. "
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/space/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_living = "alienq_running"
	icon_dead = "alienq_l"
	icon_rest = "alienq_sleep"
	health = 750
	maxHealth = 750
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/queen)

	mod_min = 90
	mod_max = 150

	movement_cooldown = 8

/datum/category_item/catalogue/fauna/feral_alien/queen/empress
	name = "Feral Xenomorph - Empress"
	desc = "A Xenomorph queen who reaches a certain stage of maturity \
	may eventually develop into an Empress. Xenomorph Empresses reign \
	over large, complex Hives and signify the escalation of a Xenomorph \
	outbreak from a serious hazard to an existential threat. When disconnected \
	from the greater Hive, an Empress will not always revert like lesser \
	Queens, and may still exhibit ferocious cunning in eliminating aggressors. \
	Kill on sight."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/space/alien/queen/empress
	name = "alien empress"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	icon_rest = "queen_sleep"
	maxHealth = 1000
	health = 1000
	meat_amount = 5
	hide_amount = 5
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/queen/empress)

	base_pixel_x = -16
	icon_dimension_x = 64
	icon_dimension_y = 64

/datum/category_item/catalogue/fauna/feral_alien/queen/empress/mother
	name = "Feral Xenomorph - Mother"
	desc = "The true end stage of Xenomorph Queen development, \
	the Xenomorph Mother is the local psionic node of the Hive. These \
	beasts communicate across systems to execute the will of the Hivemind \
	itself. Powerful, large, and often ancient, Mothers are a sign that your \
	planet may be too far gone to save. When somehow separated from the Hivemind, \
	Mothers retain their full faculties, and will try and direct their Xenomorphs \
	to eliminate any threat. Retreat immediately."
	value = CATALOGUER_REWARD_SUPERHARD

/mob/living/simple_mob/animal/space/alien/queen/empress/mother
	name = "alien mother"
	icon = 'icons/mob/96x96.dmi'
	icon_state = "empress_s"
	icon_living = "empress_s"
	icon_dead = "empress_dead"
	icon_rest = "empress_rest"
	maxHealth = 600
	health = 600
	meat_amount = 10
	hide_amount = 10
	melee_damage_lower = 15
	melee_damage_upper = 25
	catalogue_data = list(/datum/category_item/catalogue/fauna/feral_alien/queen/empress/mother)

	base_pixel_x = -32
	base_pixel_y = -32
	icon_dimension_x = 96
	icon_dimension_y = 96

	mod_min = 100
	mod_max = 150

/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)
