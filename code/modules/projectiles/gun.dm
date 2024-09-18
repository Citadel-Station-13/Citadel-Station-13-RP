/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()

	/// state key for rendering, if any
	var/render_key

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
	description_info = "This is a gun.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
		then click where you want to fire."
	icon = 'icons/obj/gun/ballistic.dmi'
	icon_state = "detective"
	item_state = "gun"
	item_flags = ITEM_ENCUMBERS_WHILE_HELD | ITEM_ENCUMBERS_ONLY_HELD
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	materials_base = list(MAT_STEEL = 2000)
	rad_flags = RAD_BLOCK_CONTENTS
	w_class = WEIGHT_CLASS_NORMAL
	throw_force = 5
	throw_speed = 4
	throw_range = 5
	damage_force = 5
	damage_tier = MELEE_TIER_MEDIUM
	preserve_item = 1
	origin_tech = list(TECH_COMBAT = 1)
	attack_verb = list("struck", "hit", "bashed")
	zoomdevicename = "scope"
	inhand_default_type = INHAND_DEFAULT_ICON_GUNS

	//* Accuracy, Dispersion, Instability *//

	/// entirely disable baymiss on fired projectiles
	///
	/// * this is a default value; set to null by default to have the projectile's say.
	var/accuracy_disabled = null

	// legacy below //

	var/burst = 1
	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/move_delay = 1
	var/fire_sound = null // This is handled by projectile.dm's fire_sound var now, but you can override the projectile's fire_sound with this one if you want to.
	var/fire_sound_text = "gunshot"
	var/fire_anim = null
	var/recoil = 0		//screen shake
	var/suppressible = FALSE
	var/silenced = FALSE
	var/silenced_icon = null
	var/muzzle_flash = 3
	var/accuracy = 65   //Accuracy is measured in percents. +15 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -15 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null
	var/list/burst_accuracy = list(0) //allows for different accuracies for each shot in a burst. Applied on top of accuracy
	var/list/dispersion = list(0)
	var/mode_name = null
	// todo: purge with fire
	var/projectile_type = /obj/projectile	//On ballistics, only used to check for the cham gun
	var/holy = FALSE //For Divinely blessed guns
	// todo: this should be on /ballistic, and be `internal_chambered`.
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

	//Gun Malfunction variables
	var/unstable = 0
	var/destroyed = 0

	//* Rendering
	/// renderer datum we use for world rendering of the gun item itself
	/// set this in prototype to a path
	/// if null, we will not perform default rendering/updating of item states.
	///
	/// * anonymous types are allowed and encouraged.
	/// * the renderer defaults to [base_icon_state || initial(icon_state)] for the base icon state to append to.
	var/datum/gun_item_renderer/item_renderer
	/// for de-duping
	var/static/list/item_renderer_store = list()
	/// renderer datum we use for mob rendering of the gun when held / worn
	/// set this in prototype to a path
	/// if null, we will not perform default rendering/updating of onmob states
	///
	/// * anonymous types are allowed and encouraged.
	/// * the renderer defaults to [base_icon_state || render_mob_base || initial(icon_state)] for the base icon state to append to.
	var/datum/gun_mob_renderer/mob_renderer
	/// for de-duping
	var/static/list/mob_renderer_store = list()
	/// base onmob state override so we don't use [base_icon_state] if overridden
	//  todo: impl
	var/render_mob_base
	/// render as -wield if we're wielded? applied at the end of our worn state no matter what
	///
	/// * ignores [mob_renderer]
	/// * ignores [render_additional_exclusive] / [render_additional_worn]
	//  todo: impl
	var/render_mob_wielded = FALSE
	/// state to add as an append
	///
	/// * segment and overlay renders add [base_icon_state]-[append]
	/// * state renders set state to [base_icon_state]-[append]-[...rest]
	var/render_additional_state
	/// only render [render_additional_state]
	var/render_additional_exclusive = FALSE
	/// [render_additional_state] and [render_additional_exclusive] apply to worn sprites
	//  todo: impl
	var/render_additional_worn = FALSE
	/// use the old render system, if item_renderer and mob_renderer are not set
	//  todo: remove
	var/render_use_legacy_by_default = TRUE

/obj/item/gun/Initialize(mapload)
	. = ..()

	// instantiate & dedupe renderers
	var/requires_icon_update
	if(item_renderer)
		if(ispath(item_renderer) || IS_ANONYMOUS_TYPEPATH(item_renderer))
			item_renderer = new item_renderer
		var/item_renderer_key = item_renderer.dedupe_key()
		item_renderer = item_renderer_store[item_renderer_key] || (item_renderer_store[item_renderer_key] = item_renderer)
		requires_icon_update = TRUE
	if(mob_renderer)
		if(ispath(mob_renderer) || IS_ANONYMOUS_TYPEPATH(mob_renderer))
			mob_renderer = new mob_renderer
		var/mob_renderer_key = mob_renderer.dedupe_key()
		mob_renderer = mob_renderer_store[mob_renderer_key] || (mob_renderer_store[mob_renderer_key] = mob_renderer)
		requires_icon_update = TRUE
	if(requires_icon_update)
		update_icon()

	//! LEGACY: if neither of these are here, we are using legacy render.
	if(!item_renderer && !mob_renderer && render_use_legacy_by_default)
		item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi',
			)

	for(var/i in 1 to firemodes.len)
		var/key = firemodes[i]
		if(islist(key))
			firemodes[i] = new /datum/firemode(src, key)
		else if(IS_ANONYMOUS_TYPEPATH(key))
			firemodes[i] = new key
		else if(ispath(key))
			firemodes[i] = new key
	if(length(firemodes))
		sel_mode = 0
		switch_firemodes()

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	if(pin)
		pin = new pin(src)

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
			LAZYINITLIST(item_state_slots)
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

/obj/item/gun/afterattack(atom/target, mob/living/user, clickchain_flags, list/params)
	if(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)
		return
	if(!istype(user))
		return

	var/shitty_legacy_params = list2params(params)
	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != target)
		PreFire(target,user,shitty_legacy_params) //They're using the new gun system, locate what they're aiming at.
		return
	else
		Fire(target, user, shitty_legacy_params) //Otherwise, fire normally.
		return

/obj/item/gun/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/A = target
	if(!istype(A))
		return ..()
	if(user.a_intent == INTENT_HARM) //point blank shooting
		// todo: disabled for now
		// if (A == user && user.zone_sel.selecting == O_MOUTH && !mouthshoot)
		// 	handle_suicide(user)
		// 	return
		var/mob/living/L = user
		if(user && user.client && istype(L) && L.aiming && L.aiming.active && L.aiming.aiming_at != A && A != user)
			PreFire(A,user) //They're using the new gun system, locate what they're aiming at.
			return
		else
			Fire(A, user, pointblank=1)
			return
	return ..() //Pistolwhippin'

/obj/item/gun/attackby(obj/item/A, mob/user)
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

	if(!user?.client?.get_preference_toggle(/datum/game_preference_toggle/game/help_intent_firing) && user.a_intent == INTENT_HELP)
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

		if(istype(projectile, /obj/projectile))
			var/obj/projectile/P = projectile

			var/acc = burst_accuracy[min(i, burst_accuracy.len)]
			var/disp = dispersion[min(i, dispersion.len)]

			P.accuracy_overall_modify *= 1 + acc / 100
			P.dispersion = disp

			P.shot_from = src.name
			P.silenced = silenced

			P.old_style_target(target)
			play_fire_sound(P = projectile)
			P.fire()

			last_shot = world.time

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
			if(L.has_status_effect(/datum/status_effect/sight/blindness))
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
	var/obj/projectile/P = projectile
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
	P.damage_force *= damage_mult

/obj/item/gun/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
	var/obj/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	var/acc_mod = burst_accuracy[min(burst, burst_accuracy.len)]
	var/disp_mod = dispersion[min(burst, dispersion.len)]

	if(one_handed_penalty)
		if(!held_twohanded)
			acc_mod += -CEILING(one_handed_penalty/2, 1)
			disp_mod += one_handed_penalty*0.5 //dispersion per point of two-handedness

	//Accuracy modifiers
	if(!isnull(accuracy_disabled))
		P.accuracy_disabled = accuracy_disabled

	P.accuracy_overall_modify *= 1 + (acc_mod / 100)
	P.accuracy_overall_modify *= 1 - (user.get_accuracy_penalty() / 100)
	P.dispersion = disp_mod

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy_overall_modify *= 1.3

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy_overall_modify += 1 + (M.accuracy / 100)
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)

//does the actual launching of the projectile
/obj/item/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
	var/obj/projectile/P = projectile
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
		else if(IS_PRONE(mob))
			forcespread = rand(-15, 15)
	var/launched = !P.launch_from_gun(target, target_zone, user, params, null, forcespread, src)

	if(launched)
		play_fire_sound(user, P)

	return launched

/obj/item/gun/proc/play_fire_sound(var/mob/user, var/obj/projectile/P)
	var/shot_sound = fire_sound

	if(!shot_sound && istype(P) && P.fire_sound) // If the gun didn't have a fire_sound, but the projectile exists, and has a sound...
		shot_sound = P.fire_sound
	if(!shot_sound) // If there's still no sound...
		return

	if(silenced)
		playsound(src, shot_sound, 10, 1)
	else
		playsound(src, shot_sound, 50, 1)

// todo: rework all this this is fucking dumb
//Suicide handling.
// /obj/item/gun/var/mouthshoot = 0 //To stop people from suiciding twice... >.>

// /obj/item/gun/proc/handle_suicide(mob/living/user)
// 	if(!ishuman(user))
// 		return
// 	var/mob/living/carbon/human/M = user

// 	mouthshoot = 1
// 	M.visible_message("<font color='red'>[user] sticks their gun in their mouth, ready to pull the trigger...</font>")
// 	if(!do_after(user, 40))
// 		M.visible_message("<font color=#4F49AF>[user] decided life was worth living</font>")
// 		mouthshoot = 0
// 		return
// 	var/obj/projectile/in_chamber = consume_next_projectile()
// 	if (istype(in_chamber))
// 		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
// 		play_fire_sound(M, in_chamber)
// 		if(istype(in_chamber, /obj/projectile/beam/lasertag))
// 			user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
// 			mouthshoot = 0
// 			return

// 		in_chamber.on_hit(M)
// 		if(in_chamber.damage_type != DAMAGE_TYPE_HALLOSS && !in_chamber.nodamage)
// 			log_and_message_admins("[key_name(user)] commited suicide using \a [src]")
// 			user.apply_damage(in_chamber.damage_force*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
// 			user.death()
// 		else if(in_chamber.damage_type == DAMAGE_TYPE_HALLOSS)
// 			to_chat(user, "<span class = 'notice'>Ow...</span>")
// 			user.apply_effect(110,AGONY,0)
// 		qdel(in_chamber)
// 		mouthshoot = 0
// 		return
// 	else
// 		handle_click_empty(user)
// 		mouthshoot = 0
// 		return

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

/obj/item/gun/examine(mob/user, dist)
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
	if(user)
		to_chat(user, "<span class='notice'>\The [src] is now set to [new_mode.name].</span>")
		playsound(loc, selector_sound, 50, 1)
	return new_mode

/obj/item/gun/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
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
	set category = VERB_CATEGORY_OBJECT
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

// PENDING FIREMODE REWORK
/obj/item/gun/proc/legacy_get_firemode()
	return firemodes[sel_mode]

//* Ammo *//

/**
 * Gets the ratio of our ammo left
 *
 * * Used by rendering
 *
 * @return number as 0 to 1, inclusive
 */
/obj/item/gun/proc/get_ammo_ratio()
	return 0

//* Rendering *//

/obj/item/gun/update_icon(updates)
	if(!item_renderer && !mob_renderer)
		return ..()
	cut_overlays()
	var/ratio_left = get_ammo_ratio()
	var/datum/firemode/using_firemode = legacy_get_firemode()
	item_renderer?.render(src, ratio_left, using_firemode?.render_key)
	var/needs_worn_update = mob_renderer?.render(src, ratio_left, using_firemode?.render_key)
	// todo: render_mob_wielded
	if(needs_worn_update)
		update_worn_icon()
	return ..()
