/mob/living/simple_mob/animal/space/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon_rest = "alienh_sleep"

	faction = "xeno"

	mob_class = MOB_CLASS_ABERRATION

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	maxHealth = 100
	health = 100

	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attack_sharp = TRUE
	attack_edge = TRUE

	attacktext = list("slashed")
	attack_sound = 'sound/weapons/bladeslice.ogg'

	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenohunter"
	icon_living = "xenohunter"
	icon_dead = "xenohunter-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/xenomeat

/mob/living/simple_mob/animal/space/alien/drone
	name = "alien drone"
	icon_rest = "aliend_sleep"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenodrone"
	icon_living = "xenodrone"
	icon_dead = "xenodrone-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

/mob/living/simple_mob/animal/space/alien/sentinel
	name = "alien sentinel"

	icon_rest = "aliens_sleep"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'

	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenosentinel"
	icon_living = "xenosentinel"
	icon_dead = "xenosentinel-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING
	ai_holder_type = /datum/ai_holder/simple_mob/ranged

/mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	name = "alien praetorian"
	icon_state = "prat_s"
	icon_living = "prat_s"
	icon_dead = "prat_dead"
	icon_rest = "prat_sleep"
	maxHealth = 200
	health = 200

	pixel_x = -16
	old_x = -16
	meat_amount = 5
	icon = 'icons/mob/vore64x64.dmi'
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_mob/animal/space/alien/queen
	name = "alien queen"
	icon_rest = "alienq_sleep"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectiletype = /obj/item/projectile/energy/neurotoxin/toxic
	projectilesound = 'sound/weapons/pierce.ogg'

	vore_active = 1
	icon = 'icons/mob/vore.dmi'
	icon_state = "xenoqueen"
	icon_living = "xenoqueen"
	icon_dead = "xenoqueen-dead"
	icon_gib = "gibbed-a"
	vore_icons = SA_ICON_LIVING

	ai_holder_type = /datum/ai_holder/simple_mob/ranged
	movement_cooldown = 8

/mob/living/simple_mob/animal/space/alien/queen/empress
	name = "alien empress"
	icon_rest = "queen_sleep"
	maxHealth = 400
	health = 400
	meat_amount = 5

	vore_active = 1

	icon = 'icons/mob/vore64x64.dmi'
	icon_state = "queen_s"
	icon_living = "queen_s"
	icon_dead = "queen_dead"
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	default_pixel_x = -16

	vore_capacity = 3
	vore_pounce_chance = 75
	pixel_x = -16
	old_x = -16

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
	melee_damage_lower = 15
	melee_damage_upper = 25
	vore_icons = 0 // NO VORE SPRITES
	pixel_x = -32
	old_x = -32

/mob/living/simple_mob/animal/space/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)