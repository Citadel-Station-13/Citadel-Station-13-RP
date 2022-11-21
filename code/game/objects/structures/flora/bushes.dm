/***********
 *! Bushes *
 ***********/

/obj/structure/flora/bush
	name = "bush"
	desc = "Some type of shrubbery. Known for causing considerable economic stress on designers."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	// flora_flags = FLORA_HERBAL

/obj/structure/flora/bush/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(istype(W, /obj/item/shovel))
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 10, src))
			user.visible_message(
				SPAN_NOTICE("\The [user] digs up \the [src]."),
				SPAN_NOTICE("You dig up \the [src]."),
				SPAN_HEAR("You hear something digging.")
			)
			new /obj/item/stack/tile/grass(get_turf(usr), 1)
			qdel(src)
			return

/obj/structure/flora/bush/style_2
	icon_state = "firstbush_2"
/obj/structure/flora/bush/style_3
	icon_state = "firstbush_3"
/obj/structure/flora/bush/style_4
	icon_state = "firstbush_4"
/obj/structure/flora/bush/style_random/Initialize(mapload)
	. = ..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/bush/reed
	icon_state = "reedbush_1"
/obj/structure/flora/bush/reed/style_2
	icon_state = "reedbush_2"
/obj/structure/flora/bush/reed/style_3
	icon_state = "reedbush_3"
/obj/structure/flora/bush/reed/style_4
	icon_state = "reedbush_4"
/obj/structure/flora/bush/reed/style_random/Initialize(mapload)
	. = ..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/bush/leafy
	icon_state = "leafybush_1"
/obj/structure/flora/bush/leafy/style_2
	icon_state = "leafybush_2"
/obj/structure/flora/bush/leafy/style_3
	icon_state = "leafybush_3"
/obj/structure/flora/bush/leafy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/bush/pale
	icon_state = "palebush_1"
/obj/structure/flora/bush/pale/style_2
	icon_state = "palebush_2"
/obj/structure/flora/bush/pale/style_3
	icon_state = "palebush_3"
/obj/structure/flora/bush/pale/style_4
	icon_state = "palebush_4"
/obj/structure/flora/bush/pale/style_random/Initialize(mapload)
	. = ..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/bush/stalky
	icon_state = "stalkybush_1"
/obj/structure/flora/bush/stalky/style_2
	icon_state = "stalkybush_2"
/obj/structure/flora/bush/stalky/style_3
	icon_state = "stalkybush_3"
/obj/structure/flora/bush/stalky/style_random/Initialize(mapload)
	. = ..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/bush/grassy
	icon_state = "grassybush_1"
/obj/structure/flora/bush/grassy/style_2
	icon_state = "grassybush_2"
/obj/structure/flora/bush/grassy/style_3
	icon_state = "grassybush_3"
/obj/structure/flora/bush/grassy/style_4
	icon_state = "grassybush_4"
/obj/structure/flora/bush/grassy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/bush/sparsegrass
	icon_state = "sparsegrass_1"
/obj/structure/flora/bush/sparsegrass/style_2
	icon_state = "sparsegrass_2"
/obj/structure/flora/bush/sparsegrass/style_3
	icon_state = "sparsegrass_3"
/obj/structure/flora/bush/sparsegrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/bush/fullgrass
	icon_state = "fullgrass_1"
/obj/structure/flora/bush/fullgrass/style_2
	icon_state = "fullgrass_2"
/obj/structure/flora/bush/fullgrass/style_3
	icon_state = "fullgrass_3"
/obj/structure/flora/bush/fullgrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/bush/ferny
	icon_state = "fernybush_1"
/obj/structure/flora/bush/ferny/style_2
	icon_state = "fernybush_2"
/obj/structure/flora/bush/ferny/style_3
	icon_state = "fernybush_3"
/obj/structure/flora/bush/ferny/style_random/Initialize(mapload)
	. = ..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/bush/sunny
	icon_state = "sunnybush_1"
/obj/structure/flora/bush/sunny/style_2
	icon_state = "sunnybush_2"
/obj/structure/flora/bush/sunny/style_3
	icon_state = "sunnybush_3"
/obj/structure/flora/bush/sunny/style_random/Initialize(mapload)
	. = ..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/bush/generic
	icon_state = "genericbush_1"
/obj/structure/flora/bush/generic/style_2
	icon_state = "genericbush_2"
/obj/structure/flora/bush/generic/style_3
	icon_state = "genericbush_3"
/obj/structure/flora/bush/generic/style_4
	icon_state = "genericbush_4"
/obj/structure/flora/bush/generic/style_random/Initialize(mapload)
	. = ..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/bush/pointy
	icon_state = "pointybush_1"
/obj/structure/flora/bush/pointy/style_2
	icon_state = "pointybush_2"
/obj/structure/flora/bush/pointy/style_3
	icon_state = "pointybush_3"
/obj/structure/flora/bush/pointy/style_4
	icon_state = "pointybush_4"
/obj/structure/flora/bush/pointy/style_random/Initialize(mapload)
	. = ..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/bush/lavendergrass
	icon_state = "lavendergrass_1"
/obj/structure/flora/bush/lavendergrass/style_2
	icon_state = "lavendergrass_2"
/obj/structure/flora/bush/lavendergrass/style_3
	icon_state = "lavendergrass_3"
/obj/structure/flora/bush/lavendergrass/style_4
	icon_state = "lavendergrass_4"
/obj/structure/flora/bush/lavendergrass/style_random/Initialize(mapload)
	. = ..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/bush/flowers_yw
	icon_state = "ywflowers_1"
/obj/structure/flora/bush/flowers_yw/style_2
	icon_state = "ywflowers_2"
/obj/structure/flora/bush/flowers_yw/style_3
	icon_state = "ywflowers_3"
/obj/structure/flora/bush/flowers_yw/style_random/Initialize(mapload)
	. = ..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/bush/flowers_br
	icon_state = "brflowers_1"
/obj/structure/flora/bush/flowers_br/style_2
	icon_state = "brflowers_2"
/obj/structure/flora/bush/flowers_br/style_3
	icon_state = "brflowers_3"
/obj/structure/flora/bush/flowers_br/style_random/Initialize(mapload)
	. = ..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/bush/flowers_pp
	icon_state = "ppflowers_1"
/obj/structure/flora/bush/flowers_pp/style_2
	icon_state = "ppflowers_2"
/obj/structure/flora/bush/flowers_pp/style_3
	icon_state = "ppflowers_3"
/obj/structure/flora/bush/flowers_pp/style_random/Initialize(mapload)
	. = ..()
	icon_state = "ppflowers_[rand(1, 3)]"

/obj/structure/flora/bush/snow
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

/obj/structure/flora/bush/snow/style_2
	icon_state = "snowbush2"
/obj/structure/flora/bush/snow/style_3
	icon_state = "snowbush3"
/obj/structure/flora/bush/snow/style_4
	icon_state = "snowbush4"
/obj/structure/flora/bush/snow/style_5
	icon_state = "snowbush5"
/obj/structure/flora/bush/snow/style_6
	icon_state = "snowbush6"
/obj/structure/flora/bush/snow/style_random/Initialize(mapload)
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/bush/jungle
	desc = "A wild plant that is found in jungles."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha1"
	// flora_flags = FLORA_HERBAL

/obj/structure/flora/bush/jungle/a/style_2
	icon_state = "busha2"
/obj/structure/flora/bush/jungle/a/style_3
	icon_state = "busha3"
/obj/structure/flora/bush/jungle/a/style_random/Initialize(mapload)
	. = ..()
	icon_state = "busha[rand(1, 3)]"

/obj/structure/flora/bush/jungle/b
	icon_state = "bushb1"
/obj/structure/flora/bush/jungle/b/style_2
	icon_state = "bushb2"
/obj/structure/flora/bush/jungle/b/style_3
	icon_state = "bushb3"
/obj/structure/flora/bush/jungle/b/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bushb[rand(1, 3)]"

/obj/structure/flora/bush/jungle/c
	icon_state = "bushc1"
/obj/structure/flora/bush/jungle/c/style_2
	icon_state = "bushc2"
/obj/structure/flora/bush/jungle/c/style_3
	icon_state = "bushc3"
/obj/structure/flora/bush/jungle/c/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bushc[rand(1, 3)]"

/obj/structure/flora/bush/large
	icon = 'icons/obj/flora/largejungleflora.dmi'
	icon_state = "bush1"
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/flora/bush/large/style_2
	icon_state = "bush2"
/obj/structure/flora/bush/large/style_3
	icon_state = "bush3"
/obj/structure/flora/bush/large/style_random/Initialize(mapload)
	. = ..()
	icon_state = "bush[rand(1, 3)]"
