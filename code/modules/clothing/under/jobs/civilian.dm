//Alphabetical order of civilian jobs.

/obj/item/clothing/under/rank/bartender
	desc = "It looks like it could use some more flair."
	name = "bartender's uniform"
	icon_state = "ba_suit"
	rolled_sleeves = 0

/obj/item/clothing/under/rank/bartender/skirt
	desc = "Short and cute."
	name = "bartender's skirt"
	icon_state = "ba_suit_skirt"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")

/obj/item/clothing/under/rank/bartender/skirt_pleated
	name = "bartender's pleated skirt"
	desc = "Short, and to the point."
	icon_state = "barman_skirt"
	rolled_sleeves = -1

/obj/item/clothing/under/rank/captain //Alright, technically not a 'civilian' but its better then giving a .dm file for a single define.
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Facility Director\"."
	name = "Facility Director's jumpsuit"
	icon_state = "captain"
	rolled_sleeves = 0

/obj/item/clothing/under/rank/captain/talon
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "Talon captain's jumpsuit"

/obj/item/clothing/under/rank/captain/skirt_pleated
	name = "captain's pleated skirt"
	icon_state = "captain_skirt"

/obj/item/clothing/under/rank/cargo
	name = "quartermaster's jumpsuit"
	desc = "It's a jumpsuit worn by the quartermaster. It's specially designed to prevent back injuries caused by pushing paper."
	icon_state = "qm"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/cargo/skirt_pleated
	name = "quartermaster's pleated skirt"
	desc = "Skiiiiiirt! It's pleated!"
	icon_state = "qm_skirt"

/obj/item/clothing/under/rank/cargo/jeans
	name = "quartermaster's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon_state = "qmj"

/obj/item/clothing/under/rank/cargo/jeans/female
	name = "quartermaster's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon_state = "qmjf"
	rolled_sleeves = -1

/obj/item/clothing/under/rank/cargotech
	name = "cargo technician's jumpsuit"
	desc = "Shooooorts! They're comfy and easy to wear!"
	icon_state = "cargo"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	rolled_sleeves = 0

/obj/item/clothing/under/rank/cargotech/jeans
	name = "cargo technician's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon_state = "cargoj"
	item_state_slots = list(slot_r_hand_str = "cargo", slot_l_hand_str = "cargo")
	rolled_sleeves = -1

/obj/item/clothing/under/rank/cargotech/jeans/female
	name = "cargo technician's jumpjeans"
	desc = "Jeeeaaans! They're comfy!"
	icon_state = "cargojf"

/obj/item/clothing/under/rank/cargotech/skirt_pleated
	name = "cargo technician's pleated skirt"
	desc = "Skiiiiiirt! It's pleated!"
	icon_state = "cargo_skirt"

/obj/item/clothing/under/rank/chaplain
	desc = "It's a black jumpsuit, often worn by religious folk."
	name = "chaplain's jumpsuit"
	icon_state = "chaplain"
	item_state_slots = list(slot_r_hand_str = "black", slot_l_hand_str = "black")
	rolled_sleeves = 0

/obj/item/clothing/under/rank/chaplain/skirt_pleated
	name = "chaplain's pleated skirt"
	icon_state = "chaplain_skirt"

/obj/item/clothing/under/rank/chef
	desc = "It's an apron which is given only to the most <b>hardcore</b> chefs in space."
	name = "chef's uniform"
	icon_state = "chef"
	rolled_sleeves = 0

/obj/item/clothing/under/rank/chef/skirt_pleated
	name = "chef's pleated skirt"
	desc = "It's a skirt of which is given only to the most <b>ludicrous</b> of spacebound chefs."
	icon_state = "chef_skirt"

/obj/item/clothing/under/rank/clown
	name = "clown suit"
	desc = "<i><font face='comic sans ms'>Honk!</i></font>"
	icon_state = "clown"
	rolled_sleeves = -1

/obj/item/clothing/under/rank/head_of_personnel
	desc = "It's a jumpsuit worn by someone who works in the position of \"Head of Personnel\"."
	name = "head of personnel's jumpsuit"
	icon_state = "hop"
	rolled_sleeves = 0

/obj/item/clothing/under/rank/head_of_personnel/skirt_pleated
	name = "head of personnel's pleated skirt"
	desc = "A semi formal uniform given only to Heads of Personnel."
	icon_state = "hop_skirt"

/obj/item/clothing/under/rank/head_of_personnel_whimsy
	desc = "A blue jacket and red tie, with matching red cuffs! Snazzy. Wearing this makes you feel more important than your job title does."
	name = "head of personnel's suit"
	icon_state = "hopwhimsy"
	item_state_slots = list(slot_r_hand_str = "hop", slot_l_hand_str = "hop")
	rolled_sleeves = -1

/obj/item/clothing/under/rank/hydroponics
	desc = "It's a jumpsuit designed to protect against minor plant-related hazards."
	name = "botanist's jumpsuit"
	icon_state = "hydroponics"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")
	permeability_coefficient = 0.50
	rolled_sleeves = 0

/obj/item/clothing/under/rank/hydroponics/skirt_pleated
	name = "botanist's pleated skirt"
	icon_state = "hydroponics_skirt"

/obj/item/clothing/under/rank/internalaffairs
	desc = "The plain, professional attire of an Internal Affairs Agent. The collar is <i>immaculately</i> starched."
	name = "Internal Affairs uniform"
	icon_state = "internalaffairs"
	item_state_slots = list(slot_r_hand_str = "ba_suit", slot_l_hand_str = "ba_suit")
	rolled_sleeves = 0
	starting_accessories = list(/obj/item/clothing/accessory/tie/black)

/obj/item/clothing/under/rank/internalaffairs/skirt
	desc = "The plain, professional attire of an Internal Affairs Agent. The top button is sewn shut."
	name = "Internal Affairs skirt"
	icon_state = "internalaffairs_skirt"

/obj/item/clothing/under/rank/janitor
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	name = "janitor's jumpsuit"
	icon_state = "janitor"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	rolled_sleeves = 0

/obj/item/clothing/under/rank/janitor_fem
	name = "janitor's jumpsuit"
	desc = "It's the official uniform of the station's janitor. It has minor protection from biohazards."
	icon_state = "janitor_fem"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/rank/janitor/skirt_pleated
	name = "janitor's pleated skirt"
	desc = "The official pleated skirt of the local janitor. It bears minor protection from biohazards."
	icon_state = "janitor_skirt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/lawyer
	desc = "Slick threads."
	name = "lawyer suit"

/obj/item/clothing/under/lawyer/black
	name = "black lawyer suit"
	icon_state = "lawyer_black"

/obj/item/clothing/under/lawyer/black/skirt
	name = "black lawyer skirt"
	icon_state = "lawyer_black_skirt"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/lawyer/female
	name = "black lawyer suit"
	icon_state = "black_suit_fem"
	item_state_slots = list(slot_r_hand_str = "lawyer_black", slot_l_hand_str = "lawyer_black")

/obj/item/clothing/under/lawyer/red
	name = "red lawyer suit"
	icon_state = "lawyer_red"

/obj/item/clothing/under/lawyer/red/skirt
	name = "red lawyer skirt"
	icon_state = "lawyer_red_skirt"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")

/obj/item/clothing/under/lawyer/blue
	name = "blue lawyer suit"
	icon_state = "lawyer_blue"

/obj/item/clothing/under/lawyer/blue/skirt
	name = "blue lawyer skirt"
	icon_state = "lawyer_blue_skirt"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")

/obj/item/clothing/under/lawyer/bluesuit
	name = "blue suit"
	desc = "A classy suit."
	icon_state = "bluesuit"
	item_state_slots = list(slot_r_hand_str = "lawyer_blue", slot_l_hand_str = "lawyer_blue")
	starting_accessories = list(/obj/item/clothing/accessory/tie/red)

/obj/item/clothing/under/lawyer/bluesuit/skirt
	name = "blue skirt suit"
	icon_state = "bluesuit_skirt"

/obj/item/clothing/under/lawyer/purpsuit
	name = "purple suit"
	icon_state = "lawyer_purp"
	item_state_slots = list(slot_r_hand_str = "purple", slot_l_hand_str = "purple")

/obj/item/clothing/under/lawyer/purpsuit/skirt
	name = "purple skirt suit"
	icon_state = "lawyer_purp_skirt"

/obj/item/clothing/under/lawyer/oldman
	name = "Old Man's Suit"
	desc = "A classic suit for the older gentleman, with built in back support."
	icon_state = "oldman"
	item_state_slots = list(slot_r_hand_str = "johnny", slot_l_hand_str = "johnny")

/obj/item/clothing/under/oldwoman
	name = "Old Woman's Attire"
	desc = "A typical outfit for the older woman, a lovely cardigan and comfortable skirt."
	icon_state = "oldwoman"
	item_state_slots = list(slot_r_hand_str = "johnny", slot_l_hand_str = "johnny")

/obj/item/clothing/under/librarian
	name = "sensible suit"
	desc = "It's very... sensible."
	icon_state = "red_suit"
	item_state_slots = list(slot_r_hand_str = "lawyer_red", slot_l_hand_str = "lawyer_red")

/obj/item/clothing/under/mime
	name = "mime's outfit"
	desc = "It's not very colourful."
	icon_state = "mime"

/obj/item/clothing/under/rank/mime/skirt_pleated
	name = "mime's pleated skirt"
	icon_state = "mime_skirt"

/obj/item/clothing/under/rank/miner
	desc = "It's a snappy jumpsuit with a sturdy set of overalls. It is very dirty."
	name = "shaft miner's jumpsuit"
	icon_state = "miner"
	rolled_sleeves = 0

//Pilot
/obj/item/clothing/under/rank/pilot1
	name = "\improper NanoTrasen flight suit"
	desc = "A blue and grey NanoTrasen flight suit. Warm and practical, it feels cozy."
	icon_state = "pilot1"
	worn_state = "pilot1"
	rolled_down = 0
	rolled_sleeves = 0
	item_icons = list(/datum/inventory_slot_meta/inventory/uniform = 'icons/map_assets/southern_cross/mob/sc_under.dmi')
	icon = 'icons/map_assets/southern_cross/obj/sc_uniforms.dmi'
	sprite_sheets = list(
			SPECIES_TESHARI = 'icons/map_assets/southern_cross/mob/species/teshari/sc_uniform.dmi'
			)
	starting_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1)

/obj/item/clothing/under/rank/pilot2
	name = "\improper NanoTrasen flight suit"
	desc = "A dark blue NanoTrasen flight suit. Warm and practical, several patches are scattered across it."
	icon_state = "pilot2"
	worn_state = "pilot2"
	rolled_down = 0
	rolled_sleeves = 0
	item_icons = list(/datum/inventory_slot_meta/inventory/uniform = 'icons/map_assets/southern_cross/mob/sc_under.dmi')
	icon = 'icons/map_assets/southern_cross/obj/sc_uniforms.dmi'
	sprite_sheets = list(
			SPECIES_TESHARI = 'icons/map_assets/southern_cross/mob/species/teshari/sc_uniform.dmi'
			)
	starting_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot2)

// The things folks do for fashion...
/obj/item/clothing/under/rank/janitor/starcon
	name = "janitor's uniform"
	desc = "It's the official uniform of the station's janitor with minor modifications. It has minor protection from biohazards, but not from the harshness of space."
	icon_state = "janitor_sc"
