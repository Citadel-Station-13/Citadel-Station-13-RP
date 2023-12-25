/**
 * Guns: common implementation of weapons that throw some kind of projectile,
 * or are aimable with firemode/burst/scope/etc support.
 *
 * # Keybind Priority
 *
 * When two functions need the same bind, they are to be resolved with the following,
 * and any of the following keys *must* have these functions as long as there's
 * not a competing function and a good reason to overrule:
 *
 * * use in hand / attack_self() --> rack
 * * alt click --> safety
 * * ctrl click --> firemode
 * * click with other hand --> eject magazine/bullet
 * * drag onto user or a hand slot --> pickup
 *
 * This will obviously not apply universally, and is most relevant to ballistic weapons,
 * as energy weapons do not have racking (normally) or magazines (normally) and will
 * therefore likely use attack_self() firemode change instead.
 */
/obj/item/gun
	name = "gun"
	desc = "Devs fucked up."

	#warn sprite

	#warn impl keybind priority

	attack_verb = list("struck", "hit", "bashed")
	item_flags = ITEM_ENCUMBERS_WHILE_HELD | ITEM_ENCUMBERS_ONLY_HELD
	rad_flags = RAD_BLOCK_CONTENTS
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	w_class = WEIGHT_CLASS_NORMAL

	damage_force = 10
	damage_tier = MELEE_TIER_MEDIUM

	//* Accuracy & Stability
	/// recoil to inflict per shot
	var/recoil = GUN_RECOIL_NONE
	/// multiplier to recoil to inflict per shot when wielded
	var/recoil_wielded_multiplier = 1
	/// screenshake forced; null = auto
	var/recoil_screen_shake
	/// instability applied per tile moved
	var/instability_motion = GUN_INSTABILITY_MOTION_NONE
	/// instability applied when drawing the weapon out
	var/instability_draw = GUN_INSTABILITY_DRAW_NONE
	/// instability applied when wielding the weapon
	var/instability_wield = GUN_INSTABILITY_WIELD_NONE
	/// how sensitive we are to instability ; multiplied to instability of firer
	var/instability_sensitivity = 1
	/// inherent instability stored on gun
	/// picking up or wielding a gun only applies instability to that gun
	var/instability_stored = 0
	/// recovery factor
	#warn what should this mean?
	var/instability_recovery = GUN_INSTABILITY_RECOVERY_NORMAL
	/// last instability decay time
	var/instability_decay

	//* Attachments *//
	/// all attached attachments
	var/list/obj/item/gun_attachment/attachments

	//* Firemodes
	/// current firemode
	var/datum/firemode/firemode
	/// available firemodes
	var/list/datum/firemode/regex_this_firemodes

	//* Firing
	/// mid firing
	var/firing = FALSE
	/// default fire delay between firings.
	/// not shots, not bursts, though we will never alloy two simutaneous firings.
	/// this is overridden by firemode, and will *lower the user's clickdelay*.
	var/fire_delay = 4
	/// last fire time
	var/fire_last
	/// current firing cycle. used to be 1000% unreasonably sure that we don't fire a burst shot in another cycle.
	var/firing_cycle = 0
	/// current firer ; used to know when to abort when necesary / do other checks.
	var/atom/movable/firing_user

	//* Pins
	/// our firing pin ; set to path to init on creation
	var/obj/item/firing_pin/pin = /obj/item/firing_pin
	/// requires pin?
	var/no_pin_required = FALSE

	//* Rendering
	/// renderer datum we use for world rendering of the gun item itself
	/// set this in prototype to a path or an instance via 'render_system = new /datum/gun_renderer/...(...)'
	/// if null, we will not perform default rendering/updating of item states.
	var/datum/gun_renderer/render_system

	/// perform onmob state rendering?
	/// if FALSE, we will not perform default rendering/updating of mob states.
	var/render_mob_enabled = FALSE

	/// base onmob state override so we don't use base_icon_state if overridden
	var/render_mob_base
	/// we render to worn_state as well as inhand_state; this is an override because
	/// most guns do not have different states for every slot, as opposed to inhands.
	var/render_mob_slots = FALSE

	/// how many states are there
	var/render_mob_count
	/// use empty "-0" state append when empty?
	var/render_mob_empty
	/// if set to TRUE, firemode is appended to state before count
	var/render_mob_firemode
	/// appended after
	var/render_mob_append
	/// only use the append, ignoring count and firemode while this is enabled; use this for mag-out states for energy weapons & similar
	var/render_mob_exclusive
	/// render as -wielded if we're wielded? applied at the end, even while [render_mob_exclusive] is on.
	var/render_mob_wielded = FALSE

	#warn impl above

	//* Safety
	/// whether or not we have safeties and if safeties are on
	var/safety_state = GUN_SAFETY_ON

	//* SFX
	/// default firing sound
	/// todo: priority is undefined right now :/
	#warn do it
	var/fire_sound = "gunshot"

	//* Wielding
	/// allow wielding
	var/wieldable = FALSE

/obj/item/gun/Initialize(mapload)
	. = ..()
	if(ispath(pin))
		pin = new pin
	init_firemodes()

//* Ammo *//

/**
 * gets % of total ammo as number from 0 to 1.
 * used in icon update procs for modularity,
 * so that we don't need to have multiple
 * versions of the core icon generation system.
 */
/obj/item/gun/proc/get_ammo_percent()
	return 1

/**
 * get approximate shots left
 * used for examines and counters
 */
/obj/item/gun/proc/get_ammo_amount()
	return 0

//* Attachments *//

/obj/item/gun/proc/attempt_attachment(datum/event_args/actor/actor, obj/item/gun_attachment/attachment)

/obj/item/gun/proc/attach_attachment(obj/item/gun_attachment/attachment)

/obj/item/gun/proc/detach_attachment(obj/item/gun_attachment/attachment, atom/newLoc = drop_location())
	if(newLoc == FALSE)
		newLoc = null

/obj/item/gun/proc/why_cant_fit_attachment(obj/item/gun_attachment/attachment)

/obj/item/gun/proc/on_attach_attachment(obj/item/gun_attachment/attachment)

/obj/item/gun/proc/on_detach_attachment(obj/item/gun_attachment/attachment)

#warn impl all

//* Firing *//

/**
 * terminate the current firing cycle
 */
/obj/item/gun/proc/stop_firing()
	if(!firing)
		return
	++firing_cycle

/**
 * Perform a full firing sequence
 *
 * @params
 * * target - what to aim at / the 'original' var for projectile
 * * user - what's firing us, usually a mob but coudl be an obj
 * * where - (optional) this weirdly named variable is the original turf of the click, used for guns that don't use angles.
 * * angle - (optional) the angle to shoot in. what this means to different guns can differ, and some guns can completely ignore this
 * * reflex - is it an automatic fire from aiming/hostage taking?
 * * burst_amount - how many shots to fire
 * * burst_interval - delay between shots
 * * point_blank - allow point blanking
 */
/obj/item/gun/proc/firing_sequence(atom/target, atom/movable/user, turf/where, angle, reflex, burst_amount, burst_interval, point_blank)
	#warn resolve where/angle/etc from target/user/self/etc if it's not there, because we use this for userless too
	var/current_cycle = firing_cycle
	#warn impl

/**
 * Fire a single projectile
 *
 * @return TRUE/FALSE; false for failure, will always terminate burst.
 */
/obj/item/gun/proc/fire(atom/target, atom/movable/user, turf/where, angle, reflex, point_blank)
	#warn impl

/**
 * Should we keep firing? We stop anyways if fire() returns false.
 */
/obj/item/gun/proc/should_keep_firing(current_cycle)
	if(current_cycle != firing_cycle)
		return FALSE
	return TRUE

/**
 * called after firing
 *
 * @params
 * * target - original target
 * * user - firing user
 * * where - turf targeted
 * * angle - angle firing in
 * * reflex - was this a reflexive fire?
 * * iteration - burst iteration
 */
/obj/item/gun/proc/post_fire(atom/target, atom/movable/user, turf/where, angle, reflex, iteration)
	return

/**
 * check if we can fire
 *
 * @return GUN_FIRE_* define.
 */
/obj/item/gun/proc/can_fire(atom/target, atom/movable/user, turf/where, angle, reflex, iteration)
	return GUN_FIRE_SUCCESS

/**
 * called after a fire() fails and the firing sequence is interrupted
 *
 * fire_return is the GUN_FIRE_* define that describes why it failed.
 */
/obj/item/gun/proc/failed_fire(atom/target, atom/movable/user, turf/where, angle, reflex, iteration, fire_return)
	switch(fire_return)
		if(GUN_FIRE_NO_AMMO)
			handle_fire_empty(target, user, where, angle, reflex, iteration)

/**
 * called when we fail to fire due to no next projectile
 */
/obj/item/gun/proc/handle_fire_empty(atom/target, atom/movable/user, turf/where, angle, reflex, iteration)
	return

//* Inventory *//

/obj/item/gun/unequipped(mob/user, slot, flags)
	. = ..()
	if(firing && user == firing_user)
		stop_firing()

/obj/item/gun/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	update_appearance()

/obj/item/gun/equipped(mob/user, slot, flags)
	. = ..()
	update_appearance()

//* Rendering *//

/obj/item/gun/update_icon(updates)
	if(!render_system_active)
		return ..()
	// clear overlays
	cut_overlays()
	// reset states
	icon_state = base_icon_state
	inhand_state = base_worn_state || base_icon_state
	if(use_mob_states)
	// priority 1: append
	if(!isnull(render_append_state))
		icon_state += render_append_state
		if(render_append_inhand)
			worn_state += render_append_state
	// check append override mode
	if(render_append_exclusive)
		return ..()
	// priority 2: firemode
	switch(render_firemode_world)
		if(GUN_RENDERING_OVERLAYS)
		if(GUN_RENDERING_STATES)
	switch(render_firemode_inhand)
	// priority 3: ammo
	switch(render_ammo_world)
		if(GUN_RENDERING_OVERLAYS)
		if(GUN_RENDERING_STATES)
		if(GUN_RENDERING_SEGMENTS)
	switch(render_ammo_inhand)
	#warn dea lwith all this via renderers for the gun itself

	// do default behavior last
	. = ..()
	// update inhand
	update_worn_icon()

//* Restock

/**
 * restock the gun to full, whatever that means in the context of the gun
 */
/obj/item/gun/proc/restock_to_full()
	return

#warn below

/obj/item/gun
	icon = 'icons/obj/gun/ballistic.dmi'
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"

	throw_force = 5
	throw_speed = 4
	throw_range = 5
	damage_force = 5
	damage_tier = MELEE_TIER_MEDIUM
	preserve_item = 1
	zoomdevicename = "scope"

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

	var/wielded_item_state
	var/one_handed_penalty = 0 // Penalty applied if someone fires a two-handed gun with one hand.
	var/atom/movable/screen/auto_target/auto_target

	//aiming system stuff
	var/keep_aim = 1 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = 0 //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

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

	var/scrambled = 0

/obj/item/gun/projectile/CtrlClick(mob/user)
	if(can_flashlight && ishuman(user) && src.loc == usr && !user.incapacitated(INCAPACITATION_ALL))
		toggle_flashlight()
	else
		return ..()

/obj/item/gun/projectile/proc/toggle_flashlight()
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
	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

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
/obj/item/gun/projectile/proc/special_check(var/mob/user)

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

	return 1


/obj/item/gun/projectile/afterattack(atom/target, mob/living/user, clickchain_flags, list/params)
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

/obj/item/gun/projectile/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
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

/obj/item/gun/projectile/attackby(obj/item/A, mob/user)

	#warn get rid of this fucking shitcode

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

/obj/item/gun/projectile/emag_act(var/remaining_charges, var/mob/user)
	if(pin)
		pin.emag_act(remaining_charges, user)

/obj/item/gun/projectile/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
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
/obj/item/gun/projectile/proc/Fire_userless(atom/target)
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

//used by aiming code
/obj/item/gun/projectile/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	if(check_trajectory(target, user))
		return 1 // Magic numbers are fun.

//called if there was no projectile to shoot
/obj/item/gun/projectile/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
	else
		visible_message("*click click*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/gun/projectile/proc/handle_click_safety(mob/user)
	user.visible_message(SPAN_WARNING("[user] squeezes the trigger of \the [src] but it doesn't move!"), SPAN_WARNING("You squeeze the trigger but it doesn't move!"), range = MESSAGE_RANGE_COMBAT_SILENCED)

//called after successfully firing
/obj/item/gun/projectile/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
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

/obj/item/gun/projectile/proc/process_accuracy(obj/projectile, mob/living/user, atom/target, var/burst, var/held_twohanded)
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
/obj/item/gun/projectile/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)
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

/obj/item/gun/projectile/proc/play_fire_sound(var/mob/user, var/obj/projectile/P)
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
/obj/item/gun/projectile/var/mouthshoot = 0 //To stop people from suiciding twice... >.>

/obj/item/gun/projectile/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = 1
	M.visible_message("<font color='red'>[user] sticks their gun in their mouth, ready to pull the trigger...</font>")
	if(!do_after(user, 40))
		M.visible_message("<font color=#4F49AF>[user] decided life was worth living</font>")
		mouthshoot = 0
		return
	var/obj/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		play_fire_sound(M, in_chamber)
		if(istype(in_chamber, /obj/projectile/beam/lasertag))
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

/obj/item/gun/projectile/proc/toggle_scope(var/zoom_amount=2.0)
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
/obj/item/gun/projectile/zoom(tileoffset = 14, viewsize = 9, mob/user = usr)
	..()
	if(!zoom)
		accuracy = initial(accuracy)
		recoil = initial(recoil)

/obj/item/gun/projectile/examine(mob/user, dist)
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

/obj/item/gun/projectile/proc/switch_firemodes(mob/user)
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

/obj/item/gun/projectile/attack_self(mob/user)
	. = ..()
	if(.)
		return
	switch_firemodes(user)

/obj/item/gun/projectile/proc/handle_pins(mob/living/user)
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

//* Firemodes

/obj/item/gun/proc/set_firemode(datum/firemode/mode)
	firemode = mode
	#warn impl

/obj/item/gun/proc/init_firemodes()
	if(length(regex_this_firemodes))
		for(var/i in 1 to length(regex_this_firemodes))
			var/val = regex_this_firemodes
			if(ispath(val))
				regex_this_firemodes[i] = new val
		set_firemode(regex_this_firemodes[1])
	else if(istype(regex_this_firemodes, /datum/firemode))
		regex_this_firemodes = list(regex_this_firemodes)
		set_firemode(regex_this_firemodes[1])
	else if(ispath(regex_this_firemodes))
		regex_this_firemodes = list(new regex_this_firemodes)
		set_firemode(regex_this_firemodes[1])
	else
		CRASH("gun didn't have a firemode. why is it even a gun if so?")

//* Safeties

/obj/item/gun/update_overlays()
	. = ..()
	if(!(item_flags & ITEM_IN_INVENTORY))
		return
	. += image('icons/modules/projectiles/guns/common.dmi', "safety_[check_safety()? "on" : "off"]")

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
