//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/point_redemption_vendor
	name = "point redemption vendor"
	desc = "An equipment vendor that trades points for various gear. Usually found in the station's departments \
		and used to incentivize good performance."
	#warn sprite
#warn impl	density = TRUE
	anchored = TRUE

	/// point type we operate with
	var/point_type
