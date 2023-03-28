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
	name = "Bone Spear"
	result = /obj/item/material/twohanded/spear/bone
	time = 30
	reqs = list(/obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/material/twohanded/fireaxe/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 6,
				 /obj/item/stack/sinew = 3)
	category = CAT_PRIMAL
	always_available = FALSE

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
	result = /obj/item/gun/ballistic/bow/ashen
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
	name = "Bone Pickaxe"
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 1)
	result = /obj/item/pickaxe/bone
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/boneshovel
	name = "Serrated Bone Shovel"
	reqs = list(
            /obj/item/stack/material/bone = 4,
            /obj/item/stack/sinew = 1)
	result = /obj/item/shovel/bone
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bonehatchet
	name = "Bone Hatchet"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6,
            /obj/item/stack/sinew = 2)
	result = /obj/item/material/knife/machete/hatchet/bone
	category = CAT_PRIMAL
	always_available = FALSE

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
	name = "Primitive Cautery"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 2,
			/obj/item/elderstone = 1)
	result = /obj/item/surgical/cautery_primitive
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalscalpel
	name = "Primitive Scalpel"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 1,
			/obj/item/material/shard = 1)
	result = /obj/item/surgical/scalpel_primitive
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/primalsaw
	name = "Primitive Bone Saw"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6,
            /obj/item/stack/sinew = 4,
			/obj/item/material/shard = 3)
	result = /obj/item/surgical/saw_primitive
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
	name = "Primitive Crowbar"
	result = /obj/item/tool/crowbar/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 8
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_screwdriver
	name = "Primitive Screwdriver"
	result = /obj/item/tool/screwdriver/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 4,
				/obj/item/stack/sinew = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_wrench
	name = "Primitive Wrench"
	result = /obj/item/tool/wrench/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_wirecutters
	name = "Primitive Wirecutters"
	result = /obj/item/tool/wirecutters/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 4,
				/obj/item/stack/sinew = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/bone_welder
	name = "Primitive Welding Tool"
	result = /obj/item/weldingtool/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 6,
				/obj/item/stack/sinew = 4,
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

/datum/crafting_recipe/saddle
	name = "Hide Saddle"
	result = /obj/item/saddle/shank
	time = 60
	reqs = list(/obj/item/stack/material/bone = 5,
				/obj/item/stack/sinew = 6,
				/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/stone_mortar
	name = "Stone Mortar"
	result = /obj/item/reagent_containers/glass/stone
	time = 40
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 1,
				/obj/item/ore/slag = 1
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
				/obj/item/ore/slag = 5,
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
				/obj/item/ore/slag = 2,
				/obj/item/elderstone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/cooking_spit
	name = "cooking spit"
	result = /obj/machinery/appliance/cooker/grill/spit
	time = 200
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/sinew = 10,
				/obj/item/pen/charcoal = 5
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/stone_dropper
	name = "stone dropper"
	result = /obj/item/reagent_containers/dropper/ashlander
	time = 40
	reqs = list(/obj/item/ore/slag = 1,
				/obj/item/stack/material/bone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_gloves
	name = "goliath hide gloves"
	result = /obj/item/clothing/gloves/goliath
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/tying_post
	name = "bone tying post"
	result = /obj/structure/bed/chair/post
	time = 60
	reqs = list(/obj/item/stack/material/bone = 5,
				/obj/item/stack/sinew = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_mining_satchel
	name = "goliath hide mining satchel"
	result = /obj/item/storage/bag/ore/ashlander
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 6,
				/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 1
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_armor
	name = "ashen lamellar panoply"
	result = /obj/item/clothing/suit/armor/ashlander
	time = 120
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 10,
				/obj/item/stack/sinew = 5,
				/obj/item/stack/material/copper = 10
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_helmet
	name = "ashen lamellar helmet"
	result = /obj/item/clothing/head/helmet/ashlander
	time = 100
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 5,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/material/copper = 5
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_tunic
	name = "coarse tunic"
	result = /obj/item/clothing/under/tribal_tunic/ashlander
	time = 60
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashlander_tunic_fem
	name = "coarse tunic (female)"
	result = /obj/item/clothing/under/tribal_tunic_fem/ashlander
	time = 60
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_plant_bag
	name = "goliath hide plant bag"
	result = /obj/item/storage/bag/plants/ashlander
	time = 20
	reqs = list(/obj/item/stack/animalhide/goliath_hide = 4,
				/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 2
				)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/goliath_halfcloak
	name = "goliath hide half cloak"
	result = /obj/item/clothing/accessory/poncho/rough_cloak/ashlander
	time = 50
	reqs = list(/obj/item/stack/sinew = 1,
				/obj/item/stack/animalhide/goliath_hide = 2)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/sand_whetstone
	name = "ashen whetstone"
	result = /obj/item/whetstone/ashlander
	time = 30
	reqs = list(/obj/item/stack/material/sandstone = 2,
				/obj/item/ore/slag = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashen_vestment
	name = "ashen vestments"
	result = /obj/item/clothing/suit/ashen_vestment
	time = 20
	reqs = list(/obj/item/stack/material/bone = 4,
				/obj/item/stack/animalhide/goliath_hide = 2,
				/obj/item/elderstone = 1)
	category = CAT_PRIMAL
	always_available = FALSE

/datum/crafting_recipe/ashen_tabard
	name = "ashen tabard"
	result = /obj/item/clothing/suit/ashen_tabard
	time = 20
	reqs = list(/obj/item/stack/sinew = 1,
				/obj/item/stack/material/bone = 2,
				/obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL
	always_available = FALSE
