//Helmets
/obj/item/clothing/head/helmet/medieval
	name = "medieval helmet"
	desc = "A classic metal helmet, effective at stopping melee attacks."
	icon = 'icons/clothing/suit/armor/medieval/knight.dmi'
	icon_state = "knighthelm"
	armor = list(melee = 40, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	body_cover_flags = HEAD|FACE|EYES
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/helmet/medieval/red
	icon_state = "knighthelm_red"

/obj/item/clothing/head/helmet/medieval/green
	icon_state = "knighthelm_green"

/obj/item/clothing/head/helmet/medieval/blue
	icon_state = "knighthelm_blue"

/obj/item/clothing/head/helmet/medieval/orange
	icon_state = "knighthelm_orange"

/obj/item/clothing/head/helmet/medieval/alt
	icon_state = "knighthelm_alt"

/obj/item/clothing/head/helmet/medieval/paladin
	name = "elite paladin helm"
	desc = "This tarnished helmet has clearly done its job well for many years of service."
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladinhelm"
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/helmet/medieval/paladin/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]1"
		to_chat(user, "You raise the helmet's visor.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the helmet's visor.")
	update_worn_icon()	//so our mob-overlays update"

//Armours
/obj/item/clothing/suit/armor/medieval
	name = "plate armour"
	desc = "A classic suit of plate armour, effective at stopping melee attacks."
	armor = list(melee = 50, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/clothing/suit/armor/medieval/knight.dmi'
	icon_state = "knight"
	slowdown = 1
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/armor/medieval/red
	icon_state = "knight_red"

/obj/item/clothing/suit/armor/medieval/green
	icon_state = "knight_green"

/obj/item/clothing/suit/armor/medieval/blue
	icon_state = "knight_blue"

/obj/item/clothing/suit/armor/medieval/orange
	icon_state = "knight_orange"

/obj/item/clothing/suit/armor/medieval/crimson
	icon_state = "knight_suit"

/obj/item/clothing/suit/armor/medieval/forest
	icon_state = "rhodok"

/obj/item/clothing/suit/armor/medieval/hauberk
	name = "hauberk"
	desc = "A chainmail hauberk worn beneath a dark leather jerkin. Although it grants less protection, it provides greater mobility."
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/clothing/suit/armor/medieval/bastard.dmi'
	icon_state = "bastard"
	slowdown = 0

/obj/item/clothing/suit/armor/medieval/paladin
	name = "elite paladin plate"
	desc = "This armor is worn from years of use. A fusion of chainmail and plate, it serves to provide supreme mobility without sacrificing much protection."
	armor = list(melee = 40, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladin"
	slowdown = 0

//Crusader stuff
//Helmets
/obj/item/clothing/head/helmet/medieval/crusader
	name = "great helm"
	desc = "A classic metal great helm, effective at stopping melee attacks."
	icon = 'icons/clothing/suit/armor/medieval/crusader.dmi'
	icon_state = "crusaderhelm"

/obj/item/clothing/head/helmet/medieval/crusader/templar
	name = "templar great helm"
	desc = "Deus Vult!"
	icon_state = "crusaderhelm_templar"

/obj/item/clothing/head/helmet/medieval/crusader/horned
	name = "horned great helm"
	desc = "Helfen, Wehren, Heilen!"
	icon_state = "crusaderhelm_horned"

/obj/item/clothing/head/helmet/medieval/crusader/winged
	name = "winged great helm"
	desc = "Helfen, Wehren, Heilen!"
	icon_state = "crusaderhelm_winged"

//Armours
/obj/item/clothing/suit/armor/medieval/crusader
	name = "bland crusader armour"
	desc = "A classic suit of plate armour, usually worn by crusaders. It doesn't have any insignia."
	icon = 'icons/clothing/suit/armor/medieval/crusader.dmi'
	icon_state = "crusader"

/obj/item/clothing/suit/armor/medieval/crusader/cross
	name = "crusader armour"
	desc = "God wills it!"
	icon_state = "crusader_cross"

/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic
	icon_state = "crusader_teutonic"

/obj/item/clothing/suit/armor/medieval/crusader/cross/templar
	name = "templar crusader armour"
	icon_state = "crusader_templar"

/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller
	name = "hospitaller crusader armour"
	icon_state = "crusader_hospitaller"

/obj/item/clothing/suit/armor/medieval/crusader/dark
	name = "dark crusader armour"
	desc = "A classic suit of plate armour, usually worn by crusaders. This one is dark, with no insignia."
	icon_state = "crusader_dark"

//Replica stuff
//Helmets
/obj/item/clothing/head/medievalfake
	name = "medieval helmet replica"
	desc = "A plastic replica of knight helmet. Great for tabletop and LARP sessions, not great at stopping melee attacks."
	icon = 'icons/clothing/suit/armor/medieval/knight.dmi'
	icon_state = "knighthelm"
	body_cover_flags = HEAD|FACE|EYES
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/head/medievalfake/green
	icon_state = "knighthelm_green"

/obj/item/clothing/head/medievalfake/blue
	icon_state = "knighthelm_blue"

/obj/item/clothing/head/medievalfake/orange
	icon_state = "knighthelm_orange"

/obj/item/clothing/head/medievalfake/red
	icon_state = "knighthelm_red"

/obj/item/clothing/head/medievalfake/alt
	icon_state = "knighthelm_alt"

/obj/item/clothing/head/medievalfake/paladin
	name = "elite paladin helm"
	desc = "This tarnished helmet has clearly done its job well for many years of service."
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladinhelm"
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/medievalfake/paladin/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]1"
		to_chat(user, "You raise the helmet's visor.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the helmet's visor.")
	update_worn_icon()	//so our mob-overlays update"

//Armours
/obj/item/clothing/suit/medievalfake
	name = "plate armour replica"
	desc = "A plastic replica of knight armor. Great for tabletop and LARP sessions, not great at stopping melee attacks."
	icon = 'icons/clothing/suit/armor/medieval/knight.dmi'
	icon_state = "knight"
	inv_hide_flags = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/suit/medievalfake/green
	icon_state = "knight_green"

/obj/item/clothing/suit/medievalfake/orange
	icon_state = "knight_orange"

/obj/item/clothing/suit/medievalfake/blue
	icon_state = "knight_blue"

/obj/item/clothing/suit/medievalfake/red
	icon_state = "knight_red"

/obj/item/clothing/suit/medievalfake/crimson
	icon_state = "knight_suit"

/obj/item/clothing/suit/medievalfake/forest
	icon_state = "rhodok"

/obj/item/clothing/suit/medievalfake/hauberk
	name = "hauberk"
	desc = "A chainmail hauberk worn beneath a dark leather jerkin. Although it grants less protection, it provides greater mobility."
	icon = 'icons/clothing/suit/armor/medieval/bastard.dmi'
	icon_state = "bastard"

/obj/item/clothing/suit/medievalfake/paladin
	name = "elite paladin plate"
	desc = "This armor is worn from years of use. A fusion of chainmail and plate, it serves to provide supreme mobility without sacrificing much protection."
	icon = 'icons/clothing/suit/armor/medieval/paladin.dmi'
	icon_state = "paladin"

//Crusader stuff
//Helmets
/obj/item/clothing/head/medievalfake/crusader
	name = "great helm replica"
	desc = "A plastic replica of classic great helm. Alas, divine protection is not included and you would be safer with an actual bucket."
	icon = 'icons/clothing/suit/armor/medieval/crusader.dmi'
	icon_state = "crusaderhelm"

/obj/item/clothing/head/medievalfake/crusader/templar
	name = "templar great helm replica"
	desc = "Situla Vult!"
	icon_state = "crusaderhelm_templar"

/obj/item/clothing/head/medievalfake/crusader/horned
	name = "horned great helm replica"
	desc = "A plastic replica of classic great helm. This one have horns attached (and may or may not be endrosed by crew with horns)."
	icon_state = "crusaderhelm_horned"

/obj/item/clothing/head/medievalfake/crusader/winged
	name = "winged great helm replica"
	desc = "A plastic replica of classic great helm. This one have winged horns attached (and may or may not be endrosed by crew with horns, <i>and</i> wings)."
	icon_state = "crusaderhelm_winged"

//Armours
/obj/item/clothing/suit/medievalfake/crusader
	name = "bland crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. It doesn't have any insignia."
	icon = 'icons/clothing/suit/armor/medieval/crusader.dmi'
	icon_state = "crusader"

/obj/item/clothing/suit/medievalfake/crusader/cross
	name = "crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. Alas, divine protection is not included."
	icon_state = "crusader_cross"

/obj/item/clothing/suit/medievalfake/crusader/cross/teutonic
	icon_state = "crusader_teutonic"

/obj/item/clothing/suit/medievalfake/crusader/cross/templar
	name = "templar crusader armour replica"
	icon_state = "crusader_templar"

/obj/item/clothing/suit/medievalfake/crusader/cross/hospitaller
	name = "hospitaller crusader armour replica"
	icon_state = "crusader_hospitaller"

/obj/item/clothing/suit/medievalfake/crusader/dark
	name = "dark crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. This one is painted dark."
	icon_state = "crusader_dark"
