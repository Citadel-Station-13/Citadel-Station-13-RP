//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/unit_test/shuttles/Run()
	for(var/datum/bounds2/bounds as anything in GLOB.uninitialized_shuttle_dock_bounds)
		Fail("Uninitialized shuttle bounds [bounds.to_text()] found, is a dock missing?")
