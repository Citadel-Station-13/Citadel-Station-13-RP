/obj/item/gun/projectile/ballistic/derringer
	name = "derringer"
	desc = "It's not size of your gun that matters, just the size of your load. Uses .357 rounds." //OHHH MYYY~
	icon_state = "derringer"
	item_state = "concealed"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	max_shells = 2
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/projectile/bullet/pistol/strong
