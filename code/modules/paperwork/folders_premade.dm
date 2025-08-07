/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"
	bg_color = "#355e9f"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"
	bg_color = "#b5002e"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"
	bg_color = "#b88f3d"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"
	bg_color = "#d9d9d9"

/obj/item/folder/blue_captain
	desc = "A blue folder with Facility Director markings."
	icon_state = "folder_captain"
	bg_color = "#355e9f"

/obj/item/folder/blue_hop
	desc = "A blue folder with HoP markings."
	icon_state = "folder_hop"
	bg_color = "#355e9f"

/obj/item/folder/white_cmo
	desc = "A white folder with CMO markings."
	icon_state = "folder_cmo"
	bg_color = "#d9d9d9"

/obj/item/folder/white_rd
	desc = "A white folder with RD markings."
	icon_state = "folder_rd"
	bg_color = "#d9d9d9"

/obj/item/folder/white_rd/Initialize(mapload)
	. = ..()
	//add some memos
	var/obj/item/paper/P = new(src)
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason"
	update_icon()

/obj/item/folder/yellow_ce
	desc = "A yellow folder with CE markings."
	icon_state = "folder_ce"
	bg_color = "#b88f3d"

/obj/item/folder/red_hos
	desc = "A red folder with HoS markings."
	icon_state = "folder_hos"
	bg_color = "#b5002e"
