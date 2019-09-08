/obj/item/weapon/reagent_containers/pill/nutriment
	name = "Nutriment pill"
	desc = "Used to feed people on the field. Contains 30 units of Nutriment."
	icon_state = "pill6"

/obj/item/weapon/reagent_containers/pill/nutriment/Initialize()
	..()
	reagents.add_reagent("nutriment", 30)
