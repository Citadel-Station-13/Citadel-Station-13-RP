/datum/crafting_recipe/bonetalisman
	name = "Bone Talisman"
	result = /obj/item/clothing/accessory/talisman
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonecodpiece
	name = "Skull Codpiece"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bracers
	name = "Bone Bracers"
	result = /obj/item/clothing/gloves/bracer
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliathcloak
	name = "Goliath Cloak"
	result = /obj/item/clothing/suit/storage/hooded/cloak/goliath
	time = 50
	reqs = list(/obj/item/stack/sinew = 2,
				/obj/item/stack/animalhide/goliath_hide = 4)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/drakecloak
	name = "Ash Drake Armour"
	result = /obj/item/clothing/suit/storage/hooded/cloak/drake
	time = 60
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/animalhide/ashdrake = 5)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonebag
	name = "Bone Satchel"
	result = /obj/item/storage/backpack/satchel/bone
	time = 30
	reqs = list(/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 2)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonespear
	name = "Bronze Spear"
	result = /obj/item/material/twohanded/spear/bronze
	time = 30
	reqs = list(/obj/item/stack/material/copper = 2,
				 /obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/boneaxe
	name = "Bronze Battleaxe"
	result = /obj/item/material/twohanded/fireaxe/bronze
	time = 50
	reqs = list(/obj/item/stack/material/copper = 8,
				/obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 3)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/bonesword
	name = "Bone Sword"
	result = /obj/item/melee/ashlander
	time = 100
	reqs = list(/obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 1,
				 /obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonesword_elder
	name = "Bone Sword (Elder)"
	result = /obj/item/melee/ashlander/elder
	time = 100
	reqs = list(/obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 1,
				 /obj/item/elderstone = 1,
				 /obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/sinew_line
	name = "Sinew Fishing Line Reel"
	result = /obj/item/fishing_line/sinew
	reqs = list(/obj/item/stack/sinew = 2)
	time = 2 SECONDS
	category = CAT_PRIMAL

/datum/crafting_recipe/bone_hook
	name = "Goliath Bone Hook"
	result = /obj/item/fishing_hook/bone
	reqs = list(/obj/item/stack/material/bone = 1)
	time = 2 SECONDS
	category = CAT_PRIMAL

/datum/crafting_recipe/bone_rod
	name = "Bone Fishing Rod"
	result = /obj/item/fishing_rod/bone
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/material/leather = 1,
		/obj/item/stack/sinew = 2,
		/obj/item/stack/material/bone = 2,
	)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 60
	reqs = list(/obj/item/stack/material/log = 5)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/* Commenting these out until we have decapitation on this server.
/datum/crafting_recipe/headpike
	name = "Spike Head (Glass Spear)"
	time = 65
	reqs = list(/obj/item/material/twohanded/spear = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/material/twohanded/spear = 1)
	result = /obj/structure/headpike
	category = CAT_PRIMAL

/datum/crafting_recipe/headpikebone
	name = "Spike Head (Bone Spear)"
	time = 65
	reqs = list(/obj/item/material/twohanded/spear/bone = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/material/twohanded/spear/bone = 1)
	result = /obj/structure/headpike/bone
	category = CAT_PRIMAL
*/

/datum/crafting_recipe/quiver
	name = "Quiver"
	result = /obj/item/storage/belt/quiver
	time = 80
	reqs = list(/obj/item/stack/material/leather = 3,
				 /obj/item/stack/sinew = 4)
	category = CAT_PRIMAL
	always_available = TRUE

/datum/crafting_recipe/quiver_ashlander
	name = "Ashlander Quiver"
	result = /obj/item/storage/belt/quiver
	time = 80
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 3,
				 /obj/item/stack/sinew = 4)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_bow
	name = "Bone Bow"
	result = /obj/item/gun/projectile/ballistic/bow/ashen
	time = 120 // 80+120 = 200
	reqs = list(/obj/item/stack/material/bone = 8,
				 /obj/item/stack/sinew = 4)
	category = CAT_PRIMAL
	always_available = FALSE

/* Leaving this out until I decide to fuck with the recipe knowledge stuff.
/datum/crafting_recipe/bow_tablet
	name = "Sandstone Bow Making Manual"
	result = /obj/item/book/granter/crafting_recipe/bone_bow
	time = 200 //Scribing // don't care
	always_available = FALSE
	reqs = list(/obj/item/stack/rods = 1,
				 /obj/item/stack/sheet/mineral/sandstone = 4)
	category = CAT_PRIMAL
*/

/datum/crafting_recipe/rib
	name = "Collosal Rib"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 10
            //datum/reagent/crude_oil = 5
			)
	result = /obj/structure/statue/bone
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/skull
	name = "Skull Carving"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6
            //datum/reagent/crude_oil = 5
			)
	result = /obj/structure/statue/bone/skull
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/halfskull
	name = "Cracked Skull Carving"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3
            ///datum/reagent/crude_oil = 5
			)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonepickaxe
	name = "Bronze Pickaxe"
	reqs = list(
			/obj/item/stack/material/copper = 5,
            /obj/item/stack/material/bone = 2,
            /obj/item/stack/sinew = 1)
	result = /obj/item/pickaxe/bronze
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/boneshovel
	name = "Bronze Shovel"
	reqs = list(
			/obj/item/stack/material/copper = 3,
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 1)
	result = /obj/item/shovel/bronze
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/bonehatchet
	name = "Bronze Hatchet"
	//always_available = FALSE
	reqs = list(
			/obj/item/stack/material/copper = 4,
            /obj/item/stack/material/bone = 2,
            /obj/item/stack/sinew = 2)
	result = /obj/item/material/knife/machete/hatchet/bronze
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/boneknife
	name = "Bone Knife"
	reqs = list(
            /obj/item/stack/material/bone = 5)
	result = /obj/item/material/knife/tacknife/combatknife/bone
	category = CAT_PRIMAL
	always_available = TRUE
	tools = list(TOOL_SCREWDRIVER) //Everyone can craft this one.

//Surgical Tools - I've added these to this crafting menu after I found the sprites on Main and brought them over for the novelty.
/datum/crafting_recipe/primalretractor
	name = "Primitive Retractor"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 5,
            /obj/item/stack/sinew = 2)
	result = /obj/item/surgical/retractor_primitive
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalhemostat
	name = "Primitive Hemostat"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 4,
            /obj/item/stack/sinew = 3)
	result = /obj/item/surgical/hemostat_primitive
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalcautery
	name = "Elder's Sealer (Cautery)"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 2,
			/obj/item/elderstone = 1)
	result = /obj/item/surgical/cautery_scori
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalscalpel
	name = "Bronze Scalpel"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/copper = 2,
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 1)
	result = /obj/item/surgical/scalpel_bronze
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/primalsaw
	name = "Bronze Saw"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 4,
			/obj/item/stack/material/copper = 5)
	result = /obj/item/surgical/saw_bronze
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalsetter
	name = "Primitive Bone Setter"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 5,
            /obj/item/stack/sinew = 3)
	result = /obj/item/surgical/bonesetter_primitive
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_crowbar
	name = "Bronze Crowbar"
	result = /obj/item/tool/crowbar/bronze
	time = 50
	reqs = list(
			/obj/item/stack/material/copper = 6,
			/obj/item/stack/sinew = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER)

/datum/crafting_recipe/bone_screwdriver
	name = "Bronze Chisel (Screwdriver)"
	result = /obj/item/tool/screwdriver/bronze
	time = 50
	reqs = list(/obj/item/stack/material/copper = 2,
				/obj/item/stack/material/bone = 2,
				/obj/item/stack/sinew = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_wrench
	name = "Bronze Wrench"
	result = /obj/item/tool/wrench/bronze
	time = 50
	reqs = list(/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)

/datum/crafting_recipe/bone_wirecutters
	name = "Bronze Shears (Wirecutters/Clippers)"
	result = /obj/item/tool/wirecutters/bronze
	time = 50
	reqs = list(/obj/item/stack/material/copper = 4,
				/obj/item/stack/sinew = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER)

/datum/crafting_recipe/bone_welder
	name = "Elder's Bellows (Welder)"
	result = /obj/item/weldingtool/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 4,
				/obj/item/stack/animalhide/goliath_hide = 2,
				/obj/item/stack/sinew = 2,
				/obj/item/elderstone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/munition_box
	name = "Primitive Munitions Box"
	result = /obj/item/storage/box/munition_box/empty
	time = 40
	reqs = list(/obj/item/stack/material/bone = 2,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/animalhide/goliath_hide = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/powder_horn
	name = "Bone Powder Horn"
	result = /obj/item/reagent_containers/glass/powder_horn/tribal
	time = 40
	reqs = list(/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 3
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/saddle_shank
	name = "Saddle (Goliath Hide)"
	result = /obj/item/saddle/shank
	time = 60
	reqs = list(/obj/item/stack/material/bone = 5,
				/obj/item/stack/sinew = 6,
				/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/saddle_stormdrifter
	name = "Saddle (Harness and Gondola)"
	result = /obj/item/saddle/stormdrifter
	time = 60
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/material/chitin = 5,
				/obj/item/stack/sinew = 10,
				/obj/item/stack/animalhide/goliath_hide = 5
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/stone_mortar
	name = "Stone Mortar"
	result = /obj/item/reagent_containers/glass/stone
	time = 40
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 1,
				/obj/item/stack/ore/slag = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/blessed_boat
	name = "Blessed Boat"
	result = /obj/vehicle/ridden/boat/ashlander
	time = 500
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 10,
				/obj/item/stack/material/bone = 10,
				/obj/item/stack/sinew = 5,
				/obj/item/elderstone = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/blessed_oar
	name = "Blessed Boat"
	result = /obj/item/oar/ashlander
	time = 50
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/animalhide/goliath_hide = 5,
				/obj/item/stack/sinew = 2,
				/obj/item/elderstone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_curtain
	name = "Goliath hide curtain"
	result = /obj/structure/curtain/ashlander
	time = 20
	reqs = list(/obj/item/stack/material/bone = 1,
				/obj/item/stack/animalhide/goliath_hide = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/alchemy_station
	name = "Basic Alchemical Station"
	result = /obj/machinery/reagentgrinder/ashlander
	time = 120
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/ore/slag = 5,
				/obj/item/stack/sinew = 5,
				/obj/item/reagent_containers/glass/stone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/calcinator
	name = "Calcinator"
	result = /obj/structure/ashlander/calcinator
	time = 60
	reqs = list(/obj/item/stack/material/bone = 5,
				/obj/item/stack/ore/slag = 2,
				/obj/item/elderstone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/cooking_spit
	name = "Cooking Spit"
	result = /obj/machinery/appliance/cooker/grill/spit
	time = 200
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/sinew = 10,
				/obj/item/pen/charcoal = 5
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/stone_dropper
	name = "Primitive Dropper"
	result = /obj/item/reagent_containers/dropper/ashlander
	time = 40
	reqs = list(/obj/item/stack/material/copper = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_gloves
	name = "Goliath Hide Gloves"
	result = /obj/item/clothing/gloves/goliath
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/tying_post
	name = "Bone Tying Post"
	result = /obj/structure/bed/chair/post
	time = 60
	reqs = list(/obj/item/stack/material/bone = 5,
				/obj/item/stack/sinew = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_mining_satchel
	name = "Goliath Hide Mining Satchel"
	result = /obj/item/storage/bag/ore/ashlander
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 6,
				/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_armor
	name = "Ashen Lamellar Panoply"
	result = /obj/item/clothing/suit/armor/ashlander
	time = 120
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 10,
				/obj/item/stack/sinew = 5,
				/obj/item/stack/material/copper = 10
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/ashlander_helmet
	name = "Ashen Lamellar Helmet"
	result = /obj/item/clothing/head/helmet/ashlander
	time = 100
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 5,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/material/copper = 5
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/ashlander_tunic
	name = "Coarse Tunic"
	result = /obj/item/clothing/under/tribal_tunic/ashlander
	time = 60
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_tunic_fem
	name = "Coarse Tunic (female)"
	result = /obj/item/clothing/under/tribal_tunic_fem/ashlander
	time = 60
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/goliath_plant_bag
	name = "Goliath Hide Plant Bag"
	result = /obj/item/storage/bag/plants/ashlander
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4,
				/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/goliath_halfcloak
	name = "Goliath Hide Half Cloak"
	result = /obj/item/clothing/accessory/poncho/rough_cloak/ashlander
	time = 50
	reqs = list(/obj/item/stack/sinew = 1,
				/obj/item/stack/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/sand_whetstone
	name = "Ashen Whetstone"
	result = /obj/item/whetstone/ashlander
	time = 30
	reqs = list(/obj/item/stack/material/sandstone = 2,
				/obj/item/stack/ore/slag = 1)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/ashen_vestment
	name = "Ashen Vestments"
	result = /obj/item/clothing/suit/ashen_vestment
	time = 20
	reqs = list(/obj/item/stack/material/bone = 4,
				/obj/item/stack/animalhide/goliath_hide = 2,
				/obj/item/elderstone = 1)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/ashen_tabard
	name = "Ashen Tabard"
	result = /obj/item/clothing/suit/ashen_tabard
	time = 20
	reqs = list(/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 2,
				/obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/heaven_shaker
	name = "Heaven Shaker"
	result = /obj/item/grenade/simple/explosive/ashlander
	time = 300
	reqs = list(/obj/item/reagent_containers/glass/bucket/sandstone = 1,
				/obj/item/condensedphlogiston = 3,
				/obj/item/elderstone = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/heaven_shaker_frag
	name = "Heaven Shaker (fragmentation)"
	result = /obj/item/grenade/simple/explosive/ashlander/fragmentation
	time = 300
	reqs = list(/obj/item/reagent_containers/glass/bucket/sandstone = 1,
				/obj/item/condensedphlogiston = 3,
				/obj/item/stack/ore/slag = 2,
				/obj/item/elderstone = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliathcowl
	name = "Goliath Hide Cowl"
	result = /obj/item/clothing/head/cowl/goliath
	time = 30
	reqs = list(/obj/item/stack/sinew = 1,
				/obj/item/stack/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/primitive_splint
	name = "Primitive Splints"
	result = /obj/item/stack/medical/splint/primitive
	time = 50
	reqs = list(/obj/item/stack/sinew = 5,
				/obj/item/stack/material/bone = 10)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/bone_pipe
	name = "Bone Pipe"
	result = /obj/item/clothing/mask/smokable/pipe/bonepipe
	time = 30
	reqs = list(/obj/item/stack/material/bone = 1)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_SCREWDRIVER)

/datum/crafting_recipe/spark_striker
	name = "Spark Striker"
	result = /obj/item/flame/lighter/ashlander
	time = 30
	reqs = list(/obj/item/stack/sinew = 2,
				/obj/item/stack/material/bone = 2,
				/obj/item/pen/charcoal = 1,
				/obj/item/elderstone = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/skull_mask
	name = "Bone Mask (Skull)"
	result = /obj/item/clothing/mask/skull
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				/obj/item/stack/sinew = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/alchemy_bandolier
	name = "Alchemy Bandolier"
	result = /obj/item/clothing/accessory/storage/ashlander_alchemy
	time = 40
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 5,
				/obj/item/stack/material/bone = 2,
				/obj/item/stack/sinew = 2)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

/datum/crafting_recipe/ashlander_sandals
	name = "Leather Sandals"
	result = /obj/item/clothing/shoes/ashwalker
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)

//Make this one cloth once I give Ashies a cloth plant? If I do??
/datum/crafting_recipe/ashlander_wraps
	name = "Hide Footwraps"
	result = /obj/item/clothing/shoes/footwraps
	time = 10
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL
	always_available = FALSE
	tools = list(TOOL_WIRECUTTER)
