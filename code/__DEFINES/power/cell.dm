//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// generate /small, /medium, /large, and /weapon cells for a type
#define POWER_CELL_GENERATE_TYPES(TYPEPATH) \
##TYPEPATH/small { \
	name = "small power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A small power cell used in handheld electronics. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
} \
##TYPEPATH/medium { \
	name = "medium power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A decently sized cell used in many pieces of modern equipment. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
} \
##TYPEPATH/large { \
	name = "large power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A bulky power cell used in industrial equipment and power supply systems. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
} \
##TYPEPATH/weapon { \
	name = "weapon power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A power cell accepted by many kinds of handheld weaponry. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
}
