/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "The NT Mk30 NL is a small gun used for non-lethal takedowns. Produced by NT, it's actually a licensed version of a W-T design."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	firemodes = /datum/firemode/energy/stun/taser

/obj/item/weapon/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/weapon/gun/energy/taser/mounted/cyborg
	name = "taser gun"

/obj/item/weapon/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A LAEP20 Zeus. Designed by Lawson Arms and produced under the wing of Hephaestus, several TSCs have been trying to get a hold of the blueprints for half a decade."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	firemodes = /datum/firemode/energy/stun/stunrevolver
