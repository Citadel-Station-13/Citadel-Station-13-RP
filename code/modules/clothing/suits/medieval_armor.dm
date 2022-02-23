//Helmets
/obj/item/clothing/head/helmet/medieval
	name = "medieval helmet"
	desc = "A classic metal helmet, effective at stopping melee attacks."
	icon = 'modular_citadel/icons/obj/clothing/medieval_helmet.dmi'
	icon_override = 'modular_citadel/icons/mob/medieval_helmet.dmi'
	icon_state = "knight"
	item_state = "knight"
	armor = list(melee = 40, bullet = 5, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 0)
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

/obj/item/clothing/head/helmet/medieval/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/head/helmet/medieval/green
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/head/helmet/medieval/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/head/helmet/medieval/orange
	icon_state = "knight_orange"
	item_state = "knight_orange"

//Armours
/obj/item/clothing/suit/armor/medieval
	name = "plate armour"
	desc = "A classic suit of plate armour, effective at stopping melee attacks."
	armor = list(melee = 50, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	icon = 'modular_citadel/icons/obj/clothing/medieval_armor.dmi'
	icon_override = 'modular_citadel/icons/mob/medieval_armor.dmi'
	icon_state = "knight"
	item_state = "knight"
	slowdown = 1
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/armor/medieval/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/suit/armor/medieval/green
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/suit/armor/medieval/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/suit/armor/medieval/orange
	icon_state = "knight_orange"
	item_state = "knight_orange"

//Crusader stuff
//Helmets
/obj/item/clothing/head/helmet/medieval/crusader
	name = "great helm"
	desc = "A classic metal great helm, effective at stopping melee attacks."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/head/helmet/medieval/crusader/templar
	name = "templar great helm"
	desc = "Deus Vult!"
	icon_state = "crusader_templar"
	item_state = "crusader_templar"

/obj/item/clothing/head/helmet/medieval/crusader/horned
	name = "horned great helm"
	desc = "Helfen, Wehren, Heilen!"
	icon_state = "crusader_horned"
	item_state = "crusader_horned"

/obj/item/clothing/head/helmet/medieval/crusader/winged
	name = "winged great helm"
	desc = "Helfen, Wehren, Heilen!"
	icon_state = "crusader_winged"
	item_state = "crusader_winged"

//Armours
/obj/item/clothing/suit/armor/medieval/crusader
	name = "bland crusader armour"
	desc = "A classic suit of plate armour, usually worn by crusaders. It doesn't have any insignia."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/suit/armor/medieval/crusader/cross
	name = "crusader armour"
	desc = "God wills it!"
	icon_state = "crusader_cross"
	item_state = "crusader_cross"

/obj/item/clothing/suit/armor/medieval/crusader/cross/teutonic
	icon_state = "crusader_teutonic"
	item_state = "crusader_teutonic"

/obj/item/clothing/suit/armor/medieval/crusader/cross/templar
	name = "templar crusader armour"
	icon_state = "crusader_templar"
	item_state = "crusader_templar"

/obj/item/clothing/suit/armor/medieval/crusader/cross/hospitaller
	name = "hospitaller crusader armour"
	icon_state = "crusader_hospitaller"
	item_state = "crusader_hospitaller"

/obj/item/clothing/suit/armor/medieval/crusader/dark
	name = "dark crusader armour"
	desc = "A classic suit of plate armour, usually worn by crusaders. This one is dark, with no insignia."
	icon_state = "crusader_dark"
	item_state = "crusader_dark"

//Replica stuff
//Helmets
/obj/item/clothing/head/medievalfake
	name = "medieval helmet replica"
	desc = "A plastic replica of knight helmet. Great for tabletop and LARP sessions, not great at stopping melee attacks."
	icon = 'modular_citadel/icons/obj/clothing/medieval_helmet.dmi'
	icon_override = 'modular_citadel/icons/mob/medieval_helmet.dmi'
	icon_state = "knight"
	item_state = "knight"
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR

/obj/item/clothing/head/medievalfake/green
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/head/medievalfake/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/head/medievalfake/orange
	icon_state = "knight_orange"
	item_state = "knight_orange"

/obj/item/clothing/head/medievalfake/red
	icon_state = "knight_red"
	item_state = "knight_red"

//Armours
/obj/item/clothing/suit/medievalfake
	name = "plate armour replica"
	desc = "A plastic replica of knight armor. Great for tabletop and LARP sessions, not great at stopping melee attacks."
	icon = 'modular_citadel/icons/obj/clothing/medieval_armor.dmi'
	icon_override = 'modular_citadel/icons/mob/medieval_armor.dmi'
	icon_state = "knight"
	item_state = "knight"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET

/obj/item/clothing/suit/medievalfake/green
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/suit/medievalfake/orange
	icon_state = "knight_orange"
	item_state = "knight_orange"

/obj/item/clothing/suit/medievalfake/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/suit/medievalfake/red
	icon_state = "knight_red"
	item_state = "knight_red"

//Crusader stuff
//Helmets
/obj/item/clothing/head/medievalfake/crusader
	name = "great helm replica"
	desc = "A plastic replica of classic great helm. Alas, divine protection is not included and you would be safer with an actual bucket."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/head/medievalfake/crusader/templar
	name = "templar great helm replica"
	desc = "Situla Vult!"
	icon_state = "crusader_templar"
	item_state = "crusader_templar"

/obj/item/clothing/head/medievalfake/crusader/horned
	name = "horned great helm replica"
	desc = "A plastic replica of classic great helm. This one have horns attached (and may or may not be endrosed by crew with horns)."
	icon_state = "crusader_horned"
	item_state = "crusader_horned"

/obj/item/clothing/head/medievalfake/crusader/winged
	name = "winged great helm replica"
	desc = "A plastic replica of classic great helm. This one have winged horns attached (and may or may not be endrosed by crew with horns, <i>and</i> wings)."
	icon_state = "crusader_winged"
	item_state = "crusader_winged"

//Armours
/obj/item/clothing/suit/medievalfake/crusader
	name = "bland crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. It doesn't have any insignia."
	icon_state = "crusader"
	item_state = "crusader"

/obj/item/clothing/suit/medievalfake/crusader/cross
	name = "crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. Alas, divine protection is not included."
	icon_state = "crusader_cross"
	item_state = "crusader_cross"

/obj/item/clothing/suit/medievalfake/crusader/cross/teutonic
	icon_state = "crusader_teutonic"
	item_state = "crusader_teutonic"

/obj/item/clothing/suit/medievalfake/crusader/cross/templar
	name = "templar crusader armour replica"
	icon_state = "crusader_templar"
	item_state = "crusader_templar"

/obj/item/clothing/suit/medievalfake/crusader/cross/hospitaller
	name = "hospitaller crusader armour replica"
	icon_state = "crusader_hospitaller"
	item_state = "crusader_hospitaller"

/obj/item/clothing/suit/medievalfake/crusader/dark
	name = "dark crusader armour replica"
	desc = "A plastic replica of knight armor with crusader feeling to it. This one is painted dark."
	icon_state = "crusader_dark"
	item_state = "crusader_dark"
