// "Useful" items - I'm guessing things that might be used at work?
/datum/gear/utility
	display_name = "Briefcase"
	path = /obj/item/storage/briefcase
	sort_category = "Utility"

/datum/gear/utility/clipboard
	display_name = "Clipboard"
	path = /obj/item/clipboard

/datum/gear/utility/tts_device
	display_name = "Text To Speech Device"
	path = /obj/item/text_to_speech
	cost = 3 // Not extremely expensive, but it's useful for mute chracters.

/datum/gear/utility/communicator
	display_name = "Communicator Selection"
	path = /obj/item/communicator
	cost = 0

/datum/gear/utility/communicator/New()
	..()
	var/list/communicators = list()
	for(var/communicator in typesof(/obj/item/communicator) - list(/obj/item/communicator/integrated,/obj/item/communicator/commlink))
		var/obj/item/communicator_type = communicator
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(communicators, /proc/cmp_text_asc))

/datum/gear/utility/camera
	display_name = "Camera"
	path = /obj/item/camera

/datum/gear/utility/codex
	display_name = "The Traveler's Guide to Vir"
	path = /obj/item/book/codex
	cost = 0

/datum/gear/utility/news
	display_name = "Daedalus Pocket Newscaster"
	path = /obj/item/book/codex/lore/news
	cost = 0

/* //VORESTATION REMOVAL
/datum/gear/utility/corp_regs
	display_name = "corporate regulations and legal code"
	path = /obj/item/book/codex/corp_regs
	cost = 0
*/

/datum/gear/utility/robutt
	display_name = "A Buyer's Guide To Artificial Bodies"
	path = /obj/item/book/codex/lore/robutt
	cost = 0

/datum/gear/utility/folder_blue
	display_name = "Folder - Blue"
	path = /obj/item/folder/blue

/datum/gear/utility/folder_grey
	display_name = "Folder - Grey"
	path = /obj/item/folder

/datum/gear/utility/folder_red
	display_name = "Folder - Red"
	path = /obj/item/folder/red

/datum/gear/utility/folder_white
	display_name = "Folder - White"
	path = /obj/item/folder/white

/datum/gear/utility/folder_yellow
	display_name = "Folder - Yellow"
	path = /obj/item/folder/yellow

/datum/gear/utility/paicard
	display_name = "Personal AI Device"
	path = /obj/item/paicard

/datum/gear/utility/securecase
	display_name = "Secure Briefcase"
	path =/obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/laserpointer
	display_name = "Laser Pointer"
	path =/obj/item/laser_pointer
	cost = 2

/datum/gear/utility/flashlight
	display_name = "Flashlight"
	path = /obj/item/flashlight

/datum/gear/utility/flashlight_blue
	display_name = "Flashlight - Blue"
	path = /obj/item/flashlight/color

/datum/gear/utility/flashlight_orange
	display_name = "Flashlight - Orange"
	path = /obj/item/flashlight/color/orange

/datum/gear/utility/flashlight_red
	display_name = "Flashlight - Red"
	path = /obj/item/flashlight/color/red

/datum/gear/utility/flashlight_yellow
	display_name = "Flashlight - Yellow"
	path = /obj/item/flashlight/color/yellow

/datum/gear/utility/maglight
	display_name = "Flashlight - Maglight"
	path = /obj/item/flashlight/maglight
	cost = 2

/datum/gear/utility/battery
	display_name = "Device Cell"
	path = /obj/item/cell/device

/datum/gear/utility/implant
	slot = "implant"
	exploitable = 0

/datum/gear/utility/implant/backup
	display_name= "Implant - Mind Backup"
	slot = "implant"
	cost = 2
	path = /obj/item/implant/backup

/datum/gear/utility/implant/tracking
	display_name = "Implant - Tracking"
	slot = "implant"
	path = /obj/item/implant/tracking/weak
	cost = 0

/datum/gear/utility/implant/neural
	display_name = "Implant - Neural Assistance Web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/implant/neural
	cost = 6

/datum/gear/utility/implant/dud1
	display_name = "Implant - Head"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant/dud
	cost = 1

/datum/gear/utility/implant/dud2
	display_name = "Implant - Torso"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant/dud/torso
	cost = 1

/datum/gear/utility/implant/language
	cost = 2
	exploitable = 0

/datum/gear/utility/implant/language/eal
	display_name = "Vocal Synthesizer - EAL"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak EAL, if they know it."
	path = /obj/item/implant/language/eal

/datum/gear/utility/implant/language/skrellian
	display_name = "Vocal Synthesizer - Skrellian"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak Common Skrellian, if they know it."
	path = /obj/item/implant/language/skrellian

/datum/gear/utility/pen
	display_name = "Fountain Pen"
	path = /obj/item/pen/fountain

/datum/gear/utility/pen/click
	display_name = "Clicker Pen"
	path = /obj/item/pen/click
	cost = 3

/datum/gear/utility/wheelchair/color
	display_name = "Wheelchair"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/color/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/utility/umbrella
	display_name = "Umbrella"
	path = /obj/item/melee/umbrella
	cost = 3

/datum/gear/utility/umbrella/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "Tablet Computer - Cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "Tablet Computer - Advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "Tablet Computer - Custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/tablet()

/datum/gear/utility/cheaplaptop
	display_name = "Laptop Computer - Cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 4

/datum/gear/utility/normallaptop
	display_name = "Laptop Computer - Advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 5

/datum/gear/utility/customlaptop
	display_name = "Laptop Computer - Custom"
	path = /obj/item/modular_computer/laptop/preset/
	cost = 6

/datum/gear/utility/customlaptop/New()
	..()
	gear_tweaks += new /datum/gear_tweak/laptop()

/datum/gear/utility/saddlebag
	display_name = "Saddle Bag - Horse"
	path = /obj/item/storage/backpack/saddlebag
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common
	display_name = "Saddle Bag - Common"
	path = /obj/item/storage/backpack/saddlebag_common
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/robust
	display_name = "Saddle Bag - Robust"
	path = /obj/item/storage/backpack/saddlebag_common/robust
	slot = slot_back
	cost = 2

/datum/gear/utility/saddlebag_common/vest
	display_name = "Taur Duty Vest - Backpack"
	path = /obj/item/storage/backpack/saddlebag_common/vest
	slot = slot_back
	cost = 1

/datum/gear/utility/dufflebag
	display_name = "Dufflebag"
	path = /obj/item/storage/backpack/dufflebag
	slot = slot_back
	cost = 2

/datum/gear/utility/dufflebag/black
	display_name = "Dufflebag - Black"
	path = /obj/item/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
	display_name = "Dufflebag - Medical"
	path = /obj/item/storage/backpack/dufflebag/med
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist","Psychiatrist","Field Medic")

/datum/gear/utility/dufflebag/med/emt
	display_name = "Dufflebag - Medical EMT"
	path = /obj/item/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
	display_name = "Dufflebag - Security"
	path = /obj/item/storage/backpack/dufflebag/sec
	allowed_roles = list("Head of Security","Warden","Detective","Security Officer")

/datum/gear/utility/dufflebag/eng
	display_name = "Dufflebag - Engineering"
	path = /obj/item/storage/backpack/dufflebag/eng
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/utility/dufflebag/sci
	display_name = "Dufflebag - Science"
	path = /obj/item/storage/backpack/dufflebag/sci
	allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist","Explorer","Pathfinder")
