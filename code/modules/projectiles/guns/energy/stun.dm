/obj/item/gun/energy/taser
	name = "taser gun"
	desc = "The NT Mk30 NL is a small gun used for non-lethal takedowns. Produced by NT, it's actually a licensed version of a W-T design."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	firemodes = /datum/firemode/energy/stun/taser

/obj/item/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/taser/mounted/cyborg
	name = "taser gun"

/obj/item/gun/energy/stunrevolver
	name = "stun revolver"
	desc = "A LAEP20 Zeus. Designed by Lawson Arms and produced under the wing of Hephaestus, several TSCs have been trying to get a hold of the blueprints for half a decade."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	firemodes = /datum/firemode/energy/stun/stunrevolver

// Xeno stun gun + projectile
/obj/item/gun/energy/taser/xeno
	name = "xeno taser gun"
	desc = "Straight out of NT's testing laboratories, this small gun is used to subdue non-humanoid xeno life forms. \
	While marketed towards handling slimes, it may be useful for other creatures."
	icon_state = "taserold"
	firemodes = /datum/firemode/energy/stun/xeno
	description_info = "This gun will stun a slime or other lesser slimy lifeform for about two seconds, if hit with the projectile it fires."
	description_fluff = "An easy to use weapon designed by NanoTrasen, for NanoTrasen.  This weapon is designed to subdue lesser \
	slime-based xeno lifeforms at a distance.  It is ineffective at stunning non-slimy lifeforms such as humanoids."

/obj/item/gun/energy/taser/xeno/robot // Borg version
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/taser/xeno/sec //NT's corner-cutting option for their on-station security.
	desc = "An NT Mk30 NL retrofitted to fire beams for subduing non-humanoid slimy xeno life forms."
	icon_state = "taserblue"
	item_state = "taser"
	firemodes = /datum/firemode/energy/stun/xeno/security
	description_fluff = "An NT Mk30 NL retrofitted after the events that occurred aboard the NRS Prometheus."

/obj/item/gun/energy/taser/xeno/sec/robot //Cyborg variant of the security xeno-taser.
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE
