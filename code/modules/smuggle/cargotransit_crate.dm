GLOBAL_LIST_INIT(cargotransit_data, initialize_cargotransit_data())

/proc/initialize_cargotransit_data()
	. = list()
	for(var/cargotransittype in subtypesof(/datum/cargotransit))
		var/datum/cargotransit/OD = new cargotransittype
		.[OD.name] = OD

/datum/cargotransit
	var/name
	var/display_name
	var/cargotransit
	var/crate

/datum/cargotransit/New()
	. = ..()
	if(!display_name)
		display_name = name

/datum/cargotransit/cargotransitcrate
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate

/datum/cargotransit/cargotransitcrate/ftu
	name = "Cargo Transit crate ftu"
	crate = /obj/structure/cargotransitcrate/ftu

/datum/cargotransit/cargotransitcrate/nt
	name = "Cargo Transit crate nt"
	crate = /obj/structure/cargotransitcrate/nt

/datum/cargotransit/cargotransitcrate/miaphus
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/miaphus

/datum/cargotransit/cargotransitcrate/gaia
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/gaia

/datum/cargotransit/cargotransitcrate/sky
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/sky

/datum/cargotransit/cargotransitcrate/atlas
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/atlas

/datum/cargotransit/cargotransitcrate/illegal
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal

/datum/cargotransit/cargotransitcrate/illegal/ftu
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/ftu

/datum/cargotransit/cargotransitcrate/illegal/merc
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/merc

/datum/cargotransit/cargotransitcrate/illegal/drugs
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/drugs

/datum/cargotransit/cargotransitcrate/illegal/nka
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/nka

/datum/cargotransit/cargotransitcrate/illegal/pirate
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/pirate

/datum/cargotransit/cargotransitcrate/illegal/rebel
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/rebel

/datum/cargotransit/cargotransitcrate/illegal/operative
	name = "Cargo Transit crate"
	crate = /obj/structure/cargotransitcrate/illegal/operative

/obj/structure/cargotransitcrate
	name = "Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means."
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate"
	climb_allowed = TRUE
	depth_projected = TRUE
	depth_level = 8
	armor_type = /datum/armor/object/medium
	worth_intrinsic = 45

/obj/structure/cargotransitcrate/ftu
	name = "Nebula Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. It comes from Nebula Gas Station. Usually, this is gear that the FTU sells : clothes, gear, machinery... \
	Rather cheap to get, It is best sold on NT instalations, Miaphus'Ira or Lythios 43a."

/obj/structure/cargotransitcrate/nt
	name = "NT Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. It comes from Nanotrasen. Usually you get standart NT stuff inside, altho allied corporation also use NT packaging. \
	Rather cheap to get, It is best sold on Nebula Gas station, Miaphus'Ira, Gaia station, Solar station, or Lythios 43c."

/obj/structure/cargotransitcrate/miaphus
	name = "Haddis'folly / Miaphus Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. It comes from Miaphus'Ira. Ores, mining equipement, package from the population to their familly..."

/obj/structure/cargotransitcrate/gaia
	name = "Gaia Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. It comes from Gaia... This is a un-godly ammount of advertisement and postcards..."

/obj/structure/cargotransitcrate/sky
	name = "Sky planet Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. It comes from the Lythios 43a. Inside are sometimes ores, and package to the the few people in base - towns."

/obj/structure/cargotransitcrate/atlas
	name = "43c Colonist Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy letters and survival gear for the settlers on Lythios 43c."

/obj/structure/cargotransitcrate/illegal
	name = "Illegal Cargo Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. This one has contraband."
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate"
	climb_allowed = TRUE
	depth_projected = TRUE
	depth_level = 8
	armor_type = /datum/armor/object/medium
	worth_intrinsic = 45
	color ="#b62c2c"

/obj/structure/cargotransitcrate/illegal/ftu
	name = "FTU contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports commercial goods not authorised to be sold."

/obj/structure/cargotransitcrate/illegal/pirate
	name = "Pirate contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports stolen goods."

/obj/structure/cargotransitcrate/illegal/merc
	name = "Mercenary contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports mercenary goods."

/obj/structure/cargotransitcrate/illegal/rebel
	name = "Rebel contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports weapons."

/obj/structure/cargotransitcrate/illegal/drugs
	name = "Drugs contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports drugs."

/obj/structure/cargotransitcrate/illegal/nka
	name = "Shady NKA contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy transports papers and documents."

/obj/structure/cargotransitcrate/illegal/operative
	name = "Operative contraband Transit crate"
	desc = "A rectangular cardboard box, with an layer of steel underneath it, can't be opened with normal means. Usualy contains weapons, but also a lot of vials and reports."
