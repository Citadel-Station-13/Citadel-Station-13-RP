/**
 * Riding handler components
 *
 * Handles the motion tracking/pixel offsetting/etc of riding
 *
 * This component takes over **after** something is buckled to the atom.
 * Before that, riding_filter handles it.
 */
/datum/component/riding_handler
	//? disabled as we don't have dupe handling
	can_transfer = FALSE
	/// expected typepath of what we're handling for
	var/expected_typepath = /atom/movable
	/// del after last person unbuckles
	var/ephemeral = FALSE

	/// rider check flags : kicks people off if they don't meet these requirements.
	var/rider_check_flags = NONE
	/// ridden check flags : kicks people off if the parent atom doesn't meet these requirements.
	var/ridden_check_flags = NONE
	/// handler flags : determines some of our behavior
	var/riding_handler_flags = CF_RIDING_HANDLER_ALLOW_BORDER
	/// last dir. used to avoid redoing expensive setdir stuff
	var/_last_dir


	var/last_vehicle_move = 0 //used for move delays
	var/last_move_diagonal = FALSE
	var/vehicle_move_delay = 2 //tick delay between movements, lower = faster, higher = slower
	var/keytype

	var/slowed = FALSE
	var/slowvalue = 1

	var/list/riding_offsets = list()	//position_of_user = list(dir = list(px, py)), or RIDING_OFFSET_ALL for a generic one.
	var/list/directional_vehicle_layers = list()	//["[DIRECTION]"] = layer. Don't set it for a direction for default, set a direction to null for no change.
	var/list/directional_vehicle_offsets = list()	//same as above but instead of layer you have a list(px, py)
	var/list/allowed_turf_typecache
	var/list/forbid_turf_typecache					//allow typecache for only certain turfs, forbid to allow all but those. allow only certain turfs will take precedence.
	var/drive_verb = "drive"
	var/del_on_unbuckle_all = FALSE

/datum/component/riding_handler/Initialize()
	. = ..()
	if(. & COMPONENT_INCOMPATIBLE)
		return
	if(!istype(parent, expected_typepath))
		return COMPONENT_INCOMPATIBLE

/datum/component/riding_handler/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_BUCKLED, .proc/signal_hook_mob_buckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOB_UNBUCKLED, .proc/signal_hook_mob_unbuckled)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/signal_hook_handle_move)
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, .proc/signal_hook_handle_turn)

/datum/component/riding_handler/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOB_BUCKLED,
		COMSIG_MOVABLE_MOB_UNBUCKLED,
		COMSIG_MOVABLE_MOVED,
		COMSIG_ATOM_DIR_CHANGE
	))

#warn parse below

/datum/component/riding_handler/proc/vehicle_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	var/atom/movable/AM = parent
	restore_position(M)
	unequip_buckle_inhands(M)
	if(del_on_unbuckle_all && !AM.has_buckled_mobs())
		qdel(src)

/datum/component/riding_handler/proc/vehicle_mob_buckle(datum/source, mob/living/M, force = FALSE)
	handle_vehicle_offsets()

/datum/component/riding_handler/proc/handle_vehicle_layer()
	var/atom/movable/AM = parent
	var/static/list/defaults = list(TEXT_NORTH = OBJ_LAYER, TEXT_SOUTH = ABOVE_MOB_LAYER, TEXT_EAST = ABOVE_MOB_LAYER, TEXT_WEST = ABOVE_MOB_LAYER)
	. = defaults["[AM.dir]"]
	if(directional_vehicle_layers["[AM.dir]"])
		. = directional_vehicle_layers["[AM.dir]"]
	if(isnull(.))	//you can set it to null to not change it.
		. = AM.layer
	AM.layer = .

/datum/component/riding_handler/proc/set_vehicle_dir_layer(dir, layer)
	directional_vehicle_layers["[dir]"] = layer

/datum/component/riding_handler/proc/vehicle_moved(datum/source)
	var/atom/movable/AM = parent
	for(var/i in AM.buckled_mobs)
		ride_check(i)
	handle_vehicle_offsets()
	handle_vehicle_layer()

/datum/component/riding_handler/proc/ride_check(mob/living/M)
	var/atom/movable/AM = parent
	var/mob/AMM = AM
	if((ride_check_rider_restrained && M.restrained(TRUE)) || (ride_check_rider_incapacitated && M.incapacitated(FALSE, TRUE)) || (ride_check_ridden_incapacitated && istype(AMM) && AMM.incapacitated(FALSE, TRUE)))
		M.visible_message("<span class='warning'>[M] falls off of [AM]!</span>", \
						"<span class='warning'>You fall off of [AM]!</span>")
		AM.unbuckle_mob(M)
	return TRUE

/datum/component/riding_handler/proc/force_dismount(mob/living/M)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M)

/datum/component/riding_handler/proc/handle_vehicle_offsets()
	var/atom/movable/AM = parent
	var/AM_dir = "[AM.dir]"
	var/passindex = 0
	if(AM.has_buckled_mobs())
		for(var/m in AM.buckled_mobs)
			passindex++
			var/mob/living/buckled_mob = m
			var/list/offsets = get_offsets(passindex)
			var/rider_dir = get_rider_dir(passindex)
			buckled_mob.setDir(rider_dir)
			dir_loop:
				for(var/offsetdir in offsets)
					if(offsetdir == AM_dir)
						var/list/diroffsets = offsets[offsetdir]
						buckled_mob.pixel_x = diroffsets[1]
						if(diroffsets.len >= 2)
							buckled_mob.pixel_y = diroffsets[2]
						if(diroffsets.len == 3)
							buckled_mob.layer = diroffsets[3]
						break dir_loop
	var/list/static/default_vehicle_pixel_offsets = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
	var/px = default_vehicle_pixel_offsets[AM_dir]
	var/py = default_vehicle_pixel_offsets[AM_dir]
	if(directional_vehicle_offsets[AM_dir])
		if(isnull(directional_vehicle_offsets[AM_dir]))
			px = AM.pixel_x
			py = AM.pixel_y
		else
			px = directional_vehicle_offsets[AM_dir][1]
			py = directional_vehicle_offsets[AM_dir][2]
	AM.pixel_x = px
	AM.pixel_y = py

/datum/component/riding_handler/proc/set_vehicle_dir_offsets(dir, x, y)
	directional_vehicle_offsets["[dir]"] = list(x, y)

//Override this to set your vehicle's various pixel offsets
/datum/component/riding_handler/proc/get_offsets(pass_index) // list(dir = x, y, layer)
	. = list(TEXT_NORTH = list(0, 0), TEXT_SOUTH = list(0, 0), TEXT_EAST = list(0, 0), TEXT_WEST = list(0, 0))
	if(riding_offsets["[pass_index]"])
		. = riding_offsets["[pass_index]"]
	else if(riding_offsets["[RIDING_OFFSET_ALL]"])
		. = riding_offsets["[RIDING_OFFSET_ALL]"]

/datum/component/riding_handler/proc/set_riding_offsets(index, list/offsets)
	if(!islist(offsets))
		return FALSE
	riding_offsets["[index]"] = offsets

//Override this to set the passengers/riders dir based on which passenger they are.
//ie: rider facing the vehicle's dir, but passenger 2 facing backwards, etc.
/datum/component/riding_handler/proc/get_rider_dir(pass_index)
	var/atom/movable/AM = parent
	return AM.dir

//KEYS
/datum/component/riding_handler/proc/keycheck(mob/user)
	return !keytype || user.is_holding_item_of_type(keytype)

//BUCKLE HOOKS
/datum/component/riding_handler/proc/restore_position(mob/living/buckled_mob)
	if(buckled_mob)
		buckled_mob.pixel_x = 0
		buckled_mob.pixel_y = 0
		if(buckled_mob.client)
			buckled_mob.client.change_view(CONFIG_GET(string/default_view))

//MOVEMENT
/datum/component/riding_handler/proc/turf_check(turf/next, turf/current)
	if(allowed_turf_typecache && !allowed_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && allowed_turf_typecache[current.type])
	else if(forbid_turf_typecache && forbid_turf_typecache[next.type])
		return (allow_one_away_from_valid_turf && !forbid_turf_typecache[current.type])
	return TRUE

/datum/component/riding_handler/proc/handle_ride(mob/user, direction)
	var/atom/movable/AM = parent
	if(user.incapacitated())
		Unbuckle(user)
		return

	if(world.time < last_vehicle_move + ((last_move_diagonal? 2 : 1) * vehicle_move_delay))
		return
	last_vehicle_move = world.time

	if(keycheck(user))
		var/turf/next = get_step(AM, direction)
		var/turf/current = get_turf(AM)
		if(!istype(next) || !istype(current))
			return	//not happening.
		if(!turf_check(next, current))
			to_chat(user, "<span class='warning'>Your \the [AM] can not go onto [next]!</span>")
			return
		if(!Process_Spacemove(direction) || !isturf(AM.loc))
			return
		step(AM, direction)

		if((direction & (direction - 1)) && (AM.loc == next))		//moved diagonally
			last_move_diagonal = TRUE
		else
			last_move_diagonal = FALSE

		handle_vehicle_layer()
		handle_vehicle_offsets()
	else
		to_chat(user, "<span class='warning'>You'll need the keys in one of your hands to [drive_verb] [AM].</span>")

/datum/component/riding_handler/proc/Unbuckle(atom/movable/M)
	addtimer(CALLBACK(parent, /atom/movable/.proc/unbuckle_mob, M), 0, TIMER_UNIQUE)

/datum/component/riding_handler/proc/Process_Spacemove(direction)
	var/atom/movable/AM = parent
	return override_allow_spacemove || AM.has_gravity()

/datum/component/riding_handler/proc/account_limbs(mob/living/M)
	if(M.get_num_legs() < 2 && !slowed)
		vehicle_move_delay = vehicle_move_delay + slowvalue
		slowed = TRUE
	else if(slowed)
		vehicle_move_delay = vehicle_move_delay - slowvalue
		slowed = FALSE

///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding_handler/human
	del_on_unbuckle_all = TRUE

/datum/component/riding_handler/human/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, .proc/on_host_unarmed_melee)

/datum/component/riding_handler/human/vehicle_mob_unbuckle(datum/source, mob/living/M, force = FALSE)
	var/mob/living/carbon/human/H = parent
	H.remove_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING)
	. = ..()

/datum/component/riding_handler/human/vehicle_mob_buckle(datum/source, mob/living/M, force = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = parent
	H.add_movespeed_modifier(MOVESPEED_ID_HUMAN_CARRYING, multiplicative_slowdown = HUMAN_CARRY_SLOWDOWN)

/datum/component/riding_handler/human/proc/on_host_unarmed_melee(atom/target)
	var/mob/living/carbon/human/H = parent
	if(H.a_intent == INTENT_DISARM && (target in H.buckled_mobs))
		force_dismount(target)

/datum/component/riding_handler/human/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.buckled_mobs && AM.buckled_mobs.len)
		for(var/mob/M in AM.buckled_mobs) //ensure proper layering of piggyback and carry, sometimes weird offsets get applied
			M.layer = MOB_LAYER
		if(!AM.buckle_lying)
			if(AM.dir == SOUTH)
				AM.layer = ABOVE_MOB_LAYER
			else
				AM.layer = OBJ_LAYER
		else
			if(AM.dir == NORTH)
				AM.layer = OBJ_LAYER
			else
				AM.layer = ABOVE_MOB_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding_handler/human/get_offsets(pass_index)
	var/mob/living/carbon/human/H = parent
	if(H.buckle_lying)
		return list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(0, 6), TEXT_WEST = list(0, 6))
	else
		return list(TEXT_NORTH = list(0, 6), TEXT_SOUTH = list(0, 6), TEXT_EAST = list(-6, 4), TEXT_WEST = list( 6, 4))


/datum/component/riding_handler/human/force_dismount(mob/living/user)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(user)
	user.Paralyze(60)
	user.visible_message("<span class='warning'>[AM] pushes [user] off of [AM.p_them()]!</span>", \
						"<span class='warning'>[AM] pushes you off of [AM.p_them()]!</span>")

/datum/component/riding_handler/cyborg
	del_on_unbuckle_all = TRUE

/datum/component/riding_handler/cyborg/ride_check(mob/user)
	var/atom/movable/AM = parent
	if(user.incapacitated())
		var/kick = TRUE
		if(iscyborg(AM))
			var/mob/living/silicon/robot/R = AM
			if(R.module && R.module.ride_allow_incapacitated)
				kick = FALSE
		if(kick)
			to_chat(user, "<span class='userdanger'>You fall off of [AM]!</span>")
			Unbuckle(user)
			return
	if(iscarbon(user))
		var/mob/living/carbon/carbonuser = user
		if(!carbonuser.get_num_arms())
			Unbuckle(user)
			to_chat(user, "<span class='warning'>You can't grab onto [AM] with no hands!</span>")
			return

/datum/component/riding_handler/cyborg/handle_vehicle_layer()
	var/atom/movable/AM = parent
	if(AM.buckled_mobs && AM.buckled_mobs.len)
		if(AM.dir == SOUTH)
			AM.layer = ABOVE_MOB_LAYER
		else
			AM.layer = OBJ_LAYER
	else
		AM.layer = MOB_LAYER

/datum/component/riding_handler/cyborg/get_offsets(pass_index) // list(dir = x, y, layer)
	return list(TEXT_NORTH = list(0, 4), TEXT_SOUTH = list(0, 4), TEXT_EAST = list(-6, 3), TEXT_WEST = list( 6, 3))

/datum/component/riding_handler/cyborg/handle_vehicle_offsets()
	var/atom/movable/AM = parent
	if(AM.has_buckled_mobs())
		for(var/mob/living/M in AM.buckled_mobs)
			M.setDir(AM.dir)
			if(iscyborg(AM))
				var/mob/living/silicon/robot/R = AM
				if(istype(R.module))
					M.pixel_x = R.module.ride_offset_x[dir2text(AM.dir)]
					M.pixel_y = R.module.ride_offset_y[dir2text(AM.dir)]
			else
				..()

/datum/component/riding_handler/cyborg/force_dismount(mob/living/M)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(M)
	var/turf/target = get_edge_target_turf(AM, AM.dir)
	var/turf/targetm = get_step(get_turf(AM), AM.dir)
	M.Move(targetm)
	M.visible_message("<span class='warning'>[M] is thrown clear of [AM]!</span>", \
					"<span class='warning'>You're thrown clear of [AM]!</span>")
	M.throw_at(target, 14, 5, AM)
	M.Paralyze(60)

/datum/component/riding_handler/proc/equip_buckle_inhands(mob/living/carbon/human/user, amount_required = 1, riding_target_override = null)
	var/atom/movable/AM = parent
	var/amount_equipped = 0
	for(var/amount_needed = amount_required, amount_needed > 0, amount_needed--)
		var/obj/item/riding_offhand/inhand = new /obj/item/riding_offhand(user)
		if(!riding_target_override)
			inhand.rider = user
		else
			inhand.rider = riding_target_override
		inhand.parent = AM
		if(user.put_in_hands(inhand, TRUE))
			amount_equipped++
		else
			break
	if(amount_equipped >= amount_required)
		return TRUE
	else
		unequip_buckle_inhands(user)
		return FALSE

/datum/component/riding_handler/proc/unequip_buckle_inhands(mob/living/carbon/user)
	var/atom/movable/AM = parent
	for(var/obj/item/riding_offhand/O in user.contents)
		if(O.parent != AM)
			CRASH("RIDING OFFHAND ON WRONG MOB")
			continue
		if(O.selfdeleting)
			continue
		else
			qdel(O)
	return TRUE

/obj/item/offhand/riding
	name = "riding offhand"
	desc = "Your hand is full carrying someone on you!"
	/// riding handler component
	var/datum/component/riding_handler/mob/handler

	#warn impl

#warn parse below
	var/mob/living/carbon/rider
	var/mob/living/parent
	var/selfdeleting = FALSE


/obj/item/riding_offhand/Destroy()
	var/atom/movable/AM = parent
	if(selfdeleting)
		if(rider in AM.buckled_mobs)
			AM.unbuckle_mob(rider)
	. = ..()
