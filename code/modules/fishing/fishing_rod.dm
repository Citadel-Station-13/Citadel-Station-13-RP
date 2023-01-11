
/obj/item/material/fishing_rod
	name = "crude fishing rod"
	desc = "A crude rod made for catching fish."
	description_info = "A tool usable on water-tiles to attempt to catch fish by swiping it over them.\
	You can add or remove cable by wirecutter or coil respectively to allow its use.\
	Any food containing things like protein, sugar, or standard nutriment can be attached to the rod, allowing for faster fishing based on the amount.\
	You can examine the rod to check if it has bait attached, and examine it automatically if so.\
	\
	Ctrl clicking the rod will remove any attached bait from the rod."
	description_antag = "Some fishing rods can be utilized as long-range, sharp weapons, though their pseudo ranged ability comes at the cost of slow speed."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "fishing_rod"
	item_state = "fishing_rod"
	force_divisor = 0.02
	throw_force = 1
	sharp = TRUE
	attack_verb = list("whipped", "battered", "slapped", "fished", "hooked")
	hitsound = 'sound/weapons/punchmiss.ogg'
	applies_material_colour = TRUE
	default_material = "wood"
	can_dull = FALSE
	var/strung = TRUE
	var/line_break = TRUE

	var/obj/item/reagent_containers/food/snacks/Bait
	var/bait_type = /obj/item/reagent_containers/food/snacks

	var/cast = FALSE

	attackspeed = 3 SECONDS

/obj/item/material/fishing_rod/built
	strung = FALSE

/obj/item/material/fishing_rod/examine(mob/user)
	. = ..()
	if(Bait)
		. += "<span class='notice'>\The [src] has \the [Bait] hanging on its hook.</span>"
		. += Bait.examine(user)

/obj/item/material/fishing_rod/CtrlClick(mob/user)
	if((src.loc == user || Adjacent(user)) && Bait)
		Bait.forceMove(get_turf(user))
		to_chat(user, "<span class='notice'>You remove the bait from \the [src].</span>")
		Bait = null
	else
		..()

/obj/item/material/fishing_rod/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/material/fishing_rod/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_wirecutter() && strung)
		strung = FALSE
		to_chat(user, "<span class='notice'>You cut \the [src]'s string!</span>")
		update_icon()
		return
	else if(istype(I, /obj/item/stack/cable_coil) && !strung)
		var/obj/item/stack/cable_coil/C = I
		if(C.amount < 5)
			to_chat(user, "<span class='warning'>You do not have enough length in \the [C] to string this!</span>")
			return
		if(do_after(user, rand(10 SECONDS, 20 SECONDS)))
			C.use(5)
			strung = TRUE
			to_chat(user, "<span class='notice'>You string \the [src]!</span>")
			update_icon()
			return
	else if(istype(I, bait_type))
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		if(Bait)
			user.grab_item_from_interacted_with(Bait, src)
			to_chat(user, "<span class='notice'>You swap \the [Bait] with \the [I].</span>")
		Bait = I
		update_bait()
	return ..()

/obj/item/material/fishing_rod/update_icon()
	cut_overlays()
	..()
	if(strung)
		add_overlay(image(icon, "[icon_state]_string"))

/obj/item/material/fishing_rod/proc/update_bait()
	if(istype(Bait, bait_type))
		var/foodvolume
		for(var/datum/reagent/re in Bait.reagents.reagent_list)
			if(re.id == "nutriment" || re.id == "protein" || re.id == "glucose" || re.id == "fishbait")
				foodvolume += re.volume

		tool_speed = initial(tool_speed) * min(0.75, (0.5 / max(0.5, (foodvolume / Bait.reagents.maximum_volume))))

	else
		tool_speed = initial(tool_speed)

/obj/item/material/fishing_rod/proc/consume_bait()
	if(Bait)
		qdel(Bait)
		Bait = null
		return TRUE
	return FALSE

/obj/item/material/fishing_rod/modern
	name = "fishing rod"
	desc = "A refined rod for catching fish."
	icon_state = "fishing_rod_modern"
	item_state = "fishing_rod"
	reach = 4
	attackspeed = 2 SECONDS
	default_material = "titanium"

	tool_speed = 0.75

/obj/item/material/fishing_rod/modern/built
	strung = FALSE

/obj/item/material/fishing_rod/modern/cheap //A rod sold by the fishing vendor. Done so that the rod sold by mining reward vendors doesn't loose its value.
	name = "cheap fishing rod"
	desc = "Mass produced, but somewhat reliable."
	default_material = "plastic"

	tool_speed = 0.9

/obj/item/material/fishing_rod/modern/strong
	desc = "A extremely refined rod for catching fish."
	default_material = "durasteel"

	tool_speed = 0.5
