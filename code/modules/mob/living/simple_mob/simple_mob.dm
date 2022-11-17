// Reorganized and somewhat cleaned up.
// AI code has been made into a datum, inside the AI module folder.

/mob/living/simple_mob
	name = "animal"
	desc = ""
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	// Generally we don't want simple_mobs to get displaced when bumped into due to it trivializing combat with windup attacks.
	// Some subtypes allow displacement, like passive animals.
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = ~HEAVY

	///Tooltip description
	var/tt_desc = null

	//* Settings for played mobs *//
	/// Does the percentage health show in the stat panel for the mob
	var/show_stat_health = TRUE
	/// Can a player in this mob use things like guns or AI cards?
	var/humanoid_hands = FALSE
	/// Used in IsHumanoidToolUser. 'Your X are not fit-'.
	var/hand_form = "hands"
	/// Slots to show on the hud (typically none)
	var/list/hud_gears
	/// Icon file path to use for the HUD, otherwise generic icons are used
	var/ui_icons
	/// If they have hands, they could use some icons.
	var/r_hand_sprite
	/// If they have hands, they could use some icons.
	var/l_hand_sprite
	/// Message to print to players about 'how' to play this mob on login.
	var/player_msg

	//* Mob icon/appearance settings *//
	/// The iconstate if we're alive. //!REQUIRED
	var/icon_living = ""
	/// The iconstate if we're dead. //!REQUIRED
	var/icon_dead = ""
	/// The iconstate for being gibbed, optional. Defaults to a generic gib animation.
	var/icon_gib = "generic_gib"
	/// The iconstate for resting, optional
	var/icon_rest = null
	/// Holds overlays from modifiers.
	var/image/modifier_overlay = null
	/// Holds the eye overlay.
	var/image/eye_layer = null
	/// If true, adds an overlay over the lighting plane for [icon_state]-eyes.
	var/has_eye_glow = FALSE
	///Just the default, played like the weapon attack anim
	attack_icon = 'icons/effects/effects.dmi'
	///Just the default
	attack_icon_state = "slash"

	//* Mob talking settings *//
	/// Can all mobs in the entire universe understand this one?
	universal_speak = 0
	/// Text name of their language if they speak something other than galcom. They speak the first one.
	var/has_langs = list(LANGUAGE_GALCOM)

	//* Movement things. *//
	/// Lower is faster.
	var/movement_cooldown = 5
	/// If set, will play this sound when it moves on its own will.
	var/movement_sound = null
	/// If set, plays the sound when the mob's dir changes in most cases.
	var/turn_sound = null
	/// If set, moving will shake the camera of all living mobs within this radius slightly.
	var/movement_shake_radius = 0
	/// If set, the mob will move through fluids with no hinderance.
	var/aquatic_movement = 0

	//* Mob interaction *//
	/// If clicked on help intent.
	var/response_help   = "tries to help"
	/// If clicked on disarm intent.
	var/response_disarm = "tries to disarm"
	/// If clicked on harm intent.
	var/response_harm   = "tries to hurt"
	/// Mobs on this list wont get attacked regardless of faction status.
	var/list/friends = list()
	/// How much an unarmed harm click does to this mob.
	var/harm_intent_damage = 3
	/// The list of lootable objects to drop, with "/path = prob%" structure
	var/list/loot_list = list()
	/// An ID card if they have one to give them access to stuff.
	var/obj/item/card/id/access_card

	//* Mob environment settings *//
	/// Minimum "okay" temperature in kelvin
	var/minbodytemp = 250
	/// Maximum of above
	var/maxbodytemp = 350
	/// Amount of damage applied if animal's body temperature is higher than maxbodytemp.
	var/heat_damage_per_tick = 3
	/// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp.
	var/cold_damage_per_tick = 2
	/// The mob's fire state: 0 = fine, 1 = hot, 2 = cold
	var/fire_alert = 0
	/// Oxygen in moles, minimum, 0 is 'no minimum'
	var/min_oxy = 5
	/// Oxygen in moles, maximum, 0 is 'no maximum'
	var/max_oxy = 0
	/// Phoron min
	var/min_tox = 0
	/// Phoron max
	var/max_tox = 1
	/// CO2 min
	var/min_co2 = 0
	/// CO2 max
	var/max_co2 = 5
	/// N2 min
	var/min_n2 = 0
	/// N2 max
	var/max_n2 = 0
	/// This damage is taken when atmos doesn't fit all the requirements set.
	var/unsuitable_atoms_damage = 2

	//* Hostility settings *//
	/// Is the mob weak to tasers?
	var/taser_kill = 1

	//* Attack ranged settings *//
	/// The projectiles I shoot.
	var/projectiletype
	/// The sound I make when I do it
	var/projectilesound
	/// Accuracy modifier to add onto the bullet when its fired.
	var/projectile_accuracy = 0
	/// How many degrees to vary when I do it.
	var/projectile_dispersion = 0
	/// What to make the hugely laggy casings pile out of.
	var/casingtype

	//* Reloading settings, part of ranged code *//
	/// If TRUE, mob needs to reload occasionally.
	var/needs_reload = FALSE
	/// How many shots the mob gets before it has to reload, will not be used if needs_reload is FALSE
	var/reload_max = 1
	/// A counter to keep track of how many shots the mob has fired so far. Reloads when it hits reload_max.
	var/reload_count = 0
	/// How long it takes for a mob to reload. This is to buy a player a bit of time to run or fight.
	var/reload_time = 1 SECONDS
	/// What sound gets played when the mob successfully reloads. Defaults to the same sound as reloading guns. Can be null.
	var/reload_sound = 'sound/weapons/flipblade.ogg'

	//* Mob melee settings *//
	/// Lower bound of randomized melee damage.
	var/melee_damage_lower = 2
	/// Upper bound of randomized melee damage.
	var/melee_damage_upper = 6
	/// "You are [attacktext] by the mob!"
	var/list/attacktext = list("attacked")
	/// "The mob [friendly] the person."
	var/list/friendly = list("nuzzles")
	/// Sound to play when I attack.
	var/attack_sound = null
	/// Percent chance to miss a melee attack.
	var/melee_miss_chance = 0
	/// What armor does this check?
	var/attack_armor_type = "melee"
	/// How much armor pen this attack has.
	var/attack_armor_pen = 0
	/// Is the attack sharp?
	var/attack_sharp = FALSE
	/// Does the attack have an edge?
	var/attack_edge = FALSE

	/// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/melee_attack_delay = null
	/// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/ranged_attack_delay = null
	/// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/special_attack_delay = null

	//* Special attacks *//
	/// The chance to ATTEMPT a special_attack_target(). If it fails, it will do a regular attack instead.
	//? This is commented out to ease the AI attack logic by being (a bit more) determanistic.
	//? You should instead limit special attacks using the below vars instead.
//	var/special_attack_prob = 0

	/// The minimum distance required for an attempt to be made.
	var/special_attack_min_range = null
	/// The maximum for an attempt.
	var/special_attack_max_range = null
	/// If set, special attacks will work off of a charge system, and won't be usable if all charges are expended. Good for grenades.
	var/special_attack_charges = null
	/// If set, special attacks will have a cooldown between uses.
	var/special_attack_cooldown = null
	/// world.time when a special attack occured last, for cooldown calculations.
	var/last_special_attack = null

	//* Damage resistances *//
	/// Chance for a grab attempt to fail. Note that this is not a true resist and is just a prob() of failure.
	var/grab_resist = 0
	/// Damage reduction for all types
	var/resistance = 0
	/// Values for normal getarmor() checks
	var/list/armor = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)
	/// Values for getsoak() checks.
	var/list/armor_soak = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	// Protection against heat/cold/electric/water effects.
	// 0 is no protection, 1 is total protection. Negative numbers increase vulnerability.
	var/heat_resist = 0.0
	var/cold_resist = 0.0
	var/shock_resist = 0.0
	var/water_resist = 1.0
	var/poison_resist = 0.0

	/// Stops injections and "injections".
	var/thick_armor = FALSE

	//* Cult stuff. *//
	var/purge = 0
	var/supernatural = FALSE


	/// Is it contained in a cage?
	var/in_stasis = 0

	//Randomization code base
	var/mod_min = 70
	var/mod_max = 130
	/// Are we randomized?
	var/randomized = FALSE

	/// Used for if the mob can drop limbs. Overrides species dmi.
	var/limb_icon
	/// Used for if the mob can drop limbs. Overrides the icon cache key, so it doesn't keep remaking the icon needlessly.
	var/limb_icon_key

	///Does the simple mob drop organs when butchered?
	butchery_drops_organs = FALSE

//* randomization code. *//
/mob/living/simple_mob/proc/randomize()
	if(randomized == TRUE)
		var/mod = rand(mod_min,mod_max)/100
		size_multiplier = mod
		maxHealth = round(maxHealth*mod)
		health = round(health*mod)
		melee_damage_lower = round(melee_damage_lower*mod)
		melee_damage_upper = round(melee_damage_upper*mod)
		movement_cooldown = round(movement_cooldown*mod)
		meat_amount = round(meat_amount*mod)
		update_icons()

/mob/living/simple_mob/Initialize(mapload)
	verbs -= /mob/verb/observe
	health = maxHealth
	randomize()

	for(var/L in has_langs)
		languages |= SScharacters.resolve_language_name(L)
	if(languages.len)
		default_language = languages[1]

	if(has_eye_glow)
		add_eyes()

	return ..()

/mob/living/simple_mob/Destroy()
	default_language = null
	if(access_card)
		QDEL_NULL(access_card)

	friends.Cut()
	languages.Cut()

	if(has_eye_glow)
		remove_eyes()
	return ..()

/mob/living/simple_mob/death()
	update_icon()
	..()


//Client attached
/mob/living/simple_mob/Login()
	. = ..()
	to_chat(src,"<b>You are \the [src].</b> [player_msg]")


/mob/living/simple_mob/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)


/mob/living/simple_mob/SelfMove(turf/n, direct)
	var/turf/old_turf = get_turf(src)
	var/old_dir = dir
	. = ..()
	if(. && movement_shake_radius)
		for(var/mob/living/L in range(movement_shake_radius, src))
			shake_camera(L, 1, 1)
	if(turn_sound && dir != old_dir)
		playsound(src, turn_sound, 50, 1)
	else if(movement_sound && old_turf != get_turf(src)) // Playing both sounds at the same time generally sounds bad.
		playsound(src, movement_sound, 50, 1)
/*
/mob/living/simple_mob/setDir(new_dir)
	if(dir != new_dir)
		playsound(src, turn_sound, 50, 1)
	return ..()
*/
/mob/living/simple_mob/movement_delay()
	. = ..()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = movement_cooldown

	if(force_max_speed)
		return -3

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return -3
		if(!isnull(M.slowdown))
			tally += M.slowdown

	// Turf related slowdown
	var/turf/T = get_turf(src)
	if(T && T.movement_cost && !hovering) // Flying mobs ignore turf-based slowdown. Aquatic mobs ignore water slowdown, and can gain bonus speed in it.
		if(istype(T,/turf/simulated/floor/water) && aquatic_movement)
			tally -= aquatic_movement - 1
		else
			tally += T.movement_cost

	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if(m_intent == "walk")
		tally *= 1.5

	return . + tally + config_legacy.animal_delay


/mob/living/simple_mob/Stat()
	..()
	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / getMaxHealth()) * 100)]%")

/mob/living/simple_mob/lay_down()
	..()
	if(resting && icon_rest)
		icon_state = icon_rest
	else
		icon_state = icon_living
	update_icon()


/mob/living/simple_mob/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	return ..()

/mob/living/simple_mob/get_speech_ending(verb, var/ending)
	return verb


//TODO: This needs to be phased out for a newer butchering system. Though I am too scared to undo all our custom stuff. -Zandario
// Harvest an animal's delicious byproducts
/mob/living/simple_mob/harvest(mob/user)
	var/actual_meat_amount = pick(0, meat_amount)
	var/actual_bone_amount = pick(0, bone_amount)
	var/actual_hide_amount = pick(0, hide_amount)
	var/actual_exotic_amount = pick(0, exotic_amount)
	if(stat != DEAD)
		return
	if(meat_type)
		for(var/i in 1 to actual_meat_amount)
			var/obj/item/meat = new meat_type(drop_location())
			meat.name = "[name] [meat.name]"
	if(bone_type)
		for(var/i in 1 to actual_bone_amount)
			var/obj/item/bone = new bone_type(drop_location())
			bone.name = "[bone.name]"
	if(hide_type)
		for(var/i in 1 to actual_hide_amount)
			new hide_type(drop_location())
	if(exotic_type)
		for(var/i in 1 to actual_exotic_amount)
			new exotic_type(drop_location())
	if(issmall(src))
		user?.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
		new /obj/effect/debris/cleanable/blood/splatter(get_turf(src))
		qdel(src)
	else
		user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
		gib()

/* Replace the above ^^^^ with this if enabling the butchering component.
/mob/living/simple_mob/gib()
	if(butcher_results || guaranteed_butcher_results)
		var/list/butcher = list()
		if(butcher_results)
			butcher += butcher_results
		if(guaranteed_butcher_results)
			butcher += guaranteed_butcher_results
		var/atom/Tsec = drop_location()
		for(var/path in butcher)
			for(var/i in 1 to butcher[path])
				new path(Tsec)
	..()
*/

/mob/living/simple_mob/is_sentient()
	return mob_class & MOB_CLASS_HUMANOID|MOB_CLASS_ANIMAL|MOB_CLASS_SLIME // Update this if needed.

/mob/living/simple_mob/get_nametag_desc(mob/user)
	return "<i>[tt_desc]</i>"

/// Override for special butchering checks.
/mob/living/simple_mob/can_butcher(var/mob/user, var/obj/item/I)
	. = ..()
	if(. && (!is_sharp(I) || !has_edge(I)))
		return FALSE
