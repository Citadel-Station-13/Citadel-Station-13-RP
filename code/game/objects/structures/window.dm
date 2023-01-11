/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures_vr.dmi'
	density = TRUE
	pass_flags_self = ATOM_PASS_GLASS
	CanAtmosPass = ATMOS_PASS_PROC
	w_class = ITEMSIZE_NORMAL
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE

	layer = WINDOW_LAYER
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE
	atom_flags = ATOM_BORDER

	/// are we reinforced? this is only to modify our construction state/steps.
	var/considered_reinforced = FALSE
	/// construction state
	var/construction_state = WINDOW_STATE_SECURED_TO_FRAME
	/// determines if we're a full tile window, NOT THE ICON STATE.
	var/fulltile = FALSE
	/// i'm so sorry we have to do this - set to dir for allowthrough purposes
	var/moving_right_now

	var/maxhealth = 14.0
	var/maximal_heat = T0C + 100 // Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 // Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/health
	var/force_threshold = 0
	var/basestate
	var/shardtype = /obj/item/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange osr otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate

/obj/structure/window/Initialize(mapload, start_dir, constructed = FALSE)
	. = ..(mapload)
	/// COMPATIBILITY PATCH - Replace this crap with a better solution (maybe copy /tg/'s ASAP!!)
	// unfortunately no longer a compatibility patch ish due to clickcode...
	check_fullwindow()
	if (start_dir)
		setDir(start_dir)
	//player-constructed windows
	if (constructed)
		anchored = 0
		construction_state = 0
		update_verbs()
	health = maxhealth
	AIR_UPDATE_ON_INITIALIZE_AUTO
	update_nearby_icons()

/obj/structure/window/Destroy()
	AIR_UPDATE_ON_DESTROY_AUTO
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()

/obj/structure/window/Move()
	moving_right_now = dir
	. = ..()
	setDir(moving_right_now)
	moving_right_now = null

/obj/structure/window/Moved(atom/oldloc)
	. = ..()
	AIR_UPDATE_ON_MOVED_AUTO

/obj/structure/window/proc/check_fullwindow()
	if(dir & (dir - 1))		//diagonal!
		fulltile = TRUE
	if(fulltile)
		// clickcode requires this :(
		atom_flags &= ~ATOM_BORDER
		// update: atmos code now requires tihs :(
		CanAtmosPass = ATMOS_PASS_AIR_BLOCKED

/obj/structure/window/examine(mob/user)
	. = ..()

	if(health == maxhealth)
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		var/perc = health / maxhealth
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

/obj/structure/window/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
			update_icon()
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
			update_icon()
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
			update_icon()
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (overlays)
		cut_overlays()
	update_icon()

	var/image/img = image(src)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	add_overlay(img)

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	new shardtype(loc)
	if(considered_reinforced)
		new /obj/item/stack/rods(loc)
	if(is_fulltile())
		new shardtype(loc) //todo pooling?
		if(considered_reinforced)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return

	..()
	take_damage(proj_damage)
	return


/obj/structure/window/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return

/obj/structure/window/blob_act()
	take_damage(50)

/obj/structure/window/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover, /obj/structure/window))
		// if they're a window we have special handling
		var/obj/structure/window/them = mover
		if(is_fulltile() || them.is_fulltile())
			// OUT.
			return FALSE
		// we're both single-way
		if(them.moving_right_now == dir)
			// OUT
			return FALSE
		return TRUE
	if(!is_fulltile() && !(get_dir(mover, target) & turn(dir, 180)))
		// we don't care about them if we're not fulltile and they're not moving into us
		return TRUE
	return ..()

/obj/structure/window/CanAtmosPass(turf/T, d)
	if(is_fulltile() || (d == dir))
		return anchored? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_NOT_BLOCKED
	return ATMOS_PASS_NOT_BLOCKED

/obj/structure/window/CheckExit(atom/movable/AM, turf/target)
	if(is_fulltile())
		return TRUE
	if(check_standard_flag_pass(AM))
		return TRUE
	if(get_dir(src, target) & dir)
		return FALSE
	return TRUE

/obj/structure/window/setDir(newdir)
	. = ..()
	update_nearby_tiles()

/obj/structure/window/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throw_force * TT.get_damage_multiplier()
	if(considered_reinforced) tforce *= 0.25
	if(health - tforce <= 7 && !considered_reinforced)
		anchored = 0
		update_verbs()
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(user.get_attack_speed())
	if(MUTATION_HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
		user.do_attack_animation(src)
		shatter()

	else if (usr.a_intent == INTENT_HARM)

		if (istype(usr,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		usr.visible_message("<span class='danger'>\The [usr] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(user.get_attack_speed())
	if(!damage)
		return
	if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
		visible_message("<span class='danger'>[user] smashes into [src]!</span>")
		if(considered_reinforced)
			damage = damage / 2
		take_damage(damage)
	else
		visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")
	user.do_attack_animation(src)
	return 1

/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this

	// Fixing.
	if(istype(W, /obj/item/weldingtool) && user.a_intent == INTENT_HELP)
		var/obj/item/weldingtool/WT = W
		if(health < maxhealth)
			if(WT.remove_fuel(1 ,user))
				to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
				playsound(src, WT.tool_sound, 50, 1)
				if(do_after(user, 40 * WT.tool_speed, target = src))
					health = maxhealth
			//		playsound(src, 'sound/items/Welder.ogg', 50, 1)
					update_icon()
					to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return

	// Slamming.
	if (istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch (state)
				if(1)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			return

	if(W.item_flags & ITEM_NOBLUDGEON)
		return

	else if(istype(W, /obj/item/stack/cable_coil) && considered_reinforced && construction_state == WINDOW_STATE_UNSECURED && !istype(src, /obj/structure/window/reinforced/polarized))
		var/obj/item/stack/cable_coil/C = W
		if (C.use(1))
			playsound(src.loc, 'sound/effects/sparks1.ogg', 75, 1)
			user.visible_message( \
				"<span class='notice'>\The [user] begins to wire \the [src] for electrochromic tinting.</span>", \
				"<span class='notice'>You begin to wire \the [src] for electrochromic tinting.</span>", \
				"You hear sparks.")
			if(do_after(user, 20 * C.tool_speed, src) && construction_state == WINDOW_STATE_UNSECURED)
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
				var/obj/structure/window/reinforced/polarized/P = new(loc, dir)
				if(is_fulltile())
					P.fulltile = TRUE
					P.icon_state = "fwindow"
				P.maxhealth = maxhealth
				P.health = health
				P.construction_state = construction_state
				P.anchored = anchored
				qdel(src)
	else if(istype(W,/obj/item/frame) && anchored)
		var/obj/item/frame/F = W
		F.try_build(src, user)
	else
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(damage < force_threshold || force_threshold < 0)
		return
	if(considered_reinforced) damage *= 0.5
	take_damage(damage)
	return


/obj/structure/window/verb/rotate_counterclockwise()
	set name = "Rotate Counterclockwise" // Temporary fix until someone more intelligent figures out how to add proper rotation verbs to the panels
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	setDir(turn(dir, 90))
	updateSilicate()

/obj/structure/window/verb/rotate_clockwise()
	set name = "Rotate Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	setDir(turn(dir, 270))
	updateSilicate()

//! Does this work? idk. Let's call it TBI.
/obj/structure/window/CanAStarPass(obj/item/card/id/ID, to_dir, atom/movable/caller)
	if(!density)
		return TRUE
	if((is_fulltile()) || (dir == to_dir))
		return FALSE

	return TRUE

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	return fulltile

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored || is_fulltile())
		remove_obj_verb(src, /obj/structure/window/verb/rotate_counterclockwise)
		remove_obj_verb(src, /obj/structure/window/verb/rotate_clockwise)
	else if(!is_fulltile())
		add_obj_verb(src, /obj/structure/window/verb/rotate_counterclockwise)
		add_obj_verb(src, /obj/structure/window/verb/rotate_clockwise)

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	cut_overlays()
	var/list/overlays_to_add = list()
	if(!is_fulltile())
		icon_state = "[basestate]"
		return
	var/list/dirs = list()
	if(anchored)
		for(var/obj/structure/window/W in orange(src,1))
			if(W.anchored && W.density && W.glasstype == src.glasstype && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
				dirs += get_dir(src, W)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		overlays_to_add += I

	// Damage overlays.
	var/ratio = health / maxhealth
	ratio = CEILING(ratio * 4, 1) * 25

	if(ratio > 75)
		add_overlay(overlays_to_add)
		return
	var/image/I = image(icon, "damage[ratio]", layer = layer + 0.1)
	overlays_to_add += I

	add_overlay(overlays_to_add)

	return

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		take_damage(damage_per_fire_tick)
	..()

/obj/structure/window/drop_products(method)
	if(method == ATOM_DECONSTRUCT_DISASSEMBLED)
		if(glasstype)
			new glasstype(drop_location(), is_fulltile()? 2 : 1)
		return
	if(shardtype)
		new shardtype(drop_location())
		if(is_fulltile())
			// nah no for loop
			new shardtype(drop_location())

/obj/structure/window/screwdriver_act(obj/item/I, mob/user, flags, hint)
	. = TRUE
	if(construction_state == WINDOW_STATE_UNSECURED || construction_state == WINDOW_STATE_SCREWED_TO_FLOOR || !considered_reinforced)
		if(!use_screwdriver(I, user, flags))
			return
		var/unsecuring = construction_state != WINDOW_STATE_UNSECURED
		user.action_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the frame [unsecuring? "from" : "to"] the floor."), src)
		construction_state = unsecuring? WINDOW_STATE_UNSECURED : WINDOW_STATE_SCREWED_TO_FLOOR
		anchored = !unsecuring
		CanAtmosPass = anchored? (is_fulltile()? ATMOS_PASS_AIR_BLOCKED : ATMOS_PASS_PROC) : ATMOS_PASS_NOT_BLOCKED
		update_verbs()
		return
	if(construction_state != WINDOW_STATE_CROWBRARED_IN && construction_state != WINDOW_STATE_SECURED_TO_FRAME)
		return
	if(!use_screwdriver(I, user, flags))
		return
	var/unsecuring = construction_state == WINDOW_STATE_SECURED_TO_FRAME
	user.action_feedback(SPAN_NOTICE("You [unsecuring? "unfasten" : "fasten"] the window [unsecuring? "from" : "to"] the frame."), src)
	construction_state = unsecuring? WINDOW_STATE_CROWBRARED_IN : WINDOW_STATE_SECURED_TO_FRAME

/obj/structure/window/crowbar_act(obj/item/I, mob/user, flags, hint)
	. = TRUE
	if(!considered_reinforced)
		return
	if(construction_state != WINDOW_STATE_CROWBRARED_IN && construction_state != WINDOW_STATE_SCREWED_TO_FLOOR)
		return
	if(!use_crowbar(I, user, flags))
		return
	var/unsecuring = construction_state == WINDOW_STATE_CROWBRARED_IN
	user.action_feedback(SPAN_NOTICE("You pry [src] [unsecuring? "out of" : "into"] the frame."), src)
	construction_state = unsecuring? WINDOW_STATE_SCREWED_TO_FLOOR : WINDOW_STATE_CROWBRARED_IN

/obj/structure/window/wrench_act(obj/item/I, mob/user, flags, hint)
	. = TRUE
	if(construction_state != WINDOW_STATE_UNSECURED)
		user.action_feedback(SPAN_WARNING("[src] has to be entirely unfastened from the floor before you can disasemble it!"))
		return
	if(!use_wrench(I, user, flags))
		return
	user.action_feedback(SPAN_NOTICE("You disassemble [src]."), src)
	deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

/obj/structure/window/dynamic_tool_functions(obj/item/I, mob/user)
	if(construction_state == WINDOW_STATE_UNSECURED)
		return list(
			TOOL_SCREWDRIVER = TOOL_HINT_SCREWING_WINDOW_FRAME,
			TOOL_WRENCH
		)
	if(!considered_reinforced)
		return list(
			TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_FRAME
		)
	switch(construction_state)
		if(WINDOW_STATE_SCREWED_TO_FLOOR)
			return list(
				TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_FRAME,
				TOOL_CROWBAR = TOOL_HINT_CROWBAR_WINDOW_IN
			)
		if(WINDOW_STATE_CROWBRARED_IN)
			return list(
				TOOL_SCREWDRIVER = TOOL_HINT_SCREWING_WINDOW_PANE,
				TOOL_CROWBAR = TOOL_HINT_CROWBAR_WINDOW_OUT
			)
		if(WINDOW_STATE_SECURED_TO_FRAME)
			return list(
				TOOL_SCREWDRIVER = TOOL_HINT_UNSCREWING_WINDOW_PANE
			)

/obj/structure/window/dynamic_tool_image(function, hint)
	switch(hint)
		if(TOOL_HINT_CROWBAR_WINDOW_IN)
			return dyntool_image_forward(TOOL_CROWBAR)
		if(TOOL_HINT_CROWBAR_WINDOW_OUT)
			return dyntool_image_backward(TOOL_CROWBAR)
		if(TOOL_HINT_SCREWING_WINDOW_FRAME)
			return dyntool_image_forward(TOOL_SCREWDRIVER)
		if(TOOL_HINT_UNSCREWING_WINDOW_FRAME)
			return dyntool_image_backward(TOOL_SCREWDRIVER)
		if(TOOL_HINT_SCREWING_WINDOW_PANE)
			return dyntool_image_forward(TOOL_SCREWDRIVER)
		if(TOOL_HINT_UNSCREWING_WINDOW_PANE)
			return dyntool_image_backward(TOOL_SCREWDRIVER)
	return ..()

/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... almost anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 500 // Bumping it up a bit, so that a small fire doesn't instantly melt it. Also, makes sense as glass starts softening at around ~700 C
	damage_per_fire_tick = 2.0
	maxhealth = 12.0
	force_threshold = 3

/obj/structure/window/basic/full
	icon_state = "window-full"
	maxhealth = 24
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	basestate = "phoronwindow"
	icon_state = "phoronwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	maximal_heat = INFINITY // This is high-grade atmospherics glass. Let's not have it burn, mmmkay?
	damage_per_fire_tick = 1.0
	maxhealth = 40.0
	force_threshold = 5

/obj/structure/window/phoronbasic/full
	icon_state = "phoronwindow-full"
	maxhealth = 80
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "phoronrwindow"
	icon_state = "phoronrwindow"
	shardtype = /obj/item/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	considered_reinforced = 1
	maximal_heat = INFINITY // Same here. The reinforcement is just structural anyways
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 80.0
	force_threshold = 10

/obj/structure/window/phoronreinforced/full
	icon_state = "phoronrwindow-full"
	maxhealth = 160
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)


/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 40.0
	considered_reinforced = 1
	maximal_heat = T0C + 1000 // Bumping this as well, as most fires quickly get over 800 C
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced
	force_threshold = 6

/obj/structure/window/reinforced/full
	icon_state = "rwindow-full"
	maxhealth = 80
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 30
	force_threshold = 5

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	maxhealth = 40
	considered_reinforced = 1
	basestate = "w"
	dir = 5
	force_threshold = 7

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE)
	canSmoothWith = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_WINDOW_FULLTILE_SHUTTLE + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_SHUTTLE_PARTS)

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/full
	icon_state = "rwindow-full"
	maxhealth = 80
	fulltile = TRUE

	// smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WINDOW_FULLTILE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

/obj/structure/window/reinforced/polarized/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && !anchored) // Only allow programming if unanchored!
		var/obj/item/multitool/MT = W
		// First check if they have a windowtint button buffered
		if(istype(MT.connectable, /obj/machinery/button/windowtint))
			var/obj/machinery/button/windowtint/buffered_button = MT.connectable
			src.id = buffered_button.id
			to_chat(user, "<span class='notice'>\The [src] is linked to \the [buffered_button].</span>")
			return TRUE
		// Otherwise fall back to asking them
		var/t = sanitizeSafe(input(user, "Enter the ID for the window.", src.name, null), MAX_NAME_LEN)
		if (!t && user.get_active_held_item() != W && in_range(src, user))
			src.id = t
			to_chat(user, "<span class='notice'>The new ID of \the [src] is [id]</span>")
			return TRUE
	. = ..()

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)



/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"

/obj/machinery/button/windowtint/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/MT = W
		if(!id)
			// If no ID is set yet (newly built button?) let them select an ID for first-time use!
			var/t = sanitizeSafe(input(user, "Enter an ID for \the [src].", src.name, null), MAX_NAME_LEN)
			if (t && user.get_active_held_item() != W && in_range(src, user))
				src.id = t
				to_chat(user, "<span class='notice'>The new ID of \the [src] is [id]</span>")
		if(id)
			// It already has an ID (or they just set one), buffer it for copying to windows.
			to_chat(user, "<span class='notice'>You store \the [src] in \the [MT]'s buffer!</span>")
			MT.connectable = src
			MT.update_icon()
		return TRUE
	. = ..()

/obj/structure/window/wooden
	name = "wooden panel"
	desc = "A set of wooden panelling, designed to hide the drab grey walls."
	icon_state = "woodpanel"
	basestate = "woodpanel"
	glasstype = /obj/item/stack/material/wood
	shardtype = /obj/item/material/shard/wood
	maximal_heat = T0C + 300 // Same as wooden walls "melting"
	damage_per_fire_tick = 2.0
	maxhealth = 10.0
	force_threshold = 3
	opacity = 1

/obj/structure/window/wooden/take_damage(var/damage = 0,  var/sound_effect = 1)
	var/initialhealth = health

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/woodcutting.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to fall apart!" )
			update_icon()
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
			update_icon()
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
			update_icon()
	return

/obj/structure/window/wooden/shatter(var/display_message = 1)
	playsound(loc, 'sound/effects/woodcutting.ogg', 100, 1)
	if(display_message)
		visible_message("[src] falls apart!")
	new shardtype(loc)
	qdel(src)
	return

/obj/structure/window/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)

/obj/structure/window/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE
