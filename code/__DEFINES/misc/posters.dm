//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

#define DECLARE_POSTER_DESIGN(TYPEPATH) \
/obj/item/poster/preset/##TYPEPATH{

}
/obj/structure/poster/##TYPEPATH{
	name = /datum/prototype/poster_design/##TYPEPATH::name; \
	icon = /datum/prototype/poster_design/##TYPEPATH::icon; \
	icon_state = /datum/prototype/poster_design/##TYPEPATH::icon_state; \

}
/datum/prototype/poster_design/##TYPEPATH

#define POSTER_TAG_NANOTRASEN "nanotrasen"
