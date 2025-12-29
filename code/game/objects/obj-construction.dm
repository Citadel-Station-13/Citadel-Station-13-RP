//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Deconstruction *//

/obj/drop_products(method, atom/where)
	. = ..()
	if(obj_storage?.drop_on_deconstruction_methods & method)
		obj_storage.drop_everything_at(where)
