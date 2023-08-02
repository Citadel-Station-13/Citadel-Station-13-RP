/obj/item/towel
	name = "towel"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "towel"
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	damage_force = 3.0
	clothing_flags = CLOTHING_IGNORE_BELTLINK
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/towel/equipped(var/M, var/slot)
	..()
	LAZYINITLIST(sprite_sheets)
	switch(slot)
		if(SLOT_ID_HEAD)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/head.dmi')
		if(SLOT_ID_SUIT)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/suits.dmi')
		if(SLOT_ID_BELT)
			sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/clothing/species/teshari/belt.dmi')

/obj/item/towel/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	user.visible_message(SPAN_NOTICE("[user] uses [src] to towel themselves off."))
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)
	if(H.fire_stacks > 0)
		H.fire_stacks = (max(0, H.fire_stacks - 1.5))
	else if(H.fire_stacks < 0)
		H.fire_stacks = (min(0, H.fire_stacks + 1.5))

/obj/item/towel/random/Initialize(mapload)
	. = ..()
	add_atom_colour("#"+get_random_colour(), FIXED_COLOUR_PRIORITY)
