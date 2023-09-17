/obj/item/aquarium_prop
	name = "generic aquarium prop"
	desc = "very boring"
	icon = 'icons/modules/fishing/aquarium.dmi'

	w_class = WEIGHT_CLASS_TINY
	var/layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/aquarium_content)

/obj/item/aquarium_prop/rocks
	name = "rocks"
	icon_state = "rocks"

/obj/item/aquarium_prop/seaweed_top
	name = "dense seaweeds"
	icon_state = "seaweeds_front"
	layer_mode = AQUARIUM_LAYER_MODE_TOP

/obj/item/aquarium_prop/seaweed
	name = "seaweeds"
	icon_state = "seaweeds_back"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/rockfloor
	name = "rock floor"
	icon_state = "rockfloor"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

/obj/item/aquarium_prop/treasure
	name = "tiny treasure chest"
	icon_state = "treasure"
	layer_mode = AQUARIUM_LAYER_MODE_BOTTOM

