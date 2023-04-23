/obj/item/clothing/accessory/halo_projector
	name = "halo projector"
	desc = "A small grey device that projects a holographic image."
	icon = 'icons/clothing/accessories/halo_projector.dmi'
	icon_state = "projector"
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/accessory/halo_projector/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/dynamic_recolor)

/obj/item/clothing/accessory/halo_projector/available_styles(mob/user)
	. = ..()
	var/obj/item/clothing/accessory/halo_projector/parsing
	var/static/list/parsing_types = tim_sort(subtypesof(/obj/item/clothing/accessory/halo_projector), /proc/cmp_initial_name_asc)
	for(parsing as anything in parsing_types)
		.[initial(parsing.name)] = initial(parsing.icon_state)

/obj/item/clothing/accessory/halo_projector/gabriel
	name = "messenger's halo"
	icon_state = "gabriel"

/obj/item/clothing/accessory/halo_projector/threespike
	name = "triple starred halo"
	icon_state = "threespike"

/obj/item/clothing/accessory/halo_projector/brokenspike
	name = "prophet's halo"
	icon_state = "brokenspike"

/obj/item/clothing/accessory/halo_projector/arrows
	name = "wayfinder's halo"
	icon_state = "arrows"

/obj/item/clothing/accessory/halo_projector/circles
	name = "orbiting halo"
	icon_state = "circles"

/obj/item/clothing/accessory/halo_projector/thorns
	name = "judge's halo"
	icon_state = "thorns"

/obj/item/clothing/accessory/halo_projector/cross
	name = "faithful halo"
	icon_state = "cross"

/obj/item/clothing/accessory/halo_projector/plus
	name = "unfaithful halo"
	icon_state = "crossalt"

/obj/item/clothing/accessory/halo_projector/moon
	name = "lunar halo"
	icon_state = "moon"

/obj/item/clothing/accessory/halo_projector/crown
	name = "lauded halo"
	icon_state = "crown"

/obj/item/clothing/accessory/halo_projector/shiroinv
	name = "focused halo"
	icon_state = "shiroinv"

/obj/item/clothing/accessory/halo_projector/shiroko
	name = "headstrong halo"
	icon_state = "shiroko"

/obj/item/clothing/accessory/halo_projector/wings
	name = "elevated's halo"
	icon_state = "wings"

/obj/item/clothing/accessory/halo_projector/star
	name = "bright halo"
	icon_state = "star"

/obj/item/clothing/accessory/halo_projector/squares
	name = "logistician's halo"
	icon_state = "squares"

/obj/item/clothing/accessory/halo_projector/spikes
	name = "intrepid halo"
	icon_state = "spikes"

/obj/item/clothing/accessory/halo_projector/reticle
	name = "marksman's halo"
	icon_state = "reticle"

/obj/item/clothing/accessory/halo_projector/polygon
	name = "pragmatic's halo"
	icon_state = "polygon"

/obj/item/clothing/accessory/halo_projector/offset
	name = "mercurial halo"
	icon_state = "offset"

/obj/item/clothing/accessory/halo_projector/nanotrasen
	name = "corpo halo"
	icon_state = "nanotrasen"
