/obj/item/radio/headset/centcom
	name = "centcom radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "cent_headset"
	item_state = "headset"
	centComm = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset/centcom/alt
	name = "centcom bowman headset"
	icon_state = "com_headset_alt"

/obj/item/radio/headset/nanotrasen
	name = "\improper NT radio headset"
	desc = "The headset of a Nanotrasen corporate employee."
	icon_state = "nt_headset"
	centComm = 1
	ks2type = /obj/item/encryptionkey/ert

/obj/item/radio/headset
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/seromi/ears.dmi',
						SPECIES_WEREBEAST = 'icons/mob/species/werebeast/ears.dmi',
						SPECIES_VOX = 'icons/mob/species/vox/ears.dmi')

/obj/item/radio/headset/mob_headset	//Adminbus headset for simplemob shenanigans.
	name = "nonhuman radio implant"
	desc = "An updated, modular intercom that requires no hands to operate. Takes encryption keys"

/obj/item/radio/headset/mob_headset/receive_range(freq, level)
		return ..(freq, level)


/obj/item/radio/headset/mob_headset/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/state = interactive_state)
	ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430, state = interactive_state)
	..()

/obj/item/radio/headset/mob_headset/afterattack(var/atom/movable/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(istype(target,/mob/living/simple_mob))
		var/mob/living/simple_mob/M = target
		if(!M.mob_radio)
			forceMove(M)
			M.mob_radio = src
			return
		if(M.mob_radio)
			M.mob_radio.forceMove(M.loc)
			M.mob_radio = null
			return
	..()
