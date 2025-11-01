/obj/item/gun/projectile/ballistic/musket
	name = "musket"
	desc = "The precursor to the modern cased ammuntion firearms, muskets use simple hammer mechanism to produce a spark to ignite black \
	powder which then propels a ball out the barrel of the gun. Though over a half millenium outdated muskets and other black powder weapons \
	are still used by hunters seeking more challenge, along with rebels and frontiersmen who don't have access to cased ammo."

	icon_state = "musket"
	item_state = "musket"
	wielded_item_state = "musket-wielded"

	internal_magazine = TRUE
	internal_magazine_preload_ammo = /obj/item/ammo_casing/musket
	internal_magazine_size = 1
	caliber = /datum/ammo_caliber/musket

	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	one_handed_penalty = 30 //You should really use both hands

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)

	firemodes = /datum/firemode{
		cycle_cooldown = 3.5 SECONDS;
	}
	fire_sound = 'sound/weapons/gunshot/musket.ogg'
	recoil = 4
	no_pin_required = 1
	safety_state = GUN_SAFETY_OFF

	var/has_powder = FALSE

/obj/item/gun/projectile/ballistic/musket/special_check(mob/user)
	if(!has_powder)
		to_chat(user, SPAN_WARNING("\The [src] is not loaded with gunpowder!"))
		return FALSE
	if(!user?.client?.get_preference_toggle(/datum/game_preference_toggle/game/help_intent_firing) && user.a_intent == INTENT_HELP)
		to_chat(user, SPAN_WARNING("You refrain from firing [src] because your intent is set to help!"))
		return FALSE
	if(safety_state == GUN_SAFETY_ON)
		to_chat(user, SPAN_WARNING("You squeeze the trigger but it doesn't move!"))
		return FALSE
	else
		var/datum/effect_system/smoke_spread/smoke = new /datum/effect_system/smoke_spread()
		smoke.set_up(3, 0, user.loc)
		smoke.start()
		has_powder = FALSE
		return ..()

/obj/item/gun/projectile/ballistic/musket/attackby(obj/item/W, mob/user)
	..()
	if (istype(W, /obj/item/reagent_containers))
		if(has_powder)
			to_chat(user, SPAN_WARNING("\The [src] is already full of gunpowder."))
			return
		var/obj/item/reagent_containers/C = W
		if(C.reagents.has_reagent("gunpowder", 5))
			if(do_after(user, 15))
				if(has_powder)
					return
				C.reagents.remove_reagent("gunpowder", 5)
				has_powder = TRUE
				to_chat(user, SPAN_NOTICE("You fill \the [src] with gunpowder."))

/obj/item/reagent_containers/glass/powder_horn
	name = "powder horn"
	desc = "An ivory container for gunpowder."
	icon = 'icons/modules/projectiles/rp_ammo_unused.dmi'
	icon_state = "powderhorn"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 60

/obj/item/reagent_containers/glass/powder_horn/filled
	name = "powder horn"
	desc = "An ivory container for gunpowder."

/obj/item/reagent_containers/glass/powder_horn/filled/Initialize(mapload)
	. = ..()
	reagents.add_reagent("gunpowder", 60)

/obj/item/reagent_containers/glass/powder_horn/tribal
	name = "tribal powder horn"
	desc = "An literal powder horn constructed from sinew and the horn of an unknown creature."
	icon_state = "powderhorn-scor"

/obj/item/reagent_containers/glass/powder_horn/tribal/filled
	name = "tribal powder horn"
	desc = "An literal powder horn constructed from sinew and the horn of an unknown creature."

/obj/item/reagent_containers/glass/powder_horn/tribal/filled/Initialize(mapload)
	. = ..()
	reagents.add_reagent("gunpowder", 60)

/obj/item/gun/projectile/ballistic/musket/tribal
	name = "tribal musket"
	desc = "A musket housed in bone furnishing and held together with sinew. It uses as obsidian striker."
	icon_state = "musket-scor"
	item_state = "musket-scor"
	wielded_item_state = "musket-scor-wielded"

/obj/item/gun/projectile/ballistic/musket/pistol
	name = "flintlock pistol"
	desc = "A pistol sized black powder weapon used primarily by reenactors, criminals who can't get bullets, and collectors."
	icon_state = "flintlock"
	item_state = "sawnshotgun"
	wielded_item_state = null
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR

	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = WEIGHT_CLASS_NORMAL
	one_handed_penalty = 0

/obj/item/gun/projectile/ballistic/musket/pistol/brass
	name = "brass wheelock"
	desc = "A brass black powder pistol with a strange gear like firing mechanism. You are not quite certain how it actually works though."
	icon_state = "flintlock-brass"
	item_state = "deagleg"

/obj/item/gun/projectile/ballistic/musket/pistol/tribal
	name = "tribal flintlock"
	desc = "A flintlock pistol cased in bone and sinew. It uses an obsidian striking mechanism, perhaps it should be called an obsidian-lock?"
	icon_state = "flintlock-scor"

/obj/item/gun/projectile/ballistic/blunderbuss
	name = "blunderbuss"
	desc = "The precursor to the modern shotgun. It uses blackpowder to shoot a spread of shrapnel."
	icon_state = "blunderbuss"
	item_state = "blunderbuss"
	wielded_item_state = "blunderbuss-wielded"
	caliber = /datum/ammo_caliber/blunderbuss
	internal_magazine = TRUE
	internal_magazine_preload_ammo = /obj/item/ammo_casing/blunderbuss
	internal_magazine_size = 1
