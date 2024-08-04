/obj/structure/table/drop_products(method, atom/where)
	. = ..()
	switch(method)
		if(ATOM_DECONSTRUCT_DISASSEMBLED)
			material_reinforcing?.place_sheet(where, 1)
			material_base?.place_sheet(where, 1)
			new /obj/item/stack/material/steel(where, 1)
			if(carpeted)
				new carpeted_type(where)
		else
			if(prob(20))
				material_reinforcing.place_sheet(where, 1)
			else
				material_reinforcing?.place_shard(where)
			if(prob(20))
				material_base.place_sheet(where, 1)
			else
				material_base?.place_shard(where)
			new /obj/item/stack/rods(where, 2)
