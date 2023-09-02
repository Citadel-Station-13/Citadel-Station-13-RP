/obj/structure/girder
	icon = 'icons/obj/structures/girder.dmi'
	icon_state = "girder"

	anchored = TRUE
	density = TRUE
	plane = TURF_PLANE
	w_class = ITEMSIZE_HUGE
	integrity = 200
	integrity_max = 200
	depth_level = 24
	depth_projected = TRUE

	var/state = 0
	var/current_damage = 0
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/reinforcing = 0
	var/material_color = 1

	material_parts = MATERIAL_DEFAULT_ABSTRACTED
	/// what we're made out of
	var/datum/material/material_structure = /datum/material/steel
	/// what our reinforcement is made out of
	var/datum/material/material_reinforcing

/obj/structure/girder/Initialize(mapload, material, reinforcement)
	if(!isnull(material))
		set_material_part(MATERIAL_PART_GIRDER_STRUCTURE, SSmaterials.resolve_material(material))
	if(!isnull(reinforcement))
		set_material_part(MATERIAL_PART_GIRDER_REINFORCEMENT, SSmaterials.resolve_material(reinforcement))
	. = ..()
	update_appearance()

/obj/structure/girder/update_material_parts(list/parts)
	if(isnull(material_reinforcing))
		if(isnull(material_structure))
			name = "girder"
			set_full_integrity(initial(integrity), initial(integrity_max))
		else
			name = "[material_structure.display_name] girder"

	else if(isnull(material_structure))
	else
	#warn impl

	// todo: refactor
	if(material_color)
		color = material_structure.icon_colour

/obj/structure/girder/material_init_parts()
	material_structure = SSmaterials.resolve_material(material_structure)
	material_reinforcing = SSmaterials.resolve_material(material_reinforcing)
	register_material(material_structure, FALSE)
	register_material(material_reinforcing, FALSE)

/obj/structure/girder/material_set_part(part, datum/material/material)
	var/datum/material/old
	switch(part)
		if(MATERIAL_PART_GIRDER_STRUCTURE)
			old = material_structure
			material_structure = material
		if(MATERIAL_PART_GIRDER_REINFORCEMENT)
			old = material_reinforcing
			material_reinforcing = material

	if(material != old)
		unregister_material(old, FALSE)
		register_material(material, FALSE)

/obj/structure/girder/material_get_part(part)
	switch(part)
		if(MATERIAL_PART_GIRDER_REINFORCEMENT)
			return material_reinforcing
		if(MATERIAL_PART_GIRDER_STRUCTURE)
			return material_structure

/obj/structure/girder/material_get_parts()
	return list(
		MATERIAL_PART_GIRDER_STRUCTURE = material_structure,
		MATERIAL_PART_GIRDER_REINFORCEMENT = material_reinforcing,
	)

/obj/structure/girder/material_set_parts(list/part_instances)
	material_structure = part_instances[MATERIAL_PART_GIRDER_STRUCTURE]
	material_reinforcing = part_instances[MATERIAL_PART_GIRDER_REINFORCEMENT]

/obj/structure/girder/update_icon_state()
	if(anchored)
		icon_state = initial(icon_state)
	else
		icon_state = "displaced"
	return ..()

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = 0
	cover = 25

/obj/structure/girder/displaced/Initialize(mapload, material_key)
	. = ..()
	displace()

/obj/structure/girder/proc/displace()
	name = "displaced [material_structure.display_name] [initial(name)]"
	icon_state = "displaced"
	anchored = 0
	cover = 25

/obj/structure/girder/proc/reset_girder()
	name = "[material_structure.display_name] [initial(name)]"
	anchored = 1
	cover = initial(cover)
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() && state == 0)
		if(anchored && !material_reinforcing)
			playsound(src, W.tool_sound, 100, 1)
			to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
			if(do_after(user,(2 SECONDS * round(integrity/100)) * W.tool_speed))
				if(!src) return
				to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
				deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
		else if(!anchored)
			playsound(src, W.tool_sound, 100, 1)
			to_chat(user, "<span class='notice'>Now securing the girder...</span>")
			if(do_after(user, 40 * W.tool_speed, src))
				to_chat(user, "<span class='notice'>You secured the girder!</span>")
				reset_girder()

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,30 * W.tool_speed))
			if(!src) return
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		deconstruct(ATOM_DECONSTRUCT_DESTROYED)

	else if(W.is_screwdriver())
		if(state == 2)
			playsound(src, W.tool_sound, 100, 1)
			to_chat(user, "<span class='notice'>Now unsecuring support struts...</span>")
			if(do_after(user,40 * W.tool_speed))
				if(!src) return
				to_chat(user, "<span class='notice'>You unsecured the support struts!</span>")
				state = 1
		else if(anchored && !material_reinforcing)
			playsound(src, W.tool_sound, 100, 1)
			reinforcing = !reinforcing
			to_chat(user, "<span class='notice'>\The [src] can now be [reinforcing? "reinforced" : "constructed"]!</span>")

	else if(W.is_wirecutter() && state == 1)
		playsound(src, W.tool_sound, 100, 1)
		to_chat(user, "<span class='notice'>Now removing support struts...</span>")
		if(do_after(user,40 * W.tool_speed))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the support struts!</span>")
			material_reinforcing.place_dismantled_product(get_turf(src), 2)
			set_material_part(MATERIAL_PART_GIRDER_REINFORCEMENT)
			reset_girder()

	else if(W.is_crowbar() && state == 0 && anchored)
		playsound(src, W.tool_sound, 100, 1)
		to_chat(user, "<span class='notice'>Now dislodging the girder...</span>")
		if(do_after(user, 40 * W.tool_speed))
			if(!src) return
			to_chat(user, "<span class='notice'>You dislodged the girder!</span>")
			displace()

	else if(istype(W, /obj/item/stack/material))
		if(reinforcing && !material_reinforcing)
			if(!reinforce_with_material(W, user))
				return ..()
		else
			if(!construct_wall(W, user))
				return ..()

	else
		return ..()

/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	var/amount_to_use = material_reinforcing ? 1 : 2
	if(S.get_amount() < amount_to_use)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

	var/datum/material/M = S.material
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	to_chat(user, "<span class='notice'>You begin adding the plating...</span>")

	if(!do_after(user,40) || !S.use(amount_to_use))
		return 1 //once we've gotten this far don't call parent attackby()

	if(anchored)
		to_chat(user, "<span class='notice'>You added the plating!</span>")
	else
		to_chat(user, "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.PlaceOnTop(/turf/simulated/wall)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_materials(M, material_reinforcing, material_structure)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(!isnull(material_reinforcing))
		to_chat(user, "<span class='notice'>\The [src] is already reinforced.</span>")
		return 0

	if(S.get_amount() < 1)
		to_chat(user, "<span class='notice'>There isn't enough material here to reinforce the girder.</span>")
		return 0

	var/datum/material/M = S.material

	to_chat(user, "<span class='notice'>Now reinforcing...</span>")
	if (!do_after(user,40) || !S.use(1))
		return 1 //don't call parent attackby() past this point
	to_chat(user, "<span class='notice'>You added reinforcement!</span>")

	set_material_part(MATERIAL_PART_GIRDER_REINFORCEMENT, M)
	return 1

/obj/structure/girder/drop_products(method, atom/where)
	. = ..()
	material_girder.place_dismantled_product(where, 2)

/obj/structure/girder/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	var/turf/simulated/T = get_turf(src)
	if(!istype(T) || T.density)
		return FALSE

	switch(passed_mode)
		if(RCD_FLOORWALL)
			// Finishing a wall costs two sheets.
			var/cost = RCD_SHEETS_PER_MATTER_UNIT * 2
			// Rwalls cost three to finish.
			if(the_rcd.make_rwalls)
				cost += RCD_SHEETS_PER_MATTER_UNIT * 1
			return list(
				RCD_VALUE_MODE = RCD_FLOORWALL,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = cost
			)
		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
	return FALSE

/obj/structure/girder/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	var/turf/simulated/T = get_turf(src)
	if(!istype(T) || T.density) // Should stop future bugs of people bringing girders to centcom and RCDing them, or somehow putting a girder on a durasteel wall and deconning it.
		return FALSE

	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, SPAN_NOTICE("You finish a wall."))
			// This is mostly the same as using on a floor. The girder's material is preserved, however.
			T.PlaceOnTop(/turf/simulated/wall)
			var/turf/simulated/wall/new_T = get_turf(src) // Ref to the wall we just built.
			// Apparently set_material(...) for walls requires refs to the material singletons and not strings.
			// This is different from how other material objects with their own set_material(...) do it, but whatever.
			var/datum/material/M = get_material_by_name(the_rcd.material_to_use)
			new_T.set_materials(M, the_rcd.make_rwalls ? M : null, material_girder)
			new_T.add_hiddenprint(user)
			qdel(src)
			return TRUE

		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			qdel(src)
			return TRUE

/obj/structure/girder/cult
	name = "column"
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	cover = 70
	material_color = 0
	material_structure = /datum/material/cult

/obj/structure/girder/cult/update_icon_state()
	. = ..()
	if(anchored)
		icon_state = "cultgirder"
	else
		icon_state = "displaced"

/obj/structure/girder/cult/dismantle()
	new /obj/effect/decal/remains/human(get_turf(src))
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.tool_sound, 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
		if(do_after(user,40 * W.tool_speed))
			to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
			dismantle()

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,30 * W.tool_speed))
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
		dismantle()

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		new /obj/effect/decal/remains/human(get_turf(src))
		dismantle()

/obj/structure/girder/resin
	name = "soft girder"
	icon_state = "girder_resin"
	cover = 60
	material_structure = /datum/material/resin
