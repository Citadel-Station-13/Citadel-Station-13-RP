/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet"
	slot_flags = SLOT_BACK
	plane = MOB_PLANE
	layer = BELOW_MOB_LAYER
	throw_force = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

/obj/item/bedsheet/attack_self(mob/user)
	if(!user.drop_item_to_ground(src))
		return
	if(layer == initial(layer))
		layer = ABOVE_MOB_LAYER
	else
		set_base_layer(initial(layer))
	add_fingerprint(user)

/obj/item/bedsheet/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up [src] with [I].</span>", "<span class='notice'>You begin cutting up [src] with [I].</span>")
		if(do_after(user, 50))
			to_chat(user, "<span class='notice'>You cut [src] into pieces!</span>")
			for(var/i in 1 to rand(5,10))
				new /obj/item/stack/material/cloth(drop_location())
			qdel(src)
		return
	..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetrainbow"

/obj/item/bedsheet/captain
	icon_state = "sheetcaptain"

/obj/item/bedsheet/rd
	icon_state = "sheetrd"

/obj/item/bedsheet/medical
	icon_state = "sheetmedical"

/obj/item/bedsheet/hos
	icon_state = "sheethos"

/obj/item/bedsheet/hop
	icon_state = "sheethop"

/obj/item/bedsheet/ce
	icon_state = "sheetce"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"

/obj/item/bedsheet/ian
	icon_state = "sheetian"

/obj/item/bedsheet/cosmos
	name = "cosmic space bedsheet"
	desc = "Made from the dreams of those who wonder at the stars."
	icon_state = "sheetcosmos"

/obj/item/bedsheet/double
	icon_state = "doublesheet"
	item_state = "sheet"

/obj/item/bedsheet/bluedouble
	icon_state = "doublesheetblue"
	item_state = "sheetblue"

/obj/item/bedsheet/greendouble
	icon_state = "doublesheetgreen"
	item_state = "sheetgreen"

/obj/item/bedsheet/orangedouble
	icon_state = "doublesheetorange"
	item_state = "sheetorange"

/obj/item/bedsheet/purpledouble
	icon_state = "doublesheetpurple"
	item_state = "sheetpurple"

/obj/item/bedsheet/rainbowdouble //all the way across the sky.
	icon_state = "doublesheetrainbow"
	item_state = "sheetrainbow"

/obj/item/bedsheet/reddouble
	icon_state = "doublesheetred"
	item_state = "sheetred"

/obj/item/bedsheet/yellowdouble
	icon_state = "doublesheetyellow"
	item_state = "sheetyellow"

/obj/item/bedsheet/mimedouble
	icon_state = "doublesheetmime"
	item_state = "sheetmime"

/obj/item/bedsheet/clowndouble
	icon_state = "doublesheetclown"
	item_state = "sheetrainbow"

/obj/item/bedsheet/captaindouble
	icon_state = "doublesheetcaptain"
	item_state = "sheetcaptain"

/obj/item/bedsheet/rddouble
	icon_state = "doublesheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/hosdouble
	icon_state = "doublesheethos"
	item_state = "sheethos"

/obj/item/bedsheet/hopdouble
	icon_state = "doublesheethop"
	item_state = "sheethop"

/obj/item/bedsheet/cedouble
	icon_state = "doublesheetce"
	item_state = "sheetce"

/obj/item/bedsheet/browndouble
	icon_state = "doublesheetbrown"
	item_state = "sheetbrown"

/obj/item/bedsheet/iandouble
	icon_state = "doublesheetian"
	item_state = "sheetian"

/obj/item/bedsheet/cosmosdouble
	icon_state = "doublesheetcosmos"

/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/initial_amount = 20
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine(mob/user)
	. = ..()

	if(amount < 1)
		. += "There are no bed sheets in the bin."
		return
	if(amount == 1)
		. += "There is one bed sheet in the bin."
		return
	. += "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon_state()
	. = ..()
	if(!amount)
		icon_state = "linenbin-empty"
	else if(amount < (initial_amount / 2))
		icon_state = "linenbin-half"
	else
		icon_state = "linenbin-full"

/obj/structure/bedsheetbin/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/bedsheet))
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		sheets.Add(I)
		amount++
		to_chat(user, "<span class='notice'>You put [I] in [src].</span>")
	else if(amount && !hidden && I.w_class < ITEMSIZE_LARGE)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		hidden = I
		to_chat(user, "<span class='notice'>You hide [I] among the sheets.</span>")

/obj/structure/bedsheetbin/attack_hand(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(user.drop_location())
		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You take [B] out of [src].</span>")

		if(hidden)
			hidden.forceMove(user.drop_location())
			to_chat(user, "<span class='notice'>[hidden] falls out of [B]!</span>")
			hidden = null
		update_icon()

	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user as mob)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.loc = loc
		to_chat(user, "<span class='notice'>You telekinetically remove [B] from [src].</span>")
		update_icon()

		if(hidden)
			hidden.loc = loc
			hidden = null


	add_fingerprint(user)
