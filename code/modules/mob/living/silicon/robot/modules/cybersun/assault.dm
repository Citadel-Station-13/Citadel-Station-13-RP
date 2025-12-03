GENERATE_ROBOT_MODULE_PRESET(/cybersun/assault)
/datum/prototype/robot_module/cybersun/assault
	id = "cybersun-assault"
	display_name = "Cybersun Assault"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/syndicate
	light_color = "#FF0000"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/grounded_landmate/security_cybersun,
		/datum/prototype/robot_iconset/grounded_landmate/security_cybersun_tread,
		/datum/prototype/robot_iconset/raptor/syndicate_medical,
		/datum/prototype/robot_iconset/biped_heavy/antag,
		/datum/prototype/robot_iconset/grounded_spider/combat,
		/datum/prototype/robot_iconset/baseline_misc/squats,
	)

/datum/prototype/robot_module/cybersun/assault/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
		/obj/item/shield_projector/rectangle/weak,
		/obj/item/gun/projectile/energy/dakkalaser,
		/obj/item/handcuffs/cyborg,
		/obj/item/melee/baton/robot,
		/obj/item/melee/transforming/energy/sword,
	)

/obj/item/robot_module_legacy/robot/syndicate
	name = "illegal robot module"
	languages = list(
		LANGUAGE_SOL_COMMON = 1,
		LANGUAGE_TRADEBAND = 1,
		LANGUAGE_UNATHI = 0,
		LANGUAGE_SIIK	= 0,
		LANGUAGE_AKHANI = 0,
		LANGUAGE_SKRELLIAN = 0,
		LANGUAGE_SKRELLIANFAR = 0,
		LANGUAGE_ROOTLOCAL = 0,
		LANGUAGE_GUTTER = 1,
		LANGUAGE_SCHECHI = 0,
		LANGUAGE_EAL	 = 1,
		LANGUAGE_SIGN	 = 0,
		LANGUAGE_TERMINUS = 1,
		LANGUAGE_ZADDAT = 0
	)
