/obj/item/clothing/accessory/halo_projector
	name = "halo projector"
	desc = "A small grey device that projects a holographic image."
	icon = 'icons/clothing/accessories/halo_projector.dmi'
	icon_state = "projector"
	icon_mob_y_align = 24
	slot_flags = SLOT_HEAD | SLOT_EARS
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL
	accessory_render_legacy = FALSE

	var/static/list/global_halo_styles

/obj/item/clothing/accessory/halo_projector/Initialize(mapload)
	. = ..()
	if(isnull(global_halo_styles))
		generate_styles()
	AddElement(/datum/element/clothing/dynamic_recolor)

/obj/item/clothing/accessory/halo_projector/available_styles(mob/user)
	. = ..()
	for(var/halo_name in global_halo_styles)
		.[halo_name] = global_halo_styles[halo_name]

/obj/item/clothing/accessory/halo_projector/set_style(style, mob/user)
	. = ..()
	if(.)
		return
	icon_state = global_halo_styles[style]
	update_worn_icon()

/obj/item/clothing/accessory/halo_projector/render_apply_custom(mob/M, mutable_appearance/MA, bodytype, inhands, datum/inventory_slot_meta/slot_meta, icon_used)
	. = ..()
	if(inhands)
		return
	MA.filters += filter(type = "drop_shadow", size = 3, color = src.color? src.color : "#ffffff")
	MA.appearance_flags |= KEEP_APART
	if(M)
		MA.transform = M.transform

/obj/item/clothing/accessory/halo_projector/render_additional(mob/M, icon/icon_used, state_used, layer_used, dim_x, dim_y, align_y, bodytype, inhands, datum/inventory_slot_meta/slot_meta)
	. = ..()
	if(inhands)
		return
	// todo: mob emissives, emissive renderer.
	var/mutable_appearance/emissive = emissive_appearance(icon_used, state_used)
	emissive.pixel_y += align_y
	emissive.filters += filter(type = "drop_shadow", size = 5, color = "#ffffff77")
	emissive.appearance_flags |= KEEP_APART
	if(M)
		emissive.transform = M.transform
	. += emissive

/obj/item/clothing/accessory/halo_projector/proc/generate_styles()
	var/obj/item/clothing/accessory/halo_projector/parsing
	var/list/parsing_types = tim_sort(subtypesof(/obj/item/clothing/accessory/halo_projector), /proc/cmp_initial_name_asc)
	global_halo_styles = list()
	for(parsing as anything in parsing_types)
		global_halo_styles[initial(parsing.name)] = initial(parsing.icon_state)

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
