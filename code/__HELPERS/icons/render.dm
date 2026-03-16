//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/proc/render_compound_icon_with_client(target, client/C)
	var/icon/generated

	// do one first
	var/mutable_appearance/rendering = new /mutable_appearance(target)
	rendering.dir = SOUTH
	generated = icon(C.RenderIcon(rendering.appearance))

	// do rest
	rendering.dir = EAST
	generated.Insert(C.RenderIcon(rendering.appearance), dir = EAST)
	rendering.dir = NORTH
	generated.Insert(C.RenderIcon(rendering.appearance), dir = NORTH)
	rendering.dir = WEST
	generated.Insert(C.RenderIcon(rendering.appearance), dir = WEST)

	return generated
