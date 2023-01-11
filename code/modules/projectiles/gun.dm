/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

/datum/firemode/New(obj/item/gun/gun, list/properties = null)
	..()
	if(!properties) return

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/proc/apply_to(obj/item/gun/gun)
	for(var/propname in settings)
		gun.vars[propname] = settings[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun/ballistic.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(MAT_STEEL = 2000)
	rad_flags = RAD_BLOCK_CONTENTS
	w_class = ITEMSIZE_NORMAL
	throw_force = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	preserve_item = 1
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"

	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	var/fire_sound_text = "gunshot"
	var/fire_anim = null
	var/recoil = 0		//screen shake
	var/silenced = 0
	var/muzzle_flash = 3
	var/accuracy = 65   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/mode_name = null
	var/projectile_type = /obj/item/projectile	//On ballistics, only used to check for the cham gun
	var/holy = FALSE //For Divinely blessed guns
	var/obj/item/ammo_casing/chambered = null

	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/atom/movable/screen/auto_target/auto_target
	var/shooting = 0
	var/next_fire_time = 0

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()
	var/selector_sound = 'sound/weapons/guns/selector.ogg'

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

	/// whether or not we have safeties and if safeties are on
	var/safety_state = GUN_SAFETY_ON

	var/dna_lock = 0				//whether or not the gun is locked to dna
	var/obj/item/dnalockingchip/attached_lock

	var/last_shot = 0			//records the last shot fired

	var/charge_sections = 4
	var/shaded_charge = FALSE
	var/ammo_x_offset = 2
	var/ammo_y_offset = 0
	var/can_flashlight = FALSE
	var/gun_light = FALSE
	var/light_state = "flight"
	var/light_brightness = 4
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	var/obj/item/firing_pin/pin = /obj/item/firing_pin
	var/no_pin_required = 0
	var/scrambled = 0

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

/obj/item/gun/Initialize(mapload)
	. = ..()
	for(var/i in 1 to firemodes.len)
		firemodes[i] = new /datum/firemode(src, firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(dna_lock)
		attached_lock = new /obj/item/dnalockingchip(src)
	if(!dna_lock)
		remove_obj_verb(src, /obj/item/gun/verb/remove_dna)
		remove_obj_verb(src, /obj/item/gun/verb/give_dna)
		remove_obj_verb(src, /obj/item/gun/verb/allow_dna)

	if(pin)
		pin = new pin(src)

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
				item_state_slots[SLOT_ID_LEFT_HAND] = wielded_item_state
				item_state_slots[SLOT_ID_RIGHT_HAND] = wielded_item_state
			else
				item_state_slots[SLOT_ID_LEFT_HAND] = initial(item_state)
				item_state_slots[SLOT_ID_RIGHT_HAND] = initial(item_state)
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
	if(!handle_pins(user))
		return 0

	var/mob/living/M = user
	if(dna_lock && attached_lock.stored_dna)
		if(!authorized_user(user))
			if(attached_lock.safety_level == 0)
				to_chat(M, "<span class='danger'>\The [src] buzzes in dissapointment and displays an invalid DNA symbol.</span>")
				return 0
			if(!attached_lock.exploding)
				if(attached_lock.safety_level == 1)
					to_chat(M, "<span class='danger'>\The [src] hisses in dissapointment.</span>")
					visible_message("<span class='game say'><span class='name'>\The [src]</span> announces, \"Self-destruct occurring in ten seconds.\"</span>", "<span class='game say'><span class='name'>\The [src]</span> announces, \"Self-destruct occurring in ten seconds.\"</span>")
					attached_lock.exploding = 1
					spawn(100)
						explosion(src, 0, 0, 3, 4)
						sleep(1)
						qdel(src)
					return 0
	if(MUTATION_HULK in M.mutations)
		to_chat(M, "<span class='danger'>Your fingers are much too large for the trigger guard!</span>")
		return 0
	if((MUTATION_CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
				user.visible_message(
					"<span class='danger'>\The [user] shoots [TU.himself] in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item_to_ground(src)
		else
			handle_click_empty(user)
		return 0
	return 1

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	update_appearance()

/obj/item/gun/equipped(mob/user, slot, flags)
	. = ..()
	update_appearance()

/obj/item/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return
	else
		Fire(A, user, params) //Otherwise, fire normally.
		return

/obj/item/gun/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/A = target
	if(!istype(A))
		return ..()
	if(user.a_intent == INTENT_HARM) //point blank shooting
		if (A == user && user.zone_sel.selecting == O_MOUTH && !mouthshoot)
			handle_suicide(user)
			return
		var/mob/living/L = user
		if(user && user.client && istype(L) && L.aiming && L.aiming.active && L.aiming.aiming_at != A && A != user)
			PreFire(A,user) //They're using the new gun system, locate what they're aiming at.
			return
		else
			Fire(A, user, pointblank=1)
			return
	return ..() //Pistolwhippin'

/obj/item/gun/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/dnalockingchip))
		if(dna_lock)
			to_chat(user, "<span class='notice'>\The [src] already has a [attached_lock].</span>")
			return
		if(!user.attempt_insert_item_for_installation(A, src))
			return
		to_chat(user, "<span class='notice'>You insert \the [A] into \the [src].</span>")
		attached_lock = A
		dna_lock = 1
		add_obj_verb(src, /obj/item/gun/verb/remove_dna)
		add_obj_verb(src, /obj/item/gun/verb/give_dna)
		add_obj_verb(src, /obj/item/gun/verb/allow_dna)
		return

	if(A.is_screwdriver())
		if(dna_lock && attached_lock && !attached_lock.controller_lock)
			to_chat(user, "<span class='notice'>You begin removing \the [attached_lock] from \the [src].</span>")
			playsound(src, A.tool_sound, 50, 1)
			if(do_after(user, 25 * A.tool_speed))
				to_chat(user, "<span class='notice'>You remove \the [attached_lock] from \the [src].</span>")
				user.put_in_hands(attached_lock)
				dna_lock = 0
				attached_lock = null
				remove_obj_verb(src, /obj/item/gun/verb/remove_dna)
				remove_obj_verb(src, /obj/item/gun/verb/give_dna)
				remove_obj_verb(src, /obj/item/gun/verb/allow_dna)
		else
			to_chat(user, "<span class='warning'>\The [src] is not accepting modifications at this time.</span>")

	if(A.is_multitool())
		if(!scrambled)
			to_chat(user, "<span class='notice'>You begin scrambling \the [src]'s electronic pins.</span>")
			playsound(src, A.tool_sound, 50, 1)
			if(do_after(user, 60 * A.tool_speed))
				switch(rand(1,100))
					if(1 to 10)
						to_chat(user, "<span class='danger'>The electronic pin suite detects the intrusion and explodes!</span>")
						user.show_message("<span class='danger'>SELF-DESTRUCTING...</span><br>", 2)
						explosion(get_turf(src), -1, 0, 2, 3)
						qdel(src)
					if(11 to 49)
						to_chat(user, "<span class='notice'>You fail to disrupt \the electronic warfare suite.</span>")
						return
					if(50 to 100)
						to_chat(user, "<span class='notice'>You disrupt \the electronic warfare suite.</span>")
						scrambled = 1
		else
			to_chat(user, "<span class='warning'>\The [src] does not have an active electronic warfare suite!</span>")

	if(A.is_wirecutter())
		if(pin && scrambled)
			to_chat(user, "<span class='notice'>You attempt to remove \the firing pin from \the [src].</span>")
			playsound(src, A.tool_sound, 50, 1)
			if(do_after(user, 60* A.tool_speed))
				switch(rand(1,100))
					if(1 to 10)
						to_chat(user, "<span class='danger'>You twist \the firing pin as you tug, destroying the firing pin.</span>")
						pin = null
					if(11 to 74)
						to_chat(user, "<span class='notice'>You grasp the firing pin, but it slips free!</span>")
						return
					if(75 to 100)
						to_chat(user, "<span class='notice'>You remove \the firing pin from \the [src].</span>")
						user.put_in_hands(src.pin)
						pin = null
			else if(!do_after())
				return
		else if(pin && !scrambled)
			to_chat(user, "<span class='notice'>The \the firing pin is firmly locked into \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] does not have a firing pin installed!</span>")

	..()

/obj/item/gun/emag_act(var/remaining_charges, var/mob/user)
	if(dna_lock && attached_lock.controller_lock)
		to_chat(user, "<span class='notice'>You short circuit the internal locking mechanisms of \the [src]!</span>")
		attached_lock.controller_dna = null
		attached_lock.controller_lock = 0
		attached_lock.stored_dna = list()
		return 1
	if(pin)
		pin.emag_act(remaining_charges, user)

/obj/item/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return
	if(target.z != user.z) return

	add_fingerprint(user)

	user.break_cloak()

	if(!special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			to_chat(user, "<span class='warning'>[src] is not ready to fire again!</span>")
		return

	if(check_safety())
		//If we are on harm intent (intending to injure someone) but forgot to flick the safety off, there is a 50% chance we
		//will reflexively do it anyway
		if(user.a_intent == INTENT_HARM && prob(50))
			toggle_safety(user)
		else
			handle_click_safety(user)
			return

	if(!user?.client?.is_preference_enabled(/datum/client_preference/help_intent_firing) && user.a_intent == INTENT_HELP)
		to_chat(user, SPAN_WARNING("You refrain from firing [src] because your intent is set to help!"))
		return

	var/shoot_time = (burst - 1)* burst_delay

	//These should apparently be disabled to allow for the automatic system to function without causing near-permanant paralysis. Re-enabling them while we sort that out.
	user.setClickCooldown(shoot_time) //no clicking on things while shooting

	next_fire_time = world.time + shoot_time

	var/held_twohanded = (user.can_wield_item(src) && src.is_held_twohanded(user))

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.

	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		user.newtonian_move(get_dir(target, user))		// Recoil

		process_accuracy(projectile, user, target, i, held_twohanded)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.zone_sel.selecting, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = 0

		last_shot = world.time


	// We do this down here, so we don't get the message if we fire an empty gun.
	if(user.is_holding(src) && user.hands_full())
		if(one_handed_penalty >= 20)
			to_chat(user, "<span class='warning'>You struggle to keep \the [src] pointed at the correct position with just one hand!</span>")

	var/target_for_log
	if(ismob(target))
		target_for_log = target
	else
		target_for_log = "[target.name]"

	add_attack_logs(user,target_for_log,"Fired gun [src.name] ([reflex ? "REFLEX" : "MANUAL"])")

	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracyw

	if(muzzle_flash)
		if(gun_light)
			set_light(light_brightness)
		else
			set_light(0)

// Similar to the above proc, but does not require a user, which is ideal for things like turrets.
/obj/item/gun/proc/Fire_userless(atom/target)
	if(!target)
		return

	if(world.time < next_fire_time)
		return

	var/shoot_time = (burst - 1)* burst_delay
	next_fire_time = world.time + shoot_time

	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in 1 to burst)
		var/obj/projectile = consume_next_projectile()
		if(!projectile)
			handle_click_empty()
			break

		if(istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile

			var/acc = burst_accuracy[min(i, burst_accuracy.len)]
			var/disp = dispersion[min(i, dispersion.len)]

			P.accuracy = accuracy + acc
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced = silenced

			P.old_style_target(target)
			P.fire()

			last_shot = world.time

			play_fire_sound()

			if(muzzle_flash)
				set_light(muzzle_flash)
			update_icon()

		//process_accuracy(projectile, user, target, acc, disp)

	//	if(pointblank)
	//		process_point_blank(projectile, user, target)

	//	if(process_projectile(projectile, null, target, user.zone_sel.selecting, clickparams))
	//		handle_post_fire(null, target, pointblank, reflex)

	//	update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			//pointblank = 0

	var/target_for_log
	if(ismob(target))
		target_for_log = target
	else
		target_for_log = "[target.name]"

	add_attack_logs("Unmanned",target_for_log,"Fired [src.name]")

	//update timing
	next_fire_time = world.time + fire_delay

	accuracy = initial(accuracy)	//Reset the gun's accuracy

	if(muzzle_flash)
		set_light(0)

//obtains the next projectile to fire
/obj/item/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	if(check_trajectory(target, user))
		return 1 // Magic numbers are fun.

//called if there was no projectile to shoot
/obj/item/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
	else
		visible_message("*click click*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/gun/proc/handle_click_safety(mob/user)
	user.visible_message(SPAN_WARNING("[user] squeezes the trigger of \the [src] but it doesn't move!"), SPAN_WARNING("You squeeze the trigger but it doesn't move!"), range = MESSAGE_RANGE_COMBAT_SILENCED)

//called after successfully firing
/obj/item/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(fire_anim)
		flick(fire_anim, src)

	if(silenced)
		to_chat(user, "<span class='warning'>You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]</span>")
		for(var/mob/living/L in oview(2,user))
			if(L.stat)
				continue
			if(L.blinded)
				to_chat(L, "You hear a [fire_sound_text]!")
				continue
			to_chat(L, 	"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>")
	else
		user.visible_message(
			"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>",
			"<span class='warning'>You fire \the [src][pointblank ? " point blank at \the [target]":""][reflex ? " by reflex":""]!</span>",
			"You hear a [fire_sound_text]!"
			)

	if(muzzle_flash)
		set_light(muzzle_flash)

	if(one_handed_penalty)
		if(!src.is_held_twohanded(user))
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

	if(recoil)
		spawn()
			shake_camera(user, recoil+1, recoil)
	update_icon()

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
			for(var/obj/item/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 2.5
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 1.5
	P.damage *= damage_mult

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

/obj/item/gun/proc/play_fire_sound(var/mob/user, var/obj/item/projectile/P)
	var/shot_sound = fire_sound

	if(!shot_sound && istype(P) && P.fire_sound) // If the gun didn't have a fire_sound, but the projectile exists, and has a sound...
		shot_sound = P.fire_sound
	if(!shot_sound) // If there's still no sound...
		return

	if(silenced)
		playsound(user, shot_sound, 10, 1)
	else
		playsound(user, shot_sound, 50, 1)

//Suicide handling.
/obj/item/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>

/obj/item/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<font color='red'>[user] sticks their gun in their mouth, ready to pull the trigger...</font>")
	if(!do_after(user, 40))
		M.visible_message("<font color=#4F49AF>[user] decided life was worth living</font>")
		mouthshoot = 0
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		play_fire_sound(M, in_chamber)
		if(istype(in_chamber, /obj/item/projectile/beam/lasertag))
			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
			mouthshoot = 0
			return

		in_chamber.on_hit(M)
		if(in_chamber.damage_type != HALLOSS && !in_chamber.nodamage)
			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
			user.death()
		else if(in_chamber.damage_type == HALLOSS)
			to_chat(user, "<span class = 'notice'>Ow...</span>")
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = 0
		return
	else
		handle_click_empty(user)
		mouthshoot = 0
		return

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
/obj/item/gun/zoom(tileoffset = 14, viewsize = 9, mob/user = usr)
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)

/obj/item/gun/examine(mob/user)
	. = ..()
	if(!no_pin_required)
		if(pin)
			. += "It has \a [pin] installed."
		else
			. += "It doesn't have a firing pin installed, and won't fire."
	if(firemodes.len > 1)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		. += "The fire selector is set to [current_mode.name]."
	if(safety_state != GUN_NO_SAFETY)
		to_chat(user, SPAN_NOTICE("The safety is [check_safety() ? "on" : "off"]."))

/obj/item/gun/proc/switch_firemodes(mob/user)
	if(firemodes.len <= 1)
		return null

	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = 1
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")
	playsound(loc, selector_sound, 50, 1)
	return new_mode

/obj/item/gun/attack_self(mob/user)
	switch_firemodes(user)

/obj/item/gun/proc/handle_pins(mob/living/user)
	if(no_pin_required)
		return TRUE
	if(pin)
		if(pin.pin_auth(user) || (pin.emagged))
			return 1
		else
			pin.auth_fail(user)
			return 0
	else
		to_chat(user, "<span class='warning'>[src]'s trigger is locked. This weapon doesn't have a firing pin installed!</span>")
	return 0

/obj/item/gun/update_overlays()
	. = ..()
	if(!(item_flags & ITEM_IN_INVENTORY))
		return
	. += image('icons/obj/gun/common.dmi', "safety_[check_safety()? "on" : "off"]")

/obj/item/gun/proc/toggle_safety(mob/user)
	if(user)
		if(user.stat || user.restrained() || user.incapacitated(INCAPACITATION_DISABLED))
			to_chat(user, SPAN_WARNING("You can't do that right now."))
			return
	if(safety_state == GUN_NO_SAFETY)
		to_chat(user, SPAN_WARNING("[src] has no safety."))
		return
	var/current = check_safety()
	switch(safety_state)
		if(GUN_SAFETY_ON)
			safety_state = GUN_SAFETY_OFF
		if(GUN_SAFETY_OFF)
			safety_state = GUN_SAFETY_ON
	if(user)
		user.visible_message(
			SPAN_WARNING("[user] switches the safety of \the [src] [current ? "off" : "on"]."),
			SPAN_NOTICE("You switch the safety of \the [src] [current ? "off" : "on"]."),
			SPAN_WARNING("You hear a switch being clicked."),
			MESSAGE_RANGE_COMBAT_SUBTLE
		)
	update_appearance()
	playsound(src, 'sound/weapons/flipblade.ogg', 10, 1)

/obj/item/gun/verb/toggle_safety_verb()
	set src in usr
	set category = "Object"
	set name = "Toggle Gun Safety"

	if(usr == loc)
		toggle_safety(usr)

/obj/item/gun/AltClick(mob/user)
	if(loc == user)
		toggle_safety(user)
		return TRUE
	return ..()

/**
 * returns TRUE/FALSE based on if we have safeties on
 */
/obj/item/gun/proc/check_safety()
	return (safety_state == GUN_SAFETY_ON)
