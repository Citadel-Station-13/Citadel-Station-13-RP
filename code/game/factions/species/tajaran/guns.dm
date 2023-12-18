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

/obj/item/gun/projectile/ballistic/deagle/taj
	name = "Adhomai Hand Cannon"
	desc = "The Nal'dor heavy pistol, a powerful Hadii-Wrack group handcannon that has gained an infamous reputation through its use by Commissars of the People's Republic of Adhomai."
	icon_state = "deagle-taj"

/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj
	name = "Adhomai bolt action rifle"
	desc = "The A&K-c bolt action rifle. Though a simple and dated design, this Akhan and Khan rifle is a mainstay of the of the Imperial Adhomain Army and has kept Tajaran monarchy safe since the civil war."
	item_state = "boltaction-taj"
	icon_state = "boltaction-taj"
	wielded_item_state = "boltaction-taj-wielded"

/obj/item/gun/projectile/ballistic/SVD/taj
	name = "Adhomai sniper rifle"
	desc = "The Hotaki Marksman rifle, in stark contrast to the usual products of Hotak's arms, is an elegant and precise rifle that has taken the lives of many high value targets in the name of defending the Democratic People's Republic of Adhomai."
	icon_state = "svd-taj"
	item_state = "svd-taj"
	wielded_item_state = "svd-taj-wielded"

/obj/item/gun/projectile/ballistic/SVD/taj/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "SVD-taj"
	else
		icon_state = "SVD-taj-empty"
