//////////////////////////////////////////
// Generic Tajara Weapons
///////////////////////////////////////////
/* Notes on Tajara Firearms:
The Tajara history is more or less that a fuedal society with early 19th century technology was contacted by aliens with all their new dangerous ideas and cased \
munition firearm technology (way better then mnuskets). The resulting civil war was extremely devastating and no one won, as a result Tajara weapons technology is
extremely varied ranging from 19th century crude to modern and post modern automatics. */


/obj/item/gun/projectile/ballistic/contender/taj
	name = "Adhomai pocket rifle"
	desc = "A simple Adhomai Hand Cannon. Its simple design dates back to the civil war where hand cannons like it were rushed into service to counter the massive arms shortage \
	the many factions faced at the start of the war. Since then various local manufacturers have refined the design into a mainstay backup weapon of solider and civilian alike."
	icon = 'icons/content/factions/tajara/items/guns/taj_pockrifle.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_pockrifle.dmi'
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/contender/taj/a44
	caliber = /datum/ammo_caliber/a44
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/contender/taj/a762
	caliber = /datum/ammo_caliber/a7_62mm
	internal_magazine_preload_ammo = /obj/item/ammo_casing/a7_62mm

/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj/sawn
	name = "Adhomai obrez"
	desc = "The civil war on Adhomai saw countless gun manufacturers pumping out cheap bolt action rifles. During the general chaos of the civil \
	war many of these rifles were sawn down by revolutionaries and bandits who couldn't get their hands on proper pistols. Even as technology \
	on Adhomai has moved past bolt actions these guns remain plentiful among the criminal underworld and other nefarious groups."
	icon_state = "sawnrifle"
	item_state = "sawnrifle"
	recoil = 2
	accuracy = -15
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	render_use_legacy_by_default = FALSE

/obj/item/gun/projectile/ballistic/musket/taj
	name = "Adhomian musket"
	desc = "For the Tajara, the era of black powder warfare was not all that long ago. As result many genuine Adhomian muskets both reproduction and \
	even genuine, are often seen in the hands of Tajaran civilians and weapons collectors. They are especially prominent in many Tajaran states where \
	strict firearms laws prevent the ownership of modern weapons."
	icon = 'icons/content/factions/tajara/items/guns/taj_musket.dmi'
	inhand_icon = 'icons/content/factions/tajara/items/guns/taj_musket.dmi'
	icon_state = "musket"
	item_state = "musket"
	wielded_item_state = "musket-wielded"
	render_use_legacy_by_default = FALSE
