/datum/firemode/energy/taser
	cycle_cooldown = 0.4 SECONDS

/datum/firemode/energy/taser/stun
	name = "stun"
	projectile_type = /obj/projectile/energy/electrode
	legacy_direct_varedits = list(modifystate="taser", charge_cost = 240)

/datum/firemode/energy/taser/disable
	name = "disable"
	projectile_type = /obj/projectile/beam/disabler/weak
	legacy_direct_varedits = list(modifystate="taserblue", charge_cost = 160)

/obj/item/gun/projectile/energy/taser
	name = "taser gun"
	desc = "The NT Mk31 NL is a small gun used for non-lethal takedowns. An NT exclusive iteration of the Mk30 WT design, the Mk31 features a variable output mechanism which draws from a singular power source, allowing for versatile firing solutions without increased weight."
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly. To recharge this weapon, use a weapon recharger."
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.

	worth_intrinsic = 350
	modifystate = "taser"

	firemodes = list(
		/datum/firemode/energy/taser/stun,
		/datum/firemode/energy/taser/disable,
	)

/obj/item/gun/projectile/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = 1
	use_external_power = 1

/obj/item/gun/projectile/energy/taser/mounted/augment
	self_recharge = 1
	use_external_power = 0
	use_organic_power = TRUE

/obj/item/gun/projectile/energy/taser/mounted/cyborg
	name = "taser gun"
	charge_cost = 400
	recharge_time = 7 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/projectile/energy/taser/mounted/cyborg/swarm
	name = "disabler"
	desc = "An archaic device which attacks the target's nervous-system or control circuits."
	projectile_type = /obj/projectile/beam/stun/disabler
	charge_cost = 200
	recharge_time = 0.5 SECONDS

/obj/item/gun/projectile/energy/stunrevolver
	name = "stun revolver"
	desc = "A LAEP20 Zeus. Designed by Lawson Arms and produced under the wing of Hephaestus, several TSCs have been trying to get a hold of the blueprints for half a decade."
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	projectile_type = /obj/projectile/energy/electrode/strong
	charge_cost = 400

/obj/item/gun/projectile/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = WEIGHT_CLASS_SMALL
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	materials_base = list(MAT_STEEL = 2000)
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	silenced = 1
	projectile_type = /obj/projectile/energy/bolt
	charge_cost = 480
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	charge_meter = 0

/obj/item/gun/projectile/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/projectile/energy/dart

/obj/item/gun/projectile/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = WEIGHT_CLASS_BULKY
	materials_base = list(MAT_STEEL = 200000)
	damage_force = 10
	slot_flags = SLOT_BELT
	projectile_type = /obj/projectile/energy/bolt/large

/obj/item/gun/projectile/energy/plasmastun
	name = "plasma pulse projector"
	desc = "The Mars Military Industries MA21 Selkie is a weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon_state = "plasma_stun"
	item_state = "plasma_stun"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_POWER = 3)
	firemodes = /datum/firemode/energy{
		projectile_type = /obj/projectile/energy/plasmastun;
		cycle_cooldown = 2 SECONDS;
		charge_cost = 2400 / 4;
	}
	one_handed_penalty = 5

/obj/item/gun/projectile/energy/civtas
	name = "Palm Taser"
	desc = "A LAEP5 'Little Thunder' tiny concealable taser pistol designed for the civilian self defense market. Attaches to the palm of the hand with a stylish leather strap to delivers a powerful single stun blast onto an unsuspecting target"
	icon_state = "civtas"
	item_state = "concealed"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3, TECH_POWER = 3)
	firemodes = /datum/firemode/energy{
		projectile_type = /obj/projectile/energy/electrode/stunshot;
		cycle_cooldown = 0.4 SECONDS;
		charge_cost = 2400 / 2;
	}
