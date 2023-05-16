/datum/announce_location/overmap_sector
	/// our overmap sector
	var/obj/effect/overmap/visitable/sector

/datum/announce_location/overmap_sector/New(obj/effect/overmap/visitable/sector)
	src.sector = sector
	if(!sector)
		CRASH("Invalid sector: [sector]")
	name = "overmap sector: [sector]"
	desc = "Announces to the overmap sector \"[sector]\""

/datum/announce_location/overmap_sector/get_affected_levels()
	return sector?.map_z.Copy() || list()

/datum/announce_location/overmap_sector/render_proper_possessive_name()
	return "The [sector]'s"
