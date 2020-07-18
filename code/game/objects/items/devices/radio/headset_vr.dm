/obj/item/radio/headset/centcom
	name = "\improper CentCom headset"
	desc = "A headset used by the upper echelons of Nanotrasen."
	icon_state = "cent_headset"
	independent = TRUE
	keyslot = new /obj/item/encryptionkey/headset_com
	keyslot2 = new /obj/item/encryptionkey/ert

/obj/item/radio/headset/centcom/alt
	name = "\improper CentCom bowman headset"
	desc = "A headset especially for emergency response personnel." // Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	item_state = "com_headset_alt"
	bowman = TRUE

/obj/item/radio/headset/nanotrasen
	name = "\improper NT radio headset"
	desc = "The headset of a Nanotrasen corporate employee."
	icon_state = "nt_headset"
	independent = TRUE
	keyslot = new /obj/item/encryptionkey/headset_com
	keyslot2 = new /obj/item/encryptionkey/ert

/obj/item/radio/headset
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/teshari/ears.dmi',
						SPECIES_WEREBEAST = 'icons/mob/species/werebeast/ears.dmi',
						SPECIES_VOX = 'icons/mob/species/vox/ears.dmi')

/obj/item/radio/headset/mob_headset	//Adminbus headset for simplemob shenanigans.
	name = "nonhuman radio implant"
	desc = "An updated, modular intercom that requires no hands to operate. Takes encryption keys"

/obj/item/radio/headset/mob_headset/afterattack(atom/movable/target, mob/living/user, proximity)
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
