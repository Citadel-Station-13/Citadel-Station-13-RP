/*
	This is the first stage of porting roaches from Eris.
	The intent is to eventually supplement mice and spiders with another class of pest.
	Currently the code for these mobs will be somewhat basic, but with wide potential for further development.
*/

// Obtained by scanning any roach.
/datum/category_item/catalogue/fauna/roach/roach
	name = "Roaches"
	desc = "This hardy species of insect existed on earth for Millions of years prior to humanity,\
	and attained a demonstrable measure of evolutionary 'perfection', as evidenced by their longevity.\
	Prior to the Final War, many humans speculated that the common roach might survive such a cataclysm.\
	Although none who once posited the idea are still around, they have since been vindicated.\
	It is not known exactly how roaches migrated from Earth, but true to form, they have become ubiquitous,\
	infesting stations and vessels across the galaxy.\
	Some xeno species consider roaches to be a delicacy, and have engaged in cultivation practices.\
	Some manner of speciation has been detected amongst roaches in the modern galaxy,\
	leading to an as yet unknown number of varieties and mutations."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/roach)

// Obtained by scanning all roach types.
/datum/category_item/catalogue/fauna/all_roaches
	name = "Collection - Roaches"
	desc = "You have scanned a large array of different types of roaches, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/roach/roach,
		/datum/category_item/catalogue/fauna/roach/roachling,
		/datum/category_item/catalogue/fauna/roach/panzer,
		/datum/category_item/catalogue/fauna/roach/jaeger,
		/datum/category_item/catalogue/fauna/roach/seuche,
		/datum/category_item/catalogue/fauna/roach/atomar,
		/datum/category_item/catalogue/fauna/roach/uberfallen,
		/datum/category_item/catalogue/fauna/roach/strahlend,
		/datum/category_item/catalogue/fauna/roach/zeitraum,
		/datum/category_item/catalogue/fauna/roach/fuhrer
		)

/mob/living/simple_mob/animal/roach
	name = "roach"
	real_name = "roach"
	desc = "A hardy pest native to Terra. It somehow survived the Final War and spread among the stars."
	tt_desc = "Periplaneta australasiae"
	icon_state = "roach"
	item_state = "roach"
	icon_living = "roach"
	icon_dead = "roach_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/roach)

	maxHealth = 15
	health = 15
	randomized = TRUE

	armor = list(
				"melee" = 5,
				"rad" = 100)

	see_in_dark = 6
	universal_understand = 1
	faction = "roaches"

	mob_size = MOB_SMALL
	pass_flags = PASSTABLE
//	can_pull_size = ITEMSIZE_TINY
//	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = 0

	response_help  = "strokes"
	response_disarm = "awkwardly scoots past"
	response_harm   = "stomps on"

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_edge = 1
	attacktext = list("bit", "scratched","clawed")
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	minbodytemp = 150
	maxbodytemp = 323

	speak_emote = list("chitters")
	say_list_type = /datum/say_list/roach
	holder_type = /obj/item/holder/roach
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate/cooperative

/mob/living/simple_mob/animal/roach/Initialize(mapload)
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

/mob/living/simple_mob/animal/roach/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M.visible_message("<font color='blue'>[icon2html(thing = src, target = world)] Chk chk!</font>")
			SEND_SOUND(M, sound('sound/effects/squelch1.ogg'))
	..()

/*
 * Special Roach types.
 */

//How DARE you!
/mob/living/simple_mob/animal/roach/Greta
	name = "Greta"
	desc = "Legend has it this roach sailed across the Eagle Nebula to protest bug burgers."

	taser_kill = 0

//Unrandom the pet...?
/mob/living/simple_mob/animal/roach/Greta/Initialize(mapload)
    . = ..()
    size_multiplier = 1
    maxHealth = maxHealth
    health = health
    melee_damage_lower = melee_damage_lower
    melee_damage_upper = melee_damage_upper
    movement_cooldown = movement_cooldown
    meat_amount = meat_amount
    update_icons()

/mob/living/simple_mob/animal/roach/Greta/Initialize(mapload)
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)

//Baby Roaches? Baby Roaches.
/datum/category_item/catalogue/fauna/roach/roachling
	name = "Roachling"
	desc = "Every life begins somewhere, and the juvenile roach, commonly referred to as a 'roachling',\
	serves as one of the first signs of a budding roach infestation. If you see one, there are more.\
	Attentive crews will take the sign of a single roachling as a warning to dock and pull up panels."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/roachling
	name = "roachling"
	real_name = "roachling"
	desc = "A hardy pest native to Terra. This one's just a baby."
	icon_state = "roachling"
	item_state = "roachling"
	icon_living = "roachling"
	icon_dead = "roachling_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/roachling)

	maxHealth = 5
	health = 5

	movement_cooldown = 4

	melee_damage_lower = 2
	melee_damage_upper = 3

	var/amount_grown = -1
	var/spawn_delay = 20
	var/list/grow_as = list(/mob/living/simple_mob/animal/roach, /mob/living/simple_mob/animal/roach/seuche, /mob/living/simple_mob/animal/roach/jaeger)

/mob/living/simple_mob/animal/roach/roachling/Initialize(mapload, atom/parent)
	. = ..()
	START_PROCESSING(SSobj, src)
	//50% chance to grow up
	if(prob(50))
		amount_grown = 1
	get_light_and_color(parent)

/mob/living/simple_mob/animal/roach/roachling/death()
	STOP_PROCESSING(SSobj, src)
	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/mob/living/simple_mob/animal/roach/roachling/process(delta_time)
	if(amount_grown >= 0)
		amount_grown += rand(0,2)
	if(amount_grown >= 100)
		mature()

/mob/living/simple_mob/animal/roach/roachling/proc/mature()
	var/spawn_type = pick(grow_as)
	new spawn_type(src.loc, src)
	qdel(src)

//That's just great. That's what we wanna show kids. Santa rolling down the block - in a Panzer.
/datum/category_item/catalogue/fauna/roach/panzer
	name = "Armored Roach"
	desc = "This peculiar subspecies of roach is believed to have adapted in high pressure environments,\
	where even the sturdy exoskeleton of its ancestors were too frail to survive. Slower than average,\
	but formidable in numbers, these creatures require more than a boot to dispatch effectively."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/panzer
	name = "armored roach"
	real_name = "armored roach"
	desc = "A descendant of an Old Terra pest. This one has evolved a bulky shell that shields it from harm."
	tt_desc = "Periplaneta adamantia"
	icon_state = "panzer"
	item_state = "panzer"
	icon_living = "panzer"
	icon_dead = "panzer_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/panzer)

	maxHealth = 30
	health = 30

	taser_kill = 0

	movement_cooldown = 7

	armor = list(
				"melee" = 20,
				"bullet" = 15,
				"rad" = 100)

//Sie Sind Das Essen Und Wir Sind Die Jager
/datum/category_item/catalogue/fauna/roach/jaeger
	name = "Hunter Roach"
	desc = "According to the standing theory, 'Hunter Roaches' adapted in a predator rich environment,\
	where mobility and speed became evolutionary advantages. The Hunter's aggressive nature and striking\
	green coloration make it an enticing and deadly foe, even when found alone."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/jaeger
	name = "hunter roach"
	real_name = "hunter roach"
	desc = "A descendant of an Old Terra pest. This one moves quickly to chase down its prey. Potentially more effective in forests."
	tt_desc = "Periplaneta mercuria"
	icon_state = "jaeger"
	item_state = "jaeger"
	icon_living = "jaeger"
	icon_dead = "jaeger_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/jaeger)

	maxHealth = 15
	health = 15

	taser_kill = 0

	melee_damage_lower = 7
	melee_damage_upper = 10

	movement_cooldown = 4

	armor = list(
				"melee" = 10
				)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

//When I said roaches made me sick, this isn't what I meant.
/datum/category_item/catalogue/fauna/roach/seuche
	name = "Diseased Roach"
	desc = "This phenomena was first observed on Virgo 3b, among certain species of Atrax robustus.\
	When exposed to gaseous or powdered phoron over long periods of time without protection will mutate,\
	sometimes developing abnormal traits. Most often, however, exposed organisms will contract numerous,\
	often fatal, disases as their immune systems are compromised. Such creatures are often hotbeds of disease,\
	and should be handled with extreme care."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/seuche
	name = "diseased roach"
	real_name = "diseased roach"
	desc = "A descendant of an Old Terra pest. This one is suffering from the long term effects of direct Phoron exposure."
	tt_desc = "Periplaneta morbus"
	icon_state = "seuche"
	item_state = "seuche"
	icon_living = "seuche"
	icon_dead = "seuche_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/seuche)

	maxHealth = 15
	health = 15

	taser_kill = 0

	armor = list(
				"bio" = 100
				)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

	var/poison_chance = 50
	var/poison_per_bite = 5
	var/poison_type = "phoron"

/mob/living/simple_mob/animal/roach/seuche/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)
				infect_mob(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_mob/animal/roach/seuche/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>The bite stings!</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

//If you think roaches are bad, imagine dragons.
/datum/category_item/catalogue/fauna/roach/atomar
	name = "Cancerous Roach"
	desc = "Most roaches display an intensely robust resistance to the effects of radiaton. Most.\
	Genetic mutations leading to a pronounced weakness to cell degeneration are rare, but not unheard of.\
	This roach seems to be one of those mutants, as evidenced by the mass of tumors and toxic protrusions.\
	Although frail and not long for this world, cancerous roaches often employ a grotesque defensive tactic:\
	ripping off chunks of diseased flesh and throwing it at percieved threats in an attempt to ward them off."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/atomar
	name = "cancerous roach"
	real_name = "cancerous roach"
	desc = "A descendant of an Old Terra pest. This one is covered in cancerous growths indicative of intense radiation sickness."
	tt_desc = "Periplaneta carcinodes"
	icon_state = "atomar"
	item_state = "atomar"
	icon_living = "atomar"
	icon_dead = "atomar_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/atomar)

	maxHealth = 10
	health = 10

	taser_kill = 0

	melee_damage_lower = 2
	melee_damage_upper = 3

	armor = list(
				"energy" = 40,
				"rad" = 10
				)

	base_attack_cooldown = 4
	projectiletype = /obj/item/projectile/energy/blob/toxic
	projectilesound = 'sound/effects/slime_squish.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

//Nanomachines? Huh. That's not very Patriotic.
/datum/category_item/catalogue/fauna/roach/uberfallen
	name = "Infested Roach"
	desc = "WARNING: Infested roaches are currently flagged as a Class Red threat by NanoTrasen.\
	This dangerous organism appeared shortly after the unidentified incident on local NT asset 'Surt',\
	bearing many of the hallmarks of other hostile organisms encountered in the Rift. Roaches originally,\
	Infested are now skittering nanite factories. Reports indicate they are able to expel hostile nanites\
	from range. Exposure to these nanites has been shown to cause intense genetic damage, as the nanites\
	attack their victim on a molecular level. Terminate with extreme prejudice."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/uberfallen
	name = "infested roach"
	real_name = "infested roach"
	desc = "A descendant of an Old Terra pest. This one has become a hive for even smaller rapidly breeding pests. Ironic."
	tt_desc = "Periplaneta alvus"
	icon_state = "uberfallen"
	item_state = "uberfallen"
	icon_living = "uberfallen"
	icon_dead = "uberfallen_dead"
	faction = "synthtide"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/uberfallen)

	maxHealth = 30
	health = 30

	taser_kill = 0

	movement_cooldown = 8

	melee_damage_lower = 5
	melee_damage_upper = 10

	armor = list(
				"melee" = 20,
				"bullet" = 50,
				"bio" = 100
				)

	base_attack_cooldown = 8
	projectiletype = /obj/item/projectile/energy/declone

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

//Remember when Liam Neeson taught you how to kill these?
/datum/category_item/catalogue/fauna/roach/strahlend
	name = "Glowing Roach"
	desc = "Just because roaches are by and large immune to radiation, it doesn't mean they avoid it.\
	Glowing roaches are one of the first recorded subspecies of roach to be recorded off of Earth.\
	Although not affected by it, these roaches have been exposed to - and absorbed - enough radioactive\
	material to become passively radioactive themselves. This property transfer to their spit,\
	which these roaches are not afraid to use to deter assailants, or, rarely, to wound prey."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/strahlend
	name = "glowing roach"
	real_name = "glowing roach"
	desc = "A descendant of an Old Terra pest. This one pulses with an intense, visible radioactive glow. You shouldn't be standing this close."
	tt_desc = "Periplaneta ardor"
	icon_state = "strahlend"
	item_state = "strahlend"
	icon_living = "strahlend"
	icon_dead = "strahlend_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/strahlend)

	maxHealth = 20
	health = 20

	taser_kill = 0

	armor = list(
				"melee" = 20,
				"laser" = 20,
				"energy" = 20
				)

	base_attack_cooldown = 4
	projectiletype = /obj/item/projectile/energy/dart

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

//The Color out of Bluespace
/datum/category_item/catalogue/fauna/roach/zeitraum
	name = "Bluespace Roach"
	desc = "The belief that these roaches actually inhabit Bluespace has long been disproven.\
	However, the apellation has stuck to these creatures due to their trademark predation mechanism.\
	Early settlers who encountered these roaches believed that the only possible way they could be\
	appearing was for them to be utilizing a form of Bluespace transit. In reality, these roaches\
	possess a natural stealthing mechanism, similar to other mutant species. No roaches are known to\
	genuinely infest Bluespace at this time."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/zeitraum
	name = "bluespace roach"
	real_name = "bluespace roach"
	desc = "A descendant of an Old Terra pest. Where did this one even come from?! Watch out!"
	tt_desc = "Periplaneta intervallum"
	icon_state = "zeitraum"
	item_state = "zeitraum"
	icon_living = "zeitraun"
	icon_dead = "zeitraum_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/zeitraum)

	maxHealth = 20
	health = 20

	taser_kill = 0

	melee_damage_lower = 5
	melee_damage_upper = 10

	movement_cooldown = 3

	armor = list(
				"melee" = 20,
				"laser" = 20,
				"energy" = 20
				)

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

	var/stealthed = FALSE
	var/stealthed_alpha = 60			// Lower = Harder to see.
	var/stealthed_bonus_damage = 5	// This is added on top of the normal melee damage.
	var/stealthed_weaken_amount = 1	// How long to stun for.
	var/stealth_cooldown = 10 SECONDS	// Amount of time needed to re-stealth after losing it.
	var/last_unstealth = 0			// world.time


/mob/living/simple_mob/animal/roach/zeitraum/proc/stealth()
	if(stealthed)
		return
	animate(src, alpha = stealthed_alpha, time = 1 SECOND)
	stealthed = TRUE


/mob/living/simple_mob/animal/roach/zeitraum/proc/unstealth()
	last_unstealth = world.time // This is assigned even if it isn't stealthed already, to 'reset' the timer if the spider is continously getting attacked.
	if(!stealthed)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	stealthed = FALSE


// Check if stealthing if possible.
/mob/living/simple_mob/animal/roach/zeitraum/proc/can_stealth()
	if(stat)
		return FALSE
	if(last_unstealth + stealth_cooldown > world.time)
		return FALSE

	return TRUE


// Called by things that break stealths, like Technomancer wards.
/mob/living/simple_mob/animal/roach/zeitraum/break_cloak()
	unstealth()


/mob/living/simple_mob/animal/roach/zeitraum/is_cloaked()
	return stealthed


// Cloaks the spider automatically, if possible.
/mob/living/simple_mob/animal/roach/zeitraum/handle_special()
	if(!stealthed && can_stealth())
		stealth()


// Applies bonus base damage if stealthed.
/mob/living/simple_mob/animal/roach/zeitraum/apply_bonus_melee_damage(atom/A, damage_amount)
	if(stealthed)
		return damage_amount + stealthed_bonus_damage
	return ..()

// Applies stun, then unstealths.
/mob/living/simple_mob/animal/roach/zeitraum/apply_melee_effects(atom/A)
	if(stealthed)
		if(isliving(A))
			var/mob/living/L = A
			L.Weaken(stealthed_weaken_amount)
			to_chat(L, SPAN_DANGER("\The [src] ambushes you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	unstealth()
	..() // For the poison.

// Force unstealthing if attacked.
/mob/living/simple_mob/animal/roach/zeitraum/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/animal/roach/zeitraum/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()

//King? Look around you! King of what?
/datum/category_item/catalogue/fauna/roach/fuhrer
	name = "King Roach"
	desc = "Known as the 'King Roach' by researchers, the Periplaneta rex displays no social behavior.\
	Its nickname comes from its intimidating presence. Naturally resilient, the King Roach is slow, meaty,\
	and its powerful mandibles can deliver a painful bite."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/animal/roach/fuhrer
	name = "king roach"
	real_name = "king roach"
	desc = "A descendant of an Old Terra pest. This one moves slowly, but with purpose. The other roaches seem to revere it."
	tt_desc = "Periplaneta rex"
	icon_state = "fuhrer"
	item_state = "fuhrer"
	icon_living = "fuhrer"
	icon_dead = "fuhrer_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/roach/fuhrer)

	maxHealth = 60
	health = 60

	taser_kill = 0

	melee_damage_lower = 10
	melee_damage_upper = 20

	movement_cooldown = 6

	armor = list(
				"melee" = 25,
				"bullet" = 15,
				"laser" = 25,
				"energy" = 25,
				"bomb" = 25,
				"bio" = 15
				)
