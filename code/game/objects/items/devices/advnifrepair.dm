//Programs nanopaste into NIF repair nanites
/obj/item/nifrepairer
	name = "advanced NIF repair tool"
	desc = "A tool that accepts nanopaste and converts the nanites into NIF repair nanites for injection/ingestion. Insert paste, deposit into container."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "hydro"
	item_state = "gun"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 6000)
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	var/datum/reagent_holder/supply
	var/efficiency = 15 //How many units reagent per 1 unit nanopaste


/obj/item/nifrepairer/Initialize(mapload)
	. = ..()
	supply = new(max = 60, A = src)

/obj/item/nifrepairer/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/np = W
		if(np.use(1) && supply.available_volume() >= efficiency)
			to_chat(user,"<span class='notice'>You convert some nanopaste into programmed nanites inside \the [src].</span>")
			supply.add_reagent(id = "nifrepairnanites", amount = efficiency)
			update_icon()
		else if(supply.available_volume() < efficiency)
			to_chat(user,"<span class='warning'>\The [src] is too full. Empty it into a container first.</span>")
			return

/obj/item/nifrepairer/update_icon()
	. = ..()
	if(supply.total_volume)
		icon_state = "[initial(icon_state)]2"
	else
		icon_state = initial(icon_state)

/obj/item/nifrepairer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!target.is_open_container() || !target.reagents)
		return 0

	if(!supply || !supply.total_volume)
		to_chat(user,"<span class='warning'>[src] is empty. Feed it nanopaste.</span>")
		return 1

	if(!target.reagents.available_volume())
		to_chat(user, "<span class='warning'>[target] is already full.</span>")
		return 1

	var/trans = supply.trans_to(target, 15)
	to_chat(user,"<span class='notice'>You transfer [trans] units of the programmed nanites to [target].</span>")
	update_icon()
	return 1

/obj/item/nifrepairer/examine(mob/user, dist)
	. = ..()
	if(supply.total_volume)
		. += "<span class='notice'>\The [src] contains [supply.total_volume] units of programmed nanites, ready for dispensing.</span>"
	else
		. += "<span class='notice'>\The [src] is empty and ready to accept nanopaste.</span>"
