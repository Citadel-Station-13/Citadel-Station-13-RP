/obj/item/gun/projectile/ballistic/revolver/judge
	name = "\"The Judge\""
	desc = "A revolving hand-shotgun by Cybersun Industries that packs the power of a 12 guage in the palm of your hand (if you don't break your wrist). Uses 12g rounds."
	icon_state = "judge"
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	max_shells = 5
	recoil = 2 // ow my fucking hand
	accuracy = -15 // smooth bore + short barrel = shit accuracy
	ammo_type = /obj/item/ammo_casing/a12g
	projectile_type = /obj/projectile/bullet/shotgun
	// ToDo: Remove accuracy debuf in exchange for slightly injuring your hand every time you fire it.
