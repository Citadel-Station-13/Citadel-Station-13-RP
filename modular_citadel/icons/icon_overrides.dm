// Contains all the icon overrides for the icon overhaul project

//code/game/machinery/kitchen/microwave.dm
/obj/machinery/microwave
	icon = 'modular_citadel/icons/obj/kitchen.dmi'

//code/game/machinery/newscaster.dm
/obj/item/newspaper
	icon = 'modular_citadel/icons/obj/bureaucracy.dmi'

/obj/item/storage/box/pillbottles
	icon_state = "pillbox"

//code/game/objects/structures/crates_lockers/closets.dm
/obj/structure/closet
	icon = 'modular_citadel/icons/obj/closet.dmi'

//code/game/objects/structures/crates_lockers/closets/secure/secure_closets.dm
/obj/structure/closet/secure_closet
	icon = 'modular_citadel/icons/obj/closet.dmi'

//code/game/objects/structures/crates_lockers/crates.dm
/obj/structure/closet/crate
	icon = 'icons/obj/storage.dmi'

//code/game/objects/structures/tank_dispenser.dm
/obj/structure/dispenser
	icon = 'icons/obj/objects.dmi'

//code/game/objects/structures/under_wardrobe.dm
/obj/structure/undies_wardrobe
	icon = 'modular_citadel/icons/obj/closet.dmi'

//code/modules/library/lib_machines.dm
/obj/machinery/libraryscanner
	icon = 'modular_citadel/icons/obj/library.dmi'

/obj/machinery/bookbinder
	icon = 'modular_citadel/icons/obj/library.dmi'

//code/modules/paperwork/filingcabinet.dm
/obj/structure/filingcabinet
	icon = 'modular_citadel/icons/obj/bureaucracy.dmi'

//code/modules/paperwork/paperbin.dm
/obj/item/paper_bin
	icon = 'modular_citadel/icons/obj/bureaucracy.dmi'

//code/modules/paperwork/pen.dm
/obj/item/pen
	icon = 'modular_citadel/icons/obj/bureaucracy.dmi'

//code/modules/paperwork/photocopier.dm
/obj/machinery/photocopier
	icon = 'modular_citadel/icons/obj/library.dmi'

//code/modules/paperwork/stamps.dm
/obj/item/stamp
	icon = 'modular_citadel/icons/obj/bureaucracy.dmi'

//code/modules/reagents/dispenser/dispenser2.dm
/obj/machinery/chemical_dispenser
	icon = 'modular_citadel/icons/obj/chemical.dmi'

//code/modules/reagents/dispenser/dispenser_presets.dm
/obj/machinery/chemical_dispenser/bar_soft
	icon = 'modular_citadel/icons/obj/chemical.dmi'

/obj/machinery/chemical_dispenser/bar_alc
	icon = 'modular_citadel/icons/obj/chemical.dmi'

/obj/machinery/chemical_dispenser/bar_coffee
	icon = 'icons/obj/chemical.dmi'

//code/modules/paperwork/faxmachine.dm
/obj/machinery/photocopier/faxmachine
	icon = 'modular_citadel/icons/obj/library.dmi'

//code/game/machinery/vending.dm
/obj/machinery/vending
	icon = 'modular_citadel/icons/obj/vending.dmi'

/* This section lists all the vending machines that will inherit from the above without specific overrides
/obj/machinery/vending/coffee
/obj/machinery/vending/snack
/obj/machinery/vending/cigarette
/obj/machinery/vending/cola
/obj/machinery/vending/dinnerware
/obj/machinery/vending/tool
/obj/machinery/vending/engivend
/obj/machinery/vending/security
/obj/machinery/vending/fitness
*/

// We need to do this because the vendomat is the template vending machine but IS used and spawned
/obj/machinery/vending/boozeomat
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/cart
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/medical
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/phoronresearch
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/wallmed1
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/wallmed2
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/hydronutrients
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/hydroseeds
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/magivend
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/sovietsoda
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/robotics
	icon = 'icons/obj/vending_vr.dmi'

/obj/machinery/vending/giftvendor
	icon = 'icons/obj/vending_vr.dmi'

//maps/tether/tether_things.dm
/obj/machinery/vending/wallmed_airlock
	icon = 'icons/obj/vending_vr.dmi'

//Fixes missing RSF icon.
//code/game/objects/items/weapons/RSF.dm
/obj/item/rsf
	icon = 'icons/obj/tools.dmi'

//code/modules/economy/atm.dm
/obj/machinery/atm
	icon = 'modular_citadel/icons/obj/terminals.dmi'

//code/game/objects/items/weapons/storage/briefcase.dm
/obj/item/storage/briefcase
	item_icons = list(
		slot_l_hand_str = 'modular_citadel/icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'modular_citadel/icons/mob/items/righthand_storage.dmi',
		)

/obj/item/storage/briefcase/clutch
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
		)

/obj/item/storage/briefcase/inflatable
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
		)

//code/game/objects/items/weapons/storage/secure.dm
/obj/item/storage/secure/briefcase
	item_icons = list(
		slot_l_hand_str = 'modular_citadel/icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'modular_citadel/icons/mob/items/righthand_storage.dmi',
		)