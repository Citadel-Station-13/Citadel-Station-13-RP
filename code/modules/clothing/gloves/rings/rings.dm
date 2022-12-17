/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"
	item_state = "diamond_s"

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src].</span>","<span class='warning'>You get down on one knee, presenting \the [src].</span>")

/obj/item/clothing/gloves/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon_state = "cti-grad"

/obj/item/clothing/gloves/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon_state = "mariner-grad"

/obj/item/clothing/gloves/ring/custom
	name = "ring"
	desc = "Alt-click to name and add a description."
	icon_state = "material"
	var/described = FALSE
	var/named = FALSE
	var/coloured = FALSE

/obj/item/clothing/gloves/ring/custom/AltClick(mob/user)
	if(!named)
		var/inputname = sanitizeSafe(input("Enter a prefix for the ring's name.", ,""), MAX_NAME_LEN)
		if(src && inputname && in_range(user,src))
			name = "[inputname] ring"
			to_chat(user, "You describe the [name].")
			named = TRUE
	if(!described)
		var/inputdesc = sanitizeSafe(input("Enter the new description for the ring. 2048 character limit.", ,""), 2048) // 2048 character limit
		if(src && inputdesc && in_range(user,src))
			desc = "[inputdesc]"
			to_chat(user, "You describe the [name].")
			described = TRUE
	if(!coloured)
		var/colour_input = input(usr,"","Choose Color",color) as color|null
		if(colour_input)
			color = sanitize_hexcolor(colour_input)
			coloured = TRUE
/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/gloves/ring/reagent
	atom_flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 4)

/obj/item/clothing/gloves/ring/reagent/Initialize(mapload)
	. = ..()
	create_reagents(15)

/obj/item/clothing/gloves/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)

		if(reagents.total_volume)
			to_chat(H, "<span class='danger'>You feel a prick as you slip on \the [src].</span>")
			if(H.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_BLOOD)
				add_attack_logs(usr, H, "Injected with [name] containing [contained] transferred [trans] units")
	return

//Sleepy Ring
/obj/item/clothing/gloves/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	icon_state = "material"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/clothing/gloves/ring/reagent/sleepy/Initialize(mapload)
	. = ..()
	reagents.add_reagent("chloralhydrate", 15) // Less than a sleepy-pen, but still enough to knock someone out

/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/gloves/ring/seal/secgen
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon_state = "seal-secgen"

/obj/item/clothing/gloves/ring/seal/mason
	name = "\improper Masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon_state = "seal-masonic"

/obj/item/clothing/gloves/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon_state = "seal-signet"
	var/nameset = FALSE

/obj/item/clothing/gloves/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>The [src] has already been claimed!</span>")
		return

	to_chat(user, "<span class='notice'>You claim the [src] as your own!</span>")
	change_name(user)
	nameset = TRUE

/obj/item/clothing/gloves/ring/seal/signet/proc/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s signet ring"
	desc = "A signet ring belonging to [signet_name], for when you're too sophisticated to sign letters."


/obj/item/clothing/gloves/ring/wedding
	name = "golden wedding ring"
	desc = "For showing your devotion to another person. It has a golden glimmer to it."
	icon_state = "wedring_g"
	item_state = "wedring_g"
	var/partnername = ""

/obj/item/clothing/gloves/ring/wedding/attack_self(mob/user)
	partnername = copytext(sanitize(input(user, "Would you like to change the holoengraving on the ring?", "Name your spouse", "Bae") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [partnername]"

/obj/item/clothing/gloves/ring/wedding/silver
	name = "silver wedding ring"
	desc = "For showing your devotion to another person. It has a silver glimmer to it."
	icon_state = "wedring_s"
	item_state = "wedring_s"
