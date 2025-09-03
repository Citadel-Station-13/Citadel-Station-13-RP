/obj/machinery/point_redemption_vendor/smuggle/illegal
	name = "Illegal Cargo Transit Vendor"
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

/obj/machinery/point_redemption_vendor/smuggle/illegal/pirate
	name = "Pirate Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Pirate Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/pirate,				150),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/illegal/miaphus
	name = "Mercenary Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Merc Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/merc,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/illegal/casino
	name = "Drug smuggler Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Drug Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/drugs,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/illegal/sky
	name = "Rebel Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Rebel Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/rebel,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/illegal/atlas
	name = "NKA Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("NKA Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/nka,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )

/obj/machinery/point_redemption_vendor/smuggle/illegal/classd
	name = "Operative Cargo Transit Vendor"
	desc = "A vending machine to order cargo transit crates with Transit points (not cargo points)."
	prize_list = list(
		new /datum/point_redemption_item("Operative Contraband Cargo",			/obj/structure/cargotransitcrate/illegal/operative,					250),
		new /datum/point_redemption_item("100 Thaler",					    /obj/item/spacecash/c100,									    100),
		new /datum/point_redemption_item("1000 Thaler",					    /obj/item/spacecash/c1000,									    1000)
    )
