/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple silver bracelet with a clasp."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bracelet"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/bracelet/friendship
	name = "friendship bracelet"
	desc = "A beautiful friendship bracelet in all the colors of the rainbow."
	icon_state = "friendbracelet"

/obj/item/clothing/accessory/bracelet/friendship/verb/dedicate_bracelet()
	set name = "Dedicate Bracelet"
	set category = VERB_CATEGORY_OBJECT
	set desc = "Dedicate your friendship bracelet to a special someone."
	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("Who do you want to dedicate the bracelet to?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		desc = "A beautiful friendship bracelet in all the colors of the rainbow. It's dedicated to [input]."
		to_chat(M, "You dedicate the bracelet to [input], remembering the times you've had together.")
		return 1
