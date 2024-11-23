//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Helpers *//

#define DECLARE_POSTER_DESIGN(TYPEPATH) \
/obj/item/poster/preset##TYPEPATH { \
	name = /obj/item/poster::name + " - " + /datum/prototype/poster_design##TYPEPATH::name; \
	desc = /obj/item/poster::desc + " " + /datum/prototype/poster_design##TYPEPATH::desc; \
	poster_design_id = /datum/prototype/poster_design##TYPEPATH; \
}; \
/obj/structure/poster/preset##TYPEPATH {; \
	name = /datum/prototype/poster_design##TYPEPATH::name; \
	desc = /obj/structure/poster::desc + " " + /datum/prototype/poster_design##TYPEPATH::desc; \
	icon = /datum/prototype/poster_design##TYPEPATH::icon; \
	icon_state = /datum/prototype/poster_design##TYPEPATH::icon_state; \
	poster_design_id = /datum/prototype/poster_design##TYPEPATH; \
}; \
/datum/prototype/poster_design##TYPEPATH

//* Tags *//

#define POSTER_TAG_NANOTRASEN "nanotrasen"
