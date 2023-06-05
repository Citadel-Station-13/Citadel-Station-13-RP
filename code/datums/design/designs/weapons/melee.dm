/datum/design/weapon/knuckle_duster
	id = "WeaponKnuckleDusters"
	build_path = /obj/item/clothing/gloves/knuckledusters
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials = list()
	material_parts = list(
		"body" = 2000,
	)

/datum/design/weapon/tactical_knife
	id = "WeaponTacticalKnife"
	build_path = /obj/item/material/knife/tacknife
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC
	materials = list(
		MAT_STEEL = 500,
	)
	material_parts = list(
		"blade" = 3000,
	)

/datum/design/weapon/flamethrower
	id = "WeaponFlamethrower"
	build_path = /obj/item/flamethrower/full
	lathe_type = LATHE_TYPE_AUTOLATHE
	design_unlock = DESIGN_UNLOCK_INTRINSIC

