/datum/role/ghostrole/ashlander
	name = "Ashlander"
	assigned_role = "Ashlander"
	desc = "You are an Ashlander! An old and storied race of subterranean xenos."
	spawntext = "Your tribe still worships the Buried Ones. The wastes are sacred ground, its monsters a blessed bounty - your people have long farmed these creatures. From Goliaths you can harvest fresh meat and hardy leather, and you may breed them using Bentar seeds. Goliaths produce sacred fire powder, which can be milked to replenish certain weapons. Gutshank glands may be milked for water. You would never willingly leave your homeland behind. You have seen lights in the distance - falling from the heavens, and returning. They foreshadow the arrival of outsiders to your domain. Ensure your tribe remains protected at all costs."
	important_info = "The nomadic Ashlanders are a neutral party. The Ashlander race (Scorian), is selected by default. If you accidentally swap, make sure to change it back. Ashlanders are all permadeath characters. They have gray skin of varying hues, red eyes, and - typically - white, black, or brown hair. These options are selectable through the appearance menu, directly below the race block, and above hairstyles. "
	instantiator = /datum/ghostrole_instantiator/human/player_static/ashlander

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

/datum/ghostrole_instantiator/human/player_static/ashlander
	equip_loadout = FALSE
	equip_traits = FALSE
	species_required = /datum/species/scori
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
		/datum/crafting_recipe/sand_whetstone, /datum/crafting_recipe/ashen_vestment, /datum/crafting_recipe/ashen_tabard, /datum/crafting_recipe/heaven_shaker, /datum/crafting_recipe/heaven_shaker_frag,
		/datum/crafting_recipe/goliathcowl, /datum/crafting_recipe/primitive_splint, /datum/crafting_recipe/bone_pipe, /datum/crafting_recipe/spark_striker
		)

/datum/ghostrole_instantiator/human/player_static/ashlander/GetOutfit(client/C, mob/M, list/params)
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

/datum/ghostrole_instantiator/human/player_static/ashlander/AfterSpawn(mob/created, list/params)
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
