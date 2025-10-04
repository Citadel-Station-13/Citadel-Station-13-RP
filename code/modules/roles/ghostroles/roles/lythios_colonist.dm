/datum/prototype/role/ghostrole/lythios_colonist
	name = "Na'sahira Colonist"
	assigned_role = "Colonist"
	desc = "You are a Tajara colonist from the New Kingdom of Adhomai, struggling to eek out a living on a distant planet."
	spawntext = "You were selected by lottery, to settle a new colony on land leased from Nanotrasen, Na'sahira. In order to make this journey you had to swear \
	fealty to the Baronness Anjarra Azorman, a small price to escape the poverty you faced on Adhomai. This planet is harsh and even here it is a struggle to survive. \
	Thankfully there is a Nanotrasen base nearby the ground around which are said to be rich in resources. Through the Baronness agreement with Nanotrasen you may \
	harvest these resources and trade with the crew. Hopefully that makes the long walk here from Na'sahira worth it. Maybe this crew can even afford to pay in things \
	beyond their useless Thalers."

	important_info = "The colonists of Na'sahira are all Tajara from the New Kingdom of Adhomai. They come mostly from destitute backgrounds and won a lottery to be \
	resettled here. The planet is harsh and you are extremely poor. Thalers are not an accepted currency in Na'sahira and as such they are only useful to you as kindling. \
	Na'Sahira's colonists are not meant to leave the planet without the permission of their Baronness. This is not an antag role though minor acts of mischief such as petty \
	theft or vandalism are permitted especially in the name of survival. Serious criminal acts however may see your character punished by the Na'sahira Constabulary whose \
	form of justice is harsher then Nanotrasen's. Na'sahira colonists are permadeath characters, be very careful."

	instantiator = /datum/ghostrole_instantiator/human/player_static/lythios_colonist

/datum/prototype/role/ghostrole/lythios_colonist/Instantiate(client/C, atom/loc, list/params)
	return ..()

/datum/prototype/role/ghostrole/lythios_colonist/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	to_chat(created, "<i> The metal clanks beneath you as you step through the final old door entering the grounds of NSB Atlas. You travelled \
	around five kilometers through the snow to get here. Compared to that the few hundred meter tunnel wasn't bad at all, even if the climb through \
	the hatch was a tight fit. The area around NSB is allegedly rich in resources for harvesting and equally as rich with oppourtunities to barter \
	with the Nanotrasen crew. You reach for your tightly bundled travel pack. S'rendarr perserve you, its time to get to work!</i>")

/datum/ghostrole_instantiator/human/player_static/lythios_colonist
	equip_loadout = FALSE //You are too poor to have a loadout.
	species_required = /datum/species/tajaran
	var/list/lythios_colonist_crafting = list(/datum/crafting_recipe/evapmilk, /datum/crafting_recipe/kompot, /datum/crafting_recipe/watercan,
	/datum/crafting_recipe/guskacake, /datum/crafting_recipe/taj_pemmican, /datum/crafting_recipe/stimm_hypo, /datum/crafting_recipe/chloral_hypo,
	/datum/crafting_recipe/trippy_hypo, /datum/crafting_recipe/empty_can, /datum/crafting_recipe/spider_spray, /datum/crafting_recipe/hunter_coat,
	/datum/crafting_recipe/taj_dress, /datum/crafting_recipe/taj_rdress, /datum/crafting_recipe/taj_bdress
	)

/datum/ghostrole_instantiator/human/player_static/lythios_colonist/GetOutfit(client/C, mob/M, list/params)
		return new /datum/outfit/lythios_colonist

/datum/ghostrole_instantiator/human/player_static/lythios_colonist/AfterSpawn(mob/created, list/params)
	. = ..()
	created.mind.teach_crafting_recipe(lythios_colonist_crafting)

/obj/structure/ghost_role_spawner/lythios_colonist
	name = "maintenance hatch"
	desc = "A old ladder connecting to the old People's Republic of Adhomai maintnance tunnels. A good way to get around Lythios."
	icon = 'icons/obj/structures.dmi'
	icon_state = "hatchdown"
	anchored = TRUE
	role_type = /datum/prototype/role/ghostrole/lythios_colonist
	role_spawns = 4

/obj/item/gearbox/lythios_colonist
	name = "tightly bundled pack"
	desc = "A tajaran colonist's tightly bundled pack of equipment. All there is left to do is open it up."
	icon = 'icons/obj/storage.dmi'
	icon_state = "giftbag2"

/obj/item/gearbox/lythios_colonist/attack_self(mob/user, datum/event_args/actor/actor)
	var/list/options = list()
	options["Herder"] = list(/obj/item/tool/wirecutters/clippers/trimmers, /obj/item/reagent_containers/glass/bucket/wood, /obj/item/bo_staff,
	/obj/item/material/butterfly/butterfly_wooden, /obj/item/reagent_containers/food/drinks/cans/empty, /obj/item/reagent_containers/food/drinks/cans/empty,
	/obj/item/reagent_containers/food/drinks/cans/empty, /obj/item/reagent_containers/food/drinks/cans/empty, /obj/item/reagent_containers/food/drinks/cans/empty,
	/obj/item/reagent_containers/food/drinks/cans/empty, /obj/item/clothing/suit/storage/hooded/tajaran/cloak/gruff, /obj/item/stack/medical/crude_pack)
	options["Hunter"] = list(/obj/item/gun/projectile/ballistic/musket/taj, /obj/item/storage/box/munition_box, /obj/item/storage/box/munition_box,
	/obj/item/reagent_containers/glass/powder_horn/filled, /obj/item/material/knife/hook, /obj/item/beartrap, /obj/item/clothing/suit/storage/tajaran/coat,
	/obj/item/clothing/head/tajaran/fur, /obj/item/clothing/accessory/permit/gun/nka, /obj/item/stack/medical/crude_pack)
	options["Lumberjack"] = list(/obj/item/material/knife/machete/hatchet, /obj/item/material/twohanded/fireaxe/iron,  /obj/item/clothing/shoes/tajara/workboots,
	/obj/item/clothing/head/tajaran/fur, /obj/item/clothing/suit/storage/hooded/tajaran/cloak/gruff, /obj/item/stack/medical/crude_pack)
	options["Prospector"] = list(/obj/item/pickaxe/icepick, /obj/item/storage/bag/ore, /obj/item/flashlight/lantern, /obj/item/clothing/head/hardhat/orange,
	/obj/item/clothing/suit/storage/hooded/tajaran/cloak/gruff, /obj/item/clothing/shoes/tajara/workboots, /obj/item/stack/medical/crude_pack)
	options["Scavenger"] = list(/obj/item/storage/belt/utility/full, /obj/item/clothing/head/welding, /obj/item/clothing/suit/storage/hooded/tajaran/cloak/gruff,
	/obj/item/clothing/shoes/tajara/workboots/dark, /obj/item/clothing/under/tajaran/mechanic, /obj/item/clothing/gloves/black/tajara/smithgloves,
	/obj/item/reagent_containers/pill/hyronalin, /obj/item/reagent_containers/pill/hyronalin, /obj/item/stack/medical/crude_pack)
	var/choice = input(user,"What is your profession?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn) // Spawn all the things,
			new new_type(get_turf(src))
		if(choice == "Herder")
			to_chat(user, "<i>You are a Herder, back home you tended livestock on a smaller poor homestead. Now you do much the same lightyears away. \
			You have the tools to harvest from the local animals here. You also have cans which can be used to brew some traditional Adhomai drinks. \
			Perhaps the station will barter good things for some homemade Ashomarr'Darr. If not the beasts here should at least provide enough wool \
			and milk to take home. Maybe the station would be interested too as long they aren't buying in worthless Thalers. You should try \
			collecting milk in your bucket before evaporating and canning it. It will save a lot of space. </i>")
		if(choice == "Hunter")
			to_chat(user, "<i>You are a hunter sanctioned by the Baronness to to hunt game in the local region. On Adhomai overhunting and population \
			growth drove much of the game from your home leaving you destitute. Here the game is far more plentiful though life is still harsh. \
			Hunting the creatures here may prove challenging as many are dangerous however as long as you keep your whits about you this journey may \
			prove very profitable indeed. The venom glands of giant spiders maybe of special use to you and the station, or sold to the station for their venom. \
			Hopefully they are willing to pay for them in things that aren't Thalers.</i>")
		if(choice == "Lumberjack")
			to_chat(user, "<i>You are lumberjack from the hinterlands of Adhomai. The forests of your home are heavily depleted and though this \
			place is far from prime forest land it still provides an oppourtunity that home lacked. With your axe and trees all about \
			you are likely to collect a lot of lumber which is hard to transport back to Na'sahira. Trading it to the crew or crafting \
			it into items is probably a better use of your labor.</i>")
		if(choice == "Prospector")
			to_chat(user, "<i>You are a prospector from the hills of Adhomai. As industrialized mining replaced good old fashioned miners and \
			old viens of ore are stripped dry, many miners such as you were left unemployed. However, this planet is mostly untouched and the demand for \
			ore both from Na'sahira and the Nanotrasen station means that there may be good things awaiting those willing to dig it up. It is time to strike the \
			frozen earth and just maybe you can make a good wage when you take the ore back home. The station may be willing to buy ore \
			too as long as they aren't paying in worthless Thalers.</i>")
		if(choice == "Scavenger")
			to_chat(user, "<i>You are rare among the Na'sahira settlers. Hailing from the urban poor you learned to scavenge to survive taking apart \
			all the broken left behind trash of your home city and selling the goods bits for what few pennies people would take it for. On this new \
			planet there is far less to scavenge however, the People's Republic of Adhomai left behind many things in their old facility. \
			As long as you avoid Radiation hotspots you maybe able to bring quite the haul back home if only enough to survive to next week. \
			Perhaps even the station will be interested in some of your finds, as long as they aren't paying in Thalers.</i>")
		qdel(src)
