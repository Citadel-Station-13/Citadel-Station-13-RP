/obj/item/robot_module/robot/quad/stray
	name = "stray robot module"
	hide_on_manifest = 1
	sprites = list(
		"Stray" = "stray"
	)
	can_shred = TRUE

/obj/item/robot_module/robot/quad/stray/get_modules()
	. = ..()
	. |= list(
		// Sec
		/obj/item/handcuffs/cyborg,
		/obj/item/dogborg/jaws/big,
		/obj/item/melee/baton/robot,
		/obj/item/dogborg/pounce,

		// Med
		/obj/item/healthanalyzer,
		/obj/item/shockpaddles/robot/hound,
		/obj/item/dogborg/mirrortool,

		// Engi
		/obj/item/weldingtool/electric/mounted,
		/obj/item/tool/screwdriver/cyborg,
		/obj/item/tool/wrench/cyborg,
		/obj/item/tool/wirecutters/cyborg,
		/obj/item/multitool
	)

/obj/item/robot_module/robot/quad/stray/handle_special_module_init(mob/living/silicon/robot/R)
	. = ..()
	// Boof
	src.emag 	 = new /obj/item/gun/projectile/energy/retro/mounted(src)

	var/obj/item/reagent_containers/borghypo/hound/lost/H = new /obj/item/reagent_containers/borghypo/hound/lost(src)
	H.water = synths_by_kind[MATSYN_WATER]
	. += H

	var/obj/item/dogborg/sleeper/B = new /obj/item/dogborg/sleeper(src)
	B.water = synths_by_kind[MATSYN_WATER]
	. += B
