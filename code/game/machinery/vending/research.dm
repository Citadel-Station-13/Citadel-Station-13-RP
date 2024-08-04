
/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(
		/obj/item/clothing/under/rank/scientist = 6,
		/obj/item/clothing/suit/bio_suit = 6,
		/obj/item/clothing/head/bio_hood = 6,
		/obj/item/transfer_valve = 6,
		/obj/item/assembly/timer = 6,
		/obj/item/assembly/signaler = 6,
		/obj/item/assembly/prox_sensor = 6,
		/obj/item/assembly/igniter = 6,
	)
	req_log_access = ACCESS_SCIENCE_RD
	has_logs = 1

/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access = list(ACCESS_SCIENCE_ROBOTICS)
	products = list(
		/obj/item/clothing/suit/storage/toggle/labcoat = 4,
		/obj/item/clothing/under/rank/roboticist = 4,
		/obj/item/stack/cable_coil = 4,
		/obj/item/flash = 4,
		/obj/item/cell/high = 12,
		/obj/item/assembly/prox_sensor = 3,
		/obj/item/assembly/signaler = 3,
		/obj/item/healthanalyzer = 3,
		/obj/item/surgical/scalpel = 2,
		/obj/item/surgical/circular_saw = 2,
		/obj/item/tank/anesthetic = 2,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/tool/screwdriver = 5,
		/obj/item/tool/crowbar = 5,
	)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	req_log_access = ACCESS_SCIENCE_RD
	has_logs = 1
