/obj/item/gun/projectile/musket
	name = "musket"
	desc = "The precursor to the modern cased ammuntion firearms, muskets use simple hammer mechanism to produce a spark to ignite black \
	powder which then propels a ball out the barrel of the gun. Though over a half millenium outdated muskets and other black powder weapons \
	are still used by hunters seeking more challenge, along with rebels and frontiersmen who don't have access to cased ammo."

	icon_state = "musket"
	item_state = "musket"
	wielded_item_state = "musket-wielded"

	load_method = SINGLE_CASING

	max_shells = 1
	caliber = "musket"

	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	one_handed_penalty = 30 //You should really use both hands

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)

	fire_delay = 35
	fire_sound = 'sound/weapons/gunshot/musket.ogg'
	recoil = 4

	ammo_type = /obj/item/ammo_casing/musket

	var/has_powder = FALSE

/obj/item/gun/projectile/musket/special_check(mob/user)
	if(!has_powder)
		to_chat(user, SPAN_WARNING("\The [src] is not loaded with gunpowder!"))
		return FALSE
	if(!user?.client?.is_preference_enabled(/datum/client_preference/help_intent_firing) && user.a_intent == INTENT_HELP)
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

/obj/item/gun/projectile/musket/attackby(obj/item/W, mob/user)
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
	icon = 'icons/obj/ammo.dmi'
	icon_state = "powderhorn"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 30

/obj/item/reagent_containers/glass/powder_horn/Initialize(mapload)
	. = ..()
	reagents.add_reagent("gunpowder", 30)

/obj/item/reagent_containers/glass/powder_horn/tribal
	name = "tribal powder horn"
	desc = "An literal powder horn constructed from sinew and the horn of an unknown creature."
	icon_state = "powderhorn-scor"


/obj/item/gun/projectile/musket/taj
	name = "adhomian musket"
	desc = "For the Tajara, the era of black powder warfare was not all that long ago. As result many genuine Adhomian both reproduction and \
	even genuine muskets are often seen in the hands of Tajaran civilians, and weapons collectors, especially since such weapons circumvent the \
	normally strict weapons laws in many Tajaran states."
	icon_state = "musket-taj"
	item_state = "musket-taj"
	wielded_item_state = "musket-taj-wielded"

/obj/item/gun/projectile/musket/tribal
	name = "tribal musket"
	desc = "A musket housed in bone furnishing and held together with sinew. It uses as obsidian striker."
	icon_state = "musket-scor"
	item_state = "musket-scor"
	wielded_item_state = "musket-scor-wielded"

/obj/item/gun/projectile/musket/pistol
	name = "flintlock pistol"
	desc = "A pistol sized black powder weapon used primarily by reenactors, criminals who can't get bullets, and collectors."
	icon_state = "flintlock"
	item_state = "sawnshotgun"
	wielded_item_state = null

	slot_flags = SLOT_BELT|SLOT_HOLSTER
	w_class = ITEMSIZE_NORMAL
	one_handed_penalty = 0

/obj/item/gun/projectile/musket/pistol/brass 
	name = "brass wheelock"
	desc = "A brass black powder pistol with a strange gear like firing mechanism. You are not quite certain how it actually works though."
	icon_state = "flintlock-brass"
	item_state = "deagleg"


/obj/item/gun/projectile/musket/pistol/tribal
	name = "tribal flintlock"
	desc = "A flintlock pistol cased in bone and sinew. It uses an obsidian striking mechanism, perhaps it should be called an obsidian-lock?"
	icon_state = "flintlock-scor"



/obj/item/gun/projectile/musket/blunderbuss
	name = "blunderbuss"
	desc = "The precursor to the modern shotgun. It uses blackpowder to shoot a spread of shrapnel."
	icon_state = "blunderbuss"
	item_state = "blunderbuss"
	wielded_item_state = "blunderbuss-wielded"
	caliber = "blunderbuss"

	ammo_type = /obj/item/ammo_casing/musket/blunderbuss
