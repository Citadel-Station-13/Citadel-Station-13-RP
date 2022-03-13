/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/Initialize(mapload)
	. = ..()
	new /obj/item/book/manual/excavation(src)
	new /obj/item/book/manual/mass_spectrometry(src)
	new /obj/item/book/manual/materials_chemistry_analysis(src)
	new /obj/item/book/manual/anomaly_testing(src)
	new /obj/item/book/manual/anomaly_spectroscopy(src)
	new /obj/item/book/manual/stasis(src)
	update_icon()

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	icon_state = "secureres1"
	icon_closed = "secureres"
	icon_locked = "secureres1"
	icon_opened = "secureresopen"
	icon_broken = "secureresbroken"
	icon_off = "secureresoff"
	req_access = list(access_tox_storage)

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/melee/umbrella,
		/obj/item/clothing/glasses/science,
		/obj/item/radio/headset/headset_sci,
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation)

/obj/structure/closet/excavation
	name = "Excavation tools"
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

	starts_with = list(
		/obj/item/storage/belt/archaeology,
		/obj/item/storage/excavation,
		/obj/item/flashlight/lantern,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/beacon_locator,
		/obj/item/radio/beacon,
		/obj/item/clothing/glasses/meson,
		/obj/item/pickaxe,
		/obj/item/measuring_tape,
		/obj/item/pickaxe/hand,
		/obj/item/storage/bag/fossils,
		/obj/item/camera_film,
		/obj/item/camera_film,
		/obj/item/camera_film,
		/obj/item/camera,
		/obj/item/storage/box/evidence,
		/obj/item/storage/box/evidence,
		/obj/item/storage/secure/briefcase,
		/obj/item/paper_bin,
		/obj/item/hand_labeler)

/obj/machinery/alarm/isolation
	req_one_access = list(access_research, access_atmospherics, access_engine_equip)

/obj/machinery/alarm/monitor/isolation
	req_one_access = list(access_research, access_atmospherics, access_engine_equip)
