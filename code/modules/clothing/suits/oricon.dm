//OriCon Uniform Suits

//Service

/obj/item/clothing/suit/storage/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	flags_inv = HIDEHOLSTER
	allowed = list(/obj/item/tank/emergency/oxygen,/obj/item/flashlight,/obj/item/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/storage/fancy/cigarettes,/obj/item/flame/lighter,/obj/item/tape_recorder,/obj/item/analyzer,/obj/item/radio,/obj/item/barrier_tape_roll)

/obj/item/clothing/suit/storage/service/sysguard
	name = "\improper SysGuard jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has silver buttons."
	icon_state = "blackservice_crew"

/obj/item/clothing/suit/storage/service/sysguard/medical
	name = "\improper SysGuard medical jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has silver buttons and blue trim."
	icon_state = "blackservice_med"

/obj/item/clothing/suit/storage/service/sysguard/medical/command
	name = "\improper SysGuard medical command jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has gold buttons and blue trim."
	icon_state = "blackservice_medcom"

/obj/item/clothing/suit/storage/service/sysguard/engineering
	name = "\improper SysGuard engineering jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has silver buttons and orange trim."
	icon_state = "blackservice_eng"

/obj/item/clothing/suit/storage/service/sysguard/engineering/command
	name = "\improper SysGuard engineering command jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has gold buttons and orange trim."
	icon_state = "blackservice_engcom"

/obj/item/clothing/suit/storage/service/sysguard/supply
	name = "\improper SysGuard supply jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has silver buttons and brown trim."
	icon_state = "blackservice_sup"

/obj/item/clothing/suit/storage/service/sysguard/security
	name = "\improper SysGuard security jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has silver buttons and red trim."
	icon_state = "blackservice_sec"

/obj/item/clothing/suit/storage/service/sysguard/security/command
	name = "\improper SysGuard security command jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has gold buttons and red trim."
	icon_state = "blackservice_seccom"

/obj/item/clothing/suit/storage/service/sysguard/command
	name = "\improper SysGuard command jacket"
	desc = "A uniform service jacket belonging to the System Defense Force. It has gold buttons and gold trim."
	icon_state = "blackservice_com"

/obj/item/clothing/suit/storage/service/marine
	name = "marine coat"
	desc = "An OCG Marine Corps service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state_slots = list(slot_r_hand_str = "suit_olive", slot_l_hand_str = "suit_olive")

/obj/item/clothing/suit/storage/service/marine/medical
	name = "marine medical jacket"
	desc = "An OCG Marine Corps service coat. This one has blue markings."
	icon_state = "greenservice_med"

/obj/item/clothing/suit/storage/service/marine/medical/command
	name = "marine medical command jacket"
	desc = "An OCG Marine Corps service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/service/marine/engineering
	name = "marine engineering jacket"
	desc = "An OCG Marine Corps service coat. This one has orange markings."
	icon_state = "greenservice_eng"

/obj/item/clothing/suit/storage/service/marine/engineering/command
	name = "marine engineering command jacket"
	desc = "An OCG Marine Corps service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/service/marine/supply
	name = "marine supply jacket"
	desc = "An OCG Marine Corps service coat. This one has brown markings."
	icon_state = "greenservice_sup"

/obj/item/clothing/suit/storage/service/marine/security
	name = "marine security jacket"
	desc = "An OCG Marine Corps service coat. This one has red markings."
	icon_state = "greenservice_sec"

/obj/item/clothing/suit/storage/service/marine/security/command
	name = "marine security command jacket"
	desc = "An OCG Marine Corps service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/service/marine/command
	name = "marine command jacket"
	desc = "An OCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"

//Dress

/obj/item/clothing/suit/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "greydress"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/tank/emergency/oxygen,/obj/item/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/radio,/obj/item/pen)

/obj/item/clothing/suit/dress/expedition
	name = "SysGuard dress jacket"
	desc = "A silver and grey dress jacket belonging to the System Defense Force. Fashionable, for the 25th century at least."
	icon_state = "greydress"

/obj/item/clothing/suit/dress/expedition/command
	name = "SysGuard command dress jacket"
	desc = "A gold and grey dress jacket belonging to the System Defense Force. The height of fashion."
	icon_state = "greydress_com"

/obj/item/clothing/suit/storage/toggle/dress
	name = "clasped dress jacket"
	desc = "A uniform dress jacket with gold toggles."
	icon_state = "whitedress"
	item_state = "labcoat"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/toggle/dress/fleet
	name = "fleet dress jacket"
	desc = "A crisp white OCG Fleet dress jacket with blue and gold accents. Don't get near pasta sauce or vox."

/obj/item/clothing/suit/storage/toggle/dress/fleet/command
	name = "fleet command dress jacket"
	desc = "A crisp white OCG Fleet dress jacket dripping with gold accents. So bright it's blinding."
	icon_state = "whitedress_com"
	item_state = "labcoat"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/dress/marine
	name = "marine dress jacket"
	desc = "A tailored black OCG Marine Corps dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")

/obj/item/clothing/suit/dress/marine/command
	name = "marine command dress jacket"
	desc = "A tailored black OCG Marine Corps dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
//Misc

/obj/item/clothing/suit/storage/toggle/marshal_jacket
	name = "colonial marshal jacket"
	desc = "A black synthleather jacket. The word 'MARSHAL' is stenciled onto the back in gold lettering."
	icon_state = "marshal_jacket"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	body_parts_covered = UPPER_TORSO|ARMS

//OriCon Uniform Suits

//Service
/obj/item/clothing/suit/storage/service/sysguard
	name = "explorer's jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has silver buttons."

/obj/item/clothing/suit/storage/service/sysguard/medical
	name = "explorer's medical jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has silver buttons and blue trim."

/obj/item/clothing/suit/storage/service/sysguard/medical/command
	name = "explorer's medical command jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has gold buttons and blue trim."

/obj/item/clothing/suit/storage/service/sysguard/engineering
	name = "explorer's engineering jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has silver buttons and orange trim."

/obj/item/clothing/suit/storage/service/sysguard/engineering/command
	name = "explorer's engineering command jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has gold buttons and orange trim."

/obj/item/clothing/suit/storage/service/sysguard/supply
	name = "explorer's supply jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has silver buttons and brown trim."

/obj/item/clothing/suit/storage/service/sysguard/security
	name = "explorer's security jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has silver buttons and red trim."

/obj/item/clothing/suit/storage/service/sysguard/security/command
	name = "explorer's security command jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has gold buttons and red trim."

/obj/item/clothing/suit/storage/service/sysguard/command
	name = "explorer's command jacket"
	desc = "A uniform service jacket belonging to the Society of Universal Cartographers. It has gold buttons and gold trim."

/obj/item/clothing/suit/storage/service/marine
	name = "marine coat"
	desc = "A JSDF Marine Corps service coat. Green and undecorated."

/obj/item/clothing/suit/storage/service/marine/medical
	name = "marine medical jacket"
	desc = "A JSDF Marine Corps service coat. This one has blue markings."

/obj/item/clothing/suit/storage/service/marine/medical/command
	name = "marine medical command jacket"
	desc = "A JSDF Marine Corps service coat. This one has blue and gold markings."

/obj/item/clothing/suit/storage/service/marine/engineering
	name = "marine engineering jacket"
	desc = "A JSDF Marine Corps service coat. This one has orange markings."

/obj/item/clothing/suit/storage/service/marine/engineering/command
	name = "marine engineering command jacket"
	desc = "A JSDF Marine Corps service coat. This one has orange and gold markings."

/obj/item/clothing/suit/storage/service/marine/supply
	name = "marine supply jacket"
	desc = "A JSDF Marine Corps service coat. This one has brown markings."

/obj/item/clothing/suit/storage/service/marine/security
	name = "marine security jacket"
	desc = "A JSDF Marine Corps service coat. This one has red markings."

/obj/item/clothing/suit/storage/service/marine/security/command
	name = "marine security command jacket"
	desc = "A JSDF Marine Corps service coat. This one has red and gold markings."

/obj/item/clothing/suit/storage/service/marine/command
	name = "marine command jacket"
	desc = "A JSDF Marine Corps service coat. This one has gold markings."

//Dress

/obj/item/clothing/suit/dress/expedition
	name = "explorer's dress jacket"
	desc = "A silver and grey dress jacket belonging to the Society of Universal Cartographers. Fashionable, for the 25th century at least."

/obj/item/clothing/suit/dress/expedition/command
	name = "explorer's command dress jacket"
	desc = "A gold and grey dress jacket belonging to the Society of Universal Cartographers. The height of fashion."

/obj/item/clothing/suit/storage/toggle/dress/fleet
	name = "fleet dress jacket"
	desc = "A crisp white JSDF Fleet dress jacket with blue and gold accents. Don't get near pasta sauce or vox."

/obj/item/clothing/suit/storage/toggle/dress/fleet/command
	name = "fleet command dress jacket"
	desc = "A crisp white JSDF Fleet dress jacket dripping with gold accents. So bright it's blinding."

/obj/item/clothing/suit/dress/marine
	name = "marine dress jacket"
	desc = "A tailored black JSDF Marine Corps dress jacket with red trim. So sexy it hurts."

/obj/item/clothing/suit/dress/marine/command
	name = "marine command dress jacket"
	desc = "A tailored black JSDF Marine Corps dress jacket with gold trim. Smells like ceremony."

/obj/item/clothing/suit/dress/marine/command/hos
	name = "head of security's dress jacket"
	desc = "A sleek, buttoned coat with gold trim. The fabric feels sturdy, could come in handy"
	icon_state = "blackdress_com"
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/dress/expedition/command/cd
	name = "Facility Director's dress jacket"
	desc = "A grey dress jacket, adorned with gold trim and buttons. Makes those wearing it look powerful."
	icon_state = "greydress_com"
