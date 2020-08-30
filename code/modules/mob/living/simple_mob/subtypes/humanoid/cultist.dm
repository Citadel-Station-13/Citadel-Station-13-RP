////////////////////////////
//		Basic Cultist
////////////////////////////

/mob/living/simple_mob/humanoid/cultist //Do not spawn this on in directly it is simply a base for the rest namely the unique death animations.
	name = "Cultist"
	desc = "An awfully frail and ghastly looking individual"
	tt_desc = "NULL"
	icon = 'icons/mob/cult.dmi'
	icon_state = "initiate"

/mob/living/simple_mob/humanoid/cultist/human
	name = "cultist"
	desc = "A fanatical zealot armed with a darkly colored sword."
	icon_state = "cultist"
	icon_living = "cultist"
	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Cult Sword Damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 100, rad = 100)	// Same armor are cult armor, may nerf since DAMN THAT IS GOOD ARMOR
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 3

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/human/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"let's out a maddening laugh as his body crumbles away.")
	ghostize()
	qdel(src)

/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt //Teleporting Cultists

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	var/jaunt_warning = 0.5 SECONDS	// How long the jaunt telegraphing is.
	var/jaunt_tile_speed = 20		// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.

// In Theory this Jury Rigged Code form Tunneler Spiders Should Allow Wraiths to Jaunt
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	flick("bloodout",A)
	icon_state = "bloodout"
	sleep(jaunt_warning) // For the telegraphing.

	// Do the dig!
	visible_message(span("danger","\The [src] sinks into a puddle of blood \the [A]!"))
	new /obj/effect/decal/cleanable/blood (src.loc)
	flick("blood_out",A)
	icon_state = "bloodout"

	if(handle_jaunt(destination) == FALSE)
		set_AI_busy(FALSE)
		flick("bloodin",A)
		icon_state = "bloodin"
		return FALSE

	// Did we make it?
	if(!(src in destination))
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for(var/mob/living/L in destination)
		if(L == src)
			continue

		visible_message(span("danger","\The [src] suddenly rises from a pool of blood \the [L]!"))
		new /obj/effect/decal/cleanable/blood (src.loc)
		playsound(L, 'sound/weapons/heavysmash.ogg', 75, 1)
		L.Weaken(3)
		overshoot = FALSE

	if(!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, span("warning", "You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for(var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	if(handle_jaunt(destination) == FALSE)
		set_AI_busy(FALSE)
		icon_state = "bloodin"
		flick("bloodin",A)
		return FALSE

	set_AI_busy(FALSE)
	icon_state = "bloodin"
	flick("bloodin",A)
	return FALSE

// Does the jaunt movement
/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/proc/handle_jaunt(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for(var/i = 1 to get_dist(src, destination))
		if(stat)
			return FALSE // We died or got knocked out on the way.
		if(loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		if(T.check_density(ignore_mobs = TRUE))
			to_chat(src, span("critical", "You hit something really solid!"))
			playsound(src, "punch", 75, 1)
			Weaken(5)
			add_modifier(/datum/modifier/tunneler_vulnerable, 10 SECONDS)
			return FALSE // Hit a wall.

		// Get into the tile.
		forceMove(T)


/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/should_special_attack(atom/A)
	// Make sure its possible for the wraith to reach the target so it doesn't try to go through a window.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)
	var/turf/T = starting_turf
	for(var/i = 1 to get_dist(starting_turf, destination))
		if(T == destination)
			break

		T = get_step(T, get_dir(T, destination))
		if(T.check_density(ignore_mobs = TRUE))
			return FALSE
	return T == destination

////////////////////////////
//		Teshari Cultist
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/tesh
	name = "cultist"
	desc = "A sinister looking hooded Teshari armed with a curved knife."
	icon_state = "culttesh"
	icon_living = "culttesh"
	maxHealth = 75
	health = 75

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_armor_pen = 25
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 45, bullet = 40, laser = 30, energy = 80, bomb = 20, bio = 100, rad = 100)	// Reduced Resistance to Approximate increased Tesh damage.
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 2

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/tesh/death()
	new /obj/effect/decal/cleanable/ash (src.loc)
	..(null,"let's out a shrill chirp as his body turns to dust.")
	ghostize()
	qdel(src)

////////////////////////////
//		Lizard Cultist
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/lizard
	name = "cultist"
	desc = "With a knife in each hand, this lizard looks ready to disect you."
	icon_state = "cultliz"
	icon_living = "cultliz"
	maxHealth = 200
	health = 200

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 70, bullet = 60, laser = 30, energy = 80, bomb = 35, bio = 100, rad = 100)	// Better Armor to match lizard brute resist
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4
	base_attack_cooldown = 7.5 //Two knives mean double stab.

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/lizard/death()
	new /obj/effect/decal/remains/unathi (src.loc)
	..(null,"hisses as he collapses into a pile of bones.")
	ghostize()
	qdel(src)

////////////////////////////
//		Blood Mage
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/caster
	name = "Blood Mage"
	desc = "A Robed individual whose hands pulsate with unnatural power."
	icon_state = "caster"
	icon_living = "caster"
	maxHealth = 150
	health = 150

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged

/mob/living/simple_mob/humanoid/cultist/caster/death()
	new /obj/effect/decal/remains/human (src.loc)
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	..(null,"melts into a pile of blood and bones.")
	ghostize()
	qdel(src)

////////////////////////////
//		Blood Initiate
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/initiate
	name = "Blood Intiate"
	desc = "A Novice Amongst his betters, he still seems determined to slice you to bits."
	icon_state = "initiate"
	icon_living = "initiate"
	maxHealth = 150
	health = 150

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/initiate/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"lets out a horrified scream as his body crumbles away.")
	ghostize()
	qdel(src)

////////////////////////////
//		Teshari Mage
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/castertesh
	name = "Teshari Mage"
	desc = "This Teshari seems to have forsoken weapons for unfanthomable power."
	icon_state = "castertesh"
	icon_living = "castertesh"
	maxHealth = 75
	health = 75

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15	//Ritual Knife
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 35, bullet = 20, laser = 35, energy = 60, bomb = 20, bio = 100, rad = 100)	//Rebalanced for Robes and Tesh damage
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 2
	base_attack_cooldown = 7.5
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/humanoid/cultist/castertesh/death()
	new /obj/effect/decal/cleanable/ash (src.loc)
	..(null,"burns away into nothing.")
	ghostize()
	qdel(src)

////////////////////////////
//		Elite Cultist
////////////////////////////

/mob/living/simple_mob/humanoid/cultist/elite
	name = "Elite Cultist"
	desc = "A heavily armed cultist with a mirror shield that hurts to look at."
	icon_state = "cult_elite"
	icon_living = "cult_elite"
	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Cult Sword Damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 80, bomb = 30, bio = 100, rad = 100)	// Same armor are cult armor, may nerf since DAMN THAT IS GOOD ARMOR
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 3

	ai_holder_type = /datum/ai_holder/simple_mob/melee

/mob/living/simple_mob/humanoid/cultist/elite/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(30))
			visible_message("<span class='danger'>\The [src] blocks \the [O] with its shield!</span>")
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/humanoid/cultist/elite/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(50))
		visible_message("<font color='red'><B>[Proj] disappears into the mirror world as it hits the shield.</B></font>")
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()

/mob/living/simple_mob/humanoid/cultist/elite/death()
	new /obj/effect/decal/remains/human (src.loc)
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	new /obj/item/material/shard (src.loc)
	..(null,"shatters into bone and blood like pieces like the now shattered mirror.")
	playsound(src, 'sound/effects/Glassbr2.ogg', 100, 1)
	ghostize()
	qdel(src)

////////////////////////////
//		Cult Magus
////////////////////////////
/mob/living/simple_mob/humanoid/cultist/magus
	name = "Blood Magus"
	desc = "A leader of the bloody cult and master of the forbidden arts, wielding powers beyond that of mortal men."
	icon_state = "magus"
	icon_living = "magus"
	maxHealth = 300 //Boss Mobs should be tanky.
	health = 300

	faction = "cult"

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 30	//Ritual Knife
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 50, energy = 80, bomb = 30, bio = 100, rad = 100)	//Super Armor since Boss Mob
	attack_sound = 'sound/weapons/bladeslice.ogg'
	movement_cooldown = 4

	projectiletype = /obj/item/projectile/beam/inversion
	base_attack_cooldown = 5
	projectilesound = 'sound/weapons/spiderlunge.ogg'
	var/obj/item/shield_projector/cult = null

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

/mob/living/simple_mob/humanoid/cultist/magus/death()
	new /obj/effect/decal/cleanable/blood/gibs (src.loc)
	..(null,"let's out a dark laugh as it collapses into a puddle of blood.")
	ghostize()
	qdel(src)