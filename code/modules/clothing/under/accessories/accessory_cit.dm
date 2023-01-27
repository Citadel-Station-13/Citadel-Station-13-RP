//
// Allows collars to be renamed with pen.
//

/obj/item/clothing/accessory/collar/attackby(obj/item/P as obj, mob/user as mob)
	. = ..()
	if(istype(P, /obj/item/pen))
		to_chat(user,SPAN_NOTICE("You write on [name]'s tag."))
		var/str = copytext(reject_bad_text(input(user,"Tag text?","Set tag","")),1,MAX_NAME_LEN)

		if(!str || !length(str))
			to_chat(user,SPAN_NOTICE("[name]'s tag set to be blank."))
			name = initial(name)
			desc = initial(desc)
		else
			to_chat(user,SPAN_NOTICE("You set the [name]'s tag to '[str]'."))
			name = initial(name) + " ([str])"
			desc = initial(desc) + " The tag says \"[str]\"."
	return
