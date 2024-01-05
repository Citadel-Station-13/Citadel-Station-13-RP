//Empty Sandbags
/obj/item/stack/emptysandbag
	name = "empty sandbag"
	desc = "A bag designed to be filled with sand."
	singular_name = "empty sandbag"
	icon_state = "sandbag_empty"
	w_class = ITEMSIZE_NORMAL
	damage_force = 1
	throw_force = 1
	throw_speed = 5
	throw_range = 20
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	materials_base = list("cloth" = 2)
	max_amount = 50
	attack_verb = list("tapped", "smacked", "flapped")

/obj/item/stack/emptysandbag/Initialize(mapload, new_amount, merge)
	. = ..()
	update_icon()

/obj/item/stack/emptysandbag/update_icon()
	var/amount = get_amount()
	if((amount >= 35))
		icon_state = "sandbag_empty_3"
	else if((amount < 35) && (amount > 1))
		icon_state = "sandbag_empty_2"
	else
		icon_state = "sandbag_empty"

/obj/item/stack/emptysandbag/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/stack/ore/glass) && !interact(user, src))
		if(do_after(user, 1 SECONDS, src) && use(1))
			var/obj/item/stack/ore/glass/O = W
			var/turf/T = get_turf(user)
			if(O.use(1))
				to_chat(user, "<span class='notice'>You fill the sandbag.</span>")
				new /obj/item/stack/sandbags(T)
			return
	else if(is_sharp(W))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [W].</span>", "<span class='notice'>You begin cutting up [src] with [W].</span>")
		if(do_after(user, 3 SECONDS, src) && use(1))
			to_chat(user, "<span class='notice'>You cut [src] into pieces!</span>")
			new /obj/item/stack/material/cloth(drop_location(),rand(1,2))
		return
	return ..()

//Filled Sandbags
/obj/item/stack/sandbags
	name = "sandbag"
	desc = "This is a synthetic bag tightly packed with sand. It is designed to provide structural support and serve as a portable barrier."
	singular_name = "sandbag"
	icon_state = "sandbags"
	w_class = ITEMSIZE_NORMAL
	damage_force = 10
	throw_force = 15
	throw_speed = 3
	throw_range = 10
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'
	materials_base = list("cloth" = 2)
	max_amount = 50
	attack_verb = list("hit", "bludgeoned", "whacked")

/obj/item/stack/sandbags/Initialize(mapload, new_amount, merge)
	. = ..()
	update_icon()

/obj/item/stack/sandbags/update_icon()
	var/amount = get_amount()
	if((amount >= 35))
		icon_state = "sandbags_3"
	else if((amount < 35) && (amount > 1))
		icon_state = "sandbags_2"
	else
		icon_state = "sandbags"

/obj/item/stack/sandbags/generate_explicit_recipes()
	. = list()
	. += create_stack_recipe_datum(name = "sandbag barricade", product = /obj/structure/sandbag, cost = 7, time = 1.5 SECONDS)

/obj/item/stack/sandbags/attackby(var/obj/item/W, var/mob/user)
	if(is_sharp(W))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [W].</span>", "<span class='notice'>You begin cutting up [src] with [W].</span>")
		if(do_after(user, 3 SECONDS, src) && use(1))
			to_chat(user, "<span class='notice'>You cut [src] into pieces, causing sand to spill everywhere!</span>")
			for(var/i in 1 to rand(1,1))
				new /obj/item/stack/material/cloth(drop_location())
				new /obj/item/stack/ore/glass(drop_location())
		return
	else
		if(do_after(user, 1 SECONDS, src) && use(1))
			var/turf/T = get_turf(user)
			to_chat(user, "<span class='notice'>You cut the cords securing the sandbag, spilling sand everywhere!</span>")
			for(var/i in 1 to rand(1,1))
				new /obj/item/stack/emptysandbag(T)
				new /obj/item/stack/ore/glass(T)
		return

//Sandbag Barricades
/obj/structure/sandbag
	name = "sandbag barricade"
	desc = "A barrier made of stacked sandbags."
	icon = 'icons/obj/structures/sandbags.dmi'
	icon_state = "sandbags-0"
	base_icon_state = "sandbags"
	anchored = TRUE
	density = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_THROWN | ATOM_PASS_CLICK
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_SANDBAGS)
	canSmoothWith = (SMOOTH_GROUP_SANDBAGS)
	integrity = 200
	integrity_max = 200

	var/vestigial = TRUE

/obj/structure/sandbag/Initialize(mapload)
	. = ..()
	for(var/obj/structure/sandbag/S in loc)
		if(S != src)
			break_to_parts(full_return = 1)
			return
	if(mapload)
		return INITIALIZE_HINT_LATELOAD
	else
		//update_connections(TRUE)
		update_icon()

/obj/structure/sandbag/LateInitialize()
	. = ..()
	//update_connections(FALSE)
	update_icon()

/obj/structure/sandbag/Destroy()
	//update_connections(TRUE)
	. = ..()

/obj/structure/sandbag/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	if(istype(W, /obj/item/stack/sandbags))
		var/obj/item/stack/sandbags/S = W
		if(integrity < integrity_max)
			if(S.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sandbag to repair \the [src].</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20) && integrity < integrity_max)
				if(S.use(1))
					integrity = integrity_max
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		return CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/structure/sandbag/proc/break_to_parts(full_return = 0)
	if(full_return || prob(20))
		new /obj/item/stack/sandbags(src.loc)
	else
		new /obj/item/stack/material/cloth(src.loc)
		new /obj/item/stack/ore/glass(src.loc)
	qdel(src)
