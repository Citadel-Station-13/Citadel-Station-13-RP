/datum/category_item/catalogue/fauna/mimic		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Aberration - Mimic"
	desc = "A being that seems to take the form of a crates, closets, doors and potentially other inanimate objects, for whatever reason. \
	It seems to lie in wait for it's prey, and then pounce once the unsuspecting person attempts to open it. \
	For whatever reason, they seem native to underground areas, and they're very tough, and hard to kill, able to pounce fast."
	value = CATALOGUER_REWARD_HARD

/obj/structure/closet/crate/mimic
	name = "old crate"
	desc = "A rectangular steel crate. This one looks particularly unstable."
	icon = 'icons/mob/animal.dmi'
	icon_state = "mimic"
	icon_opened = "open"
	icon_closed = "mimic"
	var/mimic_chance = 30
	var/mimic_active = TRUE

/obj/structure/closet/crate/mimic/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(mimic_active)
		mimic_active = FALSE
		if(prob(mimic_chance))
			var/mob/living/simple_mob/vore/aggressive/mimic/new_mimic = new(loc, src)
			visible_message("<font color='red'><b>The [new_mimic] suddenly growls as it turns out to be a mimic!</b></font>") //Controls the vars of the mimic that spawns
			forceMove(new_mimic)
			new_mimic.real_crate = src
			new_mimic.name = name
			new_mimic.desc = desc
			new_mimic.icon = icon
			new_mimic.icon_state = "mimicopen"
			new_mimic.icon_living = "mimicopen"
		else
			return ..()
	else
		return ..()

/obj/structure/closet/crate/mimic/ex_act(severity) //Stores Mimic Contents for later
	for(var/obj/O in src.contents)
		qdel(O)
	qdel(src)
	return

/obj/structure/closet/crate/mimic/damage(var/damage)
	if(contents.len)
		visible_message("<font color='red'><b>The [src] makes out a crunchy noise as its contents are destroyed!</b></font>")
		for(var/obj/O in src.contents)
			qdel(O)
	..()

/obj/structure/closet/crate/mimic/safe
	mimic_chance = 0
	mimic_active = FALSE

/obj/structure/closet/crate/mimic/guaranteed
	mimic_chance = 100

/obj/structure/closet/crate/mimic/dangerous
	mimic_chance = 70

/obj/structure/closet/crate/mimic/cointoss
	mimic_chance = 50

/mob/living/simple_mob/vore/aggressive/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon_state = "mimicopen"
	icon_living = "mimicopen"
	icon = 'icons/mob/animal.dmi'

	faction = "mimic"

	maxHealth = 125
	health = 125
	movement_cooldown = 7

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	melee_damage_lower = 7
	melee_damage_upper = 15
	attacktext = list("attacked")
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	ai_holder_type = /datum/ai_holder/mimic

	var/obj/structure/closet/crate/real_crate

	var/knockdown_chance = 10 //Stubbing your toe on furniture hurts.

	showvoreprefs = 0 //Hides mechanical vore prefs for mimics. You can't see their gaping maws when they're just sitting idle.

/mob/living/simple_mob/vore/aggressive/mimic
	vore_active = 1
	vore_pounce_chance = 10
	swallowTime = 3 SECONDS
	vore_capacity = 1
	vore_default_mode = DM_DIGEST

/datum/ai_holder/mimic
	wander = FALSE
	hostile = TRUE

/mob/living/simple_mob/vore/aggressive/mimic/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

/mob/living/simple_mob/vore/aggressive/mimic/will_show_tooltip()
	return FALSE

/mob/living/simple_mob/vore/aggressive/mimic/death()
	..()
	if(real_crate)
		real_crate.forceMove(loc)
	else
		new/obj/structure/closet/crate(src.loc)
	real_crate = null
	qdel(src)

//NEW AND TERRIFYING AIRLOCK MIMIC

/obj/structure/closet/crate/mimic/airlock
	name = "Maintnence Access"
	desc = "It opens and closes."
	icon = 'icons/mob/animal.dmi'
	icon_state = "amimic"
	icon_opened = "amimicopen"
	icon_closed = "amimic"
	mimic_chance = 100  //Since It would require shitcode otherwise airlock mimics are always mimics

/obj/structure/closet/crate/mimic/airlock/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(mimic_active)
		mimic_active = FALSE
		if(prob(mimic_chance))
			var/mob/living/simple_mob/vore/aggressive/mimic/airlock/new_mimic = new(loc, src)
			visible_message("<font color='red'><b>The [new_mimic] suddenly growls as it turns out to be a mimic!</b></font>") //Controls the vars of the mimic that spawns
			forceMove(new_mimic)
			new_mimic.real_crate = src
			new_mimic.name = name
			new_mimic.desc = desc
			new_mimic.icon = icon
			new_mimic.icon_state = "amimicopen"
			new_mimic.icon_living = "amimicopen"
		else
			return ..()
	else
		return ..()

/obj/structure/closet/crate/mimic/airlock/ex_act(severity) //Stores Mimic Contents for later
	for(var/obj/O in src.contents)
		qdel(O)
	qdel(src)
	return

/obj/structure/closet/crate/mimic/airlock/damage(var/damage)
	if(contents.len)
		visible_message("<font color='red'><b>The [src] let's out an enraged screach!</b></font>")
		for(var/obj/O in src.contents)
			qdel(O)
	..()

/mob/living/simple_mob/vore/aggressive/mimic/airlock
	name = "Maintnence Access"
	desc = "It opens and closes."
	icon_state = "amimicopen"
	icon_living = "amimicopen"
	icon = 'icons/mob/animal.dmi'

	maxHealth = 250
	health = 250
	movement_cooldown = 10

	melee_damage_lower = 15
	melee_damage_upper = 30
	attack_armor_pen = 50 //Its jaw is an airlock. Its got enough bite strength.

	armor = list(
				"melee" = 70,
				"bullet" = 30,
				"laser" = 30,
				"energy" = 30,
				"bomb" = 10,
				"bio" = 100,
				"rad" = 100) //Its an airlock.

/mob/living/simple_mob/vore/aggressive/mimic/airlock/will_show_tooltip()
	return FALSE

/mob/living/simple_mob/vore/aggressive/mimic/airlock/death()
	new/obj/machinery/door/airlock/maintenance/common (src.loc)
	real_crate = null
	qdel(src)



//Less Terrifying Closet Mimic
/obj/structure/closet/crate/mimic/closet
	name = "old closet"
	desc = "It's a basic storage unit. It seems awfully rickety."
	icon_state = "cmimic"
	icon = 'icons/mob/animal.dmi'
	icon_opened = "copen"
	icon_closed = "cmimic"
	mimic_chance = 30
	mimic_active = TRUE

/obj/structure/closet/crate/mimic/closet/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(mimic_active)
		mimic_active = FALSE
		if(prob(mimic_chance))
			var/mob/living/simple_mob/vore/aggressive/mimic/closet/new_mimic = new(loc, src)
			visible_message("<font color='red'><b>The [new_mimic] suddenly growls as it turns out to be a mimic!</b></font>") //Controls the mimic that spawns
			forceMove(new_mimic)
			new_mimic.real_crate = src
			new_mimic.name = name
			new_mimic.desc = desc
			new_mimic.icon = icon
			new_mimic.icon_state = "cmimicopen"
			new_mimic.icon_living = "cmimicopen"
		else
			return ..()
	else
		return ..()

/obj/structure/closet/crate/mimic/closet/ex_act(severity) //Stores Mimic Contents for later
	for(var/obj/O in src.contents)
		qdel(O)
	qdel(src)
	return

/obj/structure/closet/crate/mimic/closet/damage(var/damage)
	if(contents.len)
		visible_message("<font color='red'><b>The [src] makes out a crunchy noise as its contents are destroyed!</b></font>")
		for(var/obj/O in src.contents)
			qdel(O)
	..()

/obj/structure/closet/crate/mimic/closet/safe
	mimic_chance = 0
	mimic_active = FALSE

/obj/structure/closet/crate/mimic/closet/guaranteed
	mimic_chance = 100

/obj/structure/closet/crate/mimic/closet/dangerous
	mimic_chance = 70

/obj/structure/closet/crate/mimic/closet/cointoss
	mimic_chance = 50

/mob/living/simple_mob/vore/aggressive/mimic/closet
	name = "Maintnence Access"
	desc = "It opens and closes."
	icon_state = "cmimicopen"
	icon_living = "cmimicopen"
	icon = 'icons/mob/animal.dmi'

	maxHealth = 150
	health = 150
	movement_cooldown = 7

	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_armor_pen =  25 // NOM NOM

	armor = list(
				"melee" = 10,
				"bullet" = 20,
				"laser" = 20,
				"energy" = 20,
				"bomb" = 20,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/vore/aggressive/mimic/closet/will_show_tooltip()
	return FALSE

/mob/living/simple_mob/vore/aggressive/mimic/closet/death()
	..()
	if(real_crate)
		real_crate.forceMove(loc)
	else
		new/obj/structure/closet(src.loc)
	real_crate = null
	qdel(src)
