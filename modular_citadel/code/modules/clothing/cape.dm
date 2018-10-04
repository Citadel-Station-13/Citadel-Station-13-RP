// I gave up.

/obj/item/clothing/suit/cape
	name = "cape"
	desc = "A bland, rough, dark cape."
	icon = 'modular_citadel/icons/obj/clothing/cape.dmi'
	icon_override = 'modular_citadel/icons/mob/cape.dmi'
	icon_state = "cape"
	body_parts_covered = 0
	flags_inv = 0
	w_class = ITEMSIZE_NORMAL
	var/frontcover = 0 // Alas, doesn't cover your items in hands and still show backpack straps.
	var/capehood = 0 // Can't make it work with proper hoodies with var above - sprites getting broken.


/obj/item/clothing/suit/cape/verb/adjust_cape()
	set name = "Adjust Cape"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return
	if(frontcover == 0)
		frontcover = 1
		flags_inv = HIDEJUMPSUIT|HIDEGLOVES|HIDETIE|HIDEHOLSTER|HIDESUITSTORAGE
		body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS
		usr << "<span class='notice'>You adjust [src]'s fabric to front.</span>"
	else
		frontcover = 0
		flags_inv = 0
		body_parts_covered = 0
		usr << "<span class='notice'>You move [src]'s fabric away.</span>"
	update_icon()

/obj/item/clothing/suit/cape/verb/adjust_hood()
	set name = "Toggle Hood"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)||usr.stat)
		return
	if(capehood == 0)
		capehood = 1
		flags_inv = BLOCKHEADHAIR
		body_parts_covered = HEAD
		usr << "<span class='notice'>You slide [src]'s hood on.</span>"
	else
		capehood = 0
		flags_inv = 0
		body_parts_covered = 0
		usr << "<span class='notice'>You slide [src]'s hood off.</span>"
	update_icon()

/obj/item/clothing/suit/cape/update_icon()
	icon_state = initial(icon_state)
	if(frontcover)
		icon_state += "f"
	if(capehood)
		icon_state += "h"
	update_clothing_icon()
