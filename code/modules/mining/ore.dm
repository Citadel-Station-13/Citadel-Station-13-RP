/obj/item/stack/ore
	name = "small rock"
	icon = 'icons/obj/stacks_ore.dmi'
	icon_state = "ore"
	no_variants = FALSE
	w_class = ITEMSIZE_NORMAL
	rad_flags = RAD_BLOCK_CONTENTS | RAD_NO_CONTAMINATE // uh let's like, not? it'd be funny but fields usually have like 400 pieces of ore in just a few tiles.
	//^ not as horrible now that it's stacked but I'm keeping this. <3
	singular_name = "ore"
	max_amount = 50

	var/datum/geosample/geologic_data
	var/material

/obj/item/stack/ore/update_icon()
	if(no_variants)
		icon_state = initial(icon_state)
	else //this is assuming that max_amount for ores will always be 50.
		switch(amount)
			if(-INFINITY to 1)
				icon_state = initial(icon_state)
			if(2 to 4)
				icon_state = "[initial(icon_state)]_[amount]"
			if(5 to 10)
				icon_state = "[initial(icon_state)]_5"
			if(11 to 26)
				icon_state = "[initial(icon_state)]_6"
			if(27 to INFINITY)
				icon_state = "[initial(icon_state)]_7"
		item_state = initial(icon_state)

/obj/item/stack/ore/legacy_ex_act(severity)
	return

/obj/item/stack/ore/Initialize(mapload)
	. = ..()
	pixel_x = rand(0,16)-8
	pixel_y = rand(0,8)-8

/obj/item/stack/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()

/obj/item/stack/ore/uranium
	name = "pitchblende"
	icon_state = "uranium"
	origin_tech = list(TECH_MATERIAL = 5)
	material = MAT_URANIUM

/obj/item/stack/ore/iron
	name = "hematite"
	icon_state = "iron"
	origin_tech = list(TECH_MATERIAL = 1)
	material = MAT_HEMATITE

/obj/item/stack/ore/coal
	name = "raw carbon"
	icon_state = "coal"
	origin_tech = list(TECH_MATERIAL = 1)
	material = MAT_CARBON

/obj/item/stack/ore/marble
	name = "recrystallized carbonate"
	icon_state = "marble"
	origin_tech = list(TECH_MATERIAL = 1)
	material = MAT_MARBLE

/obj/item/stack/ore/glass
	name = "sand"
	icon_state = "glass"
	origin_tech = list(TECH_MATERIAL = 1)
	material = "sand"
	singular_name = "sand"
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/stack/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(5)
		H.eye_blurry += 10
		spawn(1)
			if(isturf(loc))
				use(1) //oh no, they might toss the sand right back if you had more of it...

/obj/item/stack/ore/phoron
	name = "phoron crystals"
	icon_state = "phoron"
	singular_name = "crystal"
	origin_tech = list(TECH_MATERIAL = 2)
	material = MAT_PHORON

/obj/item/stack/ore/copper
	name = "native copper ore"
	icon_state = "copper"
	origin_tech = list(TECH_MATERIAL = 2)
	material = MAT_COPPER

/obj/item/stack/ore/silver
	name = "native silver ore"
	icon_state = "silver"
	origin_tech = list(TECH_MATERIAL = 3)
	material = MAT_SILVER

/obj/item/stack/ore/gold
	name = "native gold ore"
	icon_state = "gold"
	origin_tech = list(TECH_MATERIAL = 4)
	material = MAT_GOLD

/obj/item/stack/ore/diamond
	name = "diamonds"
	icon_state = "diamond"
	singular_name = "diamond"
	origin_tech = list(TECH_MATERIAL = 6)
	material = MAT_DIAMOND

/obj/item/stack/ore/osmium
	name = "raw platinum"
	icon_state = "platinum"
	material = MAT_PLATINUM

/obj/item/stack/ore/hydrogen
	name = "raw hydrogen"
	icon_state = "hydrogen"
	material = MAT_METALHYDROGEN

/obj/item/stack/ore/verdantium
	name = "verdantite dust"
	icon_state = "verdantium"
	material = MAT_VERDANTIUM
	origin_tech = list(TECH_MATERIAL = 7)

// POCKET ... Crystal dust.
/obj/item/stack/ore/verdantium/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.Blind(10)
		H.eye_blurry += 15
		spawn(1)
			if(isturf(loc))
				use(1)

/obj/item/stack/ore/lead
	name = "lead glance"
	icon_state = "lead"
	material = MAT_LEAD
	origin_tech = list(TECH_MATERIAL = 3)

/obj/item/stack/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	singular_name = "slag"
	icon_state = "slag"
	material = null

//Vaudium
/obj/item/stack/ore/vaudium
	name = "raw vaudium"
	icon_state = "vaudium"
	material = MAT_VAUDIUM
	origin_tech = list(TECH_MATERIAL = 7)
