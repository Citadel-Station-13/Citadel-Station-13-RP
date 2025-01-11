/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	w_class = WEIGHT_CLASS_NORMAL
	damage_force = 9.0
	throw_force = 15.0
	throw_speed = 5
	throw_range = 20
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	materials_base = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT / 2)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")
	skip_legacy_icon_update = TRUE

/obj/item/stack/rods/generate_explicit_recipes()
	. = list()
	. += create_stack_recipe_datum(name = "grille", product = /obj/structure/grille, cost = 2, time = 1 SECONDS)
	. += create_stack_recipe_datum(name = "catwalk", product = /obj/structure/catwalk, cost = 2, time = 1 SECONDS)

/obj/item/stack/rods/update_icon_state()
	var/amount = get_amount()
	if((amount <= 5) && (amount > 0))
		icon_state = "rods-[amount]"
	else
		icon_state = "rods"
	return ..()

/obj/item/stack/rods/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W

		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two rods to do this.</span>")
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/steel/new_item = new(usr.loc)
			new_item.add_to_stacks(usr)
			for (var/mob/M in viewers(src))
				M.show_message("<span class='notice'>[src] is shaped into metal by [user.name] with the weldingtool.</span>", 3, "<span class='notice'>You hear welding.</span>", 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_held_item()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
		return

	if (istype(W, /obj/item/duct_tape_roll))
		var/obj/item/stack/medical/splint/ghetto/new_splint = new(get_turf(user))
		new_splint.add_fingerprint(user)

		user.visible_message("<span class='notice'>\The [user] constructs \a [new_splint] out of a [singular_name].</span>", \
				"<span class='notice'>You use make \a [new_splint] out of a [singular_name].</span>")
		src.use(1)
		return

	..()

/obj/item/stack/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	uses_charge = 1
	charge_costs = list(500)
	stack_type = /obj/item/stack/rods
	stacktype_legacy = /obj/item/stack/rods
	no_variants = TRUE
