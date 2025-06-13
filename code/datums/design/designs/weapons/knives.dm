
/datum/prototype/design/weapon/tactical_knife
	id = "WeaponTacticalKnife"
	build_path = /obj/item/material/knife/tacknife
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials_base = list(
		/datum/prototype/material/steel = 500,
	)
	material_costs = list(
		"blade" = 3000,
	)
	material_autodetect_tags = list(
		"blade" = MATERIAL_TAG_BASIC_STRUCTURAL,
	)
