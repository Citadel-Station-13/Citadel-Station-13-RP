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
