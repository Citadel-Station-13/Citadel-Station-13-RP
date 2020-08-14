/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/ammo/AssembleDesignName()
	..()
	name = "Weapon ammo prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

// Energy weapons

/datum/design/item/weapon/energy/AssembleDesignName()
	..()
	name = "Energy weapon prototype ([item_name])"

/datum/design/item/weapon/energy/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	sort_string = "MAAAA"

/datum/design/item/weapon/energy/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/gun/nuclear
	sort_string = "MAAAB"

/datum/design/item/weapon/energy/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 1000, MAT_PHORON = 3000)
	build_path = /obj/item/gun/energy/toxgun
	sort_string = "MAAAC"

/datum/design/item/weapon/energy/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	sort_string = "MAAAD"

/datum/design/item/weapon/energy/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000)
	build_path = /obj/item/gun/energy/decloner
	sort_string = "MAAAE"

/datum/design/item/weapon/energy/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 500, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature
	sort_string = "MAAAF"

/datum/design/item/weapon/energy/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_GLASS = 500, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun
	sort_string = "MAAAG"

// Ballistic weapons

/datum/design/item/weapon/ballistic/AssembleDesignName()
	..()
	name = "Ballistic weapon prototype ([item_name])"

/datum/design/item/weapon/ballistic/advanced_smg
	id = "smg"
	desc = "An advanced 9mm SMG with a reflective laser optic."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_SILVER = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/projectile/automatic/advanced_smg
	sort_string = "MABAA"

// Ballistic ammo

/datum/design/item/weapon/ballistic/ammo/AssembleDesignName()
	..()
	name = "Ballistic weapon ammo prototype ([name])"

/datum/design/item/weapon/ballistic/ammo/ammo_9mmAdvanced
	name = "9mm magazine"
	id = "ammo_9mm"
	desc = "A 21 round magazine for an advanced 9mm SMG."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced
	sort_string = "MABBA"

/datum/design/item/weapon/ballistic/ammo/stunshell
	name = "stun shell"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 360, MAT_GLASS = 720)
	build_path = /obj/item/ammo_casing/a12g/stunshell
	sort_string = "MABBB"
	
datum/design/item/weapon/ballistic/ammo/m10x24/medium
	name = "M41A Medium Magazine"
	id = "ammo_10x24med"
	desc = "A 64 round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5500, MAT_SILVER = 250)
	build_path = /obj/item/ammo_magazine/m10x24mm/med
	sort_string = "MABBZ"

datum/design/item/weapon/ballistic/ammo/m10x24/medium/hp
	name = "M41A Medium HP Magazine"
	id = "ammo_10x24medhp"
	desc = "A 64 hollow point round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5500, MAT_SILVER = 250)
	build_path = /obj/item/ammo_magazine/m10x24mm/med/hp
	sort_string = "MABBY"

datum/design/item/weapon/ballistic/ammo/m10x24/medium/ap
	name = "M41A Medium AP Magazine"
	id = "ammo_10x24medap"
	desc = "A 64 armor piercing round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5500, MAT_SILVER = 250)
	build_path = /obj/item/ammo_magazine/m10x24mm/med/ap
	sort_string = "MABBX"

datum/design/item/weapon/ballistic/ammo/m10x24/large
	name = "M41A Large Magazine"
	id = "ammo_10x24large"
	desc = "A 96 round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8500, MAT_SILVER = 250)
	build_path = /obj/item/ammo_magazine/m10x24mm/large
	sort_string = "MABBW"

datum/design/item/weapon/ballistic/ammo/m10x24/large/hp
	name = "M41A Large HP Magazine"
	id = "ammo_10x24largehp"
	desc = "A 96 hollow point round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8500, MAT_SILVER = 250)
	build_path = /obj/item/ammo_magazine/m10x24mm/large/hp
	sort_string = "MABBV"

datum/design/item/weapon/ballistic/ammo/m10x24/large/ap
	name = "M41A Large Magazine"
	id = "ammo_10x24largeap"
	desc = "A 96 armor piercing round magazine for the M41A pulse rifle."
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 8500, MAT_SILVER = 500)
	build_path = /obj/item/ammo_magazine/m10x24mm/large/ap
	sort_string = "MABBU"

// Phase weapons

/datum/design/item/weapon/phase/AssembleDesignName()
	..()
	name = "Phase weapon prototype ([item_name])"

/datum/design/item/weapon/phase/phase_pistol
	id = "phasepistol"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000)
	build_path = /obj/item/gun/energy/phasegun/pistol
	sort_string = "MACAA"

/datum/design/item/weapon/phase/phase_carbine
	id = "phasecarbine"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MAT_GLASS = 1500)
	build_path = /obj/item/gun/energy/phasegun
	sort_string = "MACAB"

/datum/design/item/weapon/phase/phase_rifle
	id = "phaserifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7000, MAT_GLASS = 2000, MAT_SILVER = 500)
	build_path = /obj/item/gun/energy/phasegun/rifle
	sort_string = "MACAC"

/datum/design/item/weapon/phase/phase_cannon
	id = "phasecannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MAT_GLASS = 2000, MAT_SILVER = 1000, MAT_DIAMOND = 750)
	build_path = /obj/item/gun/energy/phasegun/cannon
	sort_string = "MACAD"

// Other weapons

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid
	sort_string = "MADAA"

/datum/design/item/weapon/dartgun
	desc = "A gun that fires small hollow chemical-payload darts."
	id = "dartgun_r"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GOLD = 5000, MAT_SILVER = 2500, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/dartgun/research
	sort_string = "MADAB"

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer
	sort_string = "MADAC"

/datum/design/item/weapon/fuelrod
	id = "fuelrod_gun"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MAT_GLASS = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_URANIUM = 1000, MAT_PHORON = 3000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/magnetic/fuelrod
	sort_string = "MADAD"

// Ammo for those

/datum/design/item/weapon/ammo/dartgunmag_small
	id = "dartgun_mag_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 300, MAT_GOLD = 100, MAT_SILVER = 100, MAT_GLASS = 300)
	build_path = /obj/item/ammo_magazine/chemdart/small
	sort_string = "MADBA"

/datum/design/item/weapon/ammo/dartgun_ammo_small
	id = "dartgun_ammo_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 50, MAT_GOLD = 30, MAT_SILVER = 30, MAT_GLASS = 50)
	build_path = /obj/item/ammo_casing/chemdart/small
	sort_string = "MADBB"

/datum/design/item/weapon/ammo/dartgunmag_med
	id = "dartgun_mag_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 500, MAT_GOLD = 150, MAT_SILVER = 150, MAT_DIAMOND = 200, MAT_GLASS = 400)
	build_path = /obj/item/ammo_magazine/chemdart
	sort_string = "MADBC"

/datum/design/item/weapon/ammo/dartgun_ammo_med
	id = "dartgun_ammo_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 80, MAT_GOLD = 40, MAT_SILVER = 40, MAT_GLASS = 60)
	build_path = /obj/item/ammo_casing/chemdart
	sort_string = "MADBD"

// Melee weapons

/datum/design/item/weapon/melee/AssembleDesignName()
	..()
	name = "Melee weapon prototype ([item_name])"

/datum/design/item/weapon/melee/esword
	name = "Portable Energy Blade"
	id = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 3500, MAT_GLASS = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/sword/charge
	sort_string = "MBAAA"

/datum/design/item/weapon/melee/eaxe
	name = "Energy Axe"
	id = "chargeaxe"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_PLASTEEL = 3500, MAT_OSMIUM = 2000, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/axe/charge
	sort_string = "MBAAB"

// Grenade stuff
/datum/design/item/weapon/grenade/AssembleDesignName()
	..()
	name = "Grenade casing prototype ([item_name])"

/datum/design/item/weapon/grenade/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	sort_string = "MCAAA"

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

/datum/design/item/weapon/energy/protector
	name = "\'Myrmidon\' code-locked e-gun"
	desc = "The 'Myrmidon' is a common energy gun that cannot fired lethally on Code Green, requiring Code Blue or higher to unlock its deadly capabilities."
	id = "protector"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/gun/energy/protector
	sort_string = "MAAAH"

/datum/design/item/weapon/energy/netgun
	name = "\'Retiarius\' capture gun"
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/energy/netgun
	sort_string = "MAAAI"

/datum/design/item/weapon/energy/sickshot
	desc = "The 'Discombobulator' is a 4-shot energy revolver that causes nausea and confusion."
	id = "sickshot"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MAT_GLASS = 2000)
	build_path = /obj/item/gun/energy/sickshot
	sort_string = "MAAAJ"

// Misc weapons

/datum/design/item/weapon/pummeler
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	id = "pummeler"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MAT_GLASS = 3000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/energy/pummeler
	sort_string = "MAAAK"

// Anti-particle stuff

/datum/design/item/weapon/particle/AssembleDesignName()
	..()
	name = "Anti-particle weapon prototype ([item_name])"

/datum/design/item/weapon/particle/advparticle
	name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/energy/particle/advanced
	sort_string = "MAAUA"

/datum/design/item/weapon/particle/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/particle/cannon
	sort_string = "MAAUB"

/datum/design/item/weapon/particle/pressureinterlock
	name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock
	sort_string = "MAAUC"

// NSFW gun and cells
/datum/design/item/weapon/cell_based/AssembleDesignName()
	..()
	name = "Cell-based weapon prototype ([item_name])"

/datum/design/item/weapon/cell_based/prototype_nsfw
	name = "cell-loaded revolver"
	id = "nsfw_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MAT_GLASS = 6000, MAT_PHORON = 8000, MAT_URANIUM = 4000)
	build_path = /obj/item/gun/projectile/cell_loaded/combat/prototype
	sort_string = "MAVAA"

/datum/design/item/weapon/cell_based/prototype_nsfw_mag
	name = "combat cell magazine"
	id = "nsfw_mag_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype
	sort_string = "MAVBA"

/datum/design/item/nsfw_cell/AssembleDesignName()
	..()
	name = "Microbattery prototype ([name])"

/datum/design/item/nsfw_cell/stun
	name = "STUN"
	id = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun
	sort_string = "MAVCA"

/datum/design/item/nsfw_cell/lethal
	name = "LETHAL"
	id = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_PHORON = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal
	sort_string = "MAVCB"

/datum/design/item/nsfw_cell/net
	name = "NET"
	id = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net
	sort_string = "MAVCC"

/datum/design/item/nsfw_cell/ion
	name = "ION"
	id = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion
	sort_string = "MAVCD"

/datum/design/item/nsfw_cell/shotstun
	name = "SCATTERSTUN"
	id = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun
	sort_string = "MAVCE"

/datum/design/item/nsfw_cell/xray
	name = "XRAY"
	id = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_PHORON = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray
	sort_string = "MAVCF"

/datum/design/item/nsfw_cell/stripper
	name = "STRIPPER"
	id = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 2000, MAT_PHORON = 2000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper
	sort_string = "MAVCG"
