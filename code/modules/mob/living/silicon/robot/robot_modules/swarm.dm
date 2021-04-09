/obj/item/robot_module/drone/swarm
	name = "swarm drone module"
	var/id

/obj/item/robot_module/drone/swarm/Initialize(mapload)
	. = ..()
	var/mob/living/silicon/robot/robot = loc
	id = robot.idcard
	src.modules += id

	src.modules += new /obj/item/rcd/electric/mounted/borg/swarm(src)
	src.modules += new /obj/item/flash/robot(src)
	src.modules += new /obj/item/handcuffs/cable/tape/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg/swarm(src)
	src.modules += new /obj/item/matter_decompiler/swarm(src)

/obj/item/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

/obj/item/robot_module/drone/swarm/ranged/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/gun/energy/xray/swarm(src)

/obj/item/robot_module/drone/swarm/melee/Initialize(mapload)
	. = ..()
	src.modules += new /obj/item/melee/energy/sword/ionic_rapier/lance(src)
