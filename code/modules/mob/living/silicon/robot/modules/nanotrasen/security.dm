GENERATE_ROBOT_MODULE_PRESET(/nanotrasen/security)
/datum/prototype/robot_module/nanotrasen/security
	id = "nt-security"
	use_robot_module_path = /obj/item/robot_module/robot/security
	light_color = "#FF0000"
	iconsets = list(
		/datum/prototype/robot_iconset/baseline_standard/security,
		/datum/prototype/robot_iconset/hover_eyebot/security,
		/datum/prototype/robot_iconset/grounded_landmate/security,
		/datum/prototype/robot_iconset/grounded_landmate/security_tread,
		/datum/prototype/robot_iconset/biped_marina/security,
		/datum/prototype/robot_iconset/biped_tall/tallred,
		/datum/prototype/robot_iconset/baseline_toiletbot/security,
		/datum/prototype/robot_iconset/biped_sleek/security,
		/datum/prototype/robot_iconset/grounded_spider/security,
		/datum/prototype/robot_iconset/biped_heavy/security,
		/datum/prototype/robot_iconset/baseline_old/security,
		/datum/prototype/robot_iconset/baseline_old/security_riot,
		/datum/prototype/robot_iconset/hover_drone/security,
		/datum/prototype/robot_iconset/biped_insekt/security,
		/datum/prototype/robot_iconset/biped_tall/alternative/security,
		/datum/prototype/robot_iconset/biped_miss/security,
		/datum/prototype/robot_iconset/hover_glitterfly/security,
		/datum/prototype/robot_iconset/grounded_mechoid/security,
		/datum/prototype/robot_iconset/hover_handy/security,
		/datum/prototype/robot_iconset/biped_noble/security,
		/datum/prototype/robot_iconset/grounded_zoomba/security,
		/datum/prototype/robot_iconset/grounded_worm/security,
		/datum/prototype/robot_iconset/dog_borgi/security,
		/datum/prototype/robot_iconset/dog_k9/security,
		/datum/prototype/robot_iconset/dog_otie/security,
		/datum/prototype/robot_iconset/dog_pupdozer/security,
		/datum/prototype/robot_iconset/dog_vale/security,
		/datum/prototype/robot_iconset/cat_feli/security,
		/datum/prototype/robot_iconset/drake_mizartz/security,
		/datum/prototype/robot_iconset/dog_k9/red,
	)

/datum/prototype/robot_module/nanotrasen/security/create_mounted_item_descriptors(list/normal_out, list/emag_out)
	..()
	if(normal_out)
		normal_out |= list(
			/obj/item/handcuffs/cyborg,
			/obj/item/melee/baton/robot,
			/obj/item/gun/energy/taser/mounted/cyborg,
			/obj/item/barrier_tape_roll/police,
			/obj/item/reagent_containers/spray/pepper,
			/obj/item/gripper/security,
		)
	if(emag_out)
		emag_out |= list(
			/obj/item/gun/energy/laser/mounted,
		)

#warn translate chassis below

// todo: legacy
/obj/item/robot_module/robot/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	can_be_pushed = 0
	supported_upgrades = list(/obj/item/robot_upgrade/tasercooler)

/obj/item/robot_module/robot/security/general
	sprites = list(
		"Black Knight" = "securityrobot",
		"Coffcurity" = "coffin-Combat",
	)

/obj/item/robot_module/robot/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0

/obj/item/robot_module/robot/quad/sec
	name = "SecuriQuad module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	can_be_pushed = 0
	can_shred = TRUE
	supported_upgrades = list(/obj/item/robot_upgrade/tasercooler)

/obj/item/robot_module/robot/quad/sec/get_modules()
	. = ..()
	. |= list(
		/obj/item/robot_builtin/dog_pounce //Pounce
	)

/obj/item/robot_module/robot/quad/sec/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0
