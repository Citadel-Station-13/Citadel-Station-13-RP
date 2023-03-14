/datum/design/science/weapon/generate_name(template)
	return "Weapon prototype ([..()])"

/datum/design/science/weapon/ammo/generate_name(template)
	return "Weapon ammo ([..()])"

// Energy weapons

/datum/design/science/weapon/energy/generate_name(template)
	return "Energy weapon prototype ([..()])"

/datum/design/science/weapon/energy/stunrevolver
	identifier = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver

/datum/design/science/weapon/energy/nuclear_gun
	identifier = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/gun/nuclear

/datum/design/science/weapon/energy/phoronpistol
	identifier = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_PHORON = 3000)
	build_path = /obj/item/gun/energy/toxgun

/datum/design/science/weapon/energy/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	identifier = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon

/datum/design/science/weapon/energy/decloner
	identifier = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000)
	build_path = /obj/item/gun/energy/decloner

/datum/design/science/weapon/energy/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	identifier = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 500, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature

/datum/design/science/weapon/energy/flora_gun
	identifier = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun

// Ballistic weapons

/datum/design/science/weapon/ballistic/generate_name(template)
	return "Ballistic weapon prototype ([..()])"

/datum/design/science/weapon/ballistic/advanced_smg
	identifier = "smg"
	desc = "An advanced 9mm SMG with a reflective laser optic."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 8000, MAT_SILVER = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/ballistic/automatic/advanced_smg

/datum/design/science/weapon/ballistic/p90
	identifier = "p90"
	desc = "The H90K is a compact, large capacity submachine gun produced by Hephaestus Industries. Despite its fierce reputation, it still manages to feel like a toy. Uses 9mm rounds."
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 5000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/ballistic/automatic/p90

// Ballistic ammo

/datum/design/science/weapon/ballistic/ammo/generate_name(template)
	return "Ballistic weapon ammo ([..()])"

/datum/design/science/weapon/ballistic/ammo/ammo_9mmAdvanced
	name = "9mm magazine"
	identifier = "ammo_9mm"
	desc = "A 21 round magazine for an advanced 9mm SMG."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced

/datum/design/science/weapon/ballistic/ammo/techshell
	name = "unloaded tech shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	identifier = "techshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 500, MAT_PHORON = 200)
	build_path = /obj/item/ammo_casing/a12g/techshell

/datum/design/science/weapon/ballistic/ammo/stunshell
	name = "stun shell"
	desc = "A stunning shell for a shotgun."
	identifier = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 360, MAT_GLASS = 720)
	build_path = /obj/item/ammo_casing/a12g/stunshell

/datum/design/science/weapon/ballistic/ammo/m57x28mmp90
	name = "H90K magazine"
	desc = "A large capacity top mounted magazine (5.7x28mm armor-piercing)."
	identifier = "m57x28mmp90"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 2250, MAT_PLASTIC = 1500, MAT_COPPER = 1000)
	build_path = /obj/item/ammo_magazine/m57x28mmp90

/datum/design/science/weapon/ballistic/ammo/m57x28mm
	name = "5.7 magazine"
	desc = "A standard capacity sidearm magazine (5.7x28mm)."
	identifier = "m57x28mm"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 1750, MAT_COPPER = 750)
	build_path = /obj/item/ammo_magazine/m57x28mm

/datum/design/science/weapon/ballistic/ammo/m57x28mm/ap
	name = "5.7 magazine (AP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm armor-piercing)."
	identifier = "m57x28mmap"
	materials = list(MAT_STEEL = 2500, MAT_COPPER = 750)
	build_path = /obj/item/ammo_magazine/m57x28mm/ap

/datum/design/science/weapon/ballistic/ammo/m57x28mm/hp
	name = "5.7 magazine (HP)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hollow point)."
	identifier = "m57x28mmhp"
	materials = list(MAT_STEEL = 2100, MAT_COPPER = 750)
	build_path = /obj/item/ammo_magazine/m57x28mm/hp

/datum/design/science/weapon/ballistic/ammo/m57x28mm/hunter
	name = "5.7 magazine (Hunter)"
	desc = "A standard capacity sidearm magazine (5.7x28mm hunter)."
	identifier = "m57x28mmhunter"
	materials = list(MAT_STEEL = 1750, MAT_COPPER = 1250)
	build_path = /obj/item/ammo_magazine/m57x28mm/hunter

// Phase weapons

/datum/design/science/weapon/phase/generate_name(template)
	return "Phase weapon prototype ([..()])"

/datum/design/science/weapon/phase/phase_pistol
	identifier = "phasepistol"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/phasegun/pistol

/datum/design/science/weapon/phase/phase_carbine
	identifier = "phasecarbine"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1500)
	build_path = /obj/item/gun/energy/phasegun

/datum/design/science/weapon/phase/phase_rifle
	identifier = "phaserifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2000, MAT_SILVER = 500)
	build_path = /obj/item/gun/energy/phasegun/rifle

/datum/design/science/weapon/phase/phase_cannon
	identifier = "phasecannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_SILVER = 1000, MAT_DIAMOND = 750)
	build_path = /obj/item/gun/energy/phasegun/cannon

// Other weapons

/datum/design/science/weapon/rapidsyringe
	identifier = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid

/datum/design/science/weapon/dartgun
	desc = "A gun that fires small hollow chemical-payload darts."
	identifier = "dartgun_r"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 5000, MAT_GOLD = 5000, MAT_SILVER = 2500, MAT_GLASS = 750)
	build_path = /obj/item/gun/ballistic/dartgun/research

/datum/design/science/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	identifier = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer

/datum/design/science/weapon/fuelrod
	identifier = "fuelrod_gun"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_URANIUM = 1000, MAT_PHORON = 3000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/magnetic/fuelrod

// Ammo for those

/datum/design/science/weapon/ammo/dartgunmag_small
	identifier = "dartgun_mag_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 300, MAT_GOLD = 100, MAT_SILVER = 100, MAT_GLASS = 300)
	build_path = /obj/item/ammo_magazine/chemdart/small

/datum/design/science/weapon/ammo/dartgun_ammo_small
	identifier = "dartgun_ammo_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 50, MAT_GOLD = 30, MAT_SILVER = 30, MAT_GLASS = 50)
	build_path = /obj/item/ammo_casing/chemdart/small

/datum/design/science/weapon/ammo/dartgunmag_med
	identifier = "dartgun_mag_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 150, MAT_SILVER = 150, MAT_DIAMOND = 200, MAT_GLASS = 400)
	build_path = /obj/item/ammo_magazine/chemdart

/datum/design/science/weapon/ammo/dartgun_ammo_med
	identifier = "dartgun_ammo_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 80, MAT_GOLD = 40, MAT_SILVER = 40, MAT_GLASS = 60)
	build_path = /obj/item/ammo_casing/chemdart

// Melee weapons

/datum/design/science/weapon/melee/generate_name(template)
	return "Melee weapon prototype ([..()])"

/datum/design/science/weapon/melee/esword
	name = "Portable Energy Blade"
	identifier = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 3500, MAT_GLASS = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/sword/charge

/datum/design/science/weapon/melee/eaxe
	name = "Energy Axe"
	identifier = "chargeaxe"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_PLASTEEL = 3500, MAT_OSMIUM = 2000, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/axe/charge

// Grenade stuff
/datum/design/science/weapon/grenade/generate_name(template)
	return "Grenade casing prototype ([..()])"

/datum/design/science/weapon/grenade/large_grenade
	identifier = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large

/*
	MAU - AP weapons
	MAV - cell-loaded weapons
	MAVA - weapon
	MAVB - cartridge
	MAVC - cells
	MAVD - modular energy weps
	MAVE - modular energy weapon modules
*/


// Energy Weapons

//Commenting this weapon out pending further review.
/*
/datum/design/science/weapon/energy/protector
	name = "\'Myrmidon\' code-locked e-gun"
	desc = "The 'Myrmidon' is a common energy gun that cannot fired lethally on Code Green, requiring Code Blue or higher to unlock its deadly capabilities."
	identifier = "protector"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/gun/energy/protector
*/

/datum/design/science/weapon/energy/netgun
	name = "\'Retiarius\' capture gun"
	identifier = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/energy/netgun

/datum/design/science/weapon/energy/sickshot
	desc = "The 'Discombobulator' is a 4-shot energy revolver that causes nausea and confusion."
	identifier = "sickshot"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000)
	build_path = /obj/item/gun/energy/sickshot

// Misc weapons

/datum/design/science/weapon/pummeler
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	identifier = "pummeler"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/energy/pummeler

// Anti-particle stuff

/datum/design/science/weapon/particle/generate_name(template)
	return "Anti-particle weapon prototype ([..()])"

/datum/design/science/weapon/particle/advparticle
	name = "Advanced anti-particle rifle"
	identifier = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/energy/particle/advanced

/datum/design/science/weapon/particle/particlecannon
	name = "Anti-particle cannon"
	identifier = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/particle/cannon

/datum/design/science/weapon/particle/pressureinterlock
	name = "APP pressure interlock"
	identifier = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock

// NSFW gun and cells
/datum/design/science/weapon/cell_based/AssembleDesignName()
	..()
	name = "Cell-based weapon prototype ([build_name])"

/datum/design/science/weapon/cell_based/prototype_nsfw
	name = "cell-loaded revolver"
	identifier = "nsfw_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_PHORON = 8000, MAT_URANIUM = 4000)
	build_path = /obj/item/gun/ballistic/cell_loaded/combat/prototype

/datum/design/science/weapon/cell_based/prototype_nsfw_mag
	name = "combat cell magazine"
	identifier = "nsfw_mag_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype

/datum/design/science/nsfw_cell/generate_name(template)
	return "Microbattery prototype ([..()])"

/datum/design/science/nsfw_cell/stun
	name = "STUN"
	identifier = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun

/datum/design/science/nsfw_cell/lethal
	name = "LETHAL"
	identifier = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PHORON = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal

/datum/design/science/nsfw_cell/net
	name = "NET"
	identifier = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net

/datum/design/science/nsfw_cell/ion
	name = "ION"
	identifier = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion

/datum/design/science/nsfw_cell/shotstun
	name = "SCATTERSTUN"
	identifier = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun

/datum/design/science/nsfw_cell/xray
	name = "XRAY"
	identifier = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_PHORON = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray

/datum/design/science/nsfw_cell/stripper
	name = "STRIPPER"
	identifier = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 2000, MAT_PHORON = 2000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper


/datum/design/science/modweapon/generate_name(template)
	return "Modular weapon prototype ([..()])"

/datum/design/science/modweapon/basic
	name = "modular energy pistol"
	identifier = "modpistol"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/modular/basic

/datum/design/science/modweapon/adv
	name = "advanced modular energy pistol"
	identifier = "advmodpistol"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 6000, MAT_SILVER = 3000, MAT_GOLD = 2000, MAT_URANIUM = 3000)
	build_path = /obj/item/gun/energy/modular/advanced

/datum/design/science/modweapon/carbine
	name = "modular energy carbine"
	identifier = "modcarbine"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/gun/energy/modular/carbine

/datum/design/science/modweapon/rifle
	name = "modular energy rifle"
	identifier = "modrifle"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/gun/energy/modular/rifle

/datum/design/science/modweapon/tririfle
	name = "tri-core modular energy rifle"
	identifier = "threemodrifle"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 1500)
	build_path = /obj/item/gun/energy/modular/rifle/tribeam

/datum/design/science/modweapon/compact
	name = "compact modular energy pistol"
	identifier = "modcompact"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_DIAMOND = 3000)
	build_path = /obj/item/gun/energy/modular/compact

/datum/design/science/modweapon/scatter
	name = "modular energy scattergun"
	identifier = "modscatter"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5, TECH_ILLEGAL = 4)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/modular/rifle/scatter

/datum/design/science/modweapon/cannon
	name = "modular energy cannon"
	identifier = "modcannon"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 4000)
	build_path = /obj/item/gun/energy/modular/cannon

/datum/design/science/modweapon/nuclear
	name = "modular AEG"
	identifier = "modAEG"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6, TECH_BLUESPACE = 4)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_LEAD = 20000, MAT_URANIUM = 20000, MAT_DIAMOND = 4000)
	build_path = /obj/item/gun/energy/modular/nuke

/datum/design/science/modweaponnodule/generate_name(template)
	return "Modular weapon module design ([..()])"

/datum/design/science/modweaponnodule/stunmedium
	name = "stun medium"
	identifier = "stunmedium"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_GOLD = 4000)
	build_path = /obj/item/modularlaser/lasermedium/stun

/datum/design/science/modweaponnodule/stunweak
	name = "weak stun medium"
	identifier = "stunweak"
	req_tech = list(TECH_MAGNET = 1, TECH_POWER = 2, TECH_COMBAT = 1)
	materials =	list(MAT_STEEL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/stun/weak

/datum/design/science/modweaponnodule/netmedium
	name = "net projector medium"
	identifier = "netmedium"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_GOLD = 4000, MAT_URANIUM = 2000)
	build_path = /obj/item/modularlaser/lasermedium/net

/datum/design/science/modweaponnodule/electrode
	name = "electrode projector tube"
	identifier =	"electrodetube"
	req_tech =  list(TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/electrode

/datum/design/science/modweaponnodule/laser
	name = "laser medium"
	identifier = "lasermedium"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_SILVER = 4000)
	build_path = /obj/item/modularlaser/lasermedium/laser

/datum/design/science/modweaponnodule/weaklaser
	name = "low-power laser medium"
	identifier = "weaklaser"
	req_tech =  list(TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/laser/weak

/datum/design/science/modweaponnodule/sniper
	name = "laser sniper medium"
	identifier = "sniperlaser"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 6, TECH_COMBAT = 4)
	materials =	list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_DIAMOND = 10)
	build_path = /obj/item/modularlaser/lasermedium/laser/sniper

/datum/design/science/modweaponnodule/heavylaser
	name = "heavy laser medium"
	identifier = "heavylasermedium"
	req_tech =  list(TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5, TECH_ILLEGAL = 2)
	materials =	list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/heavy

/datum/design/science/modweaponnodule/cannonmedium
	name = "cannon beam medium"
	identifier = "cannonmedium"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/cannon

/datum/design/science/modweaponnodule/xraser
	name = "xraser medium"
	identifier = "xraser"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 4000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/xray

/datum/design/science/modweaponnodule/dig
	name = "excavation beam medium"
	identifier = "digbeam"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_PLASTEEL = 500)
	build_path = /obj/item/modularlaser/lasermedium/dig

/datum/design/science/modweaponnodule/lightning
	name = "lightning arc tube"
	identifier = "lightning"
	req_tech = list(TECH_MAGNET = 6, TECH_POWER = 7)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_SILVER = 4000, MAT_GOLD = 4000)
	build_path = /obj/item/modularlaser/lasermedium/lightning

/datum/design/science/modweaponnodule/hook
	name = "graviton grapple tube"
	identifier = "hook"
	req_tech = list(TECH_ARCANE = 4, TECH_POWER = 2)
	materials =list(MAT_STEEL = 8000, MAT_GLASS = 8000, MAT_MORPHIUM = 4000, MAT_VERDANTIUM = 4000)
	build_path = /obj/item/modularlaser/lasermedium/hook

/datum/design/science/modweaponnodule/phasemedium
	name = "phase projector tube"
	identifier = "phasemedium"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/phase

/datum/design/science/modweaponnodule/basiclens
	name = "basic lens"
	identifier = "basiclens"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lens/basic

/datum/design/science/modweaponnodule/advlens
	name = "advanced lens"
	identifier = "advlens"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000)
	build_path = /obj/item/modularlaser/lens/advanced

/datum/design/science/modweaponnodule/superlens
	name = "superior lens"
	identifier = "superlens"
	req_tech =  list(TECH_MATERIAL = 9)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000, MAT_DURASTEEL = 2000)
	build_path = /obj/item/modularlaser/lens/super

/datum/design/science/modweaponnodule/scatterlens
	name = "scatter lens"
	identifier = "scatterlens"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000)
	build_path = /obj/item/modularlaser/lens/scatter

/datum/design/science/modweaponnodule/advscatterlens
	name = "advanced scatter lens"
	identifier = "advscatterlens"
	req_tech = list(TECH_MATERIAL = 9)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000, MAT_VERDANTIUM = 2000)
	build_path = /obj/item/modularlaser/lens/scatter/adv

/datum/design/science/modweaponnodule/basiccap
	name = "basic capacitor"
	identifier = "basiccap"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/capacitor/basic

/datum/design/science/modweaponnodule/ecocap
	name = "efficient capacitor"
	identifier = "ecocap"
	req_tech = list(TECH_POWER = 4)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500)
	build_path = /obj/item/modularlaser/capacitor/eco

/datum/design/science/modweaponnodule/supereco
	name = "economical capacitor"
	identifier = "superecocap"
	req_tech = list(TECH_POWER = 6)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/capacitor/eco/super

/datum/design/science/modweaponnodule/quickcap
	name = "high throughput capactior"
	identifier = "quickcap"
	req_tech = list(TECH_POWER = 8)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/capacitor/speed

/datum/design/science/modweaponnodule/advqcap
	name = "very high throughput capactior"
	identifier = "advqcap"
	req_tech = list(TECH_POWER = 8)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/capacitor/speed/advanced

/datum/design/science/modweaponnodule/basicac
	name = "cooling system"
	identifier = "basicac"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/cooling/basic

/datum/design/science/modweaponnodule/recoverac
	name = "regenerative cooling system"
	identifier = "recoverac"
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/cooling/efficient

/datum/design/science/modweaponnodule/fastac
	name = "high-power regenerative cooling system"
	identifier = "fastac"
	req_tech = list(TECH_ENGINEERING = 7)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/cooling/efficient/super

/datum/design/science/modweaponnodule/superac
	name = "supercharged cooling system"
	identifier = "superac"
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/cooling/speed

/datum/design/science/modweaponnodule/bestac
	name = "hypercharged cooling system"
	identifier = "hyperac"
	req_tech = list(TECH_ENGINEERING = 7)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/cooling/speed/adv

/datum/design/science/modweaponnodule/modcontrol
	name = "controller"
	identifier = "modcontrol"
	req_tech = list(TECH_DATA = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/controller/basic

/datum/design/science/modweaponnodule/an94
	name = "AN-94 patterned fire controller"
	identifier = "an94"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/controller/twoburst

/datum/design/science/modweaponnodule/threecontrol
	name = "burst FCU"
	identifier = "threecontrol"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/controller/threeburst

/datum/design/science/modweaponnodule/fivecontrol
	name = "quintburst FCU"
	identifier = "fivecontrol"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/controller/fiveburst

//Firing pins to shoot your guns with
/datum/design/science/pin/generate_name(template)
	return "Weapon firing pin ([..()])"

/datum/design/science/pin/test
	name = "Testing range"
	identifier = "test_range_pin"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 1000)
	build_path = /obj/item/firing_pin/test_range

/datum/design/science/pin/explorer
	name = "Exploration"
	identifier = "explorer_pin"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_COMBAT = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/firing_pin/explorer
