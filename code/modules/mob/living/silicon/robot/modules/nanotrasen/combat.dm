GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/combat)
/datum/prototype/robot_module/nanotrasen/combat
	id = "nt-combat"
	display_name = "NT-Lancer"
	use_robot_module_path = /obj/item/robot_module_legacy/robot/combat
	module_hud_state = "combat"
	light_color = "#FF0000"
	auto_iconsets = list(
		/datum/prototype/robot_iconset/hover_eyebot/combat,
		/datum/prototype/robot_iconset/biped_insekt/combat,
		/datum/prototype/robot_iconset/grounded_zoomba/combat,
		/datum/prototype/robot_iconset/cat_feli/combat,
		/datum/prototype/robot_iconset/biped_marina/combat,
		/datum/prototype/robot_iconset/grounded_mechoid/combat,
		/datum/prototype/robot_iconset/dog_k9/blade,
		/datum/prototype/robot_iconset/baseline_droid/combat,
	)

/datum/prototype/robot_module/nanotrasen/combat/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	if(normal_out)
		normal_out |= list(
			/obj/item/gun/projectile/energy/laser/mounted,
			/obj/item/pickaxe/plasmacutter,
			/obj/item/borg/combat/shield,
			/obj/item/borg/combat/mobility,
			/obj/item/handcuffs/cyborg,
			/obj/item/melee/baton/robot,
			/obj/item/barrier_tape_roll/police,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/projectile/energy/lasercannon/mounted,
		)
	return ..()
