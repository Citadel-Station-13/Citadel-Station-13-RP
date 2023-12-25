/obj/item/gun/projectile/ballistic/revolver/consul
	name = "\improper \"Consul\" Revolver"
	desc = "Are you feeling lucky, punk? Uses .44 rounds."
	icon_state = "inspector"
	item_state = "revolver"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/rubber
	handle_casings = CYCLE_CASINGS
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/revolver/consul/update_overlays()
	. = ..()
	if(loaded.len==0)
		. += "inspector_off"
	else
		. += "inspector_on"
