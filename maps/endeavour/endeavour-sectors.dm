
/obj/overmap/entity/visitable/sector/centcom_endeavour
	name = "NDV Oracle"
	desc = "The NDV Oracle is a Nanotrasen Fleet Support Ship that serves as the flagship for the eponymous Oracle Fleet."
	scanner_desc = @{"[i]Information[/i]: The NCV Oracle is a Nanotrasen Fleet Support Ship that serves as the flagship for the eponymous Oracle Fleet."}
	in_space = 1
	known = TRUE
	icon = 'icons/modules/overmap/tiled.dmi'
	icon_state = "fleet"
	color = "#007396"

	initial_restricted_waypoints = list(
		"NDV Quicksilver" = list("specops_hangar")
		)
