/obj/structure/reagent_dispensers/oil
	name = "Oil Dispenser"
	desc = "A dispenser of crude oil for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	amount_per_transfer_from_this = 10
	anchored = TRUE
	starting_reagents = list(
		/datum/reagent/crude_oil = 1000,
	)
	starting_capacity = 1000

/obj/structure/reagent_dispensers/tallow
	name = "tallow tank"
	desc = "A fifty-litre tank of commercial-grade tallow, intended for use in large scale deep fryers. Store in a cool, dark place"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	amount_per_transfer_from_this = 120
	starting_reagents = list(
		/datum/reagent/nutriment/triglyceride/oil/tallow = 5000,
	)
	starting_capacity = 5000

/obj/structure/reagent_dispensers/cookingoil/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/cookingoil/legacy_ex_act()
	explode()

/obj/structure/reagent_dispensers/cookingoil/proc/explode()
	reagents.splash_area(get_turf(src), 3)
	visible_message(SPAN_DANGER("The [src] bursts open, spreading oil all over the area."))
	qdel(src)
