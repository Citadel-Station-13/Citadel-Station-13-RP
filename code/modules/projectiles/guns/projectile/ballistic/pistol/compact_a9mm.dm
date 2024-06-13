/obj/item/gun/projectile/ballistic/pistol
	name = "compact pistol"
	desc = "An ultra-compact pistol with a matte black finish. Uses 9mm."
	description_fluff = "The Lumoco Arms P3 Whisper is a compact, easily concealable gun. Designed by GMC as a simplified improvement to the Konigin, the Whisper comes with a threaded barrel and slender profile. This weapon was favored by Syndicate special operatives during the Phoron War, and retains a somewhat sinister reputation to this day. Due to its slim design it is only compatible with compact 9mm magazines."
	icon_state = "pistol"
	item_state = null
	w_class = WEIGHT_CLASS_SMALL
	caliber = "9mm"
	suppressible = TRUE
	silenced_icon = "pistol_silencer"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm/compact
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/compact)
	projectile_type = /obj/projectile/bullet/pistol

/obj/item/gun/projectile/ballistic/pistol/flash
	name = "compact signal pistol"
	magazine_type = /obj/item/ammo_magazine/m9mm/compact/flash
