
/obj/structure/flora
	name = "flora"
	desc = "A perfectly generic plant."

	anchored = TRUE // Usually, plants don't move. Usually.
	plane = TURF_PLANE
	layer = BELOW_MOB_LAYER

	var/randomize_size = FALSE
	var/max_x_scale = 1.25
	var/max_y_scale = 1.25
	var/min_x_scale = 0.9
	var/min_y_scale = 0.9

	var/harvest_tool = null // The type of item used to harvest the plant.
	var/harvest_count = 0

	var/randomize_harvest_count = TRUE
	var/max_harvests = 0
	var/min_harvests = -1
	var/list/harvest_loot = null	// Should be an associative list for things to spawn, and their weights. An example would be a branch from a tree.

/obj/structure/flora/Initialize(mapload)
	. = ..()

	if(randomize_size)
		icon_scale_x = rand(min_x_scale * 100, max_x_scale * 100) / 100
		icon_scale_y = rand(min_y_scale * 100, max_y_scale * 100) / 100

		if(prob(50))
			icon_scale_x *= -1
		update_transform()

	if(randomize_harvest_count)
		max_harvests = max(0, rand(min_harvests, max_harvests)) // Incase you want to weight it more toward 'not harvestable', set min_harvests to a negative value.

/obj/structure/flora/examine(mob/user)
	. = ..()
	if(harvest_count < max_harvests)
		. += "<span class='notice'>\The [src] seems to have something hanging from it.</span>"

/obj/structure/flora/attackby(var/obj/item/W, var/mob/living/user)
	if(can_harvest(W))
		var/harvest_spawn = pickweight(harvest_loot)
		var/atom/movable/AM = spawn_harvest(harvest_spawn, user)

		if(!AM)
			to_chat(user, "<span class='notice'>You fail to harvest anything from \the [src].</span>")

		else
			to_chat(user, "<span class='notice'>You harvest \the [AM] from \the [src].</span>")
			return

	..(W, user)

/obj/structure/flora/proc/can_harvest(var/obj/item/I)
	. = FALSE
	if(harvest_tool && istype(I, harvest_tool) && harvest_loot && harvest_loot.len && harvest_count < max_harvests)
		. = TRUE
	return .

/obj/structure/flora/proc/spawn_harvest(var/path = null, var/mob/user = null)
	if(!ispath(path))
		return 0
	var/turf/Target = get_turf(src)
	if(user)
		Target = get_turf(user)

	var/atom/movable/AM = new path(Target)

	harvest_count++
	return AM

//bushes
/obj/structure/flora/bush
	name = "bush"
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"

/obj/structure/flora/bush/Initialize(mapload)
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"

/obj/structure/flora/pottedplant
	name = "potted plant"
	desc = "Really ties the room together."
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-26"

	anchored = FALSE

//newbushes

/obj/structure/flora/ausbushes
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"

/obj/structure/flora/ausbushes/attackby(obj/item/W as obj, mob/user as mob)
	// Dismantle
	if(istype(W, /obj/item/shovel))
		playsound(src.loc, W.tool_sound, 50, 1)
		if(do_after(user, 10, src))
			user.visible_message("<span class='notice'>\The [user] digs up \the [src].</span>", "<span class='notice'>You dig up \the [src].</span>")
			new /obj/item/stack/tile/grass(get_turf(usr), 1)
			qdel(src)
			return

/obj/structure/flora/ausbushes/Initialize(mapload)
	. = ..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/reedbush
	name = "reeds"
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/Initialize(mapload)
	. = ..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	name = "leafy bush"
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/Initialize(mapload)
	. = ..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	name = "sparse bush"
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/Initialize(mapload)
	. = ..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	name = "stalks"
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/Initialize(mapload)
	. = ..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	name = "lush grass"
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/Initialize(mapload)
	. = ..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	name = "ferns"
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/Initialize(mapload)
	. = ..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	name = "sapling"
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/Initialize(mapload)
	. = ..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	name = "leafy sapling"
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/Initialize(mapload)
	. = ..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	name = "needled sapling"
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/Initialize(mapload)
	. = ..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	name = "patchy flowers"
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/Initialize(mapload)
	. = ..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	name = "yellow flowers"
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/Initialize(mapload)
	. = ..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	name = "colorful flowers"
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/Initialize(mapload)
	. = ..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	name = "purple flowers"
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/Initialize(mapload)
	. = ..()
	icon_state = "ppflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sparsegrass
	name = "sparse grass"
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/Initialize(mapload)
	. = ..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	name = "grass"
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/Initialize(mapload)
	. = ..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/structure/flora/skeleton
	name = "hanging skeleton model"
	icon = 'icons/obj/plants.dmi' //what an interesting plant
	icon_state = "hangskele"
	desc = "It's an anatomical model of a human skeletal system made of plaster."

	plane = OBJ_PLANE

//potted plants credit: Flashkirby
/obj/structure/flora/pottedplant
	name = "potted plant"
	desc = "Really brings the room together."
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-01"

	plane = OBJ_PLANE

/obj/structure/flora/pottedplant/large
	name = "large potted plant"
	desc = "This is a large plant. Three branches support pairs of waxy leaves."
	icon_state = "plant-26"

/obj/structure/flora/pottedplant/fern
	name = "potted fern"
	desc = "This is an ordinary looking fern. It looks like it could do with some water."
	icon_state = "plant-02"

/obj/structure/flora/pottedplant/overgrown
	name = "overgrown potted plants"
	desc = "This is an assortment of colourful plants. Some parts are overgrown."
	icon_state = "plant-03"

/obj/structure/flora/pottedplant/bamboo
	name = "potted bamboo"
	desc = "These are bamboo shoots. The tops looks like they've been cut short."
	icon_state = "plant-04"

/obj/structure/flora/pottedplant/largebush
	name = "large potted bush"
	desc = "This is a large bush. The leaves stick upwards in an odd fashion."
	icon_state = "plant-05"

/obj/structure/flora/pottedplant/thinbush
	name = "thin potted bush"
	desc = "This is a thin bush. It appears to be flowering."
	icon_state = "plant-06"

/obj/structure/flora/pottedplant/mysterious
	name = "mysterious potted bulbs"
	desc = "This is a mysterious looking plant. Touching the bulbs cause them to shrink."
	icon_state = "plant-07"
	catalogue_data = list(/datum/category_item/catalogue/flora/eyebulbs)

/obj/structure/flora/pottedplant/smalltree
	name = "small potted tree"
	desc = "This is a small tree. It is rather pleasant."
	icon_state = "plant-08"

/obj/structure/flora/pottedplant/unusual
	name = "unusual potted plant"
	desc = "This is an unusual plant. It's bulbous ends emit a soft blue light."
	icon_state = "plant-09"
	light_range = 2
	light_power = 0.6
	light_color = "#33CCFF"
	catalogue_data = list(/datum/category_item/catalogue/flora/sif_tree)

/obj/structure/flora/pottedplant/orientaltree
	name = "potted oriental tree"
	desc = "This is a rather oriental style tree. Its flowers are bright pink."
	icon_state = "plant-10"

/obj/structure/flora/pottedplant/smallcactus
	name = "small potted cactus"
	desc = "This is a small cactus. Its needles are sharp."
	icon_state = "plant-11"

/obj/structure/flora/pottedplant/tall
	name = "tall potted plant"
	desc = "This is a tall plant. Tiny pores line its surface."
	icon_state = "plant-12"

/obj/structure/flora/pottedplant/sticky
	name = "sticky potted plant"
	desc = "This is an odd plant. Its sticky leaves trap insects."
	icon_state = "plant-13"

/obj/structure/flora/pottedplant/smelly
	name = "smelly potted plant"
	desc = "This is some kind of tropical plant. It reeks of rotten eggs."
	icon_state = "plant-14"

/obj/structure/flora/pottedplant/small
	name = "small potted plant"
	desc = "This is a pot of assorted small flora. Some look familiar."
	icon_state = "plant-15"

/obj/structure/flora/pottedplant/aquatic
	name = "aquatic potted plant"
	desc = "This is apparently an aquatic plant. It's probably fake."
	icon_state = "plant-16"

/obj/structure/flora/pottedplant/shoot
	name = "small potted shoot"
	desc = "This is a small shoot. It still needs time to grow."
	icon_state = "plant-17"

/obj/structure/flora/pottedplant/flower
	name = "potted flower"
	desc = "This is a slim plant. Sweet smelling flowers are supported by spindly stems."
	icon_state = "plant-18"

/obj/structure/flora/pottedplant/crystal
	name = "crystalline potted plant"
	desc = "These are rather cubic plants. Odd crystal formations grow on the end."
	icon_state = "plant-19"

/obj/structure/flora/pottedplant/subterranean
	name = "subterranean potted plant"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "plant-20"
	light_range = 2
	light_power = 0.6
	light_color = "#FF6633"

/obj/structure/flora/pottedplant/minitree
	name = "potted tree"
	desc = "This is a miniature tree. Apparently it was grown to 1/5 scale."
	icon_state = "plant-21"

/obj/structure/flora/pottedplant/stoutbush
	name = "stout potted bush"
	desc = "This is a stout bush. Its leaves point up and outwards."
	icon_state = "plant-22"

/obj/structure/flora/pottedplant/drooping
	name = "drooping potted plant"
	desc = "This is a small plant. The drooping leaves make it look like its wilted."
	icon_state = "plant-23"

/obj/structure/flora/pottedplant/tropical
	name = "tropical potted plant"
	desc = "This is some kind of tropical plant. It hasn't begun to flower yet."
	icon_state = "plant-24"

/obj/structure/flora/pottedplant/dead
	name = "dead potted plant"
	desc = "This is the dried up remains of a dead plant. Someone should replace it."
	icon_state = "plant-25"

/obj/structure/flora/pottedplant/decorative
	name = "decorative potted plant"
	desc = "This is a decorative shrub. It's been trimmed into the shape of an apple."
	icon_state = "applebush"

/obj/structure/flora/pottedplant/xmas
	name = "small christmas tree"
	desc = "This is a tiny well lit decorative christmas tree."
	icon_state = "plant-xmas"

/obj/structure/flora/sif
	icon = 'icons/obj/flora/sifflora.dmi'

/obj/structure/flora/sif/attack_hand(mob/user)
	if (user.a_intent == INTENT_HARM)
		if(do_after(user, 5 SECONDS))
			user.visible_message("\The [user] digs up \the [src.name].", "You dig up \the [src.name].")
			qdel(src)
	else
		user.visible_message("\The [user] pokes \the [src.name].", "You poke \the [src.name].")

/datum/category_item/catalogue/flora/subterranean_bulbs
	name = "Sivian Flora - Subterranean Bulbs"
	desc = "A plant which is native to Sif, it continues the trend of being a bioluminescent specimen. These plants \
	are generally suited for conditions experienced in caverns, which are generally dark and cold. It is not \
	known why this plant evolved to be bioluminescent, however this property has, unintentionally, allowed for \
	it to spread much farther than before, with the assistance of humans.\
	<br><br>\
	In Sif's early history, Sivian settlers found this plant while they were establishing mines. Their ability \
	to emit low, but consistant amounts of light made them desirable to the settlers. They would often cultivate \
	this plant inside man-made tunnels and mines to act as a backup source of light that would not need \
	electricity. This technique has saved many lost miners, and this practice continues to this day."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/sif/subterranean
	name = "subterranean plant"
	desc = "This is a subterranean plant. It's bulbous ends glow faintly."
	icon_state = "glowplant"
	light_range = 2
	light_power = 0.6
	light_color = "#FF6633"
	catalogue_data = list(/datum/category_item/catalogue/flora/subterranean_bulbs)

/obj/structure/flora/sif/subterranean/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,2)]"
	. = ..()


/datum/category_item/catalogue/flora/eyebulbs
	name = "Sivian Flora - Eyebulbs"
	desc = "A plant native to Sif. On the end of its stems are bulbs which visually resemble \
	eyes, which shrink when touched. One theory is that the bulbs are a result of mimicry, appearing as eyeballs to protect from predators.<br><br>\
	These plants have no known use."
	value = CATALOGUER_REWARD_EASY

/obj/structure/flora/sif/eyes
	name = "mysterious bulbs"
	desc = "This is a mysterious looking plant. They kind of look like eyeballs. Creepy."
	icon_state = "eyeplant"
	catalogue_data = list(/datum/category_item/catalogue/flora/eyebulbs)

/obj/structure/flora/sif/eyes/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,3)]"
	. = ..()

/datum/category_item/catalogue/flora/mosstendrils
	name = "Sivian Flora - Moss Stalks"
	desc = "A plant native to Sif. The plant is most closely related to the common, dense moss found covering Sif's terrain. \
	It has evolved a method of camouflage utilizing white hairs on its dorsal sides to make it appear as a small mound of snow from \
	above. It has no known use, though it is a common furnishing in contemporary homes."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/structure/flora/sif/tendrils
	name = "stocky tendrils"
	desc = "A 'plant' made up of hardened moss. It has tiny hairs that bunch together to look like snow."
	icon_state = "grass"
	randomize_size = TRUE
	catalogue_data = list(/datum/category_item/catalogue/flora/mosstendrils)

/obj/structure/flora/sif/tendrils/Initialize(mapload)
	icon_state = "[initial(icon_state)][rand(1,3)]"
	. = ..()

//Pumpkins
/obj/structure/flora/pumpkin
	name = "pumpkin"
	icon = 'icons/obj/flora/pumpkins.dmi'
	desc = "A healthy, fat pumpkin. It looks as if it was freshly plucked from its vines and shows no signs of decay."
	icon_state = "decor-pumpkin"

/obj/landmark/carved_pumpkin_spawn
	name = "jack o'lantern spawn"
	icon = 'icons/obj/flora/pumpkins.dmi'
	icon_state = "spawner-jackolantern"

/obj/landmark/carved_pumpkin_spawn/New()
    var/new_pumpkin = pick(
		prob(70);/obj/structure/flora/pumpkin,
        prob(60);/obj/structure/flora/pumpkin/carved,
        prob(30);/obj/structure/flora/pumpkin/carved/scream,
        prob(30);/obj/structure/flora/pumpkin/carved/girly,
        prob(10);/obj/structure/flora/pumpkin/carved/owo)
    new new_pumpkin(src.loc)
    ..()

/obj/structure/flora/pumpkin/carved
	name = "jack o'lantern"
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has develishly evil-looking eyes and a grinning mouth more than big enough for a very small person to hide in."
	icon_state = "decor-jackolantern"

/obj/structure/flora/pumpkin/carved/scream
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has rounded eyes looking in completely opposite directions and a wide mouth, forever frozen in a silent scream. It looks ridiculous, actually."
	icon_state = "decor-jackolantern-scream"

/obj/structure/flora/pumpkin/carved/girly
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has neatly rounded eyes topped with what appear to be cartoony eyelashes, completed with what seems to have been the carver's attempt at friendly, toothy smile. The mouth is easily the scariest part of its face."
	icon_state = "decor-jackolantern-girly"

/obj/structure/flora/pumpkin/carved/owo
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has large, round eyes and a squiggly, cat-like smiling mouth. Its pleasantly surprised expression seems to suggest that the pumpkin has noticed something about you."
	icon_state = "decor-jackolantern-owo"

//Halloween Gift Spawner
/obj/structure/flora/pumpkin/pumpkin_patch
	name = "pumpkin patch"
	desc = "A big pile of pumpkins, guarded by a spooky scarecrow!"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pumpkinpatch"

/obj/structure/flora/pumpkin/pumpkin_patch/presents
	desc = "A big pile of pumpkins, guarded by a spooky scarecrow! It has presents!"
	var/gift_type = /obj/item/b_gift
	var/list/ckeys_that_took = list()

/obj/structure/flora/pumpkin/pumpkin_patch/presents/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(ckeys_that_took[user.ckey])
		to_chat(user, SPAN_WARNING( "There are no pumpkins that look familiar to you."))
		return
	to_chat(user, SPAN_NOTICE("After a bit of searching, you locate a pumpkin with your face carved into it!"))
	ckeys_that_took[user.ckey] = TRUE
	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)
