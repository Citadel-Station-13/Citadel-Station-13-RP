/obj/structure/table/drop_products(method, atom/where)
	. = ..()
	switch(method)
		if(ATOM_DECONSTRUCT_DISASSEMBLED)
		else
