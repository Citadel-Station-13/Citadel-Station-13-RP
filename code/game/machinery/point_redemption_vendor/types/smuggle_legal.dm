/obj/machinery/point_redemption_vendor/smuggle
	name = "Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	icon = 'icons/machinery/point_redemption_vendor/engineering.dmi'
	icon_state = "vendor"
	icon_state_append_deny = "-deny"
	icon_state_append_open = "-open"
	icon_state_append_off = "-off"
	point_type = POINT_REDEMPTION_TYPE_SMUGGLE
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate,								100),
		new /datum/point_redemption_item("Cargo crates Illegal",			/obj/structure/cargotransitcrate/illegal,						250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/ftu
	name = "FTU Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/ftu,							100),
		new /datum/point_redemption_item("Contraband Cargo",				/obj/structure/cargotransitcrate/illegal/ftu,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/nt
	name = "NT Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/nt,							100),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/miaphus
	name = "Haddis' folley Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/miaphus,						100),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/gaia
	name = "Gaia Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/gaia,							100),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/sky
	name = "Gaia Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/sky,							100),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/atlas
	name = "Atlas Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Cargo crates",					/obj/structure/cargotransitcrate/atlas,							100),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )


