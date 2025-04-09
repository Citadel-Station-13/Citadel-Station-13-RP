/obj/item/gun/projectile/ballistic/contender
	name = "Thompson Contender"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle"
	item_state = "revolver"
	// single shot, chamber only
	caliber = /datum/ammo_caliber/a357
	internal_magazine = TRUE
	chamber_preload_ammo = /obj/item/ammo_casing/a357
	chamber_simulation = TRUE
	chamber_cycle_after_fire = FALSE
	bolt_simulation = TRUE
	bolt_auto_eject_on_open = FALSE

	heavy = TRUE

	var/icon_retracted = "pockrifle-empty"

// todo: new rendering system
/obj/item/gun/projectile/ballistic/contender/update_icon_state()
	icon_state = bolt_closed ? initial(icon_state) : icon_retracted
	return ..()

/obj/item/gun/projectile/ballistic/contender/a44
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/contender/a762
	caliber = /datum/ammo_caliber/a7_62mm
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a7_62mm

/obj/item/gun/projectile/ballistic/contender/tacticool
	desc = "A modified replica of an ancient one-shot hand-cannon, reinvented with a tactical look. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle_b"
	// icon_retracted = "pockrifle_b-empty"

/obj/item/gun/projectile/ballistic/contender/tacticool/a44
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/contender/tacticool/a762
	caliber = /datum/ammo_caliber/a7_62mm
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a7_62mm

/obj/item/gun/projectile/ballistic/contender/holy
	name = "Divine Challenger"
	desc = "A beautifully engraved pocket rifle with a silvered barrel made of incense wood.Sometimes one good hit is all you need to vanquish a great evil and these handcannons will deliver that one shot."
	icon_state = "pockrifle_c"
	// icon_retracted = "pockrifle_c-empty"
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a357/silver
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_OCCULT = 1)

/obj/item/gun/projectile/ballistic/contender/holy/a44
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44/silver

/obj/item/gun/projectile/ballistic/contender/holy/a762
	caliber = /datum/ammo_caliber/a7_62mm
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a7_62mm/silver

/obj/item/gun/projectile/ballistic/contender/pipegun
	name = "improvised pipe rifle"
	desc = "A single shot, handmade pipe rifle. It almost functions like a bolt action. Accepts shotgun shells."
	icon_state = "pipegun"
	// icon_retracted = "pipegun-empty"
	item_state = "revolver"
	caliber = /datum/ammo_caliber/a12g
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a12g/improvised

	unstable = 1

/obj/item/gun/projectile/ballistic/contender/pipegun/consume_next_projectile(datum/gun_firing_cycle/cycle)
	. = ..()
	if(.)
		if(unstable)
			if(prob(10))
				visible_message("<span class='danger'>The pipe bursts open on [src] as the gun backfires!</span>")
				name = "ruptured pipe rifle"
				desc = "The barrel has blown wide open."
				icon_state = "pipegun-destroyed"
				destroyed = 1
				spawn(1 SECOND)
					explosion(get_turf(src), -1, 0, 2, 3)

		if(destroyed)
			return GUN_FIRED_FAIL_INERT

/obj/item/gun/projectile/ballistic/contender/pipegun/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()
