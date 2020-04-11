/datum/supply_pack/supply/stolen
	name = "Stolen Supply Crate"
	contains = list(/obj/item/stolenpackage = 1)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "shady crate"
	contraband = 1

/datum/supply_pack/randomised/stolenplus
	name = "Bulk Stolen Supply Crate"
	num_contained = 4
	contains = list(
		/obj/item/stolenpackage,
		/obj/item/stolenpackageplus,
		) // uh oh
	cost = 375 //slight discount? still contraband tho glhf
	containertype = /obj/structure/closet/crate
	containername = "shadier crate"
	contraband = 1

/datum/supply_pack/supply/wolfgirl
	name = "Wolfgirl Crate"
	cost = 200 //I mean, it's a whole wolfgirl
	containertype = /obj/structure/largecrate/animal/wolfgirl
	containername = "Wolfgirl crate"
	contraband = 1

/datum/supply_pack/supply/catgirl
	name = "Catgirl Crate"
	cost = 200 //I mean, it's a whole catgirl
	containertype = /obj/structure/largecrate/animal/catgirl
	containername = "Catgirl crate"
	contraband = 1

/datum/supply_pack/supply/medieval
	name = "Knight set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/red = 1,
			/obj/item/clothing/head/helmet/medieval/green = 1,
			/obj/item/clothing/head/helmet/medieval/blue = 1,
			/obj/item/clothing/head/helmet/medieval/orange = 1,
			/obj/item/clothing/suit/armor/medieval/red = 1,
			/obj/item/clothing/suit/armor/medieval/green = 1,
			/obj/item/clothing/suit/armor/medieval/blue = 1,
			/obj/item/clothing/suit/armor/medieval/orange = 1
			)
	cost = 120
	containertype = /obj/structure/closet/crate
	containername = "knight set crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_templar
	name = "Templar set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader/templar,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/templar,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/templar
			)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "templar armor crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_hospitaller
	name = "Hospitaller set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/hospitaller
			)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "hospitaller armor crate"
	contraband = 1

/datum/supply_pack/supply/deusvult_teutonic
	name = "Teutonic set crate"
	contains = list(
			/obj/item/clothing/head/helmet/medieval/crusader/horned,
			/obj/item/clothing/head/helmet/medieval/crusader/winged,
			/obj/item/clothing/suit/armor/medieval/crusader/cross,
			/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/teutonic
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "teutonic armor crate"
	contraband = 1

