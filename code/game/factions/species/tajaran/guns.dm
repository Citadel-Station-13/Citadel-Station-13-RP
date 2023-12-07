/obj/item/gun/projectile/ballistic/automatic/automat/taj
	name = "Adhomai automat"
	desc = "The Hadii-Wrack Avtomat, is an aging internal magazine automatic rifle of the People's Republic of Adhomai's Grand People's Army whose long and storied service life is coming to an end as it is phased out in favor of more modern automatics."
	icon_state = "automat-taj"
	item_state = "automat-taj"
	wielded_item_state = "automat-taj-wielded"
	fire_anim = ""

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/taj
	name = "\improper Adhomai Uzi"
	desc = "The Hotak's Arms machine pistol has developed a fierce reputation for its use by guerillas of the Democratic People's Republic of Adhomai. Its top loading magazine allows one to go completely prone in the deep snow banks of Adhomai while maintaining good weapon stability."
	icon_state = "mini-uzi-taj"
	item_state = "mini-uzi-taj"

/obj/item/gun/projectile/ballistic/automatic/mini_uzi/taj/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "mini-uzi-taj"
		item_state = "mini-uzi-taj"
	else
		icon_state = "mini-uzi-taj-empty"
		item_state = "mini-uzi-taj-empty"
