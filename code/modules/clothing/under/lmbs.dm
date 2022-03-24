//The LMBS is technically a RIG subset, because it has a lot of the infrastructure I'd like to use and it'll save us on debt/bloat to just integrate LMBS into this code.
/obj/item/rig/lmbs
	name = "LMBS module"
	suit_type = "LMBS"
	desc = "The Load Management Bearing System, known affectionately as the LMBS, is the product of a joint research program between NanoTrasen and Vey-Med. Initially designed to restore mobility to parapalegics and other victims of paralysis, the system has sense been modularized and authorized for industrial, military, and civilian applications."
	icon_state = "limb_rig"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_LARGE
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	slowdown = 0
	offline_slowdown = 2
	offline_vision_restriction = 0

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit
		)

	req_access = list()
	req_one_access = list()

	glove_type = null
	helm_type = null
	boot_type = /obj/item/clothing/shoes/magboots/rig/lmbs

/obj/item/clothing/shoes/magboots/rig/lmbs
	name = "LMBS traction"
	step_volume_mod = 1.5

/obj/item/rig/belt/equipped

	req_access = list()

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/sprinter
		)

	glove_type = null
	helm_type = null
	boot_type = null
