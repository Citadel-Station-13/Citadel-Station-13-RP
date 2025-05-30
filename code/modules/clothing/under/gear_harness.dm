/obj/item/clothing/under/gear_harness
	name = "gear harness"
	desc = "How... minimalist."
	icon_state = "gear_harness"
	body_cover_flags = NONE

/obj/item/clothing/under/gear_harness/style_repick_query(mob/user)
	. = ..()
	var/image/normal_image = image(icon, "gear_harness")
	normal_image.maptext = MAPTEXT("normal")
	.["normal"] = normal_image
	var/image/invisible_image = image('icons/system/blank_32x32.dmi', "")
	invisible_image.maptext = MAPTEXT("invisible")
	.["invisible"] = invisible_image

/obj/item/clothing/under/gear_harness/style_repick_set(style, mob/user)
	switch(style)
		if("normal")
			worn_render_flags = initial(worn_render_flags)
			return TRUE
		if("invisible")
			worn_render_flags |= WORN_RENDER_SLOT_NO_RENDER
			return TRUE
		else
			return FALSE
