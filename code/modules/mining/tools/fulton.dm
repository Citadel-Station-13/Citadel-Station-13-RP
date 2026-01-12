GLOBAL_LIST_EMPTY(total_extraction_beacons)

// todo: this should be included in the air-support module being added later, not just a mining exclusive

/obj/item/extraction_pack
	name = "fulton extraction pack"
	desc = "A balloon pack that can be used to extract equipment or personnel to a Fulton Recovery Beacon. Anything not bolted down can be moved. Link the pack to a beacon by using the pack in hand."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_pack"
	w_class = WEIGHT_CLASS_NORMAL
	/// Beacon weakref
	var/datum/weakref/beacon_ref
	/// List of networks
	var/list/beacon_networks = list("station")
	/// Number of uses left
	var/uses_left = 3
	/// Can be used indoors
	var/can_use_indoors
	/// Can be used on living creatures
	var/safe_for_living_creatures = TRUE
	var/stuntime = 15
	/// Maximum force that can be used to extract
	var/max_force_fulton = MOVE_FORCE_STRONG

/obj/item/extraction_pack/wormhole
	name = "wormhole fulton extraction pack"
	desc = "A balloon pack with integrated wormhole technology and less disruptive movement that can be used to extract equipment or personnel to a Fulton Recovery Beacon. Anything not bolted down can be moved. Link the pack to a beacon by using the pack in hand."
	can_use_indoors = TRUE
	stuntime = 3

/obj/item/extraction_holdercrate
	name = "extraction crate"
	desc = "A regular old crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "phoroncrate"

/obj/item/extraction_pack/examine()
	. = ..()
	. += SPAN_INFOPLAIN("It has [uses_left] use\s remaining.")

	var/obj/structure/extraction_point/beacon = beacon_ref?.resolve()

	if(isnull(beacon))
		beacon_ref = null
		. += SPAN_INFOPLAIN("It is not linked to a beacon.")
		return

	. += SPAN_INFOPLAIN("It is linked to [beacon.name].")

/obj/item/extraction_pack/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	var/list/possible_beacons = list()
	for(var/datum/weakref/point_ref as anything in GLOB.total_extraction_beacons)
		var/obj/structure/extraction_point/extraction_point = point_ref.resolve()
		if(isnull(extraction_point))
			GLOB.total_extraction_beacons.Remove(point_ref)
			continue
		if(extraction_point.beacon_network in beacon_networks)
			possible_beacons += extraction_point

	if(!length(possible_beacons))
		balloon_alert(user, "no beacons")
		return

	var/chosen_beacon = tgui_input_list(user, "Beacon to connect to", "Balloon Extraction Pack", sortNames(possible_beacons))
	if(isnull(chosen_beacon))
		return

	beacon_ref = WEAKREF(chosen_beacon)
	balloon_alert(user, "linked!")

/obj/item/extraction_pack/afterattack(atom/interacting_with, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(!ismovable(interacting_with))
		return
	if(!isturf(interacting_with.loc)) // no extracting stuff inside other stuff
		return
	var/atom/movable/thing = interacting_with
	if(thing.anchored)
		return

	var/obj/structure/extraction_point/beacon = beacon_ref?.resolve()
	if(isnull(beacon))
		balloon_alert(user, "not linked!")
		beacon_ref = null
		return
	var/turf/turf = get_turf(thing)
	if(!can_use_indoors)
		if(!turf?.outdoors)
			balloon_alert(user, "not outdoors!")
			return
	if(!safe_for_living_creatures && check_for_living_mobs(thing))
		to_chat(user, SPAN_WARNING("[src] is not safe for use with living creatures, they wouldn't survive the trip back!"))
		balloon_alert(user, "not safe!")
		return
	if(thing.move_resist > max_force_fulton)
		balloon_alert(user, "too heavy!")
		return

	balloon_alert_to_viewers("attaching...")
	playsound(thing, 'sound/items/zip.ogg', vol = 50, vary = TRUE)
	if(isliving(thing))
		var/mob/living/creature = thing
		if(creature.mind)
			to_chat(thing, SPAN_USERDANGER("You are being extracted! Stand still to proceed."))

	if(!do_after(user, 5 SECONDS, target = thing))
		return

	balloon_alert_to_viewers("extracting!")
	// if(loc == user && ishuman(user))
	// 	var/mob/living/carbon/human/human_user = user
	// 	human_user.back?.atom_storage?.attempt_insert(src, user, force = STORAGE_SOFT_LOCKED)
	uses_left--

	if(uses_left <= 0)
		user.transfer_item_to_loc(src, thing, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)

	if(isliving(thing))
		var/mob/living/creature = thing
		creature.set_paralyzed(32 SECONDS) // Keep them from moving during the duration of the extraction
		if(creature.buckled)
			creature.buckled.unbuckle_mob(creature, TRUE) // Unbuckle them to prevent anchoring problems
	else
		thing.set_anchored(TRUE)
		thing.set_density(FALSE)

	var/obj/effect/extraction_holder/holder_obj = new(get_turf(thing))
	holder_obj.appearance = thing.appearance
	thing.forceMove(holder_obj)
	var/mutable_appearance/balloon2 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_expand", layer = ABOVE_MOB_LAYER+0.1, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon2.pixel_z = 10
	holder_obj.add_overlay(balloon2)
	addtimer(CALLBACK(src, PROC_REF(create_balloon), thing, user, holder_obj, balloon2), 0.4 SECONDS)

/obj/item/extraction_pack/proc/create_balloon(atom/movable/thing, mob/living/user, obj/effect/extraction_holder/holder_obj, mutable_appearance/balloon2)
	var/mutable_appearance/balloon = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_balloon", layer = ABOVE_MOB_LAYER+0.1, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon.pixel_z = 10
	holder_obj.cut_overlay(balloon2)
	holder_obj.add_overlay(balloon)
	playsound(holder_obj.loc, 'sound/items/fultext_deploy.ogg', vol = 50, vary = TRUE, extrarange = -3)

	animate(holder_obj, pixel_z = 10, time = 2 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)

	sleep(6 SECONDS)

	playsound(holder_obj.loc, 'sound/items/fultext_launch.ogg', vol = 50, vary = TRUE, extrarange = -3)
	animate(holder_obj, pixel_z = 1000, time = 3 SECONDS, flags = ANIMATION_RELATIVE)

	if(ishuman(thing))
		var/mob/living/carbon/human/creature = thing
		creature.set_unconscious(0)
		creature.drowsyness = 0
		creature.set_sleeping(0)

	sleep(3 SECONDS)

	var/turf/flooring_near_beacon = list()
	var/turf/beacon_turf = get_turf(beacon_ref.resolve())
	for(var/turf/floor as anything in RANGE_TURFS(1, beacon_turf))
		if(!floor.is_blocked_turf())
			flooring_near_beacon += floor

	if(!length(flooring_near_beacon))
		flooring_near_beacon += beacon_turf

	holder_obj.forceMove(pick(flooring_near_beacon))

	animate(holder_obj, pixel_z = -990, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)

	sleep(7 SECONDS)

	var/mutable_appearance/balloon3 = mutable_appearance('icons/obj/fulton_balloon.dmi', "fulton_retract", layer = ABOVE_MOB_LAYER+0.1, appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM | KEEP_APART)
	balloon3.pixel_z = 10
	holder_obj.cut_overlay(balloon)
	holder_obj.add_overlay(balloon3)

	sleep(0.4 SECONDS)

	holder_obj.cut_overlay(balloon3)
	thing.set_anchored(FALSE) // An item has to be unanchored to be extracted in the first place.
	thing.set_density(initial(thing.density))
	animate(holder_obj, pixel_z = -10, time = 0.5 SECONDS, flags = ANIMATION_RELATIVE)
	sleep(0.5 SECONDS)
	thing.forceMove(holder_obj.loc)
	qdel(holder_obj)
	if(uses_left <= 0)
		qdel(src)

/obj/item/fulton_core
	name = "extraction beacon assembly kit"
	desc = "When built, emits a signal which fulton recovery devices can lock onto. Activate in hand to unfold into a beacon."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "subspace_amplifier"

/obj/item/fulton_core/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!do_after(user, 1.5 SECONDS, target = user) || QDELETED(src))
		return

	new /obj/structure/extraction_point(get_turf(user))
	playsound(src, 'sound/items/Deconstruct.ogg', vol = 50, vary = TRUE, extrarange = -5)
	qdel(src)

/obj/structure/extraction_point
	name = "fulton recovery beacon"
	desc = "A beacon for the fulton recovery system. Activate a pack in your hand to link it to a beacon."
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_point"
	anchored = TRUE
	density = FALSE
	var/beacon_network = "station"

/obj/structure/extraction_point/Initialize(mapload)
	. = ..()
	name += " ([rand(100,999)]) ([get_area_name(src, TRUE)])"
	GLOB.total_extraction_beacons.Add(WEAKREF(src))

/obj/structure/extraction_point/attack_hand(mob/living/user, datum/event_args/actor/clickchain/e_args)
	. = ..()
	balloon_alert_to_viewers("undeploying...")
	if(!do_after(user, 1.5 SECONDS, src))
		return
	new /obj/item/fulton_core(drop_location())
	playsound(src, 'sound/items/Deconstruct.ogg', vol = 50, vary = TRUE, extrarange = -5)
	qdel(src)

/obj/effect/extraction_holder
	name = "extraction holder"
	desc = "you shouldnt see this"
	var/atom/movable/stored_obj

/obj/item/extraction_pack/proc/check_for_living_mobs(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.stat != DEAD)
			return TRUE
	for(var/thing in A.get_all_contents())
		if(isliving(A))
			var/mob/living/L = A
			if(L.stat != DEAD)
				return TRUE
	return FALSE

/obj/effect/extraction_holder/singularity_act()
	return

/obj/effect/extraction_holder/singularity_pull(atom/singularity, current_size)
	return
