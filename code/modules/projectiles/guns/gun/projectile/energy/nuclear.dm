/datum/firemode/energy/energy_gun
	abstract_type = /datum/firemode/energy/energy_gun

/datum/firemode/energy/energy_gun/stun
	name = "stun"
	projectile_type = /obj/projectile/beam/stun/med
	charge_cost = 2400 / 10
	cycle_cooldown = 0.4 SECONDS
	legacy_direct_varedits = list(
		"modifystate" = "energystun",
	)

/datum/firemode/energy/energy_gun/kill
	name = "lethal"
	projectile_type = /obj/projectile/beam
	charge_cost = 2400 / 5
	cycle_cooldown = 0.8 SECONDS
	legacy_direct_varedits = list(
		"modifystate" = "energykill",
	)

/obj/item/gun/projectile/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and "+TSC_HEPH+", the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	description_info = "This is an energy weapon.  To fire the weapon, ensure your intent is *not* set to 'help', have your gun mode set to 'fire', \
	then click where you want to fire.  Most energy weapons can fire through windows harmlessly.  To switch between stun and lethal, click the weapon \
	in your hand.  To recharge this weapon, use a weapon recharger."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.

	worth_intrinsic = 250
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	firemodes = list(
		/datum/firemode/energy/energy_gun/stun,
		/datum/firemode/energy/energy_gun/kill,
	)

/obj/item/gun/projectile/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1

/datum/firemode/energy/burst_laser
	abstract_type = /datum/firemode/energy/burst_laser
	burst_delay = 0.2 SECONDS
	cycle_cooldown = 0.6 SECONDS

/datum/firemode/energy/burst_laser/stun
	name = "stun"
	legacy_direct_varedits = list(projectile_type=/obj/projectile/beam/stun/weak, modifystate="fm-2tstun", charge_cost = 100)

/datum/firemode/energy/burst_laser/stun_burst
	name = "stun burst"
	burst_amount = 3
	legacy_direct_varedits = list(burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/projectile/beam/stun/weak, modifystate="fm-2tstun")

/datum/firemode/energy/burst_laser/lethal
	name = "lethal"
	legacy_direct_varedits = list(projectile_type=/obj/projectile/beam/burstlaser, modifystate="fm-2tkill", charge_cost = 200)

/datum/firemode/energy/burst_laser/lethal_burst
	name = "lethal burst"
	burst_amount = 3
	legacy_direct_varedits = list(burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), projectile_type=/obj/projectile/beam/burstlaser, modifystate="fm-2tkill")

/obj/item/gun/projectile/energy/gun/burst
	name = "burst laser"
	desc = "The FM-2t is a versatile energy based weapon, capable of switching between stun or kill with a three round burst option for both settings."
	icon_state = "fm-2tstun100"	//May resprite this to be more rifley
	item_state = null	//so the human update icon uses the icon_state instead.
	charge_cost = 100
	damage_force = 8
	w_class = WEIGHT_CLASS_BULKY	//Probably gonna make it a rifle sooner or later
	heavy = TRUE
	projectile_type = /obj/projectile/beam/stun/weak
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 3)
	modifystate = "fm-2tstun"

	one_handed_penalty = 30
	worth_intrinsic = 450

	firemodes = list(
		/datum/firemode/energy/burst_laser/stun,
		/datum/firemode/energy/burst_laser/stun_burst,
		/datum/firemode/energy/burst_laser/lethal,
		/datum/firemode/energy/burst_laser/lethal_burst,
	)

/datum/firemode/energy/mining_carbine
	burst_delay = 0.1 SECONDS
	cycle_cooldown = 0.3 SECONDS

/datum/firemode/energy/mining_carbine/mine
	name = "mine"
	projectile_type = /obj/projectile/beam/excavation
	legacy_direct_varedits = list(modifystate="fm-2tstun", charge_cost = 20)

/datum/firemode/energy/mining_carbine/mine_burst
	name = "mine burst"
	projectile_type = /obj/projectile/beam/excavation
	burst_amount = 5
	legacy_direct_varedits = list(burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), modifystate="fm-2tstun")

/datum/firemode/energy/mining_carbine/scatter
	name = "scatter"
	projectile_type = /obj/projectile/scatter/excavation
	legacy_direct_varedits = list(modifystate="fm-2tkill", charge_cost = 40)

/datum/firemode/energy/mining_carbine/scatter_burst
	name = "scatter burst"
	burst_amount = 5
	projectile_type = /obj/projectile/scatter/excavation
	legacy_direct_varedits = list(burst_accuracy=list(65,65,65), dispersion=list(0.0, 0.2, 0.5), modifystate="fm-2tkill")

/obj/item/gun/projectile/energy/gun/miningcarbine
	name = "mining carbine"
	desc = "Following Miner's demand for a portable excavation laser, a military-favourite FM-2t has been modified to shoot excavation lasers."
	icon_state = "fm-2tstun100"	//May resprite this to be more rifley
	item_state = null	//so the human update icon uses the icon_state instead.
	charge_cost = 20
	damage_force = 8
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	modifystate = "fm-2tstun"

	firemodes = list(
		/datum/firemode/energy/mining_carbine/mine,
		/datum/firemode/energy/mining_carbine/mine_burst,
		/datum/firemode/energy/mining_carbine/scatter,
		/datum/firemode/energy/mining_carbine/scatter_burst,
	)

/datum/firemode/energy/advanced_energy_gun
	abstract_type = /datum/firemode/energy/advanced_energy_gun
	cycle_cooldown = 0.6 SECONDS

/datum/firemode/energy/advanced_energy_gun/stun
	name = "stun"
	projectile_type = /obj/projectile/beam/stun/med
	charge_cost = 2400 / 10

/datum/firemode/energy/advanced_energy_gun/kill
	name = "lethal"
	projectile_type = /obj/projectile/beam
	charge_cost = 2400 / 5

/obj/item/gun/projectile/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgunstun"
	projectile_type = /obj/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	damage_force = 8 //looks heavier than a pistol
	w_class = WEIGHT_CLASS_BULKY	//Looks bigger than a pistol, too.
	heavy = TRUE
	cell_type = /obj/item/cell/device/weapon/recharge
	legacy_battery_lock = 1
	modifystate = null

//	requires_two_hands = 1
	one_handed_penalty = 30 // It's rather bulky at the fore, so holding it in one hand is harder than with two.

	firemodes = list(
		/datum/firemode/energy/advanced_energy_gun/stun,
		/datum/firemode/energy/advanced_energy_gun/kill,
	)

/datum/firemode/energy/legacy_nt_combat_pistol
	abstract_type = /datum/firemode/energy/advanced_energy_gun
	cycle_cooldown = 0.6 SECONDS

/datum/firemode/energy/legacy_nt_combat_pistol/stun
	name = "stun"
	projectile_type = /obj/projectile/beam/stun/med
	charge_cost = 2400 / 12

/datum/firemode/energy/legacy_nt_combat_pistol/kill
	name = "lethal"
	projectile_type = /obj/projectile/beam
	charge_cost = 2400 / 6

//NT SpecOps Laser Pistol
/obj/item/gun/projectile/energy/gun/combat
	name = "NT-ES-2 energy pistol"
	desc = "A purpose-built energy weapon designed to function as a sidearm for Nanotrasen special operations. This weapon is ideal for hazardous environments where both lethal and non-lethal responses may be required."
	icon_state = "clpistolstun100"
	modifystate = "clpistolstun"

	firemodes = list(
		/datum/firemode/energy/legacy_nt_combat_pistol/stun,
		/datum/firemode/energy/legacy_nt_combat_pistol/kill,
	)
