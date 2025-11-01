
/obj/overmap/entity/visitable/sector/ncv_oracle
	name = "NCV Oracle"
	desc = "The NCV Oracle is a Nanotrasen Fleet support ship that serves as the flagship for the eponymous Oracle Operational Group."
	scanner_desc = @{"[i]Information[/i]: The NCV Oracle is a Nanotrasen Fleet support ship that serves as the flagship for the eponymous Oracle Operational Group."}
	in_space = 1
	known = TRUE
	icon = 'icons/modules/overmap/tiled.dmi'
	icon_state = "fleet"
	color = "#007396"

	initial_restricted_waypoints = list(
		"NDV Quicksilver" = list("specops_hangar")
		)
