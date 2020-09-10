/*
	Utility - Items of some utility beyond being a fashion statement, often ones with a mechanical advantage that extends beyonds fashion sense or cosmetic flair.
	No slot assigned for the base datum because they could be anything, and may not be worn on a slot directly.
*/

/datum/gear/utility
	sort_category = "Utility" // This controls the name of the category in the loadout.
	type_category = /datum/gear/utility // All subtypes of the geartype declared will be associated with this - practically speaking this controls where the items themselves go.
	cost = 1 // Controls how much an item's "cost" is in the loadout point menu. If re-specified on a different item, that value will override this one. This sets the default value.

/datum/gear/utility/briefcase
	display_name = "briefcase"
	path = /obj/item/storage/briefcase

/datum/gear/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/clipboard

/datum/gear/utility/tts_device
	display_name = "text to speech device"
	path = /obj/item/text_to_speech
	cost = 3 //Not extremely expensive, but it's useful for mute chracters.

/datum/gear/utility/communicator
	display_name = "communicator selection"
	path = /obj/item/communicator
	cost = 0

/datum/gear/utility/communicator/New()
	..()
	var/list/communicators = list()
	for(var/communicator in typesof(/obj/item/communicator) - list(/obj/item/communicator/integrated,/obj/item/communicator/commlink)) //VOREStation Edit - Remove Commlink
		var/obj/item/communicator_type = communicator
		communicators[initial(communicator_type.name)] = communicator_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(communicators, /proc/cmp_text_asc, TRUE))

/datum/gear/utility/camera
	display_name = "camera"
	path = /obj/item/camera

/datum/gear/utility/codex
	display_name = "the traveler's guide to vir"
	path = /obj/item/book/codex //VOREStation Edit
	cost = 0

/datum/gear/utility/news
	display_name = "daedalus pocket newscaster"
	path = /obj/item/book/codex/lore/news
	cost = 0

/* //VORESTATION REMOVAL
/datum/gear/utility/corp_regs
	display_name = "corporate regulations and legal code"
	path = /obj/item/book/codex/corp_regs
	cost = 0
*/

/datum/gear/utility/robutt
	display_name = "a buyer's guide to artificial bodies"
	path = /obj/item/book/codex/lore/robutt
	cost = 0

/datum/gear/utility/folder_blue
	display_name = "folder, blue"
	path = /obj/item/folder/blue

/datum/gear/utility/folder_grey
	display_name = "folder, grey"
	path = /obj/item/folder

/datum/gear/utility/folder_red
	display_name = "folder, red"
	path = /obj/item/folder/red

/datum/gear/utility/folder_white
	display_name = "folder, white"
	path = /obj/item/folder/white

/datum/gear/utility/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/folder/yellow

/datum/gear/utility/paicard
	display_name = "personal AI device"
	path = /obj/item/paicard

/datum/gear/utility/securecase
	display_name = "secure briefcase"
	path =/obj/item/storage/secure/briefcase
	cost = 2

/datum/gear/utility/laserpointer
	display_name = "laser pointer"
	path =/obj/item/laser_pointer
	cost = 2

/datum/gear/utility/flashlight
	display_name = "flashlight"
	path = /obj/item/flashlight

/datum/gear/utility/flashlight_blue
	display_name = "flashlight, blue"
	path = /obj/item/flashlight/color

/datum/gear/utility/flashlight_orange
	display_name = "flashlight, orange"
	path = /obj/item/flashlight/color/orange

/datum/gear/utility/flashlight_red
	display_name = "flashlight, red"
	path = /obj/item/flashlight/color/red

/datum/gear/utility/flashlight_yellow
	display_name = "flashlight, yellow"
	path = /obj/item/flashlight/color/yellow

/datum/gear/utility/maglight
	display_name = "flashlight, maglight"
	path = /obj/item/flashlight/maglight
	cost = 2

/datum/gear/utility/battery
	display_name = "cell, device"
	path = /obj/item/cell/device

/*
/datum/gear/utility/implant
	display_name = "implant"
	description = "An implant with no obvious purpose."
	path = /obj/item/implant

slot = "implant" Shouldn't be used as a parent's value, because some implants you may want to keep not implanted in you for roleplaying purposes.
So either declare it manually, or make a non-implanted parent object alongside the implanted one to differentiate between the two types.

I'll just leave this here in case someone one day decide sthey want to create an implant selection for the loadout - though I wouldn't advise it personally.
Only because at the time of this comment's creation, you can only pick *one* item out of a selection rather than multiple.
*/

/datum/gear/utility/implant_backup
	display_name= "implant, mind backup"
	path = /obj/item/implant/backup
	slot = "implant"
	cost = 2

/datum/gear/utility/implant_tracking
	display_name = "implant, tracking"
	path = /obj/item/implant/tracking/weak
	slot = "implant"
	cost = 0

/datum/gear/utility/implant_neural
	display_name = "implant, neural assistance web"
	description = "A complex web implanted into the subject, medically in order to compensate for neurological disease."
	path = /obj/item/implant/neural
	slot = "implant"
	cost = 6

/datum/gear/utility/implant_generic_head
	display_name = "implant, head"
	description = "An implant with no immediately discernable purpose (to outside observers) that's intended to be implanted in someone's skull."
	path = /obj/item/implant/dud
	cost = 1

/datum/gear/utility/implant_generic_head_implanted
	display_name = "implant, head, (implanted)"
	description = "An implant with no immediately discernable purpose (to outside observers) that's been implanted into your skull."
	path = /obj/item/implant/dud
	slot = "implant"
	cost = 1

/datum/gear/utility/implant_generic_torso
	display_name = "implant, torso"
	description = "An implant with no immediately discernable purpose (to outside observers) that's intended to be implanted in someone's torso."
	path = /obj/item/implant/dud/torso
	cost = 1

/datum/gear/utility/implant_generic_torso_implanted
	display_name = "implant, torso, (implanted)"
	description = "An implant with no immediately discernable purpose (to outside observers) that's been implanted in your torso."
	path = /obj/item/implant/dud/torso
	slot = "implant"
	cost = 1

/datum/gear/utility/implant_language_eal
	display_name = "vocal synthesizer, EAL"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak EAL, if they know it."
	path = /obj/item/implant/language/eal
	slot = "implant"
	cost = 2

/datum/gear/utility/implant_language_skrellian
	display_name = "vocal synthesizer, Skrellian"
	description = "A surgically implanted vocal synthesizer which allows the owner to speak Common Skrellian, if they know it."
	path = /obj/item/implant/language/skrellian
	slot = "implant"
	cost = 2

/datum/gear/utility/pen
	display_name = "Fountain Pen"
	path = /obj/item/pen/fountain

/datum/gear/utility/pen/click
	display_name = "clicker pen"
	path = /obj/item/pen/click
	cost = 3

/datum/gear/utility/wheelchair
	display_name = "wheelchair"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/colorable
	display_name = "wheelchair (colorable)"
	path = /obj/item/wheelchair
	cost = 4

/datum/gear/utility/wheelchair/colorable/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/utility/umbrella
	display_name = "Umbrella"
	path = /obj/item/melee/umbrella
	cost = 3

/datum/gear/utility/umbrella/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/****************
modular computers
****************/

/datum/gear/utility/cheaptablet
	display_name = "tablet computer: cheap"
	display_name = "tablet computer, cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/datum/gear/utility/normaltablet
	display_name = "tablet computer: advanced"
	display_name = "tablet computer, advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/datum/gear/utility/customtablet
	display_name = "tablet computer: custom"
	display_name = "tablet computer, custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/datum/gear/utility/customtablet/New()
	..()
	gear_tweaks += new /datum/gear_tweak/tablet()

/datum/gear/utility/cheaplaptop
	display_name = "laptop computer, cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 4

/datum/gear/utility/normallaptop
	display_name = "laptop computer, advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 5

/datum/gear/utility/customlaptop
	display_name = "laptop computer, custom"
	path = /obj/item/modular_computer/laptop/preset/
	cost = 6 //VOREStation Edit

/datum/gear/utility/customlaptop/New()
	..()
	gear_tweaks += new /datum/gear_tweak/laptop()

/datum/gear/utility/saddlebag
    display_name = "saddle bag, horse"
    path = /obj/item/storage/backpack/saddlebag
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common
    display_name = "saddle bag, common"
    path = /obj/item/storage/backpack/saddlebag_common
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/robust
    display_name = "saddle bag, robust"
    path = /obj/item/storage/backpack/saddlebag_common/robust
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/vest
    display_name = "taur duty vest (backpack)"
    path = /obj/item/storage/backpack/saddlebag_common/vest
    slot = slot_back
    cost = 1

/datum/gear/utility/dufflebag
    display_name = "dufflebag"
    path = /obj/item/storage/backpack/dufflebag
    slot = slot_back
    cost = 2

/datum/gear/utility/dufflebag/black
    display_name = "black dufflebag"
    path = /obj/item/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
    display_name = "medical dufflebag"
    path = /obj/item/storage/backpack/dufflebag/med
    allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist","Psychiatrist","Field Medic")

/datum/gear/utility/dufflebag/med/emt
    display_name = "EMT dufflebag"
    path = /obj/item/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
    display_name = "security Dufflebag"
    path = /obj/item/storage/backpack/dufflebag/sec
    allowed_roles = list("Head of Security","Warden","Detective","Security Officer")

/datum/gear/utility/dufflebag/eng
    display_name = "engineering dufflebag"
    path = /obj/item/storage/backpack/dufflebag/eng
    allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/utility/dufflebag/sci
    display_name = "science dufflebag"
    path = /obj/item/storage/backpack/dufflebag/sci
    allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist","Explorer","Pathfinder")
