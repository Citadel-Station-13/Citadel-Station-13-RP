// "Useful" items - I'm guessing things that might be used at work?
/datum/loadout_entry/utility
	name = "Briefcase"
	path = /obj/item/storage/briefcase
	sort_category = LOADOUT_CATEGORY_UTILITY

/datum/loadout_entry/utility/clipboard
	name = "Clipboard"
	path = /obj/item/clipboard

/datum/loadout_entry/utility/tts_device
	name = "Text To Speech Device"
	path = /obj/item/text_to_speech
	cost = 3 // Not extremely expensive, but it's useful for mute chracters.

/datum/loadout_entry/utility/communicator
	name = "Communicator Selection"
	path = /obj/item/communicator
	cost = 0

/datum/loadout_entry/utility/communicator/New()
	..()
	var/list/communicators = list()
	for(var/communicator in typesof(/obj/item/communicator) - list(/obj/item/communicator/integrated,/obj/item/communicator/commlink))
		var/obj/item/communicator_type = communicator
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/loadout_tweak/path(tim_sort(communicators, /proc/cmp_text_asc))

/datum/loadout_entry/utility/camera
	name = "Camera"
	path = /obj/item/camera

/datum/loadout_entry/utility/news
	name = "Daedalus Pocket Newscaster"
	path = /obj/item/book/codex/lore/news
	cost = 0

/datum/loadout_entry/utility/fbp_guide
	name = "A Buyer's Guide To Artificial Bodies"
	path = /obj/item/book/codex/lore/robutt
	cost = 0

/datum/loadout_entry/utility/folder_blue
	name = "Folder - Blue"
	path = /obj/item/folder/blue

/datum/loadout_entry/utility/folder_grey
	name = "Folder - Grey"
	path = /obj/item/folder

/datum/loadout_entry/utility/folder_red
	name = "Folder - Red"
	path = /obj/item/folder/red

/datum/loadout_entry/utility/folder_white
	name = "Folder - White"
	path = /obj/item/folder/white

/datum/loadout_entry/utility/folder_yellow
	name = "Folder - Yellow"
	path = /obj/item/folder/yellow

/datum/loadout_entry/utility/paicard
	name = "Personal AI Device"
	path = /obj/item/paicard

/datum/loadout_entry/utility/securecase
	name = "Secure, Portable Briefcase"
	path =/obj/item/storage/secure/briefcase/portable
	cost = 2

/datum/loadout_entry/utility/laserpointer
	name = "Laser Pointer"
	path =/obj/item/laser_pointer
	cost = 2

/datum/loadout_entry/utility/flashlight
	name = "Flashlight"
	path = /obj/item/flashlight

/datum/loadout_entry/utility/flashlight_blue
	name = "Flashlight - Blue"
	path = /obj/item/flashlight/color

/datum/loadout_entry/utility/flashlight_orange
	name = "Flashlight - Orange"
	path = /obj/item/flashlight/color/orange

/datum/loadout_entry/utility/flashlight_red
	name = "Flashlight - Red"
	path = /obj/item/flashlight/color/red

/datum/loadout_entry/utility/flashlight_yellow
	name = "Flashlight - Yellow"
	path = /obj/item/flashlight/color/yellow

/datum/loadout_entry/utility/maglight
	name = "Flashlight - Maglight"
	path = /obj/item/flashlight/maglight
	cost = 2

/datum/loadout_entry/utility/battery
	name = "Device Cell"
	path = /obj/item/cell/device

/datum/loadout_entry/utility/implant
	slot = "implant"
	exploitable = 0

/datum/loadout_entry/utility/implant/tracking
	name = "Implant - Tracking"
	slot = "implant"
	path = /obj/item/implant/tracking/weak
	cost = 0

/datum/loadout_entry/utility/implant/neural
	name = "Implant - Neural Assistance Web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/implant/neural
	cost = 0

/datum/loadout_entry/utility/implant/dud1
	name = "Implant - Head"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant/dud
	cost = 0

/datum/loadout_entry/utility/implant/dud2
	name = "Implant - Torso"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant/dud/torso
	cost = 0

/datum/loadout_entry/utility/implant/language
	cost = 2
	exploitable = 0

/datum/loadout_entry/utility/implant/language/eal
	name = "Vocal Synthesizer - EAL"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak EAL, if they know it."
	path = /obj/item/implant/language/eal

/datum/loadout_entry/utility/implant/language/skrellian
	name = "Vocal Synthesizer - Skrellian"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak Common Skrellian, if they know it."
	path = /obj/item/implant/language/skrellian

/datum/loadout_entry/utility/pen
	name = "Fountain Pen"
	path = /obj/item/pen/fountain

/datum/loadout_entry/utility/pen/click
	name = "Clicker Pen"
	path = /obj/item/pen/click
	cost = 3

/datum/loadout_entry/utility/wheelchair/color
	name = "Wheelchair"
	path = /obj/item/wheelchair
	cost = 4

/datum/loadout_entry/utility/wheelchair/color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/utility/umbrella
	name = "Umbrella"
	path = /obj/item/melee/umbrella
	cost = 3

/datum/loadout_entry/utility/umbrella/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/****************
modular computers
****************/

/datum/loadout_entry/utility/cheaptablet
	name = "Tablet Computer - Cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/loadout_entry/utility/normaltablet
	name = "Tablet Computer - Advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/loadout_entry/utility/customtablet
	name = "Tablet Computer - Custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/loadout_entry/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/loadout_tweak/tablet()

/datum/loadout_entry/utility/cheaplaptop
	name = "Laptop Computer - Cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 4

/datum/loadout_entry/utility/normallaptop
	name = "Laptop Computer - Advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 5

/datum/loadout_entry/utility/customlaptop
	name = "Laptop Computer - Custom"
	path = /obj/item/modular_computer/laptop/preset/
	cost = 6

/datum/loadout_entry/utility/customlaptop/New()
	..()
	gear_tweaks += new /datum/loadout_tweak/laptop()

/datum/loadout_entry/utility/dufflebag
	name = "Dufflebag"
	path = /obj/item/storage/backpack/dufflebag
	slot = SLOT_ID_BACK
	cost = 2

/datum/loadout_entry/utility/dufflebag/black
	name = "Dufflebag - Black"
	path = /obj/item/storage/backpack/dufflebag/fluff

/datum/loadout_entry/utility/rigbag
	name = "Rig Storage Unit"
	path = /obj/item/storage/backpack/rig
	slot = SLOT_ID_BACK
	cost = 0

/datum/loadout_entry/utility/welding_helmet
	name = "Welding Helmet"
	path = /obj/item/clothing/head/welding
	cost = 2

/datum/loadout_entry/utility/welding_helmet/demon
	name = "Welding Helmet - Demon"
	path = /obj/item/clothing/head/welding/demon

/datum/loadout_entry/utility/welding_helmet/knight
	name = "Welding Helmet - Knight"
	path = /obj/item/clothing/head/welding/knight

/datum/loadout_entry/utility/welding_helmet/fancy
	name = "Welding Helmet - Fancy"
	path = /obj/item/clothing/head/welding/fancy

/datum/loadout_entry/utility/welding_helmet/engie
	name = "Welding Helmet - Engie"
	path = /obj/item/clothing/head/welding/engie

/datum/loadout_entry/utility/webbing
	name = "Webbing - Simple"
	path = /obj/item/clothing/accessory/storage/webbing

/datum/loadout_entry/utility/webbing/brown
	name = "Webbing - Brown"
	path = /obj/item/clothing/accessory/storage/brown_vest
	cost = 2

/datum/loadout_entry/utility/webbing/black
	name = "Webbing - Black"
	path = /obj/item/clothing/accessory/storage/black_vest
	cost = 2

/datum/loadout_entry/utility/webbing/white
	name = "Webbing - White" //it's a nice day for a / white webbing
	path = /obj/item/clothing/accessory/storage/white_vest
	cost = 2
