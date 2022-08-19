 //Fodder

/datum/category_item/catalogue/fauna/cyberhorror
	name = "Cyber Horror"
	desc = "First witnessed on Surt, the entities hence dubbed 'Cyber Horrors' have \
	begun to appear at various sites across the Frontier. Based on recordings and logs \
	found at the mining colony on Surt, these creatures were created via the introduction \
	of an unidentified Nanite pathogen into organic hosts. The infestation of the host was \
	treated by the workers on Surt as a form of religious ritual intended to bring the \
	victim closer to the creators of the pathogen. After those who resisted the plague on \
	Surt fell, the perpetrators of the incident are believed to have escaped to spread \
	the affliction to other hosts."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/cyberhorror)

/mob/living/simple_mob/mechanical/cyber_horror
	name = "Cyber horror"
	desc = "What was once a man, twisted and warped by machine."
	icon = 'icons/mob/cyber_horror.dmi'
	icon_state = "cyber_horror"
	icon_dead = "cyber_horror_dead"
	icon_gib = "cyber_horror_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/cyberhorror)

	faction = "synthtide"

	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive

	maxHealth = 175
	health = 175

	melee_damage_lower = 5
	melee_damage_upper = 10

	movement_cooldown = 3
	movement_sound = 'sound/effects/houndstep.ogg'
	// To promote a more diverse weapon selection.
	armor = list(melee = 25, bullet = 25, laser = -20, bio = 100, rad = 100)
	hovering = FALSE

	say_list_type = /datum/say_list/cyber_horror

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	attacktext = list ("wildly strikes", "swings", "batters")
	attack_sound = 'sound/weapons/punch3.ogg'

	var/emp_damage = 0
	var/nanobot_chance = 40

/datum/say_list/cyber_horror
	speak = list("H@!#$$P M@!$#",
				 "GHAA!@@#",
				 "KR@!!N",
				 "K!@@##L!@@ %!@#E",
				 "G@#!$ H@!#%",
				 "H!@%%@ @!E")
	emote_hear = list("sparks!", "groans.", "wails.", "sobs.")
	emote_see = list ("stares unblinkingly.", "jitters and twitches.", "emits a synthetic scream.", "rapidly twitches.", "convulses.", "twitches uncontrollably.", "goes stock still.")
	say_threaten = list ("FR@#DOM","EN@ T#I$-$","N0$ M^> B@!#")
	say_got_target = list("I *#@ Y@%","!E@#$P","F#RR @I","D0@#$ ##OK %","IT $##TS")

 // Fragile but dangerous
/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror
	name = "Nanite husk"
	desc = "What was once a phoronoid, now a empty shell of malfunctioning nanites."
	icon_state = "plasma_cyber_horror"
	icon_dead = "plasma_cyber_horror_dead"

	armor = list(melee = 40, bullet = -10, laser = 40, bio = 100, rad = 100)
	maxHealth = 75
	health = 75

	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "splatters on"
	attack_sound = 'sound/effects/slime_squish.ogg'

 // Do y'like brain damage?
	var/poison_chance = 100
	var/poison_per_bite = 3
	var/poison_type = "neurophage_nanites"

	bone_amount = 8
	bone_type = /obj/item/stack/material/bone

/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

 // Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel nanites digging into your skin!</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)
 // Mech Shredder
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror
	name = "Nanite abomination"
	desc = "What was once something, now an exposed shell with lashing cables."
	icon_state = "ling_cyber_horror"
	icon_dead = "ling_cyber_horror_dead"

	maxHealth = 250
	health = 250
 // Four attacks per second.
	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_armor_pen = 50
	base_attack_cooldown = 2.5
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list ("sliced", "diced", "lashed", "shredded")
 // Slow as all sin
	movement_cooldown = 9
	movement_sound = 'sound/effects/houndstep.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/melee

 // You do NOT Want to get in touchy range of this thing.
	armor = list(melee = 75, bullet = -10, laser = -25, bio = 100, rad = 100)
	hovering = FALSE


 // Leaping is a special attack, so these values determine when leap can happen.
 // Leaping won't occur if its on cooldown, set to a minute due to it purely break formations.
	special_attack_min_range = 2
	special_attack_max_range = 7
	special_attack_cooldown = 60 SECONDS
 // How long the leap telegraphing is.
	var/leap_warmup = 2 SECOND
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

	exotic_amount = 10
	exotic_type = /obj/item/stack/sinew

 // Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 2.5
	return ..()


 // The actual leaping attack.
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

 // Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
 // For the telegraphing.
	sleep(leap_warmup)

 // Do the actual leap.
 // Lets us pass over everything.
	status_flags |= LEAPING
	visible_message(SPAN_DANGER("\The [src] leaps at \the [A]!"))
	throw_at_old(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)
 // For the throw to complete. It won't hold up the AI SSticker due to waitfor being false.
	sleep(5)

 // Revert special passage ability.
	if(status_flags & LEAPING)
		status_flags &= ~LEAPING
 // Where we landed. This might be different than A's turf.
	var/turf/T = get_turf(src)

	. = FALSE

 // Now for the stun.
	var/mob/living/victim = null
 // So player-controlled cyber horrors only need to click the tile to stun them.
	for(var/mob/living/L in T)
		if(L == src)
			continue

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.check_shields(damage = 0, damage_source = src, attacker = src, def_zone = null, attack_text = "the leap"))
 // We were blocked.
				continue

		victim = L
		break

	if(victim)
		victim.Weaken(2)
		victim.visible_message(SPAN_DANGER("\The [src] knocks down \the [victim]!"))
		to_chat(victim, SPAN_CRITICAL("\The [src] jumps on you!"))
		. = TRUE

	set_AI_busy(FALSE)
 //Slightly more durable fodder
/mob/living/simple_mob/mechanical/cyber_horror/vox
	name = "Vox shambles"
	desc = "Once a Vox now torn and changed, peices of a Durand have been grafted onto it."
	icon_state = "vox_cyber_horror"
	icon_dead = "vox_cyber_horror_dead"

	armor = list(melee = 40, bullet = 30, laser = 30, bio = 100, rad = 100)
	ai_holder_type = /datum/ai_holder/simple_mob/melee

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat/vox
	bone_amount = 2
	bone_type = /obj/item/stack/material/bone

 // Hit and run mob
/mob/living/simple_mob/mechanical/cyber_horror/tajaran
	name = "Tajaran cyber stalker"
	desc = "A mangled mess of machine and fur, light seems to bounce off it."
	icon_state = "tajaran_cyber_horror"
	icon_dead = "tajaran_cyber_horror_dead"


	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run

	var/stealthed = FALSE
 // Lower = Harder to see.
	var/stealthed_alpha = 30
 // This is added on top of the normal melee damage.
	var/stealthed_bonus_damage = 30
 // How long to stun for.
	var/stealthed_weaken_amount = 3
 // Amount of time needed to re-stealth after losing it.
	var/stealth_cooldown = 10 SECONDS
 // world.time
	var/last_unstealth = 0

	bone_amount = 2
	bone_type = /obj/item/stack/material/bone
	hide_amount = 5
	hide_type = /obj/item/stack/animalhide/grey


/mob/living/simple_mob/mechanical/cyber_horror/tajaran/proc/stealth()
	if(stealthed)
		return
	animate(src, alpha = stealthed_alpha, time = 1 SECOND)
	stealthed = TRUE

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/proc/unstealth()
 // This is assigned even if it isn't stealthed already, to 'reset' the timer if the spider is continously getting attacked.
	last_unstealth = world.time
	if(!stealthed)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	stealthed = FALSE


// Check if stealthing if possible.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/proc/can_stealth()
	if(stat)
		return FALSE
	if(last_unstealth + stealth_cooldown > world.time)
		return FALSE

	return TRUE


// Called by things that break stealths, like Technomancer wards.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/break_cloak()
	unstealth()


/mob/living/simple_mob/mechanical/cyber_horror/tajaran/is_cloaked()
	return stealthed


// Cloaks the tajaran automatically, if possible.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/handle_special()
	if(!stealthed && can_stealth())
		stealth()


// Applies bonus base damage if stealthed.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/apply_bonus_melee_damage(atom/A, damage_amount)
	if(stealthed)
		return damage_amount + stealthed_bonus_damage
	return ..()

// Applies stun, then unstealths.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/apply_melee_effects(atom/A)
	if(stealthed)
		if(isliving(A))
			var/mob/living/L = A
			L.Weaken(stealthed_weaken_amount)
			to_chat(L, SPAN_DANGER("\The [src] tears into you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	unstealth()
	..() // For the poison.

// Force unstealthing if attacked.
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/mechanical/cyber_horror/tajaran/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()

//Arcing Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/grey
	name = "Twisted cyber horror"
	desc = "A mess of machine and organic, it's hard to even know what it was before."
	icon_state = "grey_cyber_horror"
	icon_dead = "grey_cyber_horror_dead"
	maxHealth = 100
	health = 100

	projectiletype = /obj/item/projectile/arc/blue_energy
	projectilesound = 'sound/weapons/Laser.ogg'
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

	armor = list(melee = -30, bullet = 10, laser = 10, bio = 100, rad = 100)

/obj/item/projectile/arc/blue_energy
	name = "energy missle"
	icon_state = "force_missile"
	damage = 12
	damage_type = BURN

//Direct Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/corgi
	name = "Malformed Corgi"
	desc = "Pieces of metal and technology are embedded in this corgi."
	icon_state = "corgi_cyber_horror"
	icon_dead = "corgi_cyber_horror_dead"
	maxHealth = 50
	health = 50

	base_attack_cooldown = 4
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	movement_sound = 'sound/effects/servostep.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening

//Cats and mayhem
/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror
	name = "Twisted cat"
	desc = "While most things are acceptable, putting cat legs on this - only made it worse."

	icon_state = "cat_cyber_horror"
	icon_dead = "cat_cyber_horror_dead"

	maxHealth = 40
	health = 40
	movement_cooldown = 0
	movement_sound = 'sound/effects/servostep.ogg'

	pass_flags = ATOM_PASS_TABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	melee_damage_lower = 2
	melee_damage_upper = 2
 // Four attacks per second.
	base_attack_cooldown = 2.5
	attack_sharp = 1
	attack_edge = 1

	attacktext = list("jabbed", "injected")

 // Do y'like drugs?
	var/poison_chance = 75
	var/poison_per_bite = 3
	var/poison_type = "mindbreaker"

/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

 // Does actual poison injection, after all checks passed.
/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel an uncomfortable prick!</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

//These are the projectiles mobs use
/obj/item/projectile/beam/drone
	damage = 3
/obj/item/projectile/arc/blue_energy
	name = "energy missle"
	icon_state = "force_missile"
	damage = 12
	damage_type = BURN

//Boss Mob - The High Priest
/mob/living/simple_mob/mechanical/cyber_horror/priest
	name = "hulking cyber horror"
	desc = "A gnarled, still living convert forcibly integrated into a heavy walker platform composed of living metal."
	icon = 'icons/mob/64x64.dmi'
	icon_state = "the_changed"
	icon_dead = "the_changed_dead"
	maxHealth = 450
	health = 450
	armor = list(melee = 30, bullet = 20, laser = 20, bio = 100, rad = 100)
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_armor_pen = 20
	mob_class = MOB_CLASS_ABERRATION
	mob_size = MOB_HUGE
	taser_kill = FALSE
	movement_cooldown = 8
	special_attack_cooldown = 45 SECONDS
	special_attack_min_range = 2
	special_attack_max_range = 8
	var/poison_chance = 75
	var/poison_per_bite = 3
	var/poison_type = "neurophage_nanites"

	base_attack_cooldown = 30
	projectiletype = /obj/item/projectile/arc/blue_energy/priest
	projectilesound = 'sound/weapons/Laser.ogg'
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/aggressive/priest

/obj/item/projectile/arc/blue_energy/priest
	name = "nanite cloud"
	icon_state = "particle-heavy"
	damage = 15
	damage_type = BRUTE

/obj/item/projectile/arc/blue_energy/priest/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.Confuse(rand(3,5))

/datum/ai_holder/simple_mob/ranged/aggressive/priest //Adopted from the Blood Hunter.
	pointblank = FALSE
	closest_distance = 0

/mob/living/simple_mob/mechanical/cyber_horror/priest/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

/mob/living/simple_mob/mechanical/cyber_horror/priest/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, "<span class='warning'>You feel nanites digging into your skin!</span>")
		L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_mob/mechanical/cyber_horror/priest/should_special_attack(atom/A)
	var/mob_count = 0				// Are there enough mobs?
	var/turf/T = get_turf(A)
	for(var/mob/M in range(T, 2))
		if(M.faction == faction) 	// Don't grenade our friends
			return FALSE
		if(M in oview(src, special_attack_max_range))
			if(!M.stat)
				mob_count ++
	if(mob_count < 2)
		return FALSE
	else
		return TRUE

/mob/living/simple_mob/mechanical/cyber_horror/priest/do_special_attack(atom/target)
	set waitfor = FALSE

	// Warm-up
	Beam(target, icon_state = "sat_beam", time = 2 SECONDS, maxdistance = INFINITY)
	visible_message(SPAN_WARNING( "A glowing port opens up in the [src]'s carapace!"))
	playsound(src, 'sound/effects/turret/move1.wav', 50, 1)
	sleep(2 SECONDS)

	for(var/i = 1 to 1)
		if(target) // Might get deleted in the meantime.
			var/turf/T = get_turf(target)
			if(T)
				visible_message(SPAN_WARNING( "[src] discharges a beam of concentrated energy!"))
				playsound(src, 'sound/weapons/lasercannonfire.ogg', 70, 1)
				face_atom(T)
				var/obj/item/projectile/arc/radioactive/priest/ball = new(loc)
				ball.old_style_target(T, src)
				ball.fire()
				sleep(2 SECONDS)

	visible_message(SPAN_WARNING( "[src] closes its reactor port."))
	playsound(src, 'sound/effects/turret/move2.wav', 50, 1)

/obj/item/projectile/arc/radioactive/priest
	name  = "superheated plama discharge"
	icon_state = "plasma3"
	rad_power = 10

/obj/item/projectile/arc/radioactive/priest/on_impact(turf/T)
	new /obj/effect/explosion(T)
	SSradiation.radiate(T, rad_power)
	explosion(T, 0, 1, 4, adminlog = FALSE)

////////////////////////
//Lavaland Cyber_Horrors
////////////////////////

/mob/living/simple_mob/mechanical/cyber_horror/surt
	name = "ash coated remnant"
	desc = "What was once a man, now twisted and warped by machine. A heavy layer of volcanic ash clings to what little organic portions remain."

	heat_resist = 1

/datum/say_list/cyber_horror/surt
	speak = list("H@!#$$P M@!$#",
				 "GHAA!@@#",
				 "KR@!!N",
				 "K!@@##L!@@ %!@#E",
				 "G@#!$ H@!#%",
				 "H!@%%@ @!E")
	emote_hear = list("sparks!", "groans.", "wails.", "sobs.")
	emote_see = list ("stares unblinkingly.", "jitters and twitches.", "emits a synthetic scream.", "rapidly twitches.", "convulses.", "twitches uncontrollably.", "goes stock still.")
	say_threaten = list ("FR@#DOM","EN@ T#I$-$","N0$ M^> B@!#", "P#RF$*!T$ON")
	say_got_target = list("I *#@ Y@%","!E@#$P","F#RR @I","D0@#$ ##OK %","IT $##TS")

// Fragile but dangerous
/mob/living/simple_mob/mechanical/cyber_horror/plasma_cyber_horror/surt
	name = "obsidian-studded husk"
	desc = "What was once a phoronoid, now a empty shell of malfunctioning nanites. Chunks of volcanic glass have been painfully grafted into the tissue."

	heat_resist = 1

// Mech Shredder
/mob/living/simple_mob/mechanical/cyber_horror/ling_cyber_horror/surt
	name = "grainy nanite abomination"
	desc = "What was once something, now an exposed shell with lashing cables. Its form is mealy and inconsistent - it appears to have involuntarily incorporated the ash into its biology."

	heat_resist = 1

//Slightly more durable fodder
/mob/living/simple_mob/mechanical/cyber_horror/vox/surt
	name = "ragged shambler"
	desc = "Once a Vox now torn and changed, peices of a Durand have been grafted onto it. This body seems fresher than the others - perhaps a recent convert."

	heat_resist = 1

 // Hit and run mob
/mob/living/simple_mob/mechanical/cyber_horror/tajaran/surt
	name = "singed ash-stalker"
	desc = "A mangled mess of machine and fur, light seems to bounce off it. Although it cannot be seen easily, at close ranges it smells strongly of burnt hair."

	heat_resist = 1


//Arcing Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/grey/surt
	name = "exhumed deacon"
	desc = "A mess of machine and organic, it's hard to even know what it was before. Strips of charred paper and hand-crafted religious icons have been draped over its body."

	heat_resist = 1

//Direct Ranged Mob
/mob/living/simple_mob/mechanical/cyber_horror/corgi/surt
	name = "matted tracker drone"
	desc = "Pieces of metal and technology embedded in this corgi have turned it into a blank drone. Its fur is burned and matted down with soot and ash."

	heat_resist = 1

//Cats and mayhem
/mob/living/simple_mob/mechanical/cyber_horror/cat_cyber_horror/surt
	name = "smoldering hunter drone"
	desc = "This creature, formerly a cat, has had arachnid legs crudely grafted to its body. It moves with frightening acuity."

	heat_resist = 1

/mob/living/simple_mob/mechanical/cyber_horror/priest/surt
	name = "warped cyber horror"
	desc = "A gnarled, still living convert forcibly integrated into a heavy walker platform composed of living metal. The metal has bubbled and warped unnaturally from the heat."

	heat_resist = 1

/mob/living/simple_mob/mechanical/cyber_horror/priest/thechanged
	name = "The Changed One"
	desc = "The casing and writhing flesh of this body have been adorned in ritual wax and religious icons. Burned prayer sheets daubed in its own dripping blood flap in the stifling air. The cruciform body integrated into the machine wriggles feebly, its jaw tightly wagging up and down - it has no mouth."
	maxHealth = 1500
	health = 1500
	armor = list(melee = 50, bullet = 35, laser = 35, bio = 100, rad = 100)
	movement_cooldown = 4
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_armor_pen = 25
	base_attack_cooldown = 7

	heat_resist = 1
