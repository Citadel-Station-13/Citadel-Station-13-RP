#define FIREMODE_ADD_CHAMBERED(__var) ((chambered && chambered.__var) + (firemode.__var))
#define FIREMODE_OR_CHAMBERED(__var) NULL_EITHER_OR(chambered, firemode, __var)
/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty broken, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/inhands/guns_lefthand.dmi',
		slot_r_hand_str = 'icons/mob/inhands/guns_righthand.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	flags = CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = ITEMSIZE_NORMAL
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	preserve_item = 1
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	var/list/datum/firemode/firemodes = /datum/firemode		//list of typepaths, or just one thing if there's only one, created on init. first one is chosen.
	var/obj/item/ammu_casing/chambered						//currently chambered
	var/datum/firemode/firemode								//current firemode
	var/firemode_index										//current firemode index

	var/firing_burst = FALSE
	var/last_fire_time = 0

	var/obj/item/suppressed					//whether or not a message is displayed when fired - also tracks what's suppressing it
	var/can_suppress = FALSE
	var/can_unsuppress = TRUE

	var/obj/item/firing_pin/pin = /obj/item/firing_pin

	var/can_flashlight = FALSE //if a flashlight can be added or removed if it already has one.
	var/obj/item/flashlight/seclite/gun_light
	var/mutable_appearance/flashlight_overlay
	var/datum/action/item_action/toggle_gunlight/alight
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	var/can_bayonet = FALSE //if a bayonet can be added or removed if it already has one.
	var/obj/item/kitchen/knife/bayonet
	var/mutable_appearance/knife_overlay
	var/bayonet_x_offset = 0
	var/bayonet_y_offset = 0

	var/ammo_x_offset = 0 //used for positioning ammo count overlay on sprite
	var/ammo_y_offset = 0

	var/sawn_off = FALSE

/obj/item/gun/Initialize()
	. = ..()
	initialize_firemodes()
	if(pin)
		pin = new pin(src, src)
	update_icon()

/obj/item/gun/Destroy()
	QDEL_NULL(pin)
	return ..()

/obj/item/gun/proc/initialize_firemodes()
	if(!islist(firemodes))
		if(!ispath(firemodes))
			CRASH("WARNING: Gun without a firemode tried to initialize them.")
		firemodes = new firemodes
	else
		if(!firemodes.len)
			CRASH("WARNING: Gun without a firemode tried to initialize them.")
		for(var/i in 1 to firemodes.len)
			var/path = firemodes[i]
			firemodes[i] = new path
	set_firemode_index(1)

/obj/item/gun/proc/set_firemode(datum/firemode/M)
	if((M != firemodes) && !(M in firemodes))
		islist(firemodes)? ((firemodes += M)) : (isdatum(firemodes)? ((firemodes = list(firemodes, M))) : ((firemodes = M)))
	firemode = M
	islist(firemodes)? ((firemode_index = firemodes.Find(M))) : ((firemode_index = null))
	. = firemode
	firemode.apply_to_gun(src)
	if(chambered)
		firemode.apply_to_casing(chambered)
	update_icon()

/obj/item/gun/proc/set_firemode_index(index)
	if(!islist(firemodes))
		return set_firemode(firemodes)
	else if(!firemodes.len)
		return
	else if(!ISINRANGE(index, 1, firemodes.len))
		index = 1
	return set_firemode(firemodes[index])

/obj/item/gun/proc/next_firemode()
	return set_firemode_index(isnull(firemode_index)? 1 : firemode_index + 1)

/obj/item/gun/proc/user_switch_firemode(mob/user, index)
	. = isnull(index)? next_firemode() : set_firemode_index(index)
	to_chat(user, "<span class='notice'>[src] is now set to [.].</span>")

/obj/item/gun/attack_self(mob/user)
	. = ..()
	if(. & COMPONENT_NO_INTERACT)
		return
	on_attack_self()

/obj/item/gun/AltClick(mob/user)
	. = ..()
	on_alt_click()

//so this can be overridden if we want ballistics to drop mags or something and rebind firemode switching.
/obj/item/gun/proc/on_attack_self()
	user_switch_firemode(user)

/obj/item/gun/proc/on_alt_click()
	user_switch_firemode(user)

/obj/item/gun/examine(mob/user)
	. = ..()
	to_chat(user, "It is set to [firemode].")
	to_chat(user, "It [pin? "has [pin] installed" : "is missing a firing pin"].")
	if(gun_light)
		to_chat(user, "It has \a [gun_light] [can_flashlight ? "" : "permanently "]mounted on it.")
		if(can_flashlight) //if it has a light and this is false, the light is permanent.
			to_chat(user, "<span class='info'>[gun_light] looks like it can be <b>unscrewed</b> from [src].</span>")
	else if(can_flashlight)
		to_chat(user, "It has a mounting point for a <b>seclite</b>.")

	if(bayonet)
		to_chat(user, "It has \a [bayonet] [can_bayonet ? "" : "permanently "]affixed to it.")
		if(can_bayonet) //if it has a bayonet and this is false, the bayonet is permanent.
			to_chat(user, "<span class='info'>[bayonet] looks like it can be <b>unscrewed</b> from [src].</span>")
	else if(can_bayonet)
		to_chat(user, "It has a <b>bayonet</b> lug on it.")

/obj/item/gun/proc/unlock() //used in summon guns and as a convience for admins
	if(pin)
		qdel(pin)
	pin = new /obj/item/firing_pin

/obj/item/gun/handle_atom_del(atom/A)
	if(A == chambered)
		clear_chamber()
		update_icon()
	return ..()

/obj/item/gun/Destroy()
	QDEL_NULL(chambered)
	if(islist(firemodes))
		QDEL_LIST(firemodes)
	else
		QDEL(firemodes)
	firemode = null			//already qdel list'd
	return ..()

/obj/item/gun/proc/is_suppressed(obj/item/projectile/P, obj/item/ammu_casing/C)
	var/self = suppressed && (!istype(suppressed) || suppressed.handle_suppression(P))
	return self || FIREMODE_AND_CASING(suppressed)

/obj/item/gun/proc/chamber_casing(obj/item/ammu_casing/C)
	casing = C
	firemode.apply_to_casing(C)

/obj/item/gun/proc/clear_chamber(del_casing = TRUE, drop_casing = FALSE)
	chambered = null
	if(!QDELETED(chambered))
		del_casing? qdel(chambered) : (drop_casing? chambered.forceMove(drop_location()) : NONE)

/obj/item/gun/proc/process_chamber()				//called to clear/set chamber, usually after firing
	return

/obj/item/gun/proc/postfire_live(atom/target_or_angle, atom/user, point_blank = FALSE, message = TRUE, recoil = FIREMODE_AND_CHAMBERED(recoil), reflex = FALSE, suppressed = FALSE)
	var/atom_target = istype(target_or_angle)
	if(suppressed)
		playsound(user, FIREMODE_OR_CHAMBERED(suppressed_sound), FIREMODE_OR_CHAMBERED(suppressed_volume), FIREMODE_OR_CHAMBERED(vary_fire_sound))
	else
		playsound(user, FIREMODE_OR_CHAMBERED(fire_sound), FIREMODE_OR_CHAMBERED(fire_volume), FIREMODE_OR_CHAMBERED(vary_fire_sound))
		if(message)
			if(pointblank && atom_target)
				user.visible_message("<span class='danger'>[user] [reflex? "reflexively ":""]fires [src] point blank at [target]!</span>", blind_message = "<span class='danger'>You hear a [FIREMODE_OR_CHAMBERED(sound_text)]!</span>")
			else
				user.visible_message("<span class='danger'>[user] [reflex? "reflexively ":""]fires [src]!</span>", blind_message = "<span class='danger'>You hear a [FIREMODE_OR_CHAMBERED(sound_text)]!</span>")
	if(recoil)
		shake_camera(user, recoil + 1, recoil)
	var/muzzle_flash_power = FIREMODE_AND_CHAMBERED(muzzle_flash_power)
	if(muzzle_flash_power)
		var/turf/T = get_turf(src)
		if(T)
			new /obj/effect/dummy/lighting(T, FIREMODE_OR_CHAMBERED(muzzle_flash_color), FIREMODE_OR_CHAMBERED(muzzle_flash_range), muzzle_flash_power, FIREMODE_OR_CHAMBERED(muzzle_flash_duration))

	var/one_handed_penalty = FIREMODE_AND_CHAMBERED(one_handed_penalty)
	//this section needs overhauling soonish.
	if(one_handed_penalty)
		if(!is_held_twohanded(user))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(16 to 30)
					to_chat(user, "<span class='warning'>Your aim wavers as you fire \the [src] with just one hand.</span>")
				if(31 to 45)
					to_chat(user, "<span class='warning'>You have trouble keeping \the [src] on target with just one hand.</span>")
				if(46 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to keep \the [src] on target with just one hand!</span>")
		else if(!user.can_wield_item(src))
			switch(one_handed_penalty)
				if(1 to 15)
					if(prob(50)) //don't need to tell them every single time
						to_chat(user, "<span class='warning'>Your aim wavers slightly.</span>")
				if(16 to 30)
					to_chat(user, "<span class='warning'>Your aim wavers as you try to hold \the [src] steady.</span>")
				if(31 to 45)
					to_chat(user, "<span class='warning'>You have trouble holding \the [src] steady.</span>")
				if(46 to INFINITY)
					to_chat(user, "<span class='warning'>You struggle to hold \the [src] steady!</span>")

/obj/item/gun/proc/postfire_empty(atom/target_or_angle, atom/user, point_blank = FALSE, message = TRUE)
	to_chat(user, "<span class='danger'>*click*</span>")
	playsound(src, FIREMODE_OR_CHAMBERED(dry_fire_sound), FIREMODE_OR_CHAMBERED(dry_fire_volume), FIREMODE_OR_CHAMBERED(vary_fire_sound))

/obj/item/gnu/proc/default_inherent_spread(mob/living/user)
	. = firemode.spread
	if(istype(user) && !user.auto_wield_check(src))
		. += FIREMODE_OR_CHAMBERED(one_handed_penalty)
	if(sawn_off)
		. += FIREMODE_AND_CHAMBERED(sawn_off_penalty)

/obj/item/gun/proc/mob_try_fire(atom/target_or_angle, mob/living/uesr, params, zone_override, current_dualwield_penalty = 0, inherent_spread = default_inherent_spread(user))
	add_fingerprint(user)
	. = do_fire(target_or_angle, user, params, zone_override, current_dualwield_penalty, inherent_spread, requires_held = TRUE)
	if(.)
		user.change_next_move(FIREMODE_OR_CHAMBERED(clickcd_override))
		user.update_inv_hands()

/obj/item/gun/proc/atom_try_fire(atom/target_or_angle, atom/user, params, zone_override)
	. = do_fire(target_or_angle, user, params, zone_override)

//The proc to fire at something using the current firemode. Does NOT sanity check things like delays!
/obj/item/gun/proc/do_fire(atom/target_or_angle, atom/user, params, zone_override, current_dualwield_penalty = 0, inherent_spread = default_inherent_spread(user), requires_held, reflex = FALSE, burst_size = firemode.burst_size, add_spread = 0)
	if(user.has_trait(TRAIT_POOR_AIM))
		inherent_spread += TRAIT_POOR_AIM_ANGULAR_PENALTY
	inherent_spread += add_spread
	if(burst_size > 1)
		for(var/i in 1 to (burst_size - 1))
			addtimer(CALLBACK(src, .proc/process_shot, target_or_angle, user, params, zone_override, i + 1, current_dualwield_penalty, inherent_spread, requires_held, reflex, burst_size), burst_delay * (i))
	. = process_shot(target_or_angle, user, params, zone_override, 1, current_dualwield_penalty, inherent_spread, requires_held, reflex, 1)
	if(.)
		last_fire_time = world.time
		add_attack_logs(user, target_or_angle, "fired gun [src] ([reflex? "(REFLEX)" : ""])")

//The proc to do an actual shot
/obj/item/gun/proc/process_shot(atom/target_or_angle, atom/user, params, zone_override, burst_iteration = 0, current_dualwield_penalty = 0, inherent_spread = default_inherent_spread(user), requires_held, reflex = FALSE, final_burst_size = firemode.burst_size, force_suppress = FALSE)
	var/mob/living/L
	if(isliving(user))
		L = user
	if(QDELETED(src) || !firing_burst || (requires_held && (QDELETED(L) || !L.is_holding(src))))
		firing_burst = FALSE
		return FALSE
	inherent_spread += current_dualwield_penalty * firemode.dualwield_volatility
	var/atom_target = istype(target_or_angle)
	var/point_blank = atom_target && (get_dist(target_or_angle, user) <= 1)
	if(chambered && !chambered.is_spent())
		if(L.has_trait(TRAIT_PACIFISM) && chambered.harmful)
			to_chat(user, "<span class='notice'>[src] is lethally chambered! You don't want to risk harming anyone...</span>")
			return
		var/spread = 0
		if(firemode.randomspread)
			spread = (rand() - 0.5) * (inherent_spread)
		else
			var/divided = inherent_spread / final_burst_size
			spread = ((((divided) * iteration) * 0.5 * (((-1) * ((iteration % 2) - 1)))) - (0.25 * (inherent_spread / final_burst_size)))
		var/obj/item/projectile/P = chambered.return_projectile()
		firemode.apply_to_projectile(P)
		var/suppressed = is_suppressed(P, chambered) || force_suppress
		if(!chambered.fire_casing(target_or_angle, user, params, null, suppressed, zone_override, spread))
			postfire_empty(target_or_angle, user, point_blank)
			firing_burst = FALSE
			return FALSE
		else
			postfire_live(target_or_angle, user, point_blank, null, null, reflex, suppressed)
			if(iteration >= final_burst_size)
				firing_burst = FALSE
	else
		postfire_empty(target_or_angle, user, point_blank)
		firing_burst = FALSE
		return FALSE
	process_chamber()
	update_icon()
	return TRUE

/obj/item/gun/can_trigger_gun(atom/user, atom/target, params)
	. = ..()
	if(!handle_pins(user, target, params))
		return FALSE

/obj/item/gun/proc/handle_pins(atom/user, atom/target, params)
	if(pin)
		if((pin.obj_flags & EMAGGED) || pin.pin_auth(user, target, params))
			return TRUE
		else
			pin.auth_fail(user)
			return FALSE
	else
		to_chat(user, "<span class='warning'>[src]'s trigger is locked. This weapon doesn't have a firing pin installed!</span>")
	return FALSE








/obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	materials = list(MAT_METAL=2000)
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb = list("struck", "hit", "bashed")

	var/clumsy_check = TRUE
	trigger_guard = TRIGGER_GUARD_NORMAL	//trigger guard on the weapon, hulks can't fire them with their big meaty fingers
	var/sawn_desc = null				//description change if weapon is sawn-off
	var/sawn_off = FALSE
	var/weapon_weight = WEAPON_LIGHT

	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'


	//Zooming
	var/zoomable = FALSE //whether the gun generates a Zoom action on creation
	var/zoomed = FALSE //Zoom toggle
	var/zoom_amt = 3 //Distance in TURFs to move the user's screen forward (the "zoom" effect)
	var/zoom_out_amt = 0
	var/datum/action/toggle_scope_zoom/azoom









	var/scoped_accuracy = null
	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/obj/screen/auto_target/auto_target

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

//VOREStation Add - /tg/ icon system
	var/can_flashlight = FALSE
	var/gun_light = FALSE
	var/light_state = "flight"
	var/light_brightness = 4
	var/flight_x_offset = 0
	var/flight_y_offset = 0






/obj/item/gun/CtrlClick(mob/user)
	if(can_flashlight && ishuman(user) && src.loc == usr && !user.incapacitated(INCAPACITATION_ALL))
		toggle_flashlight()
	else
		return ..()

/obj/item/gun/proc/toggle_flashlight()
	if(gun_light)
		set_light(0)
		gun_light = FALSE
	else
		set_light(light_brightness)
		gun_light = TRUE

	playsound(src, 'sound/machines/button.ogg', 25)
	update_icon()
//VOREStation Add End

/obj/item/gun/update_twohanding()
	if(one_handed_penalty)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				name = "[initial(name)] (wielded)"
			else
				name = initial(name)
		else
			name = initial(name)
		update_icon() // In case item_state is set somewhere else.
	..()

/obj/item/gun/update_held_icon()
	if(wielded_item_state)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				item_state_slots[slot_l_hand_str] = wielded_item_state
				item_state_slots[slot_r_hand_str] = wielded_item_state
			else
				item_state_slots[slot_l_hand_str] = initial(item_state)
				item_state_slots[slot_r_hand_str] = initial(item_state)
	..()


//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return 0
	if(!user.IsAdvancedToolUser())
		return 0
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		if(!S.IsHumanoidToolUser(src))
			return 0

	var/mob/living/M = user
	if(HULK in M.mutations)
		to_chat(M, "<span class='danger'>Your fingers are much too large for the trigger guard!</span>")
		return 0
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				var/datum/gender/TU = gender_datums[user.get_visible_gender()]
				user.visible_message(
					"<span class='danger'>\The [user] shoots [TU.himself] in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return 0
	return 1


/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	if(user && user.a_intent == I_HELP && user.is_preference_enabled(/datum/client_preference/safefiring)) //regardless of what happens, refuse to shoot if help intent is on
		to_chat(user, "<span class='warning'>You refrain from firing your [src] as your intent is set to help.</span>")
		return

	else
		Fire(A, user, params) //Otherwise, fire normally.
		return


/obj/item/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.zone_selected == O_MOUTH && !mouthshoot)
		handle_suicide(user)
	else if(user.a_intent == I_HURT) //point blank shooting
		if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A && A != user)
			PreFire(A,user) //They're using the new gun system, locate what they're aiming at.
			return
		else
			Fire(A, user, pointblank=1)
	else
		return ..() //Pistolwhippin'



/obj/item/gun/afterattack(atom/target, mob/living/user, flag, params)
	. = ..()
	if(!target)
		return
	if(firing_burst)
		return
	if(flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target) || user.a_intent == INTENT_HARM) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L, target, params))
			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	if(flag)
		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
			handle_suicide(user, target, params)
			return


	//Exclude lasertag guns from the TRAIT_CLUMSY check.
	if(clumsy_check)
		if(istype(user))
			if (user.has_trait(TRAIT_CLUMSY) && prob(40))
				to_chat(user, "<span class='userdanger'>You shoot yourself in the foot with [src]!</span>")
				var/shot_leg = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
				process_fire(user, user, FALSE, params, shot_leg)
				user.dropItemToGround(src, TRUE)
				return

	if(weapon_weight == WEAPON_HEAVY && user.get_inactive_held_item())
		to_chat(user, "<span class='userdanger'>You need both hands free to fire [src]!</span>")
		return

	//DUAL (or more!) WIELDING
	var/bonus_spread = 0
	var/loop_counter = 0
	if(ishuman(user) && user.a_intent == INTENT_HARM)
		var/mob/living/carbon/human/H = user
		for(var/obj/item/gun/G in H.held_items)
			if(G == src || G.weapon_weight >= WEAPON_MEDIUM)
				continue
			else if(G.can_trigger_gun(user))
				bonus_spread += 24 * G.weapon_weight
				loop_counter++
				addtimer(CALLBACK(G, /obj/item/gun.proc/process_fire, target, user, TRUE, params, null, bonus_spread), loop_counter)

	process_fire(target, user, TRUE, params, null, bonus_spread)




/obj/item/gun/attack(mob/M as mob, mob/user)
	if(user.a_intent == INTENT_HARM) //Flogging
		if(bayonet)
			M.attackby(bayonet, user)
			return
		else
			return ..()
	return

/obj/item/gun/attack_obj(obj/O, mob/user)
	if(user.a_intent == INTENT_HARM)
		if(bayonet)
			O.attackby(bayonet, user)
			return
	return ..()


/obj/item/gun/proc/aiming_can_hit_target(atom/target, mob/living/user)		//, robust_aiming_aka_corner_dodging) when?
	return projectile_raytrace(user, target)

/obj/item/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/damage_mult = 1.3

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = 0
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	//shooting while in shock
	var/forcespread
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			forcespread = rand(50, 50)
		else if(mob.shock_stage > 70)
			forcespread = rand(-25, 25)
	var/launched = !P.launch_from_gun(target, target_zone, user, params, null, forcespread, src)

	if(launched)
		play_fire_sound(user, P)

	return launched


//DEATH TO ACCURACY
/*
/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]

	if(one_handed_penalty)
		if(!held_twohanded)
			acc_mod += -CEILING(one_handed_penalty/2, 1)
			disp_mod += one_handed_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod
	P.dispersion = disp_mod

	P.accuracy -= user.get_accuracy_penalty()

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 30

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy += M.accuracy
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)
*/

/*
//Suicide handling.
/obj/item/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>

/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<font color='red'>[user] sticks their gun in their mouth, ready to pull the trigger...</font>")
	if(!do_after(user, 40))
		M.visible_message("<font color='blue'>[user] decided life was worth living</font>")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		play_fire_sound()
		if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		. = in_chamber.on_hit(M)
		if (in_chamber.damage_type != HALLOSS)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
			user.death()
		else
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return
*/

/obj/item/gun/proc/toggle_scope(var/zoom_amount=2.0)
	//looking through a scope limits your periphereal vision
	//still, increase the view size by a tiny amount so that sniping isn't too restricted to NSEW
	var/zoom_offset = round(world.view * zoom_amount)
	var/view_size = round(world.view + zoom_amount)
	var/scoped_accuracy_mod = zoom_offset

	zoom(zoom_offset, view_size)
	if(zoom)
		accuracy = scoped_accuracy + scoped_accuracy_mod
		if(recoil)
			recoil = round(recoil*zoom_amount+1) //recoil is worse when looking through a scope

//make sure accuracy and recoil are reset regardless of how the item is unzoomed.
/obj/item/gun/zoom()
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)


///////////////////////////////////////////////////////////

#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4


/obj/item/gun/Initialize()
	. = ..()
	if(gun_light)
		alight = new(src)
	build_zooming()

/obj/item/gun/Destroy()
	QDEL_NULL(gun_light)
	QDEL_NULL(bayonet)
	QDEL_NULL(chambered)
	QDEL_NULL(azoom)
	return ..()

/obj/item/gun/handle_atom_del(atom/A)
	if(A == pin)
		pin = null
	if(A == bayonet)
		clear_bayonet()
	if(A == gun_light)
		clear_gunlight()
	return ..()

/obj/item/gun/CheckParts(list/parts_list)
	..()
	var/obj/item/gun/G = locate(/obj/item/gun) in contents
	if(G)
		G.forceMove(loc)
		QDEL_NULL(G.pin)
		visible_message("[G] can now fit a new pin, but the old one was destroyed in the process.", null, null, 3)
		qdel(src)

/obj/item/gun/equipped(mob/living/user, slot)
	. = ..()
	if(zoomed && user.get_active_held_item() != src)
		zoom(user, FALSE) //we can only stay zoomed in if it's in our hands	//yeah and we only unzoom if we're actually zoomed using the gun!!

//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/gun/proc/can_shoot()
	return TRUE


/obj/item/gun/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	else if(istype(I, /obj/item/flashlight/seclite))
		if(!can_flashlight)
			return ..()
		var/obj/item/flashlight/seclite/S = I
		if(!gun_light)
			if(!user.transferItemToLoc(I, src))
				return
			to_chat(user, "<span class='notice'>You click [S] into place on [src].</span>")
			if(S.on)
				set_light(0)
			gun_light = S
			update_gunlight()
			alight = new(src)
			if(loc == user)
				alight.Grant(user)
	else if(istype(I, /obj/item/kitchen/knife))
		var/obj/item/kitchen/knife/K = I
		if(!can_bayonet || !K.bayonet || bayonet) //ensure the gun has an attachment point available, and that the knife is compatible with it.
			return ..()
		if(!user.transferItemToLoc(I, src))
			return
		to_chat(user, "<span class='notice'>You attach [K] to [src]'s bayonet lug.</span>")
		bayonet = K
		var/state = "bayonet"							//Generic state.
		if(bayonet.icon_state in icon_states('icons/obj/guns/bayonets.dmi'))		//Snowflake state?
			state = bayonet.icon_state
		var/icon/bayonet_icons = 'icons/obj/guns/bayonets.dmi'
		knife_overlay = mutable_appearance(bayonet_icons, state)
		knife_overlay.pixel_x = knife_x_offset
		knife_overlay.pixel_y = knife_y_offset
		add_overlay(knife_overlay, TRUE)
	else
		return ..()

/obj/item/gun/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return
	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return
	if((can_flashlight && gun_light) && (can_bayonet && bayonet)) //give them a choice instead of removing both
		var/list/possible_items = list(gun_light, bayonet)
		var/obj/item/item_to_remove = input(user, "Select an attachment to remove", "Attachment Removal") as null|obj in possible_items
		if(!item_to_remove || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
			return
		return remove_gun_attachment(user, I, item_to_remove)

	else if(gun_light && can_flashlight) //if it has a gun_light and can_flashlight is false, the flashlight is permanently attached.
		return remove_gun_attachment(user, I, gun_light, "unscrewed")

	else if(bayonet && can_bayonet) //if it has a bayonet, and the bayonet can be removed
		return remove_gun_attachment(user, I, bayonet, "unfix")

/obj/item/gun/proc/remove_gun_attachment(mob/living/user, obj/item/tool_item, obj/item/item_to_remove, removal_verb)
	if(tool_item)
		tool_item.play_tool_sound(src)
	to_chat(user, "<span class='notice'>You [removal_verb ? removal_verb : "remove"] [item_to_remove] from [src].</span>")
	item_to_remove.forceMove(drop_location())

	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(item_to_remove)

	if(item_to_remove == bayonet)
		return clear_bayonet()
	else if(item_to_remove == gun_light)
		return clear_gunlight()

/obj/item/gun/proc/clear_bayonet()
	if(!bayonet)
		return
	bayonet = null
	if(knife_overlay)
		cut_overlay(knife_overlay, TRUE)
		knife_overlay = null
	return TRUE

/obj/item/gun/proc/clear_gunlight()
	if(!gun_light)
		return
	var/obj/item/flashlight/seclite/removed_light = gun_light
	gun_light = null
	update_gunlight()
	removed_light.update_brightness()
	QDEL_NULL(alight)
	return TRUE

/obj/item/gun/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, alight))
		toggle_gunlight()
	else
		..()

/obj/item/gun/proc/toggle_gunlight()
	if(!gun_light)
		return

	var/mob/living/carbon/human/user = usr
	gun_light.on = !gun_light.on
	to_chat(user, "<span class='notice'>You toggle the gunlight [gun_light.on ? "on":"off"].</span>")

	playsound(user, 'sound/weapons/empty.ogg', 100, TRUE)
	update_gunlight()

/obj/item/gun/proc/update_gunlight()
	if(gun_light)
		if(gun_light.on)
			set_light(gun_light.brightness_on)
		else
			set_light(0)
		cut_overlays(flashlight_overlay, TRUE)
		var/state = "flight[gun_light.on? "_on":""]"	//Generic state.
		if(gun_light.icon_state in icon_states('icons/obj/guns/flashlights.dmi'))	//Snowflake state?
			state = gun_light.icon_state
		flashlight_overlay = mutable_appearance('icons/obj/guns/flashlights.dmi', state)
		flashlight_overlay.pixel_x = flight_x_offset
		flashlight_overlay.pixel_y = flight_y_offset
		add_overlay(flashlight_overlay, TRUE)
	else
		set_light(0)
		cut_overlays(flashlight_overlay, TRUE)
		flashlight_overlay = null
	update_icon(TRUE)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/gun/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)

/obj/item/gun/dropped(mob/user)
	. = ..()
	if(azoom)
		azoom.Remove(user)
	if(zoomed)
		zoom(user,FALSE)


/obj/item/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return


	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You stick [src] in your mouth, ready to pull the trigger...</span>")
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	if(!bypass_timer && (!do_mob(user, target, 120) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target && target.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		return


	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='userdanger'>[(user == target) ? "You pull" : "[user] pulls"] the trigger!</span>")

	if(chambered && chambered.BB)
		chambered.BB.damage *= 5

	process_fire(target, user, TRUE, params)


/////////////
// ZOOMING //
/////////////

/datum/action/toggle_scope_zoom
	name = "Toggle Scope"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_LYING
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	var/obj/item/gun/gun = null

/datum/action/toggle_scope_zoom/Trigger()
	gun.zoom(owner)

/datum/action/toggle_scope_zoom/IsAvailable()
	. = ..()
	if(!. && gun)
		gun.zoom(owner, FALSE)

/datum/action/toggle_scope_zoom/Remove(mob/living/L)
	gun.zoom(L, FALSE)
	..()


/obj/item/gun/proc/zoom(mob/living/user, forced_zoom)
	if(!user || !user.client)
		return

	switch(forced_zoom)
		if(FALSE)
			zoomed = FALSE
		if(TRUE)
			zoomed = TRUE
		else
			zoomed = !zoomed

	if(zoomed)
		var/_x = 0
		var/_y = 0
		switch(user.dir)
			if(NORTH)
				_y = zoom_amt
			if(EAST)
				_x = zoom_amt
			if(SOUTH)
				_y = -zoom_amt
			if(WEST)
				_x = -zoom_amt

		user.client.change_view(zoom_out_amt)
		user.client.pixel_x = world.icon_size*_x
		user.client.pixel_y = world.icon_size*_y
	else
		user.client.change_view(CONFIG_GET(string/default_view))
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	return zoomed

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/gun/proc/build_zooming()
	if(azoom)
		return

	if(zoomable)
		azoom = new()
		azoom.gun = src







