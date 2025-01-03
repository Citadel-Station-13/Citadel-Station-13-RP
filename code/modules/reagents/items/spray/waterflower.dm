
/obj/item/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	var/empty = 0
	slot_flags = SLOT_HOLSTER
	damage_force = 0

/obj/item/reagent_containers/spray/waterflower/Initialize(mapload)
	. = ..()
	var/datum/reagent_holder/R = create_reagents(10)
	R.add_reagent("water", 10)
