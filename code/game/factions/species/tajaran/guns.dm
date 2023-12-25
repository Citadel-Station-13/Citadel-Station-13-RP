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

/obj/item/gun/projectile/ballistic/revolver/mateba/taj
	name = "Adhomai revolver"
	desc = "The Akhan and Khan Royal Service Revolver. Sophisticated but dated, this weapon is a metaphor for the New Kingdom of Adhomai itself."
	icon_state = "mateba-taj"

/obj/item/gun/projectile/ballistic/revolver/mateba/taj/knife
	name = "Adhomai knife revolver"
	desc = "An ornate knife revolver from an Adhomai gunsmith. Popular among Tajaran nobility just before the civil war and even to this day, many of these revolvers found their way into the market when they were taken as trophies by Grand People's Army soldiers and DPRA guerillas."
	icon_state = "knifegun"
	caliber = ".38"
	ammo_type = /obj/item/ammo_casing/a38
	damage_force = 15
	sharp = 1
	edge = 1

/obj/item/gun/projectile/ballistic/contender/taj
	name = "Adhomai pocket rifle"
	desc = "A hand cannon produced by Akhan and Khan. Its simple design dates back to the civil war where hand cannons like it were rushed into service to counter the massive arms shortage the Kingdom of Adhomai faced at the start of the war. Since then A&K have refined the design into a mainstay backup weapon of solider and civilian alike."
	icon_state = "pockrifle_d"
	icon_retracted = "pockrifle_d-empty"

/obj/item/gun/projectile/ballistic/contender/taj/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/ballistic/contender/taj/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762
