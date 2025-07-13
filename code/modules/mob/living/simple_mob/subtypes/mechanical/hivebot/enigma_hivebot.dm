// This is the dedicated file for Enigma Hivebots.
// Enigma hivebots are usually significantly tougher than baseline Hivebots, and are modified with salvaged abductor parts.
// These Hivebots are often meant for Event purposes, and carry a different faction than baseline Hivebots. Use these carefully!

/mob/living/simple_mob/mechanical/hivebot/enigma
	iff_factions = MOB_IFF_FACTION_HIVEBOT

// Code Stuff
/mob/living/simple_mob/mechanical/hivebot/enigma/death()
	..()
	visible_message(SPAN_WARNING("\The [src] demateralizes in a flash of energy!"))
	new /obj/effect/debris/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/simple_mob/mechanical/hivebot/enigma/director/handle_special()
	for(var/mob/living/L in range(16, src))
		if(L == src)
			continue // Don't buff ourselves.
		if(IIsAlly(L) && L.isSynthetic()) // Don't buff enemies.
			L.add_modifier(/datum/modifier/aura/hivebot_commander_buff/enigma, null, src)

/datum/modifier/aura/hivebot_commander_buff/enigma
	name = "Strategicals"
	on_created_text = "<span class='notice'>Signal established with commander. Optimizating combat performance...</span>"
	on_expired_text = "<span class='warning'>Lost signal to commander. Optimization halting.</span>"
	stacks = MODIFIER_STACK_FORBID
	aura_max_distance = 12
	mob_overlay_state = "signal_blue"

	disable_duration_percent = 0.7
	outgoing_melee_damage_percent = 1.3
	attack_speed_percent = 1.3
	accuracy = 30
	slowdown = -1
	evasion = 30

/mob/living/simple_mob/mechanical/hivebot/enigma/archaeologist/handle_special()
	if(last_resupply + resupply_cooldown > world.time)
		return // On cooldown.

	for(var/mob/living/simple_mob/SM in hearers(resupply_range, src))
		if(SM == src)
			continue // We don't use charges buuuuut in case that changes in the future...
		if(IIsAlly(SM)) // Don't resupply enemies.
			if(!isnull(SM.special_attack_charges) && SM.special_attack_charges < initial(SM.special_attack_charges))
				SM.special_attack_charges += 1
				to_chat(SM, SPAN_NOTICE("\The [src] has resupplied you, and you can use your special ability one additional time."))
				to_chat(src, SPAN_NOTICE("You have resupplied \the [SM]."))
				last_resupply = world.time
				break // Only one resupply per pulse.

/mob/living/simple_mob/mechanical/hivebot/enigma/custodian/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(SPAN_DANGER("\The [src] sends \the [L] flying with their hydraulic fists!"))
			playsound(src, 'sound/enigma/enigma_hit2.ogg', 50, 1)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at_old(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, SPAN_WARNING( "\The [src] punches you with incredible force, but you remain in place."))

// Melee

/mob/living/simple_mob/mechanical/hivebot/enigma/custodian
	name = "custodian"
	icon = 'icons/mob/enigma.dmi'
	desc = "A strangely shaped humanoid synthetic, standing taller than the average Human. Its armor seems reinforced against common energy and laser weapons, however likely less so against ballistics. Power seems to course through its arms, probably best to not let it hit you... A odd elaborate golden 'E' is etched into the side of its chassis."
	icon_state = "custodian"
	icon_living = "custodian"
	maxHealth = 500
	health = 500
	armor_legacy_mob = list(
			"melee"		= 20,
			"bullet"	= 0,
			"laser"		= 50,
			"energy"	= 50,
			"bomb"		= 100,
			"bio"		= 100,
			"rad"		= 100
			)
	legacy_melee_damage_lower = 40
	legacy_melee_damage_upper = 40
	movement_base_speed = 10 / 4
	icon_scale_x = 1.4
	icon_scale_y = 1.4
	attack_sound = 'sound/enigma/enigma_hit2.ogg'
	movement_sound = 'sound/enigma/enigma_move2.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/hivebot

/mob/living/simple_mob/mechanical/hivebot/enigma/custodian/Initialize(mapload)
	var/shield_type = /obj/item/shield_projector/rectangle{
		shield_health = 150;
		max_shield_health = 150;
		shield_regen_delay = 10 SECONDS;
		shield_regen_amount = 10;
		size_x = 1;
		size_y = 1;
		always_on = TRUE;
	}
	var/obj/item/shield_projector/shield_projector = new shield_type(src)
	shield_projector.create_shields()
	return ..()

/mob/living/simple_mob/mechanical/hivebot/enigma/disassembler
	name = "disassembler"
	icon = 'icons/mob/enigma.dmi'
	desc = "A small drone, decorated in hues of pink and purple material. Two sets of claws comprise its front legs and back legs, and thhere seems to be some sort of golden 'E' symbol which marks the under-chassis. It appears to move quite fast and fit into small spaces."
	icon_state = "disassembler"
	icon_living = "disassembler"
	maxHealth = 200
	health = 200
	armor_legacy_mob = list(
				"melee"		= 10,
				"bullet"	= 0,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	base_attack_cooldown = 6
	movement_base_speed = 10 / 1
	attack_sound = 'sound/enigma/enigma_hit.ogg'
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/hivebot

// Support

/mob/living/simple_mob/mechanical/hivebot/enigma/director
	name = "research director"
	icon = 'icons/mob/124x124_enigma.dmi'
	desc = "A towering machine which stands well above the average person. Its makeup is entirely alien, and its hull seems to shiver and move constantly. Contained within a dome shaped head appears to be some sort of impossibly advanced neural center. It looks to be directing the machines around it, as if it's some sort of Prophet."
	icon_state = "research_director"
	icon_living = "research_director"
	maxHealth = 600
	health = 600
	armor_legacy_mob = list(
				"melee"		= 30,
				"bullet"	= 20,
				"laser"		= 50,
				"energy"	= 50,
				"bomb"		= 70,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 25
	movement_base_speed = 10 / 5
	base_pixel_x = 1.5
	base_pixel_y = 1.5
	attack_sound =  'sound/weapons/slash.ogg'
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event

/mob/living/simple_mob/mechanical/hivebot/enigma/archaeologist
	name = "xeno archaeologist"
	icon = 'icons/mob/enigma.dmi'
	desc = "A humanoid synthetic, standing at around the height of the average Human. This one seems off however, and if one were to look closer it has a number of archaeological tools integrated seemlessly into its chassis. A hum of energy from its advanced sensor package follows it where-ever it goes, ready to scan and dig."
	icon_state = "archaeologist"
	icon_living = "archaeologist"
	maxHealth = 150
	health = 150
	armor_legacy_mob = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10
	movement_base_speed = 10 / 2
	attack_sound = 'sound/items/drill_hit.ogg'
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/event
	var/resupply_range = 5
	var/resupply_cooldown = 4 SECONDS
	var/last_resupply = null

// Ranged

/mob/living/simple_mob/mechanical/hivebot/enigma/atomizer
	name = "atomizer"
	icon = 'icons/mob/enigma.dmi'
	desc = "A floating orb which utilizes some sort of advanced anti-gravity technology. It's decorated in gold plating, and seems to be coursing with barely contained energy. On the side of its chassis is a odd golden 'E' shape."
	icon_state = "atomizer"
	icon_living = "atomizer"
	maxHealth = 350
	health = 350
	armor_legacy_mob = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 40,
				"energy"	= 40,
				"bomb"		= 10,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 0
	legacy_melee_damage_upper = 0
	movement_base_speed = 10 / 6
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting
	projectiletype = /obj/projectile/beam/cyan/hivebot

/mob/living/simple_mob/mechanical/hivebot/enigma/atomizer/Initialize(mapload)
	var/shield_type = /obj/item/shield_projector/rectangle{
		shield_health = 150;
		max_shield_health = 150;
		shield_regen_delay = 10 SECONDS;
		shield_regen_amount = 10;
		size_x = 1;
		size_y = 1;
		always_on = TRUE;
	}
	var/obj/item/shield_projector/shield_projector = new shield_type(src)
	shield_projector.create_shields()
	return ..()


/mob/living/simple_mob/mechanical/hivebot/enigma/sweeper
	name = "sweeper"
	icon = 'icons/mob/enigma.dmi'
	desc = "A towering mechanical construct, radiating with power. Its gauntlet contains some sort of inbuild shield projector which it uses to advance without sustaining harm, while some sort of shoulder mounted armament can be seen on its back, pointing at anything it intends to obliterate. A odd golden 'E' symbol can be seen on its breast-plate."
	icon_state = "sweeper"
	icon_living = "sweeper"
	maxHealth = 400
	health = 400
	armor_legacy_mob = list(
				"melee"		= 20,
				"bullet"	= 30,
				"laser"		= 50,
				"energy"	= 50,
				"bomb"		= 40,
				"bio"		= 100,
				"rad"		= 100
				)
	legacy_melee_damage_lower = 20
	legacy_melee_damage_upper = 20
	movement_base_speed = 10 / 6
	attack_sound = 'sound/enigma/enigma_hit2.ogg'
	movement_sound = 'sound/enigma/enigma_move2.ogg'
	icon_scale_x = 1.1
	icon_scale_y = 1.1
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting
	projectiletype = /obj/projectile/arc/fragmentation/mortar
	base_attack_cooldown = 30

/mob/living/simple_mob/mechanical/hivebot/enigma/sweeper/Initialize(mapload)
	var/shield_type = /obj/item/shield_projector/rectangle{
		shield_health = 250;
		max_shield_health = 250;
		shield_regen_delay = 5 SECONDS;
		shield_regen_amount = 10;
		size_x = 1;
		size_y = 1;
		always_on = TRUE;
	}
	var/obj/item/shield_projector/shield_projector = new shield_type(src)
	shield_projector.create_shields()
	return ..()



// Troopers

/mob/living/simple_mob/mechanical/hivebot/enigma/trooper/basic
	name = "trooper"
	icon = 'icons/mob/enigma.dmi'
	desc = "A small robotic unit with a humanoid form. It carries gold markings on its head and face plate, along with shouldering some sort of alien energy weapon."
	icon_living = "trooper"
	icon_state = "trooper"
	maxHealth = 200
	health = 200
	armor_legacy_mob = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 20,
				"energy"	= 20,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5
	movement_base_speed = 10 / 2
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged
	projectiletype = /obj/projectile/beam/weak

/mob/living/simple_mob/mechanical/hivebot/enigma/trooper/marksman
	name = "marksman trooper"
	icon = 'icons/mob/enigma.dmi'
	desc = "A slightly taller robotic unit with a humanoid form. It has dark green markings on its faceplate, and seems to carry some sort of advanced energy sniper."
	icon_state = "marksman"
	icon_living = "marksman"
	maxHealth = 190
	health = 190
	armor_legacy_mob = list(
				"melee"		= 0,
				"bullet"	= 0,
				"laser"		= 40,
				"energy"	= 40,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5
	base_attack_cooldown = 25
	movement_base_speed = 10 / 3
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/sniper
	projectiletype = /obj/projectile/beam/xray

/mob/living/simple_mob/mechanical/hivebot/enigma/trooper/magnetic
	name = "magnetic trooper"
	icon = 'icons/mob/enigma.dmi'
	desc = "Another mechanical construct, this one looks more advanced than the others. Equipped with a extensively modified Ion weapon sporting abductor technology, better steer any machinery clear of this. It sports blue markings."
	icon_state = "magnetic"
	icon_living = "magnetic"
	maxHealth = 230
	health = 230
	armor_legacy_mob = list(
				"melee"		= 0,
				"bullet"	= 20,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 0,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5
	movement_base_speed = 10 / 2
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting
	projectiletype = /obj/projectile/ion
	base_attack_cooldown = 25

//P4 units - Anything nanotechnology paired with abductor tech - Elite units

/mob/living/simple_mob/mechanical/hivebot/enigma/P4/Wraith
	name = "wraith"
	icon = 'icons/mob/enigma.dmi'
	desc = "A sleek, black bipedal combat unit with an unsettling, advanced nanotech design. Its chassis being an amalgamation of various prosthetic and synthetic components or at least mimicking such. The unit is constantly shifting and is surrounded by a thin trail of metallic dust as it moves. Spines emitting an antigrav field protrude from its arms, shoulders, and back, while its featureless faceplate displays an alien magenta glow under constant shifting and warping. The unit shudders and vibrates with uncanny precision. It wields a modified particle weapon vaguely resembling a Hephaestus G40. A capital Sigma symbol is etched on its chest, and a circular power pack on its back hums with gravity-defying particles."
	icon_living = "wraith"
	icon_state = "wraith"
	maxHealth = 250
	health = 250
	evasion = 15 //Superior reflexes due to nanotech and being build for combat
	armor_legacy_mob = list(
				"melee"		= 5,
				"bullet"	= 20,
				"laser"		= 30,
				"energy"	= 30,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 18
	legacy_melee_damage_upper = 18 //It hits you with a hardened nanite fist. Thats supposed to hurt
	movement_base_speed = 10 / 1 //again faster than standard grunts
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting //Made to draw fire hence kiting
	projectiletype = /obj/projectile/beam/antigravbeamwraith
	base_attack_cooldown = 10 //1 attacks per second

/mob/living/simple_mob/mechanical/hivebot/enigma/P4/Wraith/Initialize(mapload) //Gives the unit a weak overshield since it would be very unfun to fight kiting AI with actual proper health regen as initially intended
	var/shield_type = /obj/item/shield_projector/rectangle{
		shield_health = 100;
		max_shield_health = 100;
		shield_regen_delay = 5 SECONDS;
		shield_regen_amount = 30;
		size_x = 1;
		size_y = 1;
		always_on = TRUE;
	}
	var/obj/item/shield_projector/shield_projector = new shield_type(src)
	shield_projector.create_shields()
	return ..()

/mob/living/simple_mob/mechanical/hivebot/enigma/P4/Banshee
	name = "banshee"
	icon = 'icons/mob/enigma.dmi'
	desc = "A horrific inorganic nanite abomination. This unit possess a jet black nanite frame with typical abductor technology augmentation. Armed with two strange humming blades it is well capable of both lethal takedowns and less lethal takedowns. The head tendrilled monstrosity is lightning fast and to make matters worse has some sort of short range teleportation pack installed on its back allowing it to effectively 'blink' out if needed to disengage. Additionally the entire body is covered in thin, purple colored phase coils allowing it to effectively leap. A capital greek Sigma is etched onto its nanite chest. Embedded in its right armblade is some sort of injector loaded with strange bits of electronics. The entire thing screams in agony in an ultrasonic frequency only audible to synthetics as it constantly shifts in and out of phase."
	icon_living = "banshee"
	icon_state = "banshee"
	maxHealth = 200
	health = 200
	evasion = 50 //Phase coils and bluespace blink device. Hard to hit. Trash hitpoints and armor
	armor_legacy_mob = list(
				"melee"		= 5,
				"bullet"	= 10,
				"laser"		= 15,
				"energy"	= 15,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

	legacy_melee_damage_lower = 35 //armed with two arm mounted phase blades
	legacy_melee_damage_upper = 35 //I hate damage variance
	attack_armor_pen = 25
	base_attack_cooldown = 7 //1.3 attacks per second
	movement_base_speed = 6.66 //MUCH faster
	movement_sound = 'sound/enigma/enigma_move.ogg'
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/hivebot //hit and Run Melee is broken for when more than 1 player is visible

	player_msg = "You are very fast, and <b>can perform a leaping attack</b> by clicking on someone from a short distance away.<br>\
	If the leap succeeds, the target will be knocked down briefly and you will be on top of them.<br>\
	Note that there is a short delay before you leap!<br>\
	In addition, you will do more damage to incapacitated opponents."

	// Leaping is a special attack, so these values determine when leap can happen, also ripped from spiders
	// Leaping won't occur if its on cooldown.
	special_attack_min_range = 2
	special_attack_max_range = 8
	special_attack_cooldown = 15 SECONDS //Phase coils are not trivial to miniaturize

	var/leap_warmup = 1 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/Phasecoilengage.ogg'

// Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_mob/mechanical/hivebot/enigma/P4/Banshee/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 1.2 //lets not make it oneshot
	return ..()


// The actual leaping attack.
/mob/living/simple_mob/mechanical/hivebot/enigma/P4/Banshee/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // Telegraphing

	// Do the actual leap.
	status_flags |= STATUS_LEAPING // Lets us pass over everything.
	visible_message(SPAN_DANGER("\The [src] engages its phasecoils and initializes a phaseleap at \the [A]!"))
	throw_at_old(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI SSticker due to waitfor being false.

	if(status_flags & STATUS_LEAPING)
		status_flags &= ~STATUS_LEAPING // Revert special passage ability.

	var/turf/T = get_turf(src) // Where we landed. This might be different than A's turf.

	. = FALSE

	// Now for the stun.
	var/mob/living/victim = null
	for(var/mob/living/L in T) // So player-controlled BANSHEES only need to click the tile to stun them.
		if(L == src)
			continue

		var/list/shieldcall_result = L.atom_shieldcall(
			40,
			DAMAGE_TYPE_BRUTE,
			3,
			ARMOR_MELEE,
			NONE,
			ATTACK_TYPE_MELEE,
		) //NEEDS LIFE TESTING
		if(shieldcall_result[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAGS_BLOCK_ATTACK)
			continue

		victim = L
		break

	if(victim)
		victim.afflict_paralyze(20 * 2)
		victim.visible_message(SPAN_DANGER("\The [src] phases back in and knocks down \the [victim]!"))
		to_chat(victim, SPAN_CRITICAL("\The [src] disengages its phase coils right ontop you and knocks you to the ground!"))
		. = TRUE

	set_AI_busy(FALSE)

// Boss


// VERY POWERFUL! Uses ripped Advanced Dark Gygax code.
/mob/living/simple_mob/mechanical/hivebot/enigma/mimir
	name = "Mimir"
	desc = "A heavy exosuit, entirely made up of salvaged Abductor technology and materials. It's one of a kind, and extremely dangerous. Attempting to take it on is thought to be utter suicide due to its wide range of armaments."
	icon = 'icons/mob/enigma.dmi'
	movement_sound = 'sound/enigma/enigma_move2.ogg'
	attack_sound = 'sound/enigma/enigma_hit2.ogg'
	icon_state = "mimir"
	icon_living = "mimir"
	icon_scale_x = 1.3
	icon_scale_y = 1.3
	movement_base_speed = 10 / 3
	maxHealth = 1000
	health = 1000
	armor_legacy_mob = list(
				"melee"		= 50,
				"bullet"	= 50,
				"laser"		= 70,
				"energy"	= 70,
				"bomb"		= 50,
				"bio"		= 100,
				"rad"		= 100
				)

	special_attack_min_range = 1
	special_attack_max_range = 7
	special_attack_cooldown = 10 SECONDS
	projectiletype = /obj/projectile/beam/cyan/hivebot
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/intentional/adv_dark_gygax
	var/obj/effect/overlay/energy_ball/energy_ball = null

/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/Initialize(mapload)
	var/shield_type = /obj/item/shield_projector/rectangle{
		shield_health = 500;
		max_shield_health = 500;
		shield_regen_delay = 5 SECONDS;
		shield_regen_amount = 30;
		size_x = 1;
		size_y = 1;
		always_on = TRUE;
	}
	var/obj/item/shield_projector/shield_projector = new shield_type(src)
	shield_projector.create_shields()
	return ..()

/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/Destroy()
	if(energy_ball)
		energy_ball.stop_orbit()
		qdel(energy_ball)
	return ..()

/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/do_special_attack(atom/A)
	. = TRUE // So we don't fire a bolt as well.
	switch(a_intent)
		if(INTENT_DISARM) // Side gun
			electric_defense(A)
		if(INTENT_HARM) // Rockets
			launch_rockets(A)
		if(INTENT_GRAB) // Micro-singulo
			launch_microsingularity(A)

#define ELECTRIC_ZAP_POWER 20000

// Charges a tesla shot, while emitting a dangerous electric field. The exosuit is immune to electric damage while this is ongoing.
// It also briefly blinds anyone looking directly at the mech without flash protection.
/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/proc/electric_defense(atom/target)
	set waitfor = FALSE

	// Temporary immunity to shock to avoid killing themselves with their own attack.
	var/old_shock_resist = shock_resist
	shock_resist = 1

	// Make the energy ball. This is purely visual since the tesla ball is hyper-deadly.
	energy_ball = new(loc)
	energy_ball.adjust_scale(0.5)
	energy_ball.orbit(src, 32, TRUE, 1 SECOND)

	visible_message(SPAN_WARNING( "\The [src] creates \an [energy_ball] around itself!"))

	playsound(src.loc, 'sound/effects/lightning_chargeup.ogg', 100, 1, extrarange = 30)

	// Shock nearby things that aren't ourselves.
	for(var/i = 1 to 10)
		energy_ball.adjust_scale(0.5 + (i/10))
		energy_ball.set_light(i/2, i/2, "#0000FF")
		for(var/thing in range(3, src))
			// This is stupid because mechs are stupid and not mobs.
			if(isliving(thing))
				var/mob/living/L = thing

				if(L == src)
					continue
				if(L.stat)
					continue // Otherwise it can get pretty laggy if there's loads of corpses around.
				L.inflict_shock_damage_legacy(i * 2)
				if(L && L.has_polaris_AI()) // Some mobs delete themselves when dying.
					L.ai_holder.react_to_attack_polaris(src)

			else if(istype(thing, /obj/vehicle/sealed/mecha))
				var/obj/vehicle/sealed/mecha/M = thing
				M.take_damage_legacy(i * 2, "energy") // Mechs don't have a concept for siemens so energy armor check is the best alternative.

		sleep(1 SECOND)

	// Shoot a tesla bolt, and flashes people who are looking at the mecha without sufficent eye protection.
	visible_message(SPAN_WARNING( "\The [energy_ball] explodes in a flash of light, sending a shock everywhere!"))
	playsound(src.loc, 'sound/effects/lightningbolt.ogg', 100, 1, extrarange = 30)
	tesla_zap(src.loc, 5, ELECTRIC_ZAP_POWER, FALSE)
	for(var/mob/living/L in viewers(src))
		if(L == src)
			continue
		var/dir_towards_us = get_dir(L, src)
		if(L.dir && L.dir & dir_towards_us)
			to_chat(L, SPAN_DANGER("The flash of light blinds you briefly."))
			L.flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = TRUE)

	// Get rid of our energy ball.
	energy_ball.stop_orbit()
	qdel(energy_ball)

	sleep(1 SECOND)
	// Resist resistance to old value.
	shock_resist = old_shock_resist // Not using initial() in case the value gets modified by an admin or something.

#undef ELECTRIC_ZAP_POWER

/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/proc/launch_rockets(atom/target)
	set waitfor = FALSE

	// Telegraph our next move.
	Beam(target, icon_state = "sat_beam", time = 3.5 SECONDS, maxdistance = INFINITY)
	visible_message(SPAN_WARNING( "\The [src] deploys a missile rack!"))
	playsound(src, 'sound/effects/turret/move1.wav', 50, 1)
	sleep(0.5 SECONDS)

	for(var/i = 1 to 3)
		if(target) // Might get deleted in the meantime.
			var/turf/T = get_turf(target)
			if(T)
				visible_message(SPAN_WARNING( "\The [src] fires a rocket into the air!"))
				playsound(src, 'sound/weapons/rpg.ogg', 70, 1)
				face_atom(T)
				var/obj/projectile/arc/explosive_rocket/rocket = new(loc)
				rocket.old_style_target(T, src)
				rocket.fire()
				sleep(1 SECOND)

	visible_message(SPAN_WARNING( "\The [src] retracts the missile rack."))
	playsound(src, 'sound/effects/turret/move2.wav', 50, 1)

// Arcing rocket projectile that produces a weak explosion when it lands.
// Shouldn't punch holes in the floor, but will still hurt.
/obj/projectile/arc/explosive_rocket
	name = "rocket"
	icon_state = "mortar"

/obj/projectile/arc/explosive_rocket/on_impact(turf/T)
	new /obj/effect/explosion(T) // Weak explosions don't produce this on their own, apparently.
	explosion(T, 0, 0, 2, adminlog = FALSE)

/mob/living/simple_mob/mechanical/hivebot/enigma/mimir/proc/launch_microsingularity(atom/target)
	var/turf/T = get_turf(target)
	visible_message(SPAN_WARNING( "\The [src] fires an energetic sphere into the air!"))
	playsound(src, 'sound/weapons/Laser.ogg', 50, 1)
	face_atom(T)
	var/obj/projectile/arc/microsingulo/sphere = new(loc)
	sphere.old_style_target(T, src)
	sphere.fire()

/obj/projectile/arc/microsingulo
	name = "micro singularity"
	icon_state = "bluespace"

/obj/projectile/arc/microsingulo/on_impact(turf/T)
	new /obj/effect/temporary_effect/pulse/microsingulo(T)


/obj/effect/temporary_effect/pulse/microsingulo
	name = "micro singularity"
	desc = "It's sucking everything in!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "bhole3"
	light_range = 4
	light_power = 5
	light_color = "#2ECCFA"
	pulses_remaining = 10
	pulse_delay = 2 SECONDS

/obj/effect/temporary_effect/pulse/microsingulo/on_pulse()
	for(var/atom/A in range(pull_radius, src))
		A.singularity_pull(src, pull_strength)
// Used to control the mob's positioning based on which special attack it has done.
// Note that the intent will not change again until the next special attack is about to happen.

// Changes the mob's intent, which controls which special attack is used.
// INTENT_DISARM causes Electric Defense, INTENT_GRAB causes Micro-Singularity, and INTENT_HARM causes Missile Barrage.
/datum/ai_holder/polaris/simple_mob/intentional/adv_dark_gygax/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A

		// If we're surrounded, Electric Defense will quickly fix that.
		var/tally = 0
		var/list/potential_targets = list_targets() // Returns list of mobs and certain objects like mechs and turrets.
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(holder, AM) > electric_defense_radius)
				continue
			if(!can_attack(AM))
				continue
			tally++

		// Should we shock them?
		if(tally >= electric_defense_threshold || get_dist(target, holder) <= electric_defense_radius)
			holder.a_intent = INTENT_DISARM
			return

		// Otherwise they're a fair distance away and we're not getting mobbed up close.
		// See if we should use missiles or microsingulo.
		tally = 0 // Let's recycle the var.
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(target, AM) > microsingulo_radius) // Deliberately tests distance between target and nearby targets and not the holder.
				continue
			if(!can_attack(AM))
				continue
			if(AM.anchored) // Microsingulo doesn't do anything to anchored things.
				tally--
			else
				tally++

		// Lots of people means minisingulo would be more useful.
		if(tally >= microsingulo_threshold)
			holder.a_intent = INTENT_GRAB
		else // Otherwise use rockets.
			holder.a_intent = INTENT_HARM

	else
		if(get_dist(holder, A) >= rocket_explosive_radius + 1)
			holder.a_intent = INTENT_HARM // Fire rockets if it's an obj/turf.
		else
			holder.a_intent = INTENT_DISARM // Electricity might not work but it's safe up close.
