/obj/item/rig_module/basic
	name = "hardsuit upgrade"
	desc = "It looks pretty sciency."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"
	materials_base = list(MAT_STEEL = 2000, MAT_PLASTIC = 2500, MAT_GLASS = 1750)

	#warn we will need to implement global conflict type on everything as this defaults off
	var/redundant                       // Set to 1 to ignore duplicate module checking when installing.
