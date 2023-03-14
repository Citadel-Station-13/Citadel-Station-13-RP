/datum/role/ghostrole/ashlander
	name = "Ashlander"
	assigned_role = "Ashlander"
	desc = "You are an Ashlander! An old and storied race of subterranean xenos."
	spawntext = "Your tribe still worships the Buried Ones. The wastes are sacred ground, its monsters a blessed bounty - your people have long farmed these creatures. From Goliaths you can harvest fresh meat and hardy leather, and you may breed them using Bentar seeds. Goliaths produce sacred fire powder, which can be milked to replenish certain weapons. Gutshank glands may be milked for water. You would never willingly leave your homeland behind. You have seen lights in the distance - falling from the heavens, and returning. They foreshadow the arrival of outsiders to your domain. Ensure your tribe remains protected at all costs."
	important_info = "The nomadic Ashlanders are a neutral party. The Ashlander race (Scorian), is selected by default. If you accidentally swap, make sure to change it back. Ashlanders are all permadeath characters. They have gray skin of varying hues, red eyes, and - typically - white, black, or brown hair. These options are selectable through the appearance menu, directly below the race block, and above hairstyles. "
	instantiator = /datum/ghostrole_instantiator/human/random/species/ashlander

/datum/role/ghostrole/ashlander/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 7)
	switch(rp)
		if(1)
			params["fluff"] = "nomad"
		if(2)
			params["fluff"] = "craftsman"
		if(3)
			params["fluff"] = "farmer"
		if(4)
			params["fluff"] = "hunter"
		if(5)
			params["fluff"] = "merchant"
		if(6)
			params["fluff"] = "sentry"
		if(7)
			params["fluff"] = "priest"
	return ..()

/datum/role/ghostrole/ashlander/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "<i>Fine particles of ash slip past the fluttering Goliath hide covering your doorway to settle on the floor of the yurt. \
	The hide is patched, and worn from years of use - it was gifted to you many Storms ago. Outside, the baking heat of the planet's surface \
	sends howling winds across your threshold. Leaning back against a pile of tanned hide, you peer upwards through the roof at the ever-scarlet \
	sky. Your mind drifts to how you came to be here...</i>"
	switch(params["fluff"])

		if("nomad")
			flavour_text += "<i>For many storms you have been a traveler of the Deep Veins. Though many of your kin have welcomed you into their tribes, you have ever \
			been little more than a visitor. The call to explore this sacred land drives you ever onward. You have ridden Shanks across the great Ash Dunes of Karaktahz. \
			You charted many courses over the Sunlight Sea by the fleeting light of the Risen One. Even now, after calamity has driven you and your kin back to the surface \
			in greater numbers, you readily traverse these familiar wastes. The people of this village have accepted you warmly, but you know you will not stay for long. </i>"
		if("craftsman")
			flavour_text += "<i>The blood of the Mother coursed freely through the Vein in which you were born. The darkness of those volcanic caverns has been familiar to \
			you from birth. Unlike others in your tribe, you saw more in the Veins than simple rock and ore. When you came of age you apprenticed under a craftsman whose art \
			spoke to your soul. Now, years later, you have found yourself upon the surface. The Calamity has driven many tribes out of the Veins and back out under open sky. \
			Fortunately, the Buried Ones provide, and there are caverns and ore aplenty. The people of this village will always require more tools, more metal, more brick. \
			Your artisanry is as appreciated in this unfamiliar plain as it was deep below the bedrock of the world.</i>"
		if("farmer")
			flavour_text += "Your kin are all familiar with the Mother's other children. From the humble Gutshank to the fearsome Goliath, your people have existed in harmony \
			with these beasts for storms beyond counting. However, while others may simply be familiar, you have spent your life studying and understanding these beasts. For \
			perhaps your entire life, you have tended to crops and beasts alike. In the village you are respected for your expertise, and trusted with many of the tasks of animal \
			husbandry, from breeding to butchering. In your art you have perhaps found the simple satisfaction of life itself.</i>"
		if("hunter")
			flavour_text += "<i>When the Calamity struck, you had already been exploring the surface. Down in the Deep Veins, farmlands have grown sour and the Mother's blood \
			has been bursting forth to swallow whole tribes. The priesthood correctly predicted the misfortune to come, and dispatched you and many others to the land above to \
			hunt for more fruitful game. Now, however, you find that your solitary life in the wastes has come to an end. Driven up to reside on the surface, your tribe has now \
			erected this village in the style of home, in the remnants of a forgotten beast. Although you are no longer on your own, you may hardly rest. The hunt goes on. </i>"
		if("merchant")
			flavour_text += "The sands of the great Ash Wastes move about with every Storm. The borders of the Sunlight Sea shift forever to and fro. The Deep Veins are \
			treacherous, and the disquiet of the Buried Ones has recently begun to shake the very soil. Due to this constant cycle of upheaval, very few choose to take on \
			the burdens of a merchant. Convoys are frequently delayed - and sometimes lost - on great mercantile expeditions. At the end of the path? Bartering and squabbling, \
			and some fair few cubes of copper. You came to this village to trade, for the Mother has blessed these lands. Tonight you seek peace. Tomorrow, fortune.</i>"
		if("sentry") //Credit to YourDoom for inspiring this role.
			flavour_text += "<i>By now you've heard the tale a hundred times. The story of how the first Corrupted spilled down through the warrens, slaying and infecting \
			all they could touch. You fought to drive them back, protecting your own tribe through many perilous storms. When at last the threat of the Corrupted had been \
			divined by the priesthood, and exorcised, you had expected to find some relief at last. Too soon the Cataclysm came to drive you and your tribe from your home. \
			Now, living on the surface, you find that your sacred duties remain largely the same: protect the tribe from any threat, and honor the priesthood."
		if("priest")
			flavour_text += "<i>Many are the secrets known to you. You have learned the names of the Buried Ones, who lay in waiting repose beneath the Stones Below. You \
			walked the Path of Blue Flame, and sought out forbidden mysteries in the Tomb of the Risen One. When the Corrupted washed over your people like a plague, you strove \
			to guide them through it. When the foretold Calamity struck, it was you and your brethren who guided the tribes to the surface. The firey wrath of the Mother vomited \
			you all up into the wastes. You feel the weight of the holy tools granted to you by the Buried Ones. They are worth more than your life. Guide your people well.</i>"
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/species/ashlander
	possible_species = list(
		/datum/species/scori
	)
	var/list/ashlander_crafting = list(/datum/crafting_recipe/bonetalisman, /datum/crafting_recipe/bonecodpiece, /datum/crafting_recipe/bracers, /datum/crafting_recipe/goliathcloak,
		/datum/crafting_recipe/drakecloak, /datum/crafting_recipe/bonebag, /datum/crafting_recipe/bonespear, /datum/crafting_recipe/boneaxe, /datum/crafting_recipe/bone_bow,
		/datum/crafting_recipe/quiver_ashlander, /datum/crafting_recipe/rib, /datum/crafting_recipe/skull, /datum/crafting_recipe/halfskull, /datum/crafting_recipe/boneshovel, /datum/crafting_recipe/bonehatchet,
		/datum/crafting_recipe/primalretractor, /datum/crafting_recipe/primalhemostat, /datum/crafting_recipe/primalcautery, /datum/crafting_recipe/primalscalpel, /datum/crafting_recipe/primalsaw,
		/datum/crafting_recipe/primalsetter, /datum/crafting_recipe/bone_crowbar, /datum/crafting_recipe/bone_screwdriver, /datum/crafting_recipe/bone_wrench, /datum/crafting_recipe/bone_wirecutters,
		/datum/crafting_recipe/bone_welder, /datum/crafting_recipe/munition_box, /datum/crafting_recipe/powder_horn, /datum/crafting_recipe/bonesword, /datum/crafting_recipe/bonesword_elder,
		/datum/crafting_recipe/saddle, /datum/crafting_recipe/bonepickaxe, /datum/crafting_recipe/alchemy_station, /datum/crafting_recipe/calcinator, /datum/crafting_recipe/cooking_spit,
		/datum/crafting_recipe/stone_dropper, /datum/crafting_recipe/goliath_gloves, /datum/crafting_recipe/stone_mortar, /datum/crafting_recipe/bone_arrow, /datum/crafting_recipe/hard_bone_arrow,
		/datum/crafting_recipe/goliath_mining_satchel, /datum/crafting_recipe/ashlander_armor, /datum/crafting_recipe/ashlander_helmet, /datum/crafting_recipe/ashlander_tunic,
		/datum/crafting_recipe/ashlander_tunic_fem, /datum/crafting_recipe/tying_post, /datum/crafting_recipe/goliath_curtain, /datum/crafting_recipe/goliath_plant_bag, /datum/crafting_recipe/goliath_halfcloak,
		/datum/crafting_recipe/sand_whetstone, /datum/crafting_recipe/ashen_vestment, /datum/crafting_recipe/ashen_tabard
		)

/datum/ghostrole_instantiator/human/random/species/ashlander/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	switch(params["fluff"])
		if("nomad")
			return /datum/outfit/ashlander/nomad
		if("craftsman")
			return /datum/outfit/ashlander/craftsman
		if("farmer")
			return /datum/outfit/ashlander/farmer
		if("hunter")
			return /datum/outfit/ashlander/hunter
		if("merchant")
			return /datum/outfit/ashlander/merchant
		if("sentry")
			return /datum/outfit/ashlander/sentry
		if("priest")
			return /datum/outfit/ashlander/priest
	return outfit

/datum/ghostrole_instantiator/human/random/species/ashlander/AfterSpawn(mob/created, list/params)
	. = ..()
	created.faction = "lavaland"
	created.mind.teach_crafting_recipe(ashlander_crafting)
	created.remove_language(/datum/language/common)

/obj/structure/ghost_role_spawner/ashlander
	name = "ashlander yurt"
	desc = "A coarse leather tent. Squat and vaguely onion shaped, the thick red hide acting as a door covering flaps in the warm breeze. It seems like it could easily be dismantled and moved. A strange red icon shaped out of sinew and leather hangs over the doorway."
	icon = 'icons/obj/lavaland.dmi'
	icon_state = "yurt"
	anchored = TRUE
	density = TRUE
	role_type = /datum/role/ghostrole/ashlander
	role_spawns = 1
	//var/datum/team/ashlanders/team

//This is the old backstory data. I'm retaining it in case we've ever got a use for it in the future!
/*
/datum/ghostrole/ashlander/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 4)
	switch(rp)
		if(1)
			params["fluff"] = "nomad"
		if(2)
			params["fluff"] = "hunter"
		if(3)
			params["fluff"] = "exile"
		if(4)
			params["fluff"] = "sentry"
	return ..()

/datum/role/ghostrole/ashlander/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "<i>Fine particles of ash slip past the fluttering Goliath hide covering your doorway to settle on the floor of the yurt. \
	The hide is patched, and worn from years of use - it was gifted to you many Storms ago. Outside, the baking heat of the planet's surface \
	sends howling winds across your threshold. Leaning back against a pile of tanned hide, you peer upwards through the roof at the ever-scarlet \
	sky. Your mind drifts to how you came to be here...</i>"
	switch(params["fluff"])
		if("nomad")
			flavour_text += "<i>You served the caravan as a [pick("trader", "butcher", "shaman")], and much was the joy to be found in crossing the Mother's plains. \
			The caravan moved ever onwards, settling only when the skies were right and the omens favorable. You trekked across the deceptive Ash Dunes, and \
			paddled across the Sunlight Sea in a blessed vessel. There was great comfort in the caravan. Until one day, when a great ash storm rose up and drove \
			you from their warm embrace. Lost and alone, you set up this yurt and resolved to wait until your tribesmen could find you.</i>"
		if("hunter")
			flavour_text += "<i>You have long bemoaned life in the Deep Veins. These ancient caverns have been home to your people since the beginning of time. \
			The farms have not been doing well these last few Storms. The Mother heaves and vomits her firey blood into passages which have been untouched \
			for centuries. The priests foretell an impending cataclysm, but such concerns are beyond you. With the farms failing, you and many others have been \
			sent to the surface, to find whatever game you may. So it is that you shelter in this yurt and rest before the next hunt.</i>"
		if("exile")
			flavour_text += "<i>You had always imagined yourself a good steward. Loyal to the [pick("tribe", "caravan")], it came as a great shock to you and your \
			kinsmen when the priests declared you a sinner. For the crime of [pick("murder", "theft", "blasphemy")] you were cast out. Left with nothing but your \
			wits and your strength, you have long traversed this world alone. The brand on your chest marks you among all who may find you - Exile. This simple \
			yurt has become your latest haven. Rarely do others come across you here - a blessing, and a curse.</i>"
		if("sentry") //Credit to YourDoom for writing this one! <3
			flavour_text += "<i>You were one of the [pick("tribe", "caravan")]'s most reliable guards. It was your sacred duty to keep the Mother's \
			more dangerous children away from those you called family. However, the new threat of the Corrupted has thrown daily life into disarray. The priests \
			believe these abominations are the harbingers of an impending cataclysm - they were right. A twisted horde of Corrupted overwhelmed your post as \
			you slept. In the ensuing battle, a tunnel collapse separated you from your charges. Alone, you shelter in this yurt and wait for your kin to return.</i>"
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/species/ashlander/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	switch(params["fluff"])
		if("nomad")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic/ashlander
			outfit.shoes = /obj/item/clothing/shoes/footwraps
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/storage/backpack/satchel/bone
			outfit.r_hand = /obj/item/material/twohanded/spear/bone
		if("hunter")
			outfit.uniform = /obj/item/clothing/under/gladiator/ashlander
			outfit.head = /obj/item/clothing/head/helmet/gladiator/ashlander
			outfit.shoes = /obj/item/clothing/shoes/ashwalker
			outfit.back = /obj/item/gun/ballistic/bow/ashen
			outfit.belt = /obj/item/storage/belt/quiver/full/ash
			outfit.r_hand = /obj/item/material/knife/tacknife/combatknife/bone
		if("exile")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic/ashlander
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/bo_staff
		if("sentry")
			outfit.uniform = /obj/item/clothing/under/gladiator/ashlander
			outfit.shoes = /obj/item/clothing/shoes/ashwalker
			outfit.belt = /obj/item/reagent_containers/glass/powder_horn/tribal
			outfit.back = /obj/item/storage/backpack/satchel/bone
			outfit.r_hand = /obj/item/gun/ballistic/musket/tribal
			outfit.l_hand = /obj/item/storage/box/munition_box
	return outfit
*/


//This is stuff from the port that just didn't seem like it belonged in my imagining of Ashlanders.
/*
/obj/structure/ghost_role_spawner/ashlander/Destroy()
	new /obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()

//This all appears to be /tg/ flavored stuff. Retaining in case we want to use it later.
	var/turf/T = get_turf(created)
	if(is_mining_level(T.z))
		to_chat(created, "<b>Drag the corpses of men and beasts to your yurt. The bounty may attract more of your tribe. Glory to the Buried Ones!</b>")
		to_chat(created, "<b>You can expand the weather proof area provided by your shelters by using the 'New Area' key near the bottom right of your HUD.</b>")
	else
		to_chat(created, "<span class='userdanger'>You have awoken outside of your natural home! Whether you decide to return below the surface, or make due with your current surroundings is your own decision.</span>")

/datum/role/ghostrole/ashlander/AllowSpawn(client/C, list/params)
	if(params && params["team"])
		var/datum/team/ashlanders/team = params["team"]
		if(C.ckey in team.players_spawned)
			to_chat(C, span_warning("<b>You have exhausted your usefulness to the tribe</b>."))
			return FALSE
	return ..()

/datum/role/ghostrole/ashlander/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	if(params["team"])
		var/datum/team/ashlanders/team = spawnpoint.params["team"]
		team.players_spawned += ckey(created.key)
		created.mind.add_antag_datum(/datum/antagonist/ashlander, team)

/obj/structure/ghost_role_spawner/ashlander/Destroy()
	var/mob/living/carbon/human/yolk = new /mob/living/carbon/human/(get_turf(src))
	yolk.fully_replace_character_name(null,random_name(gender))
	yolk.set_species(/datum/species/human/ashlander)
	yolk.underwear = "Nude"
	yolk.equipOutfit(/datum/outfit/ashlander)//this is an authentic mess we're making
	yolk.update_body()
	yolk.gib()
	return ..()
*/
