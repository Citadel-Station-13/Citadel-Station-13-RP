/obj/item/clothing/head/woodcirclet
	name = "wood circlet"
	desc = "A small wood circlet for making a flower crown."
	icon_state = "woodcirclet"
	w_class = ITEMSIZE_SMALL
	body_parts_covered = 0

/obj/item/clothing/head/woodcirclet/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/item/complete
	if(istype(W, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/G = W
		if(G.seed.kitchen_tag == "poppy")
			to_chat(user, "You attach the poppy to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/poppy_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "sunflower")
			to_chat(user, "You attach the sunflower to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/sunflower_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "lavender")
			to_chat(user, "You attach the lavender to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/lavender_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "harebell")
			to_chat(user, "You attach the harebell to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/lavender_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "rose")
			to_chat(user, "You attach the rose to the circlet and create a beautiful flower crown.")
			complete = new /obj/item/clothing/head/rose_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "nettle")
			to_chat(user, "You weave the nettles to the circlet and create a terrifying crown of thorns.")
			complete = new /obj/item/clothing/head/nettle_crown(get_turf(user))
		else if(G.seed.kitchen_tag == "deathnettle")
			to_chat(user, "You weave the death nettles to the circlet and create a horrifying crown of spines.")
			complete = new /obj/item/clothing/head/nettle_crown(get_turf(user))
		user.drop_from_inventory(W)
		user.drop_from_inventory(src)
		qdel(W)
		qdel(src)
		user.put_in_hands(complete)
		return
	return ..()

//Flower crowns

/obj/item/clothing/head/sunflower_crown
	name = "sunflower crown"
	desc = "A flower crown weaved with sunflowers."
	icon_state = "sunflower_crown"
	body_parts_covered = 0

/obj/item/clothing/head/lavender_crown
	name = "lavender crown"
	desc = "A flower crown weaved with lavender."
	icon_state = "lavender_crown"
	body_parts_covered = 0
/obj/item/clothing/head/harebell_crown
	name = "harebell crown"
	desc = "A flower crown weaved with harebell."
	icon_state = "lavender_crown"
	body_parts_covered = 0

/obj/item/clothing/head/poppy_crown
	name = "poppy crown"
	desc = "A flower crown weaved with poppies."
	icon_state = "poppy_crown"
	body_parts_covered = 0

/obj/item/clothing/head/rose_crown
	name = "rose crown"
	desc = "A flower crown weaved with roses."
	icon_state = "poppy_crown"
	body_parts_covered = 0
/obj/item/clothing/head/nettle_crown
	name = "crown of thorns"
	desc = "A crown weaved with nettles and other thorny plants. Itchy."
	icon_state = "nettle_crown"
	body_parts_covered = 0

/obj/item/clothing/head/nettle_death_crown
	name = "crown of spines"
	desc = "A crown weaved with death nettles and other thorny plants. Smells faintly of burning."
	icon_state = "nettle_death_crown"
	body_parts_covered = 0
