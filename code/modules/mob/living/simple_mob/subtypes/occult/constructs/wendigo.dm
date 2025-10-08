////////////////////////////
//		Wendigos
////////////////////////////

// Invisible, quick and hits like a truck. A Beserker and servant the god of
// hunger cannibals, gluttony, known as the Gourmand. Strong Against Brute
// damage type and weak to burn damage types.

/mob/living/simple_mob/construct/flesheaters/wendigo
	name = "Wendigo"
	real_name = "Wendigo"
	desc = "The eyes burn with an insatiable hunger. You feel like prey"
	catalogue_data = list(/datum/category_item/catalogue/fauna/flesheaters/wendigo)

	icon_state = "wendigo"
	icon_living = "wendigo"

	maxHealth = 300
	health = 300

	movement_base_speed = 7 //Wendigos are very fast

	base_attack_cooldown = 7.5

	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30

	attack_armor_pen = 75
	attacktext = list("claws","slashes","bites")

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive

	armor_legacy_mob = list( 				//Weak to fire (burn damage)
				"melee" = 60,
				"bullet" = 60,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 60,
				"bio" = 100,
				"rad" = 100)

/mob/living/simple_mob/construct/flesheaters/wendigo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura)

/datum/category_item/catalogue/fauna/flesheaters/wendigo
	name = "Paranatural Entity - Wendigo"
	desc = "As if it walked straight out of ancient terran legend the Wendigo is a paranatural entity \
	with an unsatiable hunger for human flesh. At its heart the Wendigo is an ambush predator moving quickly \
	using either stealth or leaping attacks to close distance to its prey before ripping them to shreds. \
	Truly diabolical in melee range this alpha predator should be dealt with at extreme range if possible."
	value = CATALOGUER_REWARD_EASY


/mob/living/simple_mob/construct/flesheaters/wendigo/leaper

	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 5 SECONDS

	var/leap_warmup = 0.5 SECOND // How long the leap telegraphing is.
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'


// Multiplies damage if the victim is stunned in some form, including a successful leap.
/mob/living/simple_mob/construct/flesheaters/wendigo/leaper/apply_bonus_melee_damage(atom/A, damage_amount)
	if(isliving(A))
		var/mob/living/L = A
		if(L.incapacitated(INCAPACITATION_DISABLED))
			return damage_amount * 1.5
	return ..()


// The actual leaping attack.
/mob/living/simple_mob/construct/flesheaters/wendigo/leaper/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Telegraph, since getting stunned suddenly feels bad.
	do_windup_animation(A, leap_warmup)
	sleep(leap_warmup) // For the telegraphing.

	// Do the actual leap.
	status_flags |= STATUS_LEAPING // Lets us pass over everything.
	visible_message(SPAN_DANGER("\The [src] leaps at \the [A]!"))
	throw_at_old(get_step(get_turf(A), get_turf(src)), special_attack_max_range+1, 1, src)
	playsound(src, leap_sound, 75, 1)

	sleep(5) // For the throw to complete. It won't hold up the AI SSticker due to waitfor being false.

	if(status_flags & STATUS_LEAPING)
		status_flags &= ~STATUS_LEAPING // Revert special passage ability.

	var/turf/T = get_turf(src) // Where we landed. This might be different than A's turf.

	. = FALSE

	// Now for the stun.
	var/mob/living/victim = null
	for(var/mob/living/L in T) // So player-controlled spiders only need to click the tile to stun them.
		if(L == src)
			continue

		var/list/shieldcall_result = L.atom_shieldcall(
			40,
			DAMAGE_TYPE_BRUTE,
			3,
			ARMOR_MELEE,
			NONE,
			ATTACK_TYPE_MELEE,
		)
		if(shieldcall_result[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAGS_BLOCK_ATTACK)
			continue

		victim = L
		break

	if(victim)
		victim.afflict_paralyze(20 * 2)
		victim.visible_message(SPAN_DANGER("\The [src] knocks down \the [victim]!"))
		to_chat(victim, SPAN_CRITICAL("\The [src] jumps on you!"))
		. = TRUE

	set_AI_busy(FALSE)



/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked
	var/stealthed = FALSE
	var/stealthed_alpha = 35			// Lower = Harder to see.
	var/stealthed_bonus_damage = 50	// This is added on top of the normal melee damage.
	var/stealthed_weaken_amount = 3	// How long to stun for.
	var/stealth_cooldown = 3 SECONDS	// Amount of time needed to re-stealth after losing it.
	var/last_unstealth = 0			//World Time


	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/hit_and_run

/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/proc/stealth()
	if(stealthed)
		return
	animate(src, alpha = stealthed_alpha, time = 1 SECOND)
	stealthed = TRUE

/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/proc/unstealth()
	last_unstealth = world.time // This is assigned even if it isn't stealthed already, to 'reset' the timer if the spider is continously getting attacked.
	if(!stealthed)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	stealthed = FALSE


// Check if stealthing if possible.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/proc/can_stealth()
	if(stat)
		return FALSE
	if(last_unstealth + stealth_cooldown > world.time)
		return FALSE

	return TRUE


// Called by things that break stealths, like Technomancer wards.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/break_cloak()
	unstealth()


/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/is_cloaked()
	return stealthed


// Cloaks the spider automatically, if possible.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/handle_special()
	if(!stealthed && can_stealth())
		stealth()


// Applies bonus base damage if stealthed.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/apply_bonus_melee_damage(atom/A, damage_amount)
	if(stealthed)
		return damage_amount + stealthed_bonus_damage
	return ..()

// Applies stun, then unstealths.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/apply_melee_effects(atom/A)
	if(stealthed)
		if(isliving(A))
			var/mob/living/L = A
			L.afflict_paralyze(20 * stealthed_weaken_amount)
			to_chat(L, SPAN_DANGER("\The [src] ambushes you!"))
			playsound(L, 'sound/weapons/spiderlunge.ogg', 75, 1)
	unstealth()
	..()

// Force unstealthing if attacked.
/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	break_cloak()

/mob/living/simple_mob/construct/flesheaters/wendigo/cloaked/on_melee_act(mob/attacker, obj/item/weapon, datum/melee_attack/attack_style, target_zone, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_ATTACK_MISSED)
		return
	break_cloak()
