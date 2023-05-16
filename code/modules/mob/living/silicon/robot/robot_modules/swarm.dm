/obj/item/robot_module/drone/swarm
	name = "swarm drone module"
	var/id

/obj/item/robot_module/drone/swarm/get_modules()
	. = ..()
	. |= list(
		/obj/item/rcd/electric/mounted/borg/swarm,
		/obj/item/flash/robot,
		/obj/item/handcuffs/cable/tape/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/gun/energy/taser/mounted/cyborg/swarm,
		/obj/item/matter_decompiler/swarm
	)

/obj/item/robot_module/drone/swarm/handle_special_module_init(mob/living/silicon/robot/robot)
	. = ..()
	id = robot.idcard
	. += id

/obj/item/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

/obj/item/robot_module/drone/swarm/ranged/get_modules()
	. = ..()
	. |= /obj/item/gun/energy/xray/swarm

/obj/item/robot_module/drone/swarm/melee/get_modules()
	. = ..()
	. |= /obj/item/melee/energy/sword/ionic_rapier/lance
