/datum/crafting_recipe/bonetalisman
	name = "Bone Talisman"
	result = /obj/item/clothing/accessory/talisman
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonecodpiece
	name = "Skull Codpiece"
	result = /obj/item/clothing/accessory/skullcodpiece
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/animalhide/goliath_hide = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/bracers
	name = "Bone Bracers"
	result = /obj/item/clothing/gloves/bracer
	time = 20
	reqs = list(/obj/item/stack/material/bone = 2,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/goliathcloak
	name = "Goliath Cloak"
	result = /obj/item/clothing/suit/storage/hooded/cloak/goliath
	time = 50
	reqs = list(/obj/item/stack/material/leather = 2,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/animalhide/goliath_hide = 2) //it takes 4 goliaths to make 1 cloak if the plates are skinned
	category = CAT_PRIMAL

/datum/crafting_recipe/drakecloak
	name = "Ash Drake Armour"
	result = /obj/item/clothing/suit/storage/hooded/cloak/drake
	time = 60
	reqs = list(/obj/item/stack/material/bone = 10,
				/obj/item/stack/sinew = 2,
				/obj/item/stack/animalhide/ashdrake = 5)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonebag
	name = "Bone Satchel"
	result = /obj/item/storage/backpack/satchel/bone
	time = 30
	reqs = list(/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 2)
	category = CAT_PRIMAL

/datum/crafting_recipe/bonespear
	name = "Bone Spear"
	result = /obj/item/material/twohanded/spear/bone
	time = 30
	reqs = list(/obj/item/stack/material/bone = 4,
				 /obj/item/stack/sinew = 1)
	category = CAT_PRIMAL

/datum/crafting_recipe/boneaxe
	name = "Bone Axe"
	result = /obj/item/material/twohanded/fireaxe/bone
	time = 50
	reqs = list(/obj/item/stack/material/bone = 6,
				 /obj/item/stack/sinew = 3)
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

/datum/crafting_recipe/bone_bow
	name = "Bone Bow"
	result = /obj/item/gun/projectile/bow/ashen
	time = 120 // 80+120 = 200
	reqs = list(/obj/item/stack/material/bone = 8,
				 /obj/item/stack/sinew = 4)
	category = CAT_PRIMAL

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
            /obj/item/stack/material/bone = 10,
            /datum/reagent/oil = 5)
	result = /obj/structure/statue/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/skull
	name = "Skull Carving"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6,
            /datum/reagent/oil = 5)
	result = /obj/structure/statue/bone/skull
	category = CAT_PRIMAL

/datum/crafting_recipe/halfskull
	name = "Cracked Skull Carving"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /datum/reagent/oil = 5)
	result = /obj/structure/statue/bone/skull/half
	category = CAT_PRIMAL

/datum/crafting_recipe/boneshovel
	name = "Serrated Bone Shovel"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 4,
            /datum/reagent/oil = 5,
            /obj/item/shovel = 1)
	result = /obj/item/shovel/bone
	category = CAT_PRIMAL

/datum/crafting_recipe/bonehatchet
	name = "Bone Hatchet"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6,
            /obj/item/stack/sinew = 2)
	result = /obj/item/material/knife/machete/hatchet/bone
	category = CAT_PRIMAL

//Surgical Tools - I've added these to this crafting menu after I found the sprites on Main and brought them over for the novelty.
/datum/crafting_recipe/primalretractor
	name = "Primitive Retractor"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 5,
            /obj/item/stack/sinew = 2)
	result = /obj/item/surgical/retractor_primitive
	category = CAT_PRIMAL

/datum/crafting_recipe/primalhemostat
	name = "Primitive Hemostat"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 4,
            /obj/item/stack/sinew = 3)
	result = /obj/item/surgical/hemostat_primitive
	category = CAT_PRIMAL

/datum/crafting_recipe/primalcautery
	name = "Primitive Cautery"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 2,
			/obj/item/soulstone = 1)
	result = /obj/item/surgical/cautery_primitive
	category = CAT_PRIMAL

/datum/crafting_recipe/primalscalpel
	name = "Primitive Scalpel"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 3,
            /obj/item/stack/sinew = 1,
			/obj/item/material/shard = 1)
	result = /obj/item/surgical/scalpel_primitive
	category = CAT_PRIMAL

/datum/crafting_recipe/primalsaw
	name = "Primitive Bone Saw"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 6,
            /obj/item/stack/sinew = 4,
			/obj/item/material/shard = 3)
	result = /obj/item/surgical/saw_primitive
	category = CAT_PRIMAL

/datum/crafting_recipe/primalsetter
	name = "Primitive Bone Setter"
	//always_available = FALSE
	reqs = list(
            /obj/item/stack/material/bone = 5,
            /obj/item/stack/sinew = 3)
	result = /obj/item/surgical/bonesetter_primitive
	category = CAT_PRIMAL
