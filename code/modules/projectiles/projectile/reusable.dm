//Note: So I tried to make it so arrows can shatter on impact, but the code doesn't like that, and ignores the drop chance entirely. Slate this for review.

/obj/item/projectile/bullet/reusable
	name = "reusable bullet"
	desc = "How do you even reuse a bullet?"
	var/ammo_type = /obj/item/ammo_casing/arrow
	var/dropped = FALSE

	//var/fragile = FALSE
	//var/durable = FALSE
	//var/shattered = 0
	//var/broken_type = null

/obj/item/projectile/bullet/reusable/on_hit(atom/target, blocked = FALSE)
	. = ..()
	handle_drop()
	//handle_shatter()

/obj/item/projectile/bullet/reusable/on_range()
	handle_drop()
	..()

/obj/item/projectile/bullet/reusable/proc/handle_drop()
	if(!dropped)
		var/turf/T = get_turf(src)
		new ammo_type(T)
		dropped = TRUE
/*
	else
		var/turf/T = get_turf(src)
		new broken_type(T)
		dropped = TRUE

/obj/item/projectile/bullet/reusable/proc/handle_shatter()
	if(fragile)
		switch(rand(1,100))
			if(1 to 50)
				src.shattered = 1
			if(31 to 100)
				return
	if(durable)
		switch(rand(1,100))
			if(1 to 5)
				src.shattered = 1
			if(6 to 100)
				return
	else
		switch(rand(1,100))
			if(1 to 25)
				src.shattered = 1
			if(16 to 100)
				return
		return
*/

//Arrows
/obj/item/projectile/bullet/reusable/arrow
	name = "wooden arrow"
	desc = "Woosh!"
	damage = 15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/arrow/wood
	//broken_type = /obj/item/trash/broken_arrow

//Ashlander Base Arrow
/obj/item/projectile/bullet/reusable/arrow/bone
	name = "bone arrow"
	desc = "Arrow made of bone and sinew."
	damage = 15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/arrow/bone

/obj/item/projectile/bullet/reusable/arrow/ash
	name = "ashen arrow"
	desc = "Fire harderned arrow."
	damage = 25
	ammo_type = /obj/item/ammo_casing/arrow/ash

/obj/item/projectile/bullet/reusable/arrow/bone_ap //AP for ashwalkers
	name = "hardened bone arrow"
	desc = "Arrow made of bone and sinew."
	damage = 35
	armor_penetration = 10
	ammo_type = /obj/item/ammo_casing/arrow/bone_ap

/obj/item/projectile/bullet/reusable/arrow/bronze //Just some AP shots
	name = "bronze arrow"
	desc = "Bronze tipped arrow."
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/arrow/bronze

//Plunger
/obj/item/projectile/bullet/reusable/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	damage = 15
	icon_state = "plunger"
	ammo_type = /obj/item/ammo_casing/arrow/plunger

/obj/item/projectile/bullet/reusable/plunger/on_hit(atom/hit_atom)
	. = ..()
	var/mob/living/carbon/H = hit_atom
	var/obj/item/plunger/P
	if(!H.wear_mask)
		H.equip_to_slot_if_possible(P, SLOT_MASK)
	else
		handle_drop()

//Foam Darts
/obj/item/projectile/bullet/reusable/foam
	name = "foam dart"
	desc = "A soft projectile made out of orange foam with a blue plastic tip."
	damage = 0
	ammo_type = /obj/item/ammo_casing/foam
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	embed_chance = 0 // nope

/obj/item/projectile/bullet/reusable/foam/riot
	name = "riot dart"
	desc = "A flexible projectile made out of hardened orange foam with a red plastic tip."
	damage = 10
	damage_type = HALLOSS
	ammo_type = /obj/item/ammo_casing/foam/riot
