/obj/item/stamp
	var/list/stamp_sounds = list(
		'modular_citadel/sound/items/stamp1.ogg',
		'modular_citadel/sound/items/stamp2.ogg',
		'modular_citadel/sound/items/stamp3.ogg'
		)

/obj/item/stamp/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	. = ..()
	playsound(M, pick(stamp_sounds), 30, 1, -1)