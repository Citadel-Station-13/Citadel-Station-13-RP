/obj/item/projectile/bullet/reusable
	name = "reusable bullet"
	desc = "How do you even reuse a bullet?"
	var/ammo_type = /obj/item/ammo_casing/arrow
	var/dropped = FALSE

/obj/item/projectile/bullet/reusable/on_hit(atom/target, blocked = FALSE)
	. = ..()
	handle_drop()

/obj/item/projectile/bullet/reusable/on_range()
	handle_drop()
	..()

/obj/item/projectile/bullet/reusable/proc/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		new ammo_type(T)
		dropped = TRUE

//Arrows
/obj/item/projectile/bullet/reusable/arrow
	name = "wooden arrow"
	desc = "Woosh!"
	damage = 15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/arrow/wood

/obj/item/projectile/bullet/reusable/arrow/ash
	name = "ashen arrow"
	desc = "Fire harderned arrow."
	damage = 25
	ammo_type = /obj/item/ammo_casing/arrow/ash

/obj/item/projectile/bullet/reusable/arrow/bone //AP for ashwalkers
	name = "bone arrow"
	desc = "Arrow made of bone and sinew."
	damage = 35
	armor_penetration = 10
	ammo_type = /obj/item/ammo_casing/arrow/bone

/obj/item/projectile/bullet/reusable/arrow/bronze //Just some AP shots
	name = "bronze arrow"
	desc = "Bronze tipped arrow."
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/arrow/bronze
