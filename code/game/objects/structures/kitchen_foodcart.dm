/obj/structure/foodcart
	name = "Foodcart"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "foodcart-0"
	desc = "The ultimate in food transport! When opened you notice two compartments with odd blue glows to them. One feels very warm, while the other is very cold."
	anchored = 0
	opacity = 0
	density = 1

/obj/structure/foodcart/Initialize(mapload)
	. = ..()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/reagent_containers/food))
			I.loc = src
	update_icon()

/obj/structure/foodcart/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food))
		if(!user.attempt_insert_item_for_installation(O, src))
			return
		update_icon()
		return
	return ..()

/obj/structure/foodcart/attack_hand(var/mob/user as mob)
	if(contents.len)
		var/obj/item/reagent_containers/food/choice = input("What would you like to grab from the cart?") as null|obj in contents
		if(choice)
			if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.loc = get_turf(src)
			update_icon()

/obj/structure/foodcart/update_icon()
	if(contents.len < 5)
		icon_state = "foodcart-[contents.len]"
	else
		icon_state = "foodcart-5"
