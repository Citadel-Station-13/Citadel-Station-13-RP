/obj/structure/window
	abstract_type = /obj/structure/window

	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures/windowpanes.dmi'
	icon_state = null
	base_icon_state = "window"

	density = TRUE
	can_be_unanchored = TRUE
	pass_flags_self = ATOM_PASS_GLASS
	CanAtmosPass = ATMOS_PASS_PROC
	w_class = ITEMSIZE_NORMAL
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE

	layer = WINDOW_LAYER
	pressure_resistance = (4 * ONE_ATMOSPHERE)
	anchored = TRUE
	atom_flags = ATOM_BORDER

	integrity = 20
	integrity_max = 20
	integrity_failure = 0

	hit_sound = 'sound/effects/Glasshit.ogg'

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

/obj/structure/window/damage_integrity(amount, gradual)
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

/obj/structure/window/blob_act()
	take_damage(50)

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

/obj/structure/window/bullet_act(obj/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if (!proj_damage)
		return

	take_damage(proj_damage)

	return ..()

/obj/structure/window/legacy_ex_act(severity)
	switch (severity)
		if (1.0)
			qdel(src)
		if (2.0)
			shatter(FALSE)
		if (3.0)
			if (prob(50))
				shatter(FALSE)
	return

/obj/structure/window/blob_act()
	take_damage(50)

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

//? Does this work? idk. Let's call it TBI.
/obj/structure/window/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if (!density)
		return TRUE

	if ((fulltile) || (dir == to_dir))
		return FALSE

	return TRUE

/obj/structure/window/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && (check_standard_flag_pass(mover)))
		return TRUE
	if(!fulltile && get_dir(src, target) & dir)
		return !density
	return TRUE

/obj/structure/window/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()

	visible_message(SPAN_DANGER("[src] was hit by [AM]."))

	var/tforce = 0
	if (ismob(AM))
		tforce = 40
	else if (isobj(AM))
		var/obj/item/I = AM
		tforce = I.throw_force * TT.get_damage_multiplier()

	if (considered_reinforced)
		tforce *= 0.25

	if (health - tforce <= 7 && !considered_reinforced)
		set_anchored(FALSE)
		update_verbs()
		step(src, get_dir(AM, src))

	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, TRUE)

/obj/structure/window/attack_hand(mob/user, list/params)
	user.setClickCooldown(user.get_attack_speed())

	if (MUTATION_HULK in user.mutations) // Do we really still need these?
		user.say(pick(
			";RAAAAAAAARGH!",
			";HNNNNNNNNNGGGGGGH!",
			";GWAAAAAAAARRRHHH!",
			"NNNNNNNNGGGGGGGGHH!",
			";AAAAAAARRRGH!",
		))
		user.visible_message(SPAN_DANGER("[user] smashes through [src]!"))
		user.do_attack_animation(src)
		shatter()

	else if (user.a_intent == INTENT_HARM)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.species.can_shred(H))
				attack_generic(H, 25)
				return

		playsound(loc, 'sound/effects/glassknock.ogg', 80, TRUE)
		user.do_attack_animation(src)
		user.visible_message(
			SPAN_DANGER("\The [user] bangs against \the [src]!"),
			SPAN_DANGER("You bang against \the [src]!"),
			SPAN_HEAR("You hear a banging sound."),
		)
	else
		playsound(loc, 'sound/effects/glassknock.ogg', 80, TRUE)
		user.visible_message(
			SPAN_NOTICE("[user.name] knocks on the [name]."),
			SPAN_NOTICE("You knock on the [name]."),
			SPAN_HEAR("You hear a knocking sound."),
		)
	return

/obj/structure/window/attack_generic(mob/user, damage)
	user.setClickCooldown(user.get_attack_speed())
	if (!damage)
		return

	if (damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
		visible_message(SPAN_DANGER("[user] smashes into [src]!"))
		if (considered_reinforced)
			damage /= 2
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))

	user.do_attack_animation(src)

	return TRUE

/obj/structure/window/attackby(obj/item/object, mob/user)
	if (!istype(object))
		return // I really wish I did not need this.

	// Fixing.
	if (istype(object, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
		var/obj/item/weldingtool/WT = object
		if (health < maxhealth)
			if (WT.remove_fuel(1, user))
				to_chat(user, SPAN_NOTICE("You begin repairing [src]..."))
				playsound(src, WT.tool_sound, 50, TRUE)
				if (do_after(user, 40 * WT.tool_speed, target = src))
					health = maxhealth
					// playsound(src, 'sound/items/Welder.ogg', 50, 1)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You repair [src]."))
		else
			to_chat(user, SPAN_WARNING("[src] is already in good condition!"))
		return

	// Slamming.
	if (istype(object, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = object
		if (istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(object) //? Gotta delete it here because if window breaks, it won't get deleted.
			switch (state)
				if (1)
					M.visible_message(SPAN_WARNING("[user] slams [M] against \the [src]!"))
					M.apply_damage(7)
					hit(10)
				if (2)
					M.visible_message(SPAN_DANGER("[user] bashes [M] against \the [src]!"))
					if (prob(50))
						M.afflict_paralyze(20 * 1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message(SPAN_BOLDDANGER("[user] crushes [M] against \the [src]!"))
					M.afflict_paralyze(20 * 5)
					M.apply_damage(20)
					hit(50)
			return

	if (object.item_flags & ITEM_NOBLUDGEON)
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
				var/obj/structure/window/reinforced/polarized/P = new(loc, dir)
				if (fulltile)
					P.fulltile = TRUE
					P.icon_state = "fwindow"
				P.integrity_max = integrity_max
				P.set_integrity(integrity_max)
				P.construction_state = construction_state
				P.set_anchored(anchored)
				qdel(src)

	else if (istype(object, /obj/item/frame) && anchored)
		var/obj/item/frame/F = object
		F.try_build(src, user)
	else
		user.setClickCooldown(user.get_attack_speed(object))
		if (object.damtype == BRUTE || object.damtype == BURN)
			user.do_attack_animation(src)
			hit(object.damage_force)
			if (health <= 7)
				set_anchored(FALSE)
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, TRUE)

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
		take_damage(damage_per_fire_tick)

/obj/structure/window/drop_products(method, atom/where)
	var/atom/where = drop_location()
	if (method == ATOM_DECONSTRUCT_DISASSEMBLED)
		if (glasstype)
			new glasstype(where, fulltile? 2 : 1)
		return
	if (shardtype)
		new shardtype(where)
		if (fulltile)
			// nah no for loop
			new shardtype(where)

/obj/structure/window/screwdriver_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct)
		user.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE
	. = TRUE

	if (construction_state == WINDOW_STATE_UNSECURED || construction_state == WINDOW_STATE_SCREWED_TO_FLOOR || !considered_reinforced)
		if (!use_screwdriver(I, user, flags))
			return

		var/unsecuring = construction_state != WINDOW_STATE_UNSECURED
		user.action_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the frame [unsecuring? "from" : "to"] the floor."), src)
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

	if (!use_screwdriver(I, user, flags))
		return

	var/unsecuring = construction_state == WINDOW_STATE_SECURED_TO_FRAME
	user.action_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the window [unsecuring? "from" : "to"] the frame."), src)
	construction_state = unsecuring ? WINDOW_STATE_CROWBRARED_IN : WINDOW_STATE_SECURED_TO_FRAME

/obj/structure/window/crowbar_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct)
		user.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE
	. = TRUE
	if (!considered_reinforced)
		return
	if (construction_state != WINDOW_STATE_CROWBRARED_IN && construction_state != WINDOW_STATE_SCREWED_TO_FLOOR)
		return
	if (!use_crowbar(I, user, flags))
		return
	var/unsecuring = construction_state == WINDOW_STATE_CROWBRARED_IN
	user.action_feedback(SPAN_NOTICE("You pry [src] [unsecuring ? "out of" : "into"] the frame."), src)
	construction_state = unsecuring ? WINDOW_STATE_SCREWED_TO_FLOOR : WINDOW_STATE_CROWBRARED_IN

/obj/structure/window/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_deconstruct)
		user.action_feedback(SPAN_NOTICE("This can't be deconstructed."), src)
		return FALSE
	. = TRUE
	if (construction_state != WINDOW_STATE_UNSECURED)
		user.action_feedback(SPAN_WARNING("[src] has to be entirely unfastened from the floor before you can disasemble it!"))
		return
	if (!use_wrench(I, user, flags))
		return
	user.action_feedback(SPAN_NOTICE("You disassemble [src]."), src)
	deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

/obj/structure/window/dynamic_tool_functions(obj/item/I, mob/user)
	if(!allow_deconstruct)
		return
	if (construction_state == WINDOW_STATE_UNSECURED)
		. = list(
			TOOL_SCREWDRIVER = TOOL_HINT_SCREWING_WINDOW_FRAME,
			TOOL_WRENCH
		)
	else if (!considered_reinforced)
		. = list(
			TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_FRAME
		)
	else
		switch (construction_state)
			if (WINDOW_STATE_SCREWED_TO_FLOOR)
				. = list(
				  TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_FRAME,
				  TOOL_CROWBAR = TOOL_HINT_CROWBAR_WINDOW_IN
				)
			if (WINDOW_STATE_CROWBRARED_IN)
				. = list(
				TOOL_SCREWDRIVER = TOOL_HINT_SCREWING_WINDOW_PANE,
				TOOL_CROWBAR = TOOL_HINT_CROWBAR_WINDOW_OUT
				)
			if (WINDOW_STATE_SECURED_TO_FRAME)
				. = list(
				  TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_PANE
				)
	return merge_double_lazy_assoc_list(., ..())

/obj/structure/window/dynamic_tool_image(function, hint)
	switch (hint)
		if (TOOL_HINT_CROWBAR_WINDOW_IN)
			return dyntool_image_forward(TOOL_CROWBAR)
		if (TOOL_HINT_CROWBAR_WINDOW_OUT)
			return dyntool_image_backward(TOOL_CROWBAR)
		if (TOOL_HINT_SCREWING_WINDOW_FRAME)
			return dyntool_image_forward(TOOL_SCREWDRIVER)
		if (TOOL_HINT_UNSCREWING_WINDOW_FRAME)
			return dyntool_image_backward(TOOL_SCREWDRIVER)
		if (TOOL_HINT_SCREWING_WINDOW_PANE)
			return dyntool_image_forward(TOOL_SCREWDRIVER)
		if (TOOL_HINT_UNSCREWING_WINDOW_PANE)
			return dyntool_image_backward(TOOL_SCREWDRIVER)
	return ..()

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
	// var/ratio = atom_integrity / max_integrity
	var/ratio = health / maxhealth
	ratio = CEILING(ratio*4, 1) * 25
	cut_overlay(crack_overlay)
	if(ratio > 75)
		return
	crack_overlay = mutable_appearance('icons/obj/structures/window_damage.dmi', "damage[ratio]", -(layer+0.1))
	. += crack_overlay

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

/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... almost anything, really should shatter it."
	icon_state = "window"

	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 500 // Bumping it up a bit, so that a small fire doesn't instantly melt it. Also, makes sense as glass starts softening at around ~700 C
	damage_per_fire_tick = 2.0
	integrity = 20
	integrity_max = 20

/obj/structure/window/basic/full
	icon = 'icons/obj/structures/window_full.dmi'
	icon_state = "window-0"
	base_icon_state = "window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE)
	integrity = 40
	integrity_max = 40
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
	icon = 'icons/obj/structures/window_full_phoron.dmi'
	icon_state = "window-0"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE)
	integrity = 160
	integrity_max = 160
	fulltile = TRUE

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
	icon = 'icons/obj/structures/window_full_reinforced_phoron.dmi'
	icon_state = "window-0"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE)
	// canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	integrity = 240
	integrity_max = 240
	fulltile = TRUE

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"

	glasstype = /obj/item/stack/material/glass/reinforced

	integrity = 80
	integrity_max = 80
	considered_reinforced = TRUE
	maximal_heat = T0C + 1000 // Bumping this as well, as most fires quickly get over 800 C
	damage_per_fire_tick = 2.0

/obj/structure/window/reinforced/full
	icon = 'icons/obj/structures/window_full_reinforced.dmi'
	icon_state = "window-0"

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE)
	// canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	integrity = 160
	integrity_max = 160
	fulltile = TRUE

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	opacity = TRUE
/obj/structure/window/reinforced/tinted/full
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "rwindow-full"
	maxhealth = 80
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"

// TODO: Recreate this.
/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "window"

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_SHUTTLE_PARTS)
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

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_WINDOW_FULLTILE)
	// canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	integrity = 160
	integrity_max = 160
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
		animate(
			src,
			color = "#FFFFFF",
			time = 5,
		)
		set_opacity(FALSE)
	else
		animate(
			src,
			color = "#222222",
			time = 5,
		)
		set_opacity(TRUE)

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user, list/params)
	if (..())
		return TRUE
	else
		toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_appearance()

	for (var/obj/structure/window/reinforced/polarized/target_window in range(src, range))
		if (target_window.id == id || !target_window.id)
			INVOKE_ASYNC(target_window, TYPE_PROC_REF(/obj/structure/window/reinforced/polarized, toggle))

/obj/machinery/button/windowtint/power_change()
	..()
	if (active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon_state()
	. = ..()
	icon_state = "light[active]"

/obj/machinery/button/windowtint/attackby(obj/item/object, mob/user)
	if (istype(object, /obj/item/multitool))
		var/obj/item/multitool/MT = object
		if (!id)
			// If no ID is set yet (newly built button?) let them select an ID for first-time use!
			var/new_id = tgui_input_text(
				user = user,
				message = "Enter the ID for the window.",
				title = name,
			)
			if (new_id && user.get_active_held_item() != object && in_range(src, user))
				id = new_id
				to_chat(user, SPAN_NOTICE("The new ID of \the [src] is [id]"))
		if (id)
			// It already has an ID (or they just set one), buffer it for copying to windows.
			to_chat(user, SPAN_NOTICE("You store \the [src] in \the [MT]'s buffer!"))
			MT.connectable = src
			MT.update_appearance()
		return TRUE
	return ..()

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
