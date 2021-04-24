/obj/item/pda
	var/delete_id = FALSE			//Guaranteed deletion of ID upon deletion of PDA

/obj/item/pda/multicaster/exploration/New()
	..()
	owner = "Exploration Department"
	name = "Exploration Department (Relay)"
	cartridges_to_send_to = exploration_cartridges

/obj/item/pda/centcom
	default_cartridge = /obj/item/cartridge/captain
	icon_state = "pda-h"
	detonate = 0
//	hidden = 1

/obj/item/pda/pathfinder
	default_cartridge = /obj/item/cartridge/explorer
	icon_state = "pda-lawyer-old"

/obj/item/pda/explorer
	default_cartridge = /obj/item/cartridge/explorer
	icon_state = "pda-det"

/obj/item/pda/sar
	default_cartridge = /obj/item/cartridge/sar
	icon_state = "pda-h"
