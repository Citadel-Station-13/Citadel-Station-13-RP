//Note: So I tried to make it so arrows can shatter on impact, but the code doesn't like that, and ignores the drop chance entirely. Slate this for review.

/obj/projectile/bullet/reusable
	name = "reusable bullet"
	desc = "How do you even reuse a bullet?"
	var/ammo_type = /obj/item/ammo_casing/arrow

	//var/fragile = FALSE
	//var/durable = FALSE
	//var/shattered = 0
	//var/broken_type = null

/obj/projectile/bullet/reusable/expire(impacting)
	handle_drop()
	return ..()

/obj/projectile/bullet/reusable/proc/handle_drop()
	var/turf/T = get_turf(src)
	new ammo_type(T)

//Arrows
/obj/projectile/bullet/reusable/arrow
	name = "wooden arrow"
	desc = "Woosh!"
	damage_force = 15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/arrow/wood
	//broken_type = /obj/item/trash/broken_arrow

//Ashlander Base Arrow
/obj/projectile/bullet/reusable/arrow/bone
	name = "bone arrow"
	desc = "Arrow made of bone and sinew."
	damage_force = 15
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/arrow/bone

/obj/projectile/bullet/reusable/arrow/ash
	name = "ashen arrow"
	desc = "Fire harderned arrow."
	damage_force = 25
	ammo_type = /obj/item/ammo_casing/arrow/ash

/obj/projectile/bullet/reusable/arrow/bone_ap //AP for ashwalkers
	name = "hardened bone arrow"
	desc = "Arrow made of bone and sinew."
	damage_force = 35
	damage_tier = 2.5
	ammo_type = /obj/item/ammo_casing/arrow/bone_ap

/obj/projectile/bullet/reusable/arrow/bronze //Just some AP shots
	name = "bronze arrow"
	desc = "Bronze tipped arrow."
	damage_tier = 3
	ammo_type = /obj/item/ammo_casing/arrow/bronze

//Plunger
/obj/projectile/bullet/reusable/plunger
	name = "plunger"
	desc = "It's a plunger, for plunging."
	damage_force = 15
	icon_state = "plunger"
	ammo_type = /obj/item/ammo_casing/arrow/plunger

/obj/projectile/bullet/reusable/plunger/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	// use target abort as this is a target effect.
	if(. & PROJECTILE_IMPACT_FLAGS_TARGET_ABORT)
		return
	var/mob/living/carbon/H = target
	if(!istype(H))
		return
	var/obj/item/plunger/P
	if(!H.wear_mask)
		H.equip_to_slot_if_possible(P, SLOT_MASK)
	else
		handle_drop()
	return . | PROJECTILE_IMPACT_DELETE

//Foam Darts
/obj/projectile/bullet/reusable/foam
	name = "foam dart"
	desc = "A soft projectile made out of orange foam with a blue plastic tip."
	damage_force = 0
	ammo_type = /obj/item/ammo_casing/foam
	embed_chance = 0 // nope

/obj/projectile/bullet/reusable/foam/riot
	name = "riot dart"
	desc = "A flexible projectile made out of hardened orange foam with a red plastic tip."
	damage_force = 10
	damage_type = DAMAGE_TYPE_HALLOSS
	ammo_type = /obj/item/ammo_casing/foam/riot
