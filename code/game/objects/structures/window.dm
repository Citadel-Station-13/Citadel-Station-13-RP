#define FULLTILE_SMOOTHING (SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window
	abstract_type = /obj/structure/window

	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures/windowpanes.dmi'
	icon_state = null
	base_icon_state = "window"
	armor_type = /datum/armor/window

	density = TRUE
	can_be_unanchored = TRUE
	pass_flags_self = ATOM_PASS_GLASS
	CanAtmosPass = ATMOS_PASS_PROC
	w_class = ITEMSIZE_NORMAL
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE

	plane = OBJ_PLANE
	layer = WINDOW_LAYER
	atom_flags = ATOM_BORDER

	layer = WINDOW_LAYER
	pressure_resistance = (4 * ONE_ATMOSPHERE)
	anchored = TRUE
	atom_flags = ATOM_BORDER

	integrity = 20
	integrity_max = 20
	integrity_failure = 0

	hit_sound_brute = 'sound/effects/Glasshit.ogg'

	/// are we reinforced? this is only to modify our construction state/steps.
	var/considered_reinforced = FALSE
	/// construction state
	var/construction_state = WINDOW_STATE_SECURED_TO_FRAME
	/// determines if we're a full tile window, NOT THE ICON STATE.
	var/fulltile = FALSE
	/// can deconstruct at all
	var/allow_deconstruct = TRUE
	/// i'm so sorry we have to do this - set to dir for allowthrough purposes
	var/moving_right_now
	var/maximal_heat = T0C + 100 // Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 // Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/shardtype = /obj/item/material/shard
	/// Set this in subtypes. Null is assumed strange osr otherwise impossible to dismantle, such as for shuttle glass.
	var/glasstype = null
	/// number of units of silicate.
	var/silicate = 0
	/// Holder for the crack overlay.
	var/mutable_appearance/crack_overlay

/obj/structure/window/Initialize(mapload, start_dir, constructed = FALSE)
	. = ..(mapload)
	/// COMPATIBILITY PATCH - Replace this crap with a better solution (maybe copy /tg/'s ASAP!!)
	// unfortunately no longer a compatibility patch ish due to clickcode...
	check_fullwindow()
	if (start_dir)
		setDir(start_dir)
	//player-constructed windows
	if (constructed)
		set_anchored(FALSE)
		construction_state = WINDOW_STATE_UNSECURED
		update_verbs()
	AIR_UPDATE_ON_INITIALIZE_AUTO
	if(fulltile)
		if(considered_reinforced)
			icon = 'icons/obj/structures/window_reinforced.dmi'
			icon_state = "window-0"
		else
			icon = 'icons/obj/structures/window.dmi'
			icon_state = "window-0"


/obj/structure/window/Destroy()
	AIR_UPDATE_ON_DESTROY_AUTO
	set_density(FALSE)
	update_nearby_icons()
	return ..()

/obj/structure/window/Move()
	moving_right_now = dir
	. = ..()
	setDir(moving_right_now)
	moving_right_now = null

/obj/structure/window/Moved(atom/oldloc)
	. = ..()
	AIR_UPDATE_ON_MOVED_AUTO

	// Makes sure the window doesn't keep it's smoothed state when moved.
	if (smoothing_junction)
		update_nearby_icons()

/obj/structure/window/examine_integrity(mob/user)
	. = list()

	if(integrity == integrity_max)
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		var/perc = percent_integrity()
		if(perc > 0.75)
			. += "<span class='notice'>It has a few cracks.</span>"
		else if(perc > 0.5)
			. += "<span class='warning'>It looks slightly damaged.</span>"
		else if(perc > 0.25)
			. += "<span class='warning'>It looks moderately damaged.</span>"
		else
			. += "<span class='danger'>It looks heavily damaged.</span>"
	if(silicate)
		if (silicate < 30)
			. += "<span class='notice'>It has a thin layer of silicate.</span>"
		else if (silicate < 70)
			. += "<span class='notice'>It is covered in silicate.</span>"
		else
			. += "<span class='notice'>There is a thick layer of silicate covering it.</span>"

/obj/structure/window/damage_integrity(amount, gradual, do_not_break)
	var/initial_integrity = integrity
	. = ..()
	if(gradual)
		update_appearance(UPDATE_ICON)
		return
	if(integrity < integrity_max / 4 && initial_integrity >= integrity_max / 4)
		visible_message("[src] looks like it's about to shatter!" )
		update_appearance(UPDATE_ICON)
	else if(integrity < integrity_max / 2 && initial_integrity >= integrity_max / 2)
		visible_message("[src] looks seriously damaged!" )
		update_appearance(UPDATE_ICON)
	else if(integrity < integrity_max * 3/4 && initial_integrity >= integrity_max * 3/4 && integrity > 0)
		visible_message("Cracks begin to appear in [src]!" )
		update_appearance(UPDATE_ICON)

/obj/structure/window/proc/apply_silicate(amount)
	if(integrity < integrity_max)
		heal_integrity(amount * 3)
		if(integrity == integrity_max)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		update_appearance()

/obj/structure/window/atom_destruction()
	shatter_feedback()
	return ..()

/obj/structure/window/proc/shatter_feedback()
	playsound(src, "shatter", 70, 1)
	visible_message("[src] shatters!")

/obj/structure/window/setDir(newdir)
	. = ..()
	update_nearby_tiles()

/obj/structure/window/set_anchored(anchorvalue)
	. = ..()
	update_nearby_tiles() // Atmos update
	if (anchorvalue)
		smoothing_flags |= SMOOTH_OBJ
	else
		smoothing_flags &= ~SMOOTH_OBJ
	update_nearby_icons() // Icon update

/obj/structure/window/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return

	if(fulltile)
		return FALSE

	// Check direction of movement, get the opposite direction, and check if it's blocked.
	if(get_dir(mover, target) & global.reverse_dir[dir])
		return FALSE

	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/moved_window = mover
		return valid_window_location(loc, moved_window.dir, is_fulltile = moved_window.fulltile)

	if(istype(mover, /obj/structure/windoor_assembly) || istype(mover, /obj/machinery/door/window))
		return valid_window_location(loc, mover.dir, is_fulltile = FALSE)

	return TRUE

/obj/structure/window/CanAtmosPass(turf/T, d)
	if (fulltile || (d == dir))
		return anchored? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED
	return ATMOS_PASS_NOT_BLOCKED

/obj/structure/window/can_pathfinding_enter(atom/movable/actor, dir, datum/pathfinding/search)
	return ..() || (!fulltile && (src.dir) != dir)

/obj/structure/window/can_pathfinding_exit(atom/movable/actor, dir, datum/pathfinding/search)
	return ..() || (!fulltile && (src.dir != dir))

/obj/structure/window/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && (check_standard_flag_pass(mover)))
		return TRUE
	if(!fulltile && get_dir(src, target) & dir)
		return !density
	return TRUE

/obj/structure/window/attack_tk(mob/user)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, TRUE)

/obj/structure/window/attack_hand(mob/user, list/params)
	if(user.a_intent == INTENT_HARM)
		return ..()

	user.setClickCooldown(user.get_attack_speed())

	playsound(loc, 'sound/effects/glassknock.ogg', 80, TRUE)
	user.visible_message(
		SPAN_NOTICE("[user.name] knocks on the [name]."),
		SPAN_NOTICE("You knock on the [name]."),
		SPAN_HEAR("You hear a knocking sound."),
	)

/obj/structure/window/attackby(obj/item/object, mob/user)
	if(user.a_intent == INTENT_HARM)
		return ..()

	// Fixing.
	if (istype(object, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
		var/obj/item/weldingtool/WT = object
		if (integrity < integrity_max)
			if (WT.remove_fuel(1, user))
				to_chat(user, SPAN_NOTICE("You begin repairing [src]..."))
				playsound(src, WT.tool_sound, 50, TRUE)
				if (do_after(user, 40 * WT.tool_speed, target = src))
					set_integrity(integrity_max)
					// playsound(src, 'sound/items/Welder.ogg', 50, 1)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You repair [src]."))
		else
			to_chat(user, SPAN_WARNING("[src] is already in good condition!"))
		return

	else if (istype(object, /obj/item/stack/cable_coil) && considered_reinforced && construction_state == WINDOW_STATE_UNSECURED && !istype(src, /obj/structure/window/reinforced/polarized))
		var/obj/item/stack/cable_coil/C = object
		if (C.use(1))
			playsound(src.loc, 'sound/effects/sparks1.ogg', 75, TRUE)
			user.visible_message(
				message = SPAN_NOTICE("\The [user] begins to wire \the [src] for electrochromic tinting."),
				self_message = SPAN_NOTICE("You begin to wire \the [src] for electrochromic tinting."),
				blind_message = SPAN_HEAR("You hear sparks."),
			)

			if (do_after(user, 20 * C.tool_speed, src) && construction_state == WINDOW_STATE_UNSECURED)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, TRUE)
				var/obj/structure/window/reinforced/polarized/P
				if(fulltile)
					P = new /obj/structure/window/reinforced/polarized/full(loc)
				else
					P = new(loc, dir)
				P.integrity_max = integrity_max
				P.set_integrity(integrity_max)
				P.construction_state = construction_state
				P.set_anchored(anchored)
				qdel(src)
		return

	else if (istype(object, /obj/item/frame) && anchored)
		var/obj/item/frame/F = object
		F.try_build(src, user)
		return

	return ..()

/obj/structure/window/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch (passed_mode)
		if (RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)

/obj/structure/window/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch (passed_mode)
		if (RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	. = ..()
	if (exposed_temperature > maximal_heat)
		inflict_atom_damage(damage_per_fire_tick, flag = ARMOR_FIRE, gradual = TRUE)

/obj/structure/window/drop_products(method, atom/where)
	. = ..()
	if (method == ATOM_DECONSTRUCT_DISASSEMBLED)
		if (glasstype)
			new glasstype(where, fulltile? 2 : 1)
		return
	if (shardtype)
		new shardtype(where)
		if (fulltile)
			// nah no for loop
			new shardtype(where)

/obj/structure/window/screwdriver_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = TRUE
	if(!allow_deconstruct)
		e_args.initiator.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE

	if (construction_state == WINDOW_STATE_UNSECURED || construction_state == WINDOW_STATE_SCREWED_TO_FLOOR || !considered_reinforced)
		if (!use_screwdriver(I, e_args, flags))
			return

		var/unsecuring = construction_state != WINDOW_STATE_UNSECURED
		e_args.chat_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the frame [unsecuring? "from" : "to"] the floor."), src)
		if (unsecuring)
			construction_state = WINDOW_STATE_UNSECURED
			set_anchored(FALSE)
		else
			construction_state = WINDOW_STATE_SCREWED_TO_FLOOR
			set_anchored(TRUE)
		CanAtmosPass = anchored ? (fulltile ? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_PROC) : ATMOS_PASS_NOT_BLOCKED
		update_verbs()
		return

	if (construction_state != WINDOW_STATE_CROWBRARED_IN && construction_state != WINDOW_STATE_SECURED_TO_FRAME)
		return

	if (!use_screwdriver(I, e_args, flags))
		return

	var/unsecuring = construction_state == WINDOW_STATE_SECURED_TO_FRAME
	e_args.chat_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the window [unsecuring? "from" : "to"] the frame."), src)
	construction_state = unsecuring ? WINDOW_STATE_CROWBRARED_IN : WINDOW_STATE_SECURED_TO_FRAME


/obj/structure/window/crowbar_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = TRUE
	if(!allow_deconstruct)
		e_args.initiator.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE
	if (!considered_reinforced)
		return
	if (construction_state != WINDOW_STATE_CROWBRARED_IN && construction_state != WINDOW_STATE_SCREWED_TO_FLOOR)
		return
	if (!use_crowbar(I, e_args, flags))
		return
	var/unsecuring = construction_state == WINDOW_STATE_CROWBRARED_IN
	e_args.chat_feedback(SPAN_NOTICE("You pry [src] [unsecuring ? "out of" : "into"] the frame."), src)
	construction_state = unsecuring ? WINDOW_STATE_SCREWED_TO_FLOOR : WINDOW_STATE_CROWBRARED_IN


/obj/structure/window/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = TRUE
	if(!allow_deconstruct)
		e_args.initiator.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE
	if (construction_state != WINDOW_STATE_UNSECURED)
		e_args.chat_feedback(SPAN_WARNING("[src] has to be entirely unfastened from the floor before you can disasemble it!"))
		return
	if (!use_wrench(I, e_args, flags))
		return
	e_args.chat_feedback(SPAN_NOTICE("You disassemble [src]."), src)
	deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)


/obj/structure/window/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	if(!allow_deconstruct)
		return
	if (construction_state == WINDOW_STATE_UNSECURED)
		. = list(
			TOOL_SCREWDRIVER = list(
				"fasten frame" = dyntool_image_forward(TOOL_SCREWDRIVER),
			),
			TOOL_WRENCH = list(
				"deconstruct" = dyntool_image_backward(TOOL_WRENCH),
			),
		)
	else if (!considered_reinforced)
		. = list(
			TOOL_SCREWDRIVER = list(
				"unfasten frame" = dyntool_image_backward(TOOL_SCREWDRIVER),
			),
		)
	else
		switch (construction_state)
			if (WINDOW_STATE_SCREWED_TO_FLOOR)
				. = list(
					TOOL_SCREWDRIVER = list(
						"unfasten frame" = dyntool_image_backward(TOOL_SCREWDRIVER),
					),
					TOOL_CROWBAR = list(
						"seat pane" = dyntool_image_forward(TOOL_CROWBAR),
					),
				)
			if (WINDOW_STATE_CROWBRARED_IN)
				. = list(
					TOOL_SCREWDRIVER = list(
						"fasten pane" = dyntool_image_forward(TOOL_SCREWDRIVER),
					),
					TOOL_CROWBAR = list(
						"unseat pane" = dyntool_image_backward(TOOL_CROWBAR),
					),
				)
			if (WINDOW_STATE_SECURED_TO_FRAME)
				. = list(
					TOOL_SCREWDRIVER = list(
						"unfasten pane" = dyntool_image_backward(TOOL_SCREWDRIVER),
					),
				)
	return merge_double_lazy_assoc_list(., ..())

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_appearance()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)

//merges adjacent full-tile windows into one
/obj/structure/window/update_overlays(updates=ALL)
	. = ..()
	if(QDELETED(src) || !fulltile)
		return

	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK)))
		QUEUE_SMOOTH(src)

	// TODO: Atom Integrity
	var/ratio = percent_integrity()
	ratio = CEILING(ratio*4, 1) * 25
	cut_overlay(crack_overlay)
	if(ratio > 75)
		return
	crack_overlay = mutable_appearance('icons/obj/structures/window_damage.dmi', "damage[ratio]", -(layer+0.1))
	. += crack_overlay

/obj/structure/window/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/obj/structure/window/proc/check_fullwindow()
	if (dir & (dir - 1)) // Diagonal!
		fulltile = TRUE

	if (fulltile)
		// clickcode requires this :(
		atom_flags &= ~ATOM_BORDER
		// update: atmos code now requires tihs :(
		CanAtmosPass = ATMOS_PASS_AIR_BLOCKED

/obj/structure/window/verb/rotate_counterclockwise()
	set name = "Rotate Counterclockwise" // Temporary fix until someone more intelligent figures out how to add proper rotation verbs to the panels
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated())
		return FALSE

	if (fulltile)
		return FALSE

	if (anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return FALSE

	setDir(turn(dir, 90))
	update_appearance()

/obj/structure/window/verb/rotate_clockwise()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if (usr.incapacitated())
		return FALSE

	if (fulltile)
		return FALSE

	if (anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return FALSE

	setDir(turn(dir, 270))
	update_appearance()

/// Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if (anchored || fulltile)
		remove_obj_verb(src, /obj/structure/window/verb/rotate_counterclockwise)
		remove_obj_verb(src, /obj/structure/window/verb/rotate_clockwise)
	else if (!fulltile)
		add_obj_verb(src, /obj/structure/window/verb/rotate_counterclockwise)
		add_obj_verb(src, /obj/structure/window/verb/rotate_clockwise)

/proc/place_window(mob/user, loc, obj/item/stack/material/ST, var/fulltile = FALSE, var/constructed = FALSE)
	var/required_amount = 4
	var/windowtype
	if(istype(ST, /obj/item/stack/material/glass))
		windowtype = /obj/structure/window/basic/full
	if(istype(ST, /obj/item/stack/material/glass/reinforced))
		windowtype = /obj/structure/window/reinforced/full
	if(istype(ST, /obj/item/stack/material/glass/phoronglass))
		windowtype = /obj/structure/window/phoronbasic/full
	if(istype(ST, /obj/item/stack/material/glass/phoronrglass))
		windowtype = /obj/structure/window/phoronreinforced/full

	if (!ST.can_use(required_amount))
		to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
		return
	for(var/obj/structure/window/W in loc)
		if(W.check_fullwindow()) //two fulltile windows
			to_chat(user, SPAN_NOTICE("There is already a window there."))
			return
	to_chat(user, SPAN_NOTICE("You start placing the window."))
	if(do_after(user,20))
		for(var/obj/structure/window/W in loc)
			if(W.check_fullwindow())
				to_chat(user, SPAN_NOTICE("There is already a window there."))
				return

		if (ST.use(required_amount))
			var/obj/structure/window/WD = new windowtype(get_turf(loc), null, TRUE)
			to_chat(user, SPAN_NOTICE("You place [WD]."))
		else
			to_chat(user, SPAN_NOTICE("You do not have enough sheets."))
			return

/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... almost anything, really should shatter it."
	icon_state = "window"

	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 500 // Bumping it up a bit, so that a small fire doesn't instantly melt it. Also, makes sense as glass starts softening at around ~700 C
	damage_per_fire_tick = 2.0
	integrity = 20
	integrity_max = 20

/obj/structure/window/basic/full
	base_icon_state = "window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	integrity = 40
	integrity_max = 40
	canSmoothWith = FULLTILE_SMOOTHING
	color = GLASS_COLOR
	alpha = 180

	fulltile = TRUE

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	icon_state = "phoronwindow"

	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = INFINITY // This is high-grade atmospherics glass. Let's not have it burn, mmmkay?
	damage_per_fire_tick = 1.0
	integrity = 80
	integrity_max = 80


/obj/structure/window/phoronbasic/full
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	integrity = 160
	integrity_max = 160
	canSmoothWith = FULLTILE_SMOOTHING

	fulltile = TRUE
	color = GLASS_COLOR_SILICATE
	alpha = 180

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	icon_state = "phoronrwindow"

	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass

	integrity = 120
	integrity_max = 120

	considered_reinforced = TRUE
	maximal_heat = INFINITY // Same here. The reinforcement is just structural anyways
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.

/obj/structure/window/phoronreinforced/full
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = FULLTILE_SMOOTHING
	// canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	integrity = 240
	integrity_max = 240
	fulltile = TRUE
	color = GLASS_COLOR_SILICATE
	alpha = 180

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	armor_type = /datum/armor/window/reinforced

	glasstype = /obj/item/stack/material/glass/reinforced

	integrity = 80
	integrity_max = 80
	considered_reinforced = TRUE
	maximal_heat = T0C + 1000 // Bumping this as well, as most fires quickly get over 800 C
	damage_per_fire_tick = 2.0

/obj/structure/window/reinforced/full
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = FULLTILE_SMOOTHING
	// canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	integrity = 160
	integrity_max = 160
	fulltile = TRUE
	color = GLASS_COLOR
	alpha = 180

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	opacity = TRUE
/obj/structure/window/reinforced/tinted/full
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "rwindow-full"
	integrity = 80
	integrity_max = 80
	fulltile = TRUE

	color = GLASS_COLOR_TINTED
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = FULLTILE_SMOOTHING

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	color = GLASS_COLOR_FROSTED
	alpha = 180

// TODO: Recreate this.
/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/structures/window.dmi'
	icon_state = "window"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)
	// canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_SHUTTLE_PARTS)

	integrity = 160
	integrity_max = 160
	considered_reinforced = TRUE
	fulltile = TRUE

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."

	var/id

/obj/structure/window/reinforced/polarized/full
	icon = 'icons/obj/structures/window_full_reinforced.dmi'
	icon_state = "window-0"

	color = GLASS_COLOR
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)
	integrity = 160
	integrity_max = 160
	alpha = 180
	color = GLASS_COLOR
	fulltile = TRUE

/obj/structure/window/reinforced/polarized/attackby(obj/item/object, mob/user)
	if (istype(object, /obj/item/multitool) && !anchored) // Only allow programming if unanchored!

		// First check if they have a windowtint button buffered.
		var/obj/item/multitool/MT = object
		if (istype(MT.connectable, /obj/machinery/button/windowtint))
			var/obj/machinery/button/windowtint/buffered_button = MT.connectable
			id = buffered_button.id
			to_chat(user, SPAN_NOTICE("\The [src] is linked to \the [buffered_button]."))
			return TRUE

		// Otherwise fall back to asking them.
		var/new_id = tgui_input_text(
			user = user,
			message = "Enter the ID for the window.",
			title = name,
			default = id,
		)
		if (new_id && user.get_active_held_item() == object && in_range(src, user))
			id = new_id
			to_chat(user, SPAN_NOTICE("The new ID of \the [src] is [id]"))
			return TRUE
	. = ..()

/obj/structure/window/reinforced/polarized/proc/toggle()
	if (opacity)
		animate(src, color = GLASS_COLOR, time=5)
		set_opacity(FALSE)
	else
		animate(src, color = GLASS_COLOR_FROSTED, time=5)
		set_opacity(TRUE)

/obj/structure/window/wooden
	name = "wooden panel"
	desc = "A set of wooden panelling, designed to hide the drab grey walls."
	icon_state = "woodpanel"

	glasstype = /obj/item/stack/material/wood
	shardtype = /obj/item/material/shard/wood
	maximal_heat = T0C + 300 // Same as wooden walls "melting"
	damage_per_fire_tick = 2.0
	integrity = 40
	integrity_max = 40
	opacity = TRUE
