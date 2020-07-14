/obj/item/gun/energy/modular/basic
	name = "modular energy pistol"
	desc = "A basic, compact, modular energy weapon. The fire controller and power control unit are integral to the frame and are thus unremovable."

/obj/item/gun/energy/modular/basic/Initialize()
	..()
	lasercap = new /obj/item/modularlaser/capacitor/simple/integral(src)
	circuit = new /obj/item/modularlaser/controller/basic/integral(src)

/obj/item/gun/energy/modular/advanced
	name = "advanced modular energy pistol"
	desc = "A basic, compact, modular energy weapon. All parts are modular in this version."

/obj/item/gun/energy/modular/carbine
	name = "modular energy carbine"
	desc = "A basic modular energy weapon. This carbine has the capability to mount two cores but relies on an aircooling system."
	cores = 2
	icon_state = "mod_carbine"

/obj/item/gun/energy/modular/carbine/Initialize()
	..()
	lasercooler = new /obj/item/modularlaser/cooling/lame/integral(src)

/obj/item/gun/energy/modular/rifle
	name = "modular energy rifle"
	desc = "A basic modular energy weapon. This rifle has the capability to mount two cores."
	cores = 2
	icon_state = "mod_rifle"
	w_class = ITEMSIZE_LARGE

/obj/item/gun/energy/modular/rifle/tribeam
	name = "tribeam modular energy rifle"
	desc = "An advanced modular energy weapon. This rifle has the capability to mount three cores."
	cores = 3

/obj/item/gun/energy/modular/compact
	name = "compact modular energy pistol"
	desc = "A compact energy pistol that can fit into a pocket. However, only the laser core can be replaced. All the other components are purpose-built for their size and are integrated into the frame."
	icon_state = "taserblue"
	w_class = ITEMSIZE_SMALL

/obj/item/gun/energy/modular/compact/Initialize()
	..()
	lasercap = new /obj/item/modularlaser/capacitor/simple/integral(src)
	circuit = new /obj/item/modularlaser/controller/basic/integral(src)
	lasercooler = new /obj/item/modularlaser/cooling/lame/integral(src)
	laserlens = new /obj/item/modularlaser/lens/lame/integral(src)

/obj/item/gun/energy/modular/rifle/scatter
	name = "modular energy scattergun"
	desc = "A sophisticated modular energy weapon. This scattergun has the capability to mount two cores, and mounts a complex refracting lens to scatter most shots."

/obj/item/gun/energy/modular/rifle/scatter/Initialize()
	..()
	laserlens = new /obj/item/modularlaser/lens/scatter/hyper/integral(src)

/obj/item/gun/energy/modular/cannon
	name = "modular energy cannon"
	desc = "A huge, semi-modular energy cannon. Can mount three cores, and utilizes a robust power handler and circuitry combined with an integral large cell."
	cores = 3
	battery_lock = TRUE
	cell_type = /obj/item/cell/device/weapon/modcannon
	icon_state = "mod_cannon"
	w_class = ITEMSIZE_HUGE

/obj/item/gun/energy/modular/cannon/Initialize()
	..()
	lasercap = new /obj/item/modularlaser/capacitor/cannon(src)
	circuit = new /obj/item/modularlaser/controller/basic/integral(src)

/obj/item/cell/device/weapon/modcannon
	charge = 4800
	maxcharge = 4800

/obj/item/gun/energy/modular/nuke
	name = "advanced modular energy gun"
	desc = "A huge, semi-modular energy weapon. Can mount two cores, and utilizes an advanced power handler coupled with an integral RTG."
	cores = 2
	battery_lock = TRUE
	cell_type = /obj/item/cell/device/weapon/recharge/captain
	icon_state = "modnuc"
	w_class = ITEMSIZE_HUGE


/obj/item/gun/energy/modular/cannon/Initialize()
	..()
	circuit = new /obj/item/modularlaser/controller/basic/integral(src)
