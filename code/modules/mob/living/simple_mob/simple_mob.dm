// Reorganized and somewhat cleaned up.
// AI code has been made into a datum, inside the AI module folder.

#define ai_log(M,V)	if(debug_ai) ai_log_output(M,V)

//Talky things
#define try_say_list(L) if(L.len) say(pick(L))

/mob/living/simple_mob
	name = "animal"
	desc = ""
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20
	base_attack_cooldown = 15

	// Generally we don't want simple_mobs to get displaced when bumped into due to it trivializing combat with windup attacks.
	// Some subtypes allow displacement, like passive animals.
	mob_bump_flag  = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|HUMAN
	mob_push_flags = MONKEY|SLIME|HUMAN

	var/tt_desc = "Uncataloged Life Form" //Tooltip description

	//Settings for played mobs
	var/show_stat_health = 1		// Does the percentage health show in the stat panel for the mob
	var/has_hands = FALSE			// Set to TRUE to enable the use of hands and the hands hud
	var/humanoid_hands = FALSE		// Can a player in this mob use things like guns or AI cards?
	var/hand_form = "hands"			// Used in IsHumanoidToolUser. 'Your X are not fit-'.
	var/list/hud_gears				// Slots to show on the hud (typically none)
	var/ui_icons					// Icon file path to use for the HUD, otherwise generic icons are used
	var/r_hand_sprite				// If they have hands,
	var/l_hand_sprite				// they could use some icons.
	var/player_msg					// Message to print to players about 'how' to play this mob on login.
	var/ai_inactive = FALSE 		// Set to 1 to turn off most AI actions

	//Mob icon/appearance settings
	var/icon_living = ""			// The iconstate if we're alive, required
	var/icon_dead = ""				// The iconstate if we're dead, required
	var/icon_gib = "generic_gib"	// The iconstate for being gibbed, optional. Defaults to a generic gib animation.
	var/icon_rest = null			// The iconstate for resting, optional
	var/image/modifier_overlay = null // Holds overlays from modifiers.
	var/image/eye_layer = null		// Holds the eye overlay.
	var/has_eye_glow = FALSE		// If true, adds an overlay over the lighting plane for [icon_state]-eyes.
	attack_icon = 'icons/effects/effects.dmi' //Just the default, played like the weapon attack anim
	attack_icon_state = "slash" //Just the default

	//Mob talking settings
	universal_speak = FALSE			// Can all mobs in the entire universe understand this one?
	var/has_langs = list(LANGUAGE_GALCOM)// Text name of their language if they speak something other than galcom. They speak the first one.
	var/speak_chance = 0			// Probability that I talk (this is 'X in 200' chance since even 1/100 is pretty noisy)
	var/reacts = FALSE				// Reacts to some things being said
	var/list/speak = list()			// Things I might say if I talk
	var/list/emote_hear = list()	// Hearable emotes I might perform
	var/list/emote_see = list()		// Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/say_understood = list()// List of things to say when accepting an order
	var/list/say_cannot = list()	// List of things to say when they cannot comply
	var/list/say_maybe_target = list()// List of things to say when they spot something barely
	var/list/say_got_target = list()// List of things to say when they engage a target
	var/list/reactions = list() 	// List of "string" = "reaction" and things they hear will be searched for string.

	//Movement things.
	var/wander = TRUE				// Does the mob wander around when idle?
	var/wander_distance = 3			// How far the mob will wander before going home (assuming they are allowed to do that)
	var/returns_home = FALSE		// Mob knows how to return to wherever it started
	var/turns_per_move = 1			// How many life() cycles to wait between each wander mov?
	var/stop_when_pulled = TRUE 	// When set to TRUE this stops the animal from moving when someone is pulling it.
	var/follow_dist = 2				// Distance the mob tries to follow a friend
	var/obstacles = list()			// Things this mob refuses to move through
	var/movement_cooldown = 5		// Lower is faster.
	var/movement_sound = null		// If set, will play this sound when it moves on its own will.
	var/turn_sound = null			// If set, plays the sound when the mob's dir changes in most cases.
	var/movement_shake_radius = 0	// If set, moving will shake the camera of all living mobs within this radius slightly.
	var/aquatic_movement = FALSE		// If set, the mob will move through fluids with no hinderance.
	var/speed = 0					// Higher speed is slower, negative speed is faster.
	var/turf/home_turf				// Set when they spawned, they try to come back here sometimes.

	//Mob interaction
	var/response_help   = "tries to help"	// If clicked on help intent
	var/response_disarm = "tries to disarm" // If clicked on disarm intent
	var/response_harm   = "tries to hurt"	// If clicked on harm intent
	var/list/friends = list()		// Mobs on this list wont get attacked regardless of faction status.
	var/harm_intent_damage = 3		// How much an unarmed harm click does to this mob.
	var/meat_amount = 0				// How much meat to drop from this mob when butchered
	var/obj/meat_type				// The meat object to drop
	var/list/loot_list = list()		// The list of lootable objects to drop, with "/path = prob%" structure
	var/obj/item/card/id/myid// An ID card if they have one to give them access to stuff.
	var/recruitable = FALSE			// Mob can be bossed around
	var/recruit_cmd_str = "Hey,"	// The thing you prefix commands with when bossing them around
	var/intelligence_level = SA_ANIMAL// How 'smart' the mob is ICly, used to deliniate between animal, robot, and humanoid SAs.

	//Mob environment settings
	var/minbodytemp = 250			// Minimum "okay" temperature in kelvin
	var/maxbodytemp = 350			// Maximum of above
	var/heat_damage_per_tick = 3	// Amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	// Same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0				// 0 = fine, 1 = hot, 2 = cold
	var/temperature_range = 40		// How close will they get to environmental temperature before their body stops changing its heat


	var/min_oxy = 5					// Oxygen in moles, minimum, 0 is 'no minimum'
	var/max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	var/min_tox = 0					// Phoron min
	var/max_tox = 1					// Phoron max
	var/min_co2 = 0					// CO2 min
	var/max_co2 = 5					// CO2 max
	var/min_n2 = 0					// N2 min
	var/max_n2 = 0					// N2 max
	var/unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

	//Hostility settings
	var/hostile = FALSE				// Do I even attack?
	var/retaliate = FALSE			// Do I respond to damage against specific targets.
	var/view_range = 7				// Scan for targets in this range.
	var/specific_targets = FALSE	// Only use Found() targets, ignore others.
	var/investigates = FALSE		// Do I investigate if I saw someone briefly?
	var/attack_same = FALSE			// Do I attack members of my own faction?
	var/cooperative = FALSE			// Do I ask allies to help me?
	var/assist_distance = 25		// Radius in which I'll ask my comrades for help.
	var/taser_kill = TRUE			// Is the mob weak to tasers

	//Attack ranged settings
	var/ranged = FALSE					// Do I attack at range?
	var/shoot_range = 7				// How far away do I start shooting from?
	var/rapid = FALSE				// Three-round-burst fire mode
	var/firing_lines = FALSE		// Avoids shooting allies
	var/projectiletype				// The projectiles I shoot
	var/projectilesound				// The sound I make when I do it
	var/projectile_accuracy = 0		// Accuracy modifier to add onto the bullet when its fired.
	var/projectile_dispersion = 0	// How many degrees to vary when I do it.
	var/casingtype					// What to make the hugely laggy casings pile out of

	// Reloading settings, part of ranged code
	var/needs_reload = FALSE							// If TRUE, mob needs to reload occasionally
	var/reload_max = 1									// How many shots the mob gets before it has to reload, will not be used if needs_reload is FALSE
	var/reload_count = 0								// A counter to keep track of how many shots the mob has fired so far. Reloads when it hits reload_max.
	var/reload_time = 1 SECONDS							// How long it takes for a mob to reload. This is to buy a player a bit of time to run or fight.
	var/reload_sound = 'sound/weapons/flipblade.ogg'	// What sound gets played when the mob successfully reloads. Defaults to the same sound as reloading guns. Can be null.

	//Mob melee settings
	var/melee_damage_lower = 2			// Lower bound of randomized melee damage
	var/melee_damage_upper = 6			// Upper bound of randomized melee damage
	var/list/attacktext = list("attacked") // "You are [attacktext] by the mob!"
	var/list/friendly = list("nuzzles")	// "The mob [friendly] the person."
	var/attack_sound = null				// Sound to play when I attack
	var/environment_smash = 0			// How much environment damage do I do when I hit stuff?
	var/melee_miss_chance = 15			// percent chance to miss a melee attack.
	var/melee_attack_minDelay = 5		// How long between attacks at least
	var/melee_attack_maxDelay = 10		// How long between attacks at most
	var/attack_armor_type = "melee"		// What armor does this check?
	var/attack_armor_pen = 0			// How much armor pen this attack has.
	var/attack_sharp = FALSE			// Is the attack sharp?
	var/attack_edge = FALSE				// Does the attack have an edge?

	var/melee_attack_delay = null			// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/ranged_attack_delay = null
	var/special_attack_delay = null

	//Special attacks
//	var/special_attack_prob = 0				// The chance to ATTEMPT a special_attack_target(). If it fails, it will do a regular attack instead.
											// This is commented out to ease the AI attack logic by being (a bit more) determanistic.
											// You should instead limit special attacks using the below vars instead.
	var/special_attack_min_range = null		// The minimum distance required for an attempt to be made.
	var/special_attack_max_range = null		// The maximum for an attempt.
	var/special_attack_charges = null		// If set, special attacks will work off of a charge system, and won't be usable if all charges are expended. Good for grenades.
	var/special_attack_cooldown = null		// If set, special attacks will have a cooldown between uses.
	var/last_special_attack = null			// world.time when a special attack occured last, for cooldown calculations.

	var/spattack_prob = 0			// Chance of the mob doing a special attack (0 for never)
	var/spattack_min_range = 0		// Min range to perform the special attacks from
	var/spattack_max_range = 0		// Max range to perform special attacks from

	//Attack movement settings
	var/run_at_them = 1				// Don't use A* pathfinding, use walk_to
	var/move_to_delay = 4			// Delay for the automated movement (deciseconds)
	var/destroy_surroundings = 1	// Should I smash things to get to my target?
	var/astar_adjacent_proc = /turf/proc/CardinalTurfsWithAccess // Proc to use when A* pathfinding.  Default makes them bound to cardinals.

	//Damage resistances
	var/grab_resist = 0				// Chance for a grab attempt to fail. Note that this is not a true resist and is just a prob() of failure.
	var/resistance = 0				// Damage reduction for all types
	var/list/armor = list(			// Values for normal getarmor() checks
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)
	var/list/armor_soak = list(		// Values for getsoak() checks.
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
	var/shock_resistance = 0		// Siemens modifier, directly subtracted from 1. Value of 0.4 means 0.6 siemens on shocks.
	var/thick_armor = FALSE // Stops injections and "injections".
	var/supernatural = FALSE		// If the mob is supernatural (used in null-rod stuff for banishing?)

	//Scary debug things
	var/debug_ai = 0				// Logging level for this mob (1,2,3)
	var/path_display = 0			// Will display the path in green when pathing
	var/path_icon = 'icons/misc/debug_group.dmi' // What icon to use for the overlay
	var/path_icon_state = "red"		// What state to use for the overlay
	var/icon/path_overlay			// A reference to restart

	// contained in a cage
	var/in_stasis = FALSE

	// Vore Stuff
	var/vore_active = FALSE					// If vore behavior is enabled for this mob

	var/vore_capacity = 1					// The capacity (in people) this person can hold
	var/vore_max_size = RESIZE_HUGE			// The max size this mob will consider eating
	var/vore_min_size = RESIZE_TINY 		// The min size this mob will consider eating
	var/vore_bump_chance = 0				// Chance of trying to eat anyone that bumps into them, regardless of hostility
	var/vore_bump_emote	= "grabs hold of"	// Allow messages for bumpnom mobs to have a flavorful bumpnom
	var/vore_pounce_chance = 5				// Chance of this mob knocking down an opponent
	var/vore_pounce_cooldown = 0			// Cooldown timer - if it fails a pounce it won't pounce again for a while
	var/vore_pounce_successrate	= 100		// Chance of a pounce succeeding against a theoretical 0-health opponent
	var/vore_pounce_falloff = 1				// Success rate falloff per %health of target mob.
	var/vore_pounce_maxhealth = 80			// Mob will not attempt to pounce targets above this %health
	var/vore_standing_too = FALSE			// Can also eat non-stunned mobs
	var/vore_ignores_undigestable = TRUE	// Refuse to eat mobs who are undigestable by the prefs toggle.
	var/swallowsound = null					// What noise plays when you succeed in eating the mob.

	var/vore_default_mode = DM_DIGEST		// Default bellymode (DM_DIGEST, DM_HOLD, DM_ABSORB)
	var/vore_default_flags = 0				// No flags
	var/vore_digest_chance = 25				// Chance to switch to digest mode if resisted
	var/vore_absorb_chance = 0				// Chance to switch to absorb mode if resisted
	var/vore_escape_chance = 25				// Chance of resisting out of mob

	var/vore_stomach_name					// The name for the first belly if not "stomach"
	var/vore_stomach_flavor					// The flavortext for the first belly if not the default

	var/vore_default_item_mode = IM_DIGEST_FOOD			//How belly will interact with items
	var/vore_default_contaminates = TRUE				//Will it contaminate?
	var/vore_default_contamination_flavor = "Generic"	//Contamination descriptors
	var/vore_default_contamination_color = "green"		//Contamination color

	var/vore_fullness = 0				// How "full" the belly is (controls icons)
	var/vore_icons = 0					// Bitfield for which fields we have vore icons for.
	var/life_disabled = 0				// For performance reasons

	var/mount_offset_x = 5				// Horizontal riding offset.
	var/mount_offset_y = 8				// Vertical riding offset

	var/obj/item/radio/headset/mob_headset/mob_radio		//Adminbus headset for simplemob shenanigans.
	does_spin = FALSE


	////// These are used for inter-proc communications so don't edit them manually //////
	var/stance = STANCE_IDLE		// Used to determine behavior
	var/stop_automated_movement = 0 // Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/lifes_since_move = 0 		// A counter for how many life() cycles since move
	var/shuttletarget = null		// Shuttle's here, time to get to it
	var/enroute = 0					// If the shuttle is en-route
	var/purge = 0					// A counter used for null-rod stuff
	var/mob/living/target_mob		// Who I'm trying to attack
	var/mob/living/follow_mob		// Who I'm recruited by
	var/mob/living/simple_mob/list/faction_friends = list() // Other simple mobs I am friends with
	var/turf/list/walk_list = list()// List of turfs to walk through to get somewhere
	var/astarpathing = 0			// Am I currently pathing to somewhere?
	var/stance_changed = 0			// When our stance last changed (world.time)
	var/last_target_time = 0		// When we last set our target, to prevent juggles
	var/last_follow_time = 0		// When did we last get asked to follow someone?
	var/last_helpask_time = 0		// When did we last call for help?
	var/follow_until_time = 0		// Give up following when we reach this time (0 = never)
	var/annoyed = 0					// Do people keep distract-kiting us?
	////// ////// //////


/mob/living/simple_mob/Initialize()
	. = ..()
	verbs -= /mob/verb/observe
	home_turf = get_turf(src)
	path_overlay = new(path_icon,path_icon_state)
	move_to_delay = max(2,move_to_delay) //Protection against people coding things incorrectly and A* pathing 100% of the time
	maxHealth = health

	for(var/L in has_langs)
		languages |= GLOB.all_languages[L]
	if(languages.len)
		default_language = languages[1]

	if(cooperative)
		var/mob/living/simple_mob/first_friend
		for(var/mob/living/simple_mob/M in living_mob_list)
			if(M.faction == src.faction)
				first_friend = M
				break
		if(first_friend)
			faction_friends = first_friend.faction_friends
			faction_friends |= src
		else
			faction_friends |= src

	if(has_eye_glow)
		add_eyes()
	return ..()

/mob/living/simple_mob/Destroy()
	home_turf = null
	path_overlay = null
	default_language = null
	target_mob = null
	follow_mob = null
	if(myid)
		qdel(myid)
		myid = null

	if(faction_friends.len) //This list is shared amongst the faction
		faction_friends -= src

	friends.Cut() //This one is not
	walk_list.Cut()
	languages.Cut()

	if(has_eye_glow)
		remove_eyes()
	return ..()

// Release belly contents before being gc'd!
	release_vore_contents()
	prey_excludes.Cut()
	. = ..()

/mob/living/simple_mob/death()
	update_icon()
	..()


//Client attached
/mob/living/simple_mob/Login()
	. = ..()
	ai_inactive = 1
	handle_stance(STANCE_IDLE)
	LoseTarget()
	to_chat(src,"<span class='notice'>Mob AI disabled while you are controlling the mob.</span><br><b>You are \the [src]. [player_msg]</b>")

//Client detatched
/mob/living/simple_mob/Logout()
	spawn(15 SECONDS) //15 seconds to get back into the mob before it goes wild
		if(src && !src.client)
			ai_inactive = initial(ai_inactive) //So if they never have an AI, they stay that way.
	..()

//For debug purposes!
/mob/living/simple_mob/proc/ai_log_output(var/msg = "missing message", var/ver = 1)
	if(ver <= debug_ai)
		log_debug("SA-AI: ([src]:[x],[y],[z])(@[world.time]): [msg] ")

/mob/living/simple_mob/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

//Should we be dead?
/mob/living/simple_mob/updatehealth()
	health = getMaxHealth() - getToxLoss() - getFireLoss() - getBruteLoss()

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Update our hud if we have one
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	//Updates the nutrition while we're here
	if(nutrition_icon)
		var/food_per = (nutrition / initial(nutrition)) * 100
		switch(food_per)
			if(90 to INFINITY)
				nutrition_icon.icon_state = "nutrition0"
			if(75 to 90)
				nutrition_icon.icon_state = "nutrition1"
			if(50 to 75)
				nutrition_icon.icon_state = "nutrition2"
			if(25 to 50)
				nutrition_icon.icon_state = "nutrition3"
			if(0 to 25)
				nutrition_icon.icon_state = "nutrition4"

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


/mob/living/simple_mob/say(var/message,var/datum/language/language)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_mob/get_speech_ending(verb, var/ending)
	return verb


// Harvest an animal's delicious byproducts
/mob/living/simple_mob/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()


/mob/living/simple_mob/is_sentient()
	return mob_class & MOB_CLASS_HUMANOID|MOB_CLASS_ANIMAL|MOB_CLASS_SLIME // Update this if needed.

/mob/living/simple_mob/get_nametag_desc(mob/user)
	return "<i>[tt_desc]</i>"

//For all those ID-having mobs
/mob/living/simple_mob/GetIdCard()
	if(myid)
		return myid

// Update fullness based on size & quantity of belly contents
/mob/living/simple_mob/proc/update_fullness()
	var/new_fullness = 0
	for(var/belly in vore_organs)
		var/obj/belly/B = belly
		for(var/mob/living/M in B)
			new_fullness += M.size_multiplier
	new_fullness = round(new_fullness, 1) // Because intervals of 0.25 are going to make sprite artists cry.
	vore_fullness = min(vore_capacity, new_fullness)


/mob/living/simple_mob/update_icon()
	. = ..()
	var/mutable_appearance/ma = new(src)
	ma.layer = layer
	ma.plane = plane

	ma.overlays = list(modifier_overlay)

	//Awake and normal
	if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED) ))
		ma.icon_state = icon_living

	//Dead
	else if(stat >= DEAD)
		ma.icon_state = icon_dead

	//Resting or KO'd
	else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest)
		ma.icon_state = icon_rest

	//Backup
	else
		ma.icon_state = initial(icon_state)

	//VOREStation edit start
	var/vore_icon_state = update_vore_icon()
	if(vore_icon_state)
		ma.icon_state = vore_icon_state
	//VOREStation edit end

	if(has_hands)
		if(r_hand_sprite)
			ma.overlays += r_hand_sprite
		if(l_hand_sprite)
			ma.overlays += l_hand_sprite

	appearance = ma

	if(vore_active)
		update_fullness()
		if(!vore_fullness)
			return FALSE
		else if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)) && (vore_icons & SA_ICON_LIVING))
			icon_state = "[icon_living]-[vore_fullness]"
		else if(stat >= DEAD && (vore_icons & SA_ICON_DEAD))
			icon_state = "[icon_dead]-[vore_fullness]"
		else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest && (vore_icons & SA_ICON_REST))
			icon_state = "[icon_rest]-[vore_fullness]"

// If your simple mob's update_icon() call calls overlays.Cut(), this needs to be called after this, or manually apply modifier_overly to overlays.
/mob/living/simple_mob/update_modifier_visuals()
	var/image/effects = null
	if(modifier_overlay)
		overlays -= modifier_overlay
		modifier_overlay.overlays.Cut()
		effects = modifier_overlay
	else
		effects = new()

	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image("icon" = 'icons/mob/modifier_effects.dmi', "icon_state" = M.mob_overlay_state)
			I.appearance_flags = RESET_COLOR // So colored mobs don't affect the overlay.
			effects.overlays += I

	modifier_overlay = effects
	overlays += modifier_overlay

/mob/living/simple_mob/Life()

	if(life_disabled)
		return FALSE

	..()

	//Health
	updatehealth()
	if(stat >= DEAD)
		return FALSE

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_supernatural()
	handle_atmos() //Atmos

	ai_log("Life() - stance=[stance] ai_inactive=[ai_inactive]", 4)

	//AI Actions
	if(!ai_inactive)
		//Stanceyness
		handle_stance()

		//Movement
		if(!stop_automated_movement && wander && !anchored) //Allowed to move?
			handle_wander_movement()

		//Speaking
		if(speak_chance && stance == STANCE_IDLE) // Allowed to chatter?
			handle_idle_speaking()

		//Resisting out buckles
		if(stance != STANCE_IDLE && incapacitated(INCAPACITATION_BUCKLED_PARTIALLY))
			handle_resist()

		//Resisting out of closets
		if(istype(loc,/obj/structure/closet))
			var/obj/structure/closet/C = loc
			if(C.sealed)
				handle_resist()
			else
				C.open()

	return 1

/mob/living/simple_mob/proc/will_eat(var/mob/living/M)
	if(client) //You do this yourself, dick!
		//ai_log("vr/wont eat [M] because we're player-controlled", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(!istype(M)) //Can't eat 'em if they ain't /mob/living
		//ai_log("vr/wont eat [M] because they are not /mob/living", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(src == M) //Don't eat YOURSELF dork
		//ai_log("vr/won't eat [M] because it's me!", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(vore_ignores_undigestable && !M.digestable) //Don't eat people with nogurgle prefs
		//ai_log("vr/wont eat [M] because I am picky", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(!M.allowmobvore) // Don't eat people who don't want to be ate by mobs
		//ai_log("vr/wont eat [M] because they don't allow mob vore", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(M in prey_excludes) // They're excluded
		//ai_log("vr/wont eat [M] because they are excluded", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(M.size_multiplier < vore_min_size || M.size_multiplier > vore_max_size)
		//ai_log("vr/wont eat [M] because they too small or too big", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	if(vore_capacity != 0 && (vore_fullness >= vore_capacity)) // We're too full to fit them
		//ai_log("vr/wont eat [M] because I am too full", 3) //VORESTATION AI TEMPORARY REMOVAL
		return FALSE
	return 1

/mob/living/simple_mob/apply_attack(atom/A, damage_to_do)
	if(isliving(A)) // Converts target to living
		var/mob/living/L = A

		//ai_log("vr/do_attack() [L]", 3)
		// If we're not hungry, call the sideways "parent" to do normal punching
		if(!vore_active)
			return ..()

		// If target is standing we might pounce and knock them down instead of attacking
		var/pouncechance = CanPounceTarget(L)
		if(pouncechance)
			return PounceTarget(L, pouncechance)

		// We're not attempting a pounce, if they're down or we can eat standing, do it as long as they're edible. Otherwise, hit normally.
		if(will_eat(L) && (!L.canmove || vore_standing_too))
			return EatTarget(L)
		else
			return ..()
	else
		return ..()

/mob/living/simple_mob/proc/CanPounceTarget(var/mob/living/M) //returns either FALSE or a %chance of success
	if(!M.canmove || issilicon(M) || world.time < vore_pounce_cooldown) //eliminate situations where pouncing CANNOT happen
		return FALSE
	if(!prob(vore_pounce_chance) || !will_eat(M)) //mob doesn't want to pounce
		return FALSE
	if(vore_standing_too) //100% chance of hitting people we can eat on the spot
		return 100
	var/TargetHealthPercent = (M.health/M.getMaxHealth())*100 //now we start looking at the target itself
	if (TargetHealthPercent > vore_pounce_maxhealth) //target is too healthy to pounce
		return FALSE
	else
		return max(0,(vore_pounce_successrate - (vore_pounce_falloff * TargetHealthPercent)))


/mob/living/simple_mob/proc/PounceTarget(var/mob/living/M, var/successrate = 100)
	vore_pounce_cooldown = world.time + 20 SECONDS // don't attempt another pounce for a while
	if(prob(successrate)) // pounce success!
		M.Weaken(5)
		M.visible_message("<span class='danger'>\the [src] pounces on \the [M]!</span>!")
	else // pounce misses!
		M.visible_message("<span class='danger'>\the [src] attempts to pounce \the [M] but misses!</span>!")
		playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

	if(will_eat(M) && (!M.canmove || vore_standing_too)) //if they're edible then eat them too
		return EatTarget(M)
	else
		return //just leave them

// Attempt to eat target
// TODO - Review this.  Could be some issues here
/mob/living/simple_mob/proc/EatTarget(var/mob/living/M)
	//ai_log("vr/EatTarget() [M]",2) //VORESTATION AI TEMPORARY REMOVAL
	//stop_automated_movement = 1 //VORESTATION AI TEMPORARY REMOVAL
	var/old_target = M
	set_AI_busy(1) //VORESTATION AI TEMPORARY EDIT
	. = animal_nom(M)
	playsound(src, swallowsound, 50, 1)
	update_icon()

	if(.)
		// If we succesfully ate them, lose the target
		set_AI_busy(0) // lose_target(M) //Unsure what to put here. Replaced with set_AI_busy(1) //VORESTATION AI TEMPORARY EDIT
		return old_target
	else if(old_target == M)
		// If we didn't but they are still our target, go back to attack.
		// but don't run the handler immediately, wait until next tick
		// Otherwise we'll be in a possibly infinate loop
		set_AI_busy(0) //VORESTATION AI TEMPORARY EDIT
	//stop_automated_movement = 0 //VORESTATION AI TEMPORARY EDIT

/mob/living/simple_mob/death()
	release_vore_contents()
	. = ..()

// Make sure you don't call ..() on this one, otherwise you duplicate work.
/mob/living/simple_mob/init_vore()
	if(!vore_active || no_vore)
		return

	if(!IsAdvancedToolUser())
		verbs |= /mob/living/simple_mob/proc/animal_nom
		verbs |= /mob/living/proc/shred_limb

	if(LAZYLEN(vore_organs))
		return

	//A much more detailed version of the default /living implementation
	var/obj/belly/B = new /obj/belly(src)
	vore_selected = B
	B.immutable = 1
	B.name = vore_stomach_name ? vore_stomach_name : "stomach"
	B.desc = vore_stomach_flavor ? vore_stomach_flavor : "Your surroundings are warm, soft, and slimy. Makes sense, considering you're inside \the [name]."
	B.digest_mode = vore_default_mode
	B.mode_flags = vore_default_flags
	B.item_digest_mode = vore_default_item_mode
	B.contaminates = vore_default_contaminates
	B.contamination_flavor = vore_default_contamination_flavor
	B.contamination_color = vore_default_contamination_color
	B.escapable = vore_escape_chance > 0
	B.escapechance = vore_escape_chance
	B.digestchance = vore_digest_chance
	B.absorbchance = vore_absorb_chance
	B.human_prey_swallow_time = swallowTime
	B.nonhuman_prey_swallow_time = swallowTime
	B.vore_verb = "swallow"
	B.emote_lists[DM_HOLD] = list( // We need more that aren't repetitive. I suck at endo. -Ace
		"The insides knead at you gently for a moment.",
		"The guts glorp wetly around you as some air shifts.",
		"The predator takes a deep breath and sighs, shifting you somewhat.",
		"The stomach squeezes you tight for a moment, then relaxes harmlessly.",
		"The predator's calm breathing and thumping heartbeat pulses around you.",
		"The warm walls kneads harmlessly against you.",
		"The liquids churn around you, though there doesn't seem to be much effect.",
		"The sound of bodily movements drown out everything for a moment.",
		"The predator's movements gently force you into a different position.")
	B.emote_lists[DM_DIGEST] = list(
		"The burning acids eat away at your form.",
		"The muscular stomach flesh grinds harshly against you.",
		"The caustic air stings your chest when you try to breathe.",
		"The slimy guts squeeze inward to help the digestive juices soften you up.",
		"The onslaught against your body doesn't seem to be letting up; you're food now.",
		"The predator's body ripples and crushes against you as digestive enzymes pull you apart.",
		"The juices pooling beneath you sizzle against your sore skin.",
		"The churning walls slowly pulverize you into meaty nutrients.",
		"The stomach glorps and gurgles as it tries to work you into slop.")

/mob/living/simple_mob/Bumped(var/atom/movable/AM, yes)
	if(ismob(AM))
		var/mob/tmob = AM
		if(will_eat(tmob) && !istype(tmob, type) && prob(vore_bump_chance) && !ckey) //check if they decide to eat. Includes sanity check to prevent cannibalism.
			if(tmob.canmove && prob(vore_pounce_chance)) //if they'd pounce for other noms, pounce for these too, otherwise still try and eat them if they hold still
				tmob.Weaken(5)
			tmob.visible_message("<span class='danger'>\the [src] [vore_bump_emote] \the [tmob]!</span>!")
			set_AI_busy(TRUE)
			animal_nom(tmob)
			update_icon()
			set_AI_busy(FALSE)
	..()

// Checks to see if mob doesn't like this kind of turf
/mob/living/simple_mob/IMove(newloc)
	if(istype(newloc,/turf/unsimulated/floor/sky))
		return MOVEMENT_FAILED //Mobs aren't that stupid, probably
	return ..() // Procede as normal.

//Grab = Nomf
/mob/living/simple_mob/UnarmedAttack(var/atom/A, var/proximity)
	. = ..()

	if(a_intent == INTENT_GRAB && isliving(A) && !has_hands)
		animal_nom(A)

// Riding
/datum/riding/simple_mob
	keytype = /obj/item/material/twohanded/fluff/riding_crop // Crack!
	nonhuman_key_exemption = FALSE	// If true, nonhumans who can't hold keys don't need them, like borgs and simplemobs.
	key_name = "a riding crop"		// What the 'keys' for the thing being rided on would be called.
	only_one_driver = TRUE			// If true, only the person in 'front' (first on list of riding mobs) can drive.

/datum/riding/simple_mob/handle_vehicle_layer()
	ridden.layer = initial(ridden.layer)

/datum/riding/simple_mob/ride_check(mob/living/M)
	var/mob/living/L = ridden
	if(L.stat)
		force_dismount(M)
		return FALSE
	return TRUE

/datum/riding/simple_mob/force_dismount(mob/M)
	. =..()
	ridden.visible_message("<span class='notice'>[M] stops riding [ridden]!</span>")

/datum/riding/simple_mob/get_offsets(pass_index) // list(dir = x, y, layer)
	var/mob/living/simple_mob/L = ridden
	var/scale = L.size_multiplier

	var/list/values = list(
		"[NORTH]" = list(0, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[SOUTH]" = list(0, L.mount_offset_y*scale, BELOW_MOB_LAYER),
		"[EAST]" = list(-L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER),
		"[WEST]" = list(L.mount_offset_x*scale, L.mount_offset_y*scale, ABOVE_MOB_LAYER))

	return values

/mob/living/simple_mob/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	if(forced)
		return ..() // Skip our checks
	if(!riding_datum)
		return FALSE
	if(lying)
		return FALSE
	if(!ishuman(M))
		return FALSE
	if(M in buckled_mobs)
		return FALSE
	if(M.size_multiplier > size_multiplier * 1.2)
		to_chat(src,"<span class='warning'>This isn't a pony show! You need to be bigger for them to ride.</span>")
		return FALSE

	var/mob/living/carbon/human/H = M

	if(H.loc != src.loc)
		if(H.Adjacent(src))
			H.forceMove(get_turf(src))

	. = ..()
	if(.)
		buckled_mobs[H] = "riding"

/mob/living/simple_mob/attack_hand(mob/user as mob)
	if(riding_datum && LAZYLEN(buckled_mobs))
		//We're getting off!
		if(user in buckled_mobs)
			riding_datum.force_dismount(user)
		//We're kicking everyone off!
		if(user == src)
			for(var/rider in buckled_mobs)
				riding_datum.force_dismount(rider)
	else
		. = ..()

/mob/living/simple_mob/proc/animal_mount(var/mob/living/M in living_mobs(1))
	set name = "Animal Mount/Dismount"
	set category = "Abilities"
	set desc = "Let people ride on you."

	if(LAZYLEN(buckled_mobs))
		for(var/rider in buckled_mobs)
			riding_datum.force_dismount(rider)
		return
	if (stat != CONSCIOUS)
		return
	if(!can_buckle || !istype(M) || !M.Adjacent(src) || M.buckled)
		return
	if(buckle_mob(M))
		visible_message("<span class='notice'>[M] starts riding [name]!</span>")

/mob/living/simple_mob/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(mob_radio)
		switch(message_mode)
			if("intercom")
				for(var/obj/item/radio/intercom/I in view(1, null))
					I.talk_into(src, message, verb, speaking)
					used_radios += I
			if("headset")
				if(mob_radio && istype(mob_radio,/obj/item/radio/headset/mob_headset))
					mob_radio.talk_into(src,message,null,verb,speaking)
					used_radios += mob_radio
			else
				if(message_mode)
					if(mob_radio && istype(mob_radio,/obj/item/radio/headset/mob_headset))
						mob_radio.talk_into(src,message, message_mode, verb, speaking)
						used_radios += mob_radio
	else
		..()

/mob/living/simple_mob/proc/leap()
	set name = "Pounce Target"
	set category = "Abilities"
	set desc = "Select a target to pounce at."

	if(last_special > world.time)
		to_chat(src, "Your legs need some more rest.")
		return

	if(incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(3,src))
		choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 3) return

	if(last_special > world.time)
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 10
	status_flags |= LEAPING
	pixel_y = pixel_y + 10

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/effects/bodyfall1.ogg', 50, 1)
	pixel_y = default_pixel_y

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.Weaken(3)
			return
	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, HALLOSS,, armor_block, armor_soak)
	if(prob(33))
		T.apply_effect(3, WEAKEN, armor_block)
