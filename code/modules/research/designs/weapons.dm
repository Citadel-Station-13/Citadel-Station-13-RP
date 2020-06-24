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

/datum/design/item/modweapon/AssembleDesignName()
	..()
	name = "Modular weapon prototype ([name])"

/datum/design/item/modweapon/basic
	name = "modular energy pistol"
	id = "modpistol"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/modular/basic
	sort_string = "MAVDA"

/datum/design/item/modweapon/adv
	name = "advanced modular energy pistol"
	id = "advmodpistol"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MAT_GLASS = 6000, MAT_SILVER = 3000, MAT_GOLD = 2000, MAT_URANIUM = 3000)
	build_path = /obj/item/gun/energy/modular/advanced
	sort_string = "MAVDB"

/datum/design/item/modweapon/carbine
	name = "modular energy carbine"
	id = "modcarbine"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/gun/energy/modular/carbine
	sort_string = "MAVDC"

/datum/design/item/modweapon/rifle
	name = "modular energy rifle"
	id = "modrifle"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/gun/energy/modular/rifle
	sort_string = "MAVDD"

/datum/design/item/modweapon/tririfle
	name = "tri-core modular energy rifle"
	id = "threemodrifle"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 1500)
	build_path = /obj/item/gun/energy/modular/rifle/tribeam
	sort_string = "MAVDE"

/datum/design/item/modweapon/compact
	name = "compact modular energy pistol"
	id = "modcompact"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MAT_GLASS = 5000, MAT_DIAMOND = 3000)
	build_path = /obj/item/gun/energy/modular/compact
	sort_string = "MAVDF"

/datum/design/item/modweapon/scatter
	name = "modular energy scattergun"
	id = "modscatter"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5, TECH_ILLEGAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/modular/rifle/scatter
	sort_string = "MAVDG"

/datum/design/item/modweapon/cannon
	name = "modular energy cannon"
	id = "modcannon"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_GOLD = 6000, MAT_URANIUM = 4000, MAT_DIAMOND = 4000)
	build_path = /obj/item/gun/energy/modular/cannon
	sort_string = "MAVDH"

/datum/design/item/modweapon/nuclear
	name = "modular AEG"
	id = "modAEG"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6, TECH_BLUESPACE = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MAT_GLASS = 12000, MAT_SILVER = 6000, MAT_LEAD = 20000, MAT_URANIUM = 20000, MAT_DIAMOND = 4000)
	build_path = /obj/item/gun/energy/modular/nuke
	sort_string = "MAVDG"

/datum/design/item/modweaponnodule/AssembleDesignName()
	..()
	name = "Modular weapon module design ([name])"

/datum/design/item/modweaponnodule/stunmedium
	name = "stun medium"
	id = "stunmedium"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_GOLD = 4000)
	build_path = /obj/item/modularlaser/lasermedium/stun
	sort_string = "MAVEA"

/datum/design/item/modweaponnodule/stunweak
	name = "weak stun medium"
	id = "stunweak"
	req_tech = list(TECH_MAGNET = 1, TECH_POWER = 2, TECH_COMBAT = 1)
	materials =	list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/stun/weak
	sort_string = "MAVEB"

/datum/design/item/modweaponnodule/netmedium
	name = "net projector medium"
	id = "netmedium"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_GOLD = 4000, MAT_URANIUM = 2000)
	build_path = /obj/item/modularlaser/lasermedium/net
	sort_string = "MAVEC"

/datum/design/item/modweaponnodule/electrode
	name = "electrode projector tube"
	id =	"electrodetube"
	req_tech =  list(TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/electrode
	sort_string = "MAVED"

/datum/design/item/modweaponnodule/laser
	name = "laser medium"
	id = "lasermedium"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_SILVER = 4000)
	build_path = /obj/item/modularlaser/lasermedium/laser
	sort_string = "MAVEE"

/datum/design/item/modweaponnodule/weaklaser
	name = "low-power laser medium"
	id = "weaklaser"
	req_tech =  list(TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/laser/weak
	sort_string = "MAVEF"

/datum/design/item/modweaponnodule/sniper
	name = "laser sniper medium"
	id = "sniperlaser"
	req_tech =  list(TECH_MAGNET = 5, TECH_POWER = 6, TECH_COMBAT = 4)
	materials =	list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_DIAMOND = 10)
	build_path = /obj/item/modularlaser/lasermedium/laser/sniper
	sort_string = "MAVEG"

/datum/design/item/modweaponnodule/heavylaser
	name = "heavy laser medium"
	id = "heavylasermedium"
	req_tech =  list(TECH_MAGNET = 6, TECH_POWER = 6, TECH_COMBAT = 5, TECH_ILLEGAL = 2)
	materials =	list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/heavy
	sort_string = "MAVEH"

/datum/design/item/modweaponnodule/cannonmedium
	name = "cannon beam medium"
	id = "cannonmedium"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 2000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/cannon
	sort_string = "MAVEI"

/datum/design/item/modweaponnodule/xraser
	name = "xraser medium"
	id = "xraser"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_COMBAT = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_URANIUM = 4000, MAT_GOLD = 4000, MAT_DIAMOND = 500)
	build_path = /obj/item/modularlaser/lasermedium/laser/xray
	sort_string = "MAVEJ"

/datum/design/item/modweaponnodule/dig
	name = "excavation beam medium"
	id = "digbeam"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_PLASTEEL = 500)
	build_path = /obj/item/modularlaser/lasermedium/dig
	sort_string = "MAVEK"

/datum/design/item/modweaponnodule/lightning
	name = "lightning arc tube"
	id = "lightning"
	req_tech = list(TECH_MAGNET = 6, TECH_POWER = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_SILVER = 4000, MAT_GOLD = 4000)
	build_path = /obj/item/modularlaser/lasermedium/lightning
	sort_string = "MAVEL"

/datum/design/item/modweaponnodule/hook
	name = "graviton grapple tube"
	id = "hook"
	req_tech = list(TECH_ARCANE = 4, TECH_POWER = 2)
	materials =list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000, MAT_MORPHIUM = 4000, MAT_VERDANTIUM = 4000)
	build_path = /obj/item/modularlaser/lasermedium/hook
	sort_string = "MAVEM"

/datum/design/item/modweaponnodule/phasemedium
	name = "phase projector tube"
	id = "phasemedium"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lasermedium/phase
	sort_string = "MAVEN"

/datum/design/item/modweaponnodule/basiclens
	name = "basic lens"
	id = "basiclens"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list(MAT_GLASS = 8000)
	build_path = /obj/item/modularlaser/lens/basic
	sort_string = "MAVEO"

/datum/design/item/modweaponnodule/advlens
	name = "advanced lens"
	id = "advlens"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000)
	build_path = /obj/item/modularlaser/lens/advanced
	sort_string = "MAVEQ"

/datum/design/item/modweaponnodule/superlens
	name = "superior lens"
	id = "superlens"
	req_tech =  list(TECH_MATERIAL = 9)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000, MAT_DURASTEEL = 2000)
	build_path = /obj/item/modularlaser/lens/super
	sort_string = "MAVER"

/datum/design/item/modweaponnodule/scatterlens
	name = "scatter lens"
	id = "scatterlens"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000)
	build_path = /obj/item/modularlaser/lens/scatter
	sort_string = "MAVES"

/datum/design/item/modweaponnodule/advscatterlens
	name = "advanced scatter lens"
	id = "advscatterlens"
	req_tech = list(TECH_MATERIAL = 9)
	materials = list(MAT_GLASS = 8000, MAT_SILVER = 3000, MAT_VERDANTIUM = 2000)
	build_path = /obj/item/modularlaser/lens/scatter/adv
	sort_string = "MAVET"

/datum/design/item/modweaponnodule/basiccap
	name = "basic capacitor"
	id = "basiccap"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/capacitor/basic
	sort_string = "MAVEV"

/datum/design/item/modweaponnodule/ecocap
	name = "efficient capacitor"
	id = "ecocap"
	req_tech = list(TECH_POWER = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500)
	build_path = /obj/item/modularlaser/capacitor/eco
	sort_string = "MAVEW"

/datum/design/item/modweaponnodule/supereco
	name = "economical capacitor"
	id = "superecocap"
	req_tech = list(TECH_POWER = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/capacitor/eco/super
	sort_string = "MAVEX"

/datum/design/item/modweaponnodule/quickcap
	name = "high throughput capactior"
	id = "quickcap"
	req_tech = list(TECH_POWER = 8)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/capacitor/speed
	sort_string = "MAVEY"

/datum/design/item/modweaponnodule/advqcap
	name = "very high throughput capactior"
	id = "advqcap"
	req_tech = list(TECH_POWER = 8)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/capacitor/speed/advanced
	sort_string = "MAVEZ"

/datum/design/item/modweaponnodule/basicac
	name = "cooling system"
	id = "basicac"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/cooling/basic
	sort_string = "MAVFA"

/datum/design/item/modweaponnodule/recoverac
	name = "regenerative cooling system"
	id = "recoverac"
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/cooling/efficient
	sort_string = "MAVFB"

/datum/design/item/modweaponnodule/fastac
	name = "high-power regenerative cooling system"
	id = "fastac"
	req_tech = list(TECH_ENGINEERING = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/cooling/efficient/super
	sort_string = "MAVFC"

/datum/design/item/modweaponnodule/superac
	name = "supercharged cooling system"
	id = "superac"
	req_tech = list(TECH_ENGINEERING = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/cooling/speed
	sort_string = "MAVFD"

/datum/design/item/modweaponnodule/bestac
	name = "hypercharged cooling system"
	id = "hyperac"
	req_tech = list(TECH_ENGINEERING = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_VERDANTIUM = 300)
	build_path = /obj/item/modularlaser/cooling/speed/adv
	sort_string = "MAVFE"

/datum/design/item/modweaponnodule/modcontrol
	name = "controller"
	id = "modcontrol"
	req_tech = list(TECH_DATA = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/controller/basic
	sort_string = "MAVFF"

/datum/design/item/modweaponnodule/an94
	name = "AN-94 patterned fire controller"
	id = "an94"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/modularlaser/controller/twoburst
	sort_string = "MAVFG"

/datum/design/item/modweaponnodule/threecontrol
	name = "burst FCU"
	id = "threecontrol"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/controller/threeburst
	sort_string = "MAVFH"

/datum/design/item/modweaponnodule/fivecontrol
	name = "quintburst FCU"
	id = "fivecontrol"
	req_tech = list(TECH_DATA = 5, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MAT_GLASS = 1000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/modularlaser/controller/fiveburst
	sort_string = "MAVFI"
