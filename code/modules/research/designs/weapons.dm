/datum/prototype/design/science/weapon
	category = DESIGN_CATEGORY_MUNITIONS
	abstract_type = /datum/prototype/design/science/weapon

/datum/prototype/design/science/weapon/ammo
	category = DESIGN_SUBCATEGORY_AMMO
	abstract_type = /datum/prototype/design/science/weapon/ammo

/datum/prototype/design/science/weapon/energy
	subcategory = DESIGN_SUBCATEGORY_ENERGY
	abstract_type = /datum/prototype/design/science/weapon/energy

/datum/prototype/design/science/weapon/energy/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 1750)
	build_path = /obj/item/gun/projectile/energy/stunrevolver

/datum/prototype/design/science/weapon/energy/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 3750, MAT_GLASS = 1250, MAT_URANIUM = 500)
	build_path = /obj/item/gun/projectile/energy/gun/nuclear

/datum/prototype/design/science/weapon/energy/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials_base = list(MAT_STEEL = 3750, MAT_GLASS = 750, MAT_PHORON = 1500)
	build_path = /obj/item/gun/projectile/energy/toxgun

/datum/prototype/design/science/weapon/energy/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	// yeah nah no free lunch here
	materials_base = list(MAT_STEEL = 7500, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/projectile/energy/lasercannon

/datum/prototype/design/science/weapon/energy/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	// yeah nah no free lunch here this thing shouldn't even exist as-is
	materials_base = list(MAT_GOLD = 5000, MAT_URANIUM = 7500)
	build_path = /obj/item/gun/projectile/energy/decloner

/datum/prototype/design/science/weapon/energy/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 3500, MAT_GLASS = 500, MAT_SILVER = 1750)
	build_path = /obj/item/gun/projectile/energy/temperature

/datum/prototype/design/science/weapon/energy/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 500, MAT_URANIUM = 500)
	build_path = /obj/item/gun/projectile/energy/floragun

/datum/prototype/design/science/weapon/ballistic
	subcategory = DESIGN_SUBCATEGORY_BALLISTIC
	abstract_type = /datum/prototype/design/science/weapon/ballistic

/datum/prototype/design/science/weapon/ballistic/ammo
	abstract_type = /datum/prototype/design/science/weapon/ballistic/ammo

/datum/prototype/design/science/weapon/ballistic/ammo/techshell
	design_name = "unloaded tech shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	id = "techshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 125, MAT_PHORON = 25)
	build_path = /obj/item/ammo_casing/a12g/techshell

/datum/prototype/design/science/weapon/ballistic/ammo/stunshell
	design_name = "stun shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials_base = list(MAT_STEEL = 250, MAT_GLASS = 75)
	build_path = /obj/item/ammo_casing/a12g/stunshell

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm
	abstract_type = /datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles
	design_name = "5.7 top-mounted magazine"
	desc = "A standard capacity sidearm magazine (5.7x28mm)."
	id = "ntles"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 1500 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/ap
	design_name = "5.7 top-mounted magazine (AP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm armor-piercing)."
	id = "ntlesap"
	materials_base = list(MAT_STEEL = 1500 * (1 / 3), MAT_COPPER = 1000 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/ap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/hp
	design_name = "5.7 top-mounted magazine (HP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hollow point)."
	id = "ntleshp"
	materials_base = list(MAT_STEEL = 1500 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/hp

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/hunter
	design_name = "5.7 top-mounted magazine (Hunter)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hunter)."
	id = "ntleshunter"
	materials_base = list(MAT_STEEL = 1500 * (1 / 3), MAT_COPPER = 500 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/hunter

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/highcap
	design_name = "5.7 highcap top-mounted magazine"
	desc = "A high capacity sidearm magazine (5.7x28mm)."
	id = "ntleshc"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 2500 * (1 / 3), MAT_COPPER = 2000 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/highcap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/highcap/ap
	design_name = "5.7 highcap top-mounted magazine (AP)"
	desc = "A high capacity sidearm magazine (5.7x28mm armor-piercing)."
	id = "ntleshcap"
	materials_base = list(MAT_STEEL = 2500 * (1 / 3), MAT_COPPER = 2500 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/highcap/ap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/highcap/hp
	design_name = "5.7 highcap top-mounted magazine (HP)"
	desc = "A high capacity sidearm magazine (5.7x28mm hollow point)."
	id = "ntleshchp"
	materials_base = list(MAT_STEEL = 2500 * (1 / 3), MAT_COPPER = 2000 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/highcap/hp

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/ntles/highcap/hunter
	design_name = "5.7 highcap top-mounted magazine (Hunter)"
	desc = "A high capacity sidearm magazine (5.7x28mm hunter)."
	id = "ntleshchunter"
	materials_base = list(MAT_STEEL = 2500 * (1 / 3), MAT_COPPER = 1750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/nt_les/highcap/hunter

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven
	design_name = "5.7 sidearm magazine"
	desc = "A standard capacity sidearm magazine (5.7x28mm)."
	id = "fiveseven"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 1250 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/ap
	design_name = "5.7 sidearm magazine (AP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm armor-piercing)."
	id = "fivesevenap"
	materials_base = list(MAT_STEEL = 1250 * (1 / 3), MAT_COPPER = 1000 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/ap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/hp
	design_name = "5.7 sidearm magazine (HP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hollow point)."
	id = "fivesevenhp"
	materials_base = list(MAT_STEEL = 1250 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/hp

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/hunter
	design_name = "5.7 sidearm magazine (Hunter)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hunter)."
	id = "fivesevenhunter"
	materials_base = list(MAT_STEEL = 1250 * (1 / 3), MAT_COPPER = 250 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/hunter

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/highcap
	design_name = "5.7 sidearm high-cap magazine"
	desc = "A high capacity sidearm magazine (5.7x28mm)."
	id = "fivesevenhc"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials_base = list(MAT_STEEL = 2000 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/highcap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/highcap/ap
	design_name = "5.7 sidearm high-cap magazine (AP)"
	desc = "A high capacity sidearm magazine (5.7x28mm armor-piercing)."
	id = "fivesevenhcap"
	materials_base = list(MAT_STEEL = 2500 * (1 / 3), MAT_COPPER = 1000 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/highcap/ap

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/highcap/hp
	design_name = "5.7 sidearm high-cap magazine (HP)"
	desc = "A high capacity sidearm magazine (5.7x28mm hollow point)."
	id = "fivesevenhchp"
	materials_base = list(MAT_STEEL = 2000 * (1 / 3), MAT_COPPER = 750 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/highcap/hp

/datum/prototype/design/science/weapon/ballistic/ammo/m57x28mm/fiveseven/highcap/hunter
	design_name = "5.7 sidearm high-cap magazine (Hunter)"
	desc = "A high capacity sidearm magazine (5.7x28mm hunter)."
	id = "fivesevenhchunter"
	materials_base = list(MAT_STEEL = 2000 * (1 / 3), MAT_COPPER = 500 * (1 / 3))
	build_path = /obj/item/ammo_magazine/a5_7mm/five_seven/highcap/hunter

/datum/prototype/design/science/weapon/phase
	abstract_type = /datum/prototype/design/science/weapon/phase

/datum/prototype/design/science/weapon/phase/phase_pistol
	id = "phasepistol"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 2250)
	build_path = /obj/item/gun/projectile/energy/phasegun/pistol

/datum/prototype/design/science/weapon/phase/phase_carbine
	id = "phasecarbine"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials_base = list(MAT_STEEL = 3250, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/energy/phasegun

/datum/prototype/design/science/weapon/phase/phase_rifle
	id = "phaserifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 1250, MAT_SILVER = 500)
	build_path = /obj/item/gun/projectile/energy/phasegun/rifle

/datum/prototype/design/science/weapon/phase/phase_cannon
	id = "phasecannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_POWER = 4)
	materials_base = list(MAT_STEEL = 6000, MAT_GLASS = 1250, MAT_SILVER = 750, MAT_DIAMOND = 250)
	build_path = /obj/item/gun/projectile/energy/phasegun/cannon

// Other weapons

/datum/prototype/design/science/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials_base = list(MAT_STEEL = 4500, MAT_GLASS = 1500)
	build_path = /obj/item/gun/projectile/ballistic/syringe/rapid

/datum/prototype/design/science/weapon/dartgun
	desc = "A gun that fires small hollow chemical-payload darts."
	id = "dartgun_r"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 3750, MAT_GOLD = 1750, MAT_SILVER = 1250, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/ballistic/dartgun/research

/datum/prototype/design/science/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/prototype/design/science/weapon/fuelrod
	id = "fuelrod_gun"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 6500, MAT_GLASS = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_URANIUM = 250, MAT_PHORON = 750, MAT_DIAMOND = 375)
	build_path = /obj/item/gun/projectile/magnetic/fuelrod

// Ammo for those

/datum/prototype/design/science/weapon/ammo/dartgunmag_small
	id = "dartgun_mag_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 300, MAT_GOLD = 100, MAT_SILVER = 100, MAT_GLASS = 300)
	build_path = /obj/item/ammo_magazine/chemdart/small

/datum/prototype/design/science/weapon/ammo/dartgun_ammo_small
	id = "dartgun_ammo_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 50, MAT_GOLD = 30, MAT_SILVER = 30, MAT_GLASS = 50)
	build_path = /obj/item/ammo_casing/dart/chemdart/small

/datum/prototype/design/science/weapon/ammo/dartgunmag_med
	id = "dartgun_mag_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 500, MAT_GOLD = 150, MAT_SILVER = 150, MAT_DIAMOND = 200, MAT_GLASS = 400)
	build_path = /obj/item/ammo_magazine/chemdart

/datum/prototype/design/science/weapon/ammo/dartgun_ammo_med
	id = "dartgun_ammo_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials_base = list(MAT_STEEL = 80, MAT_GOLD = 40, MAT_SILVER = 40, MAT_GLASS = 60)
	build_path = /obj/item/ammo_casing/dart/chemdart

/datum/prototype/design/science/weapon/melee
	subcategory = DESIGN_SUBCATEGORY_MELEE
	abstract_type = /datum/prototype/design/science/weapon/melee

/datum/prototype/design/science/weapon/melee/esword
	design_name = "charge sword"
	id = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	materials_base = list(MAT_PLASTEEL = 1750, MAT_GLASS = 750, MAT_LEAD = 750, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/transforming/energy/sword/charge

/datum/prototype/design/science/weapon/melee/eaxe
	design_name = "charge axe"
	id = "chargeaxe"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	materials_base = list(MAT_PLASTEEL = 1500, MAT_OSMIUM = 1500, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/transforming/energy/axe/charge

/datum/prototype/design/science/weapon/grenade
	abstract_type = /datum/prototype/design/science/weapon/grenade

/datum/prototype/design/science/weapon/grenade/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials_base = list(MAT_STEEL = 500)
	build_path = /obj/item/grenade/simple/chemical/large

/datum/prototype/design/science/weapon/energy/netgun
	design_name = "\'Retiarius\' capture gun"
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 1500)
	build_path = /obj/item/gun/projectile/energy/netgun

/datum/prototype/design/science/weapon/energy/sickshot
	desc = "The 'Discombobulator' is a 4-shot energy revolver that causes nausea and confusion."
	id = "sickshot"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/energy/sickshot

/datum/prototype/design/science/weapon/pummeler
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	id = "pummeler"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 750, MAT_URANIUM = 475)
	build_path = /obj/item/gun/projectile/energy/pummeler

/datum/prototype/design/science/weapon/particle
	abstract_type = /datum/prototype/design/science/weapon/particle

/datum/prototype/design/science/weapon/particle/advparticle
	design_name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials_base = list(MAT_STEEL = 3500, MAT_GLASS = 1000, MAT_GOLD = 750, MAT_URANIUM = 375)
	build_path = /obj/item/gun/projectile/energy/particle/advanced

/datum/prototype/design/science/weapon/particle/particlecannon
	design_name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials_base = list(MAT_STEEL = 5000, MAT_GLASS = 1500, MAT_GOLD = 750, MAT_URANIUM = 750, MAT_DIAMOND = 500)
	build_path = /obj/item/gun/projectile/energy/particle/cannon

/datum/prototype/design/science/weapon/particle/pressureinterlock
	design_name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials_base = list(MAT_STEEL = 100, MAT_GLASS = 175)
	build_path = /obj/item/pressurelock

/datum/prototype/design/science/weapon/cell_based
	abstract_type = /datum/prototype/design/science/weapon/cell_based

/datum/prototype/design/science/weapon/cell_based/prototype_nsfw
	design_name = "cell-loaded revolver"
	id = "nsfw_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials_base = list(MAT_STEEL = 4000, MAT_GLASS = 1750, MAT_PHORON = 500, MAT_URANIUM = 1250)
	build_path = /obj/item/gun/projectile/ballistic/microbattery/nt_hydra/sidearm/prototype

/datum/prototype/design/science/weapon/cell_based/prototype_nsfw_mag
	design_name = "combat cell magazine"
	id = "nsfw_mag_prototype"
	subcategory = DESIGN_SUBCATEGORY_AMMO
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials_base = list(MAT_STEEL = 2500, MAT_GLASS = 750, MAT_PHORON = 250)
	build_path = /obj/item/ammo_magazine/microbattery/nt_hydra/prototype

/datum/prototype/design/science/nsfw_cell
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_AMMO
	abstract_type = /datum/prototype/design/science/nsfw_cell

/datum/prototype/design/science/nsfw_cell/generate_name(template)
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_AMMO
	return "Microbattery prototype ([..()])"

/datum/prototype/design/science/nsfw_cell/stun
	design_name = "STUN"
	id = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/stun

/datum/prototype/design/science/nsfw_cell/lethal
	design_name = "LETHAL"
	id = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials_base = list(MAT_STEEL = 500, MAT_GLASS = 500)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/lethal

/datum/prototype/design/science/nsfw_cell/net
	design_name = "NET"
	id = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 1250, MAT_URANIUM = 1250)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/net

/datum/prototype/design/science/nsfw_cell/ion
	design_name = "ION"
	id = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 1250, MAT_SILVER = 1250)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/ion

/datum/prototype/design/science/nsfw_cell/shotstun
	design_name = "SCATTERSTUN"
	id = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 1250, MAT_SILVER = 1250, MAT_GOLD = 1250)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/shotstun

/datum/prototype/design/science/nsfw_cell/xray
	design_name = "XRAY"
	id = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 1250, MAT_SILVER = 1250, MAT_GOLD = 1250, MAT_URANIUM = 1250, MAT_PHORON = 1250)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/xray

/datum/prototype/design/science/nsfw_cell/stripper
	design_name = "STRIPPER"
	id = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials_base = list(MAT_STEEL = 1250, MAT_GLASS = 1250, MAT_URANIUM = 1250, MAT_PHORON = 1250, MAT_DIAMOND = 1250)
	build_path = /obj/item/ammo_casing/microbattery/nt_hydra/stripper

/datum/prototype/design/science/pin
	category = DESIGN_CATEGORY_MUNITIONS
	subcategory = DESIGN_SUBCATEGORY_PINS
	abstract_type = /datum/prototype/design/science/pin

/datum/prototype/design/science/pin/test
	id = "test_range_pin"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_COMBAT = 2)
	materials_base = list(MAT_STEEL = 100)
	build_path = /obj/item/firing_pin/test_range

/datum/prototype/design/science/pin/explorer
	id = "explorer_pin"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_COMBAT = 2)
	materials_base = list(MAT_STEEL = 100, MAT_GLASS = 50)
	build_path = /obj/item/firing_pin/explorer
