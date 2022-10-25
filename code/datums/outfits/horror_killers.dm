/datum/outfit/tunnel_clown
	name = "Tunnel Clown"
	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	gloves = /obj/item/clothing/gloves/black
	mask = /obj/item/clothing/mask/gas/clown_hat
	head = /obj/item/clothing/head/chaplain_hood
	l_ear = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/plain/monocle
	suit = /obj/item/clothing/suit/storage/hooded/chaplain_hoodie
	r_pocket = /obj/item/bikehorn
	r_hand = /obj/item/material/twohanded/fireaxe

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/syndicate/station_access
	id_pda_assignment = "Tunnel Clown!"

/datum/outfit/masked_killer
	name = "Masked Killer"
	uniform = /obj/item/clothing/under/overalls
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/sterile/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	l_ear = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/plain/monocle
	suit = /obj/item/clothing/suit/storage/apron
	l_pocket = /obj/item/material/knife/tacknife
	r_pocket = /obj/item/surgical/scalpel
	r_hand = /obj/item/material/twohanded/fireaxe

/datum/outfit/masked_killer/post_equip(var/mob/living/carbon/human/H)
	var/victim = get_mannequin(H.ckey)
	for(var/obj/item/carried_item in H.get_equipped_items(TRUE))
		carried_item.add_blood(victim) //Oh yes, there will be blood.. just not blood from the killer because that's odd

/datum/outfit/professional
	name = "Professional"
	uniform = /obj/item/clothing/under/suit_jacket{ starting_accessories=list(/obj/item/clothing/accessory/wcoat) }
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/sunglasses
	l_pocket = /obj/item/melee/energy/sword
	mask = /obj/item/clothing/mask/gas/clown_hat

	id_slot = SLOT_ID_WORN_ID
	id_type = /obj/item/card/id/syndicate/station_access
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda/heads

/datum/outfit/professional/post_equip(var/mob/living/carbon/human/H)
	var/obj/item/storage/secure/briefcase/sec_briefcase = new(H)
	for(var/obj/item/briefcase_item in sec_briefcase)
		qdel(briefcase_item)
	for(var/i=3, i>0, i--)
		sec_briefcase.contents += new /obj/item/spacecash/c1000
	sec_briefcase.contents += new /obj/item/gun/energy/crossbow
	sec_briefcase.contents += new /obj/item/gun/projectile/revolver/mateba
	sec_briefcase.contents += new /obj/item/ammo_magazine/s357
	sec_briefcase.contents += new /obj/item/plastique
	H.equip_to_slot_or_del(sec_briefcase, /datum/inventory_slot_meta/abstract/hand/left)

/datum/outfit/samurai
	name = "Vengeful Samurai"
	uniform = /obj/item/clothing/under/color/black
	shoes = /obj/item/clothing/shoes/boots/duty
	gloves = /obj/item/clothing/gloves/black
	mask = /obj/item/clothing/mask/samurai
	head = /obj/item/clothing/head/helmet/samurai
	suit = /obj/item/clothing/suit/armor/samurai
	r_hand = /obj/item/material/sword/katana

/* //Can you tell I commented these out in reverse?
/datum/outfit/samurai/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.add_spell(list(/spell/targeted/ethereal_jaunt, /spell/noclothes))
*/

/datum/outfit/mummy
	name = "Restless Mummy"
	uniform = /obj/item/clothing/under/mummy
	shoes = /obj/item/clothing/shoes/sandal
	mask = /obj/item/clothing/mask/gas/mummy
	head = /obj/item/clothing/head/nemes
	suit = /obj/item/clothing/suit/pharaoh
	r_hand = /obj/item/nullrod/egyptian

/* //Sort out adding spells sometime.
/datum/outfit/mummy/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.add_spell(list(/spell/aoe_turf/disable_tech, /spell/noclothes))
*/

/datum/outfit/scarecrow
	name = "Menacing Scarecrow"
	uniform = /obj/item/clothing/under/scarecrow
	shoes = /obj/item/clothing/shoes/boots/workboots
	gloves = /obj/item/clothing/gloves/botanic_leather
	mask = /obj/item/clothing/mask/gas/scarecrow
	head = /obj/item/clothing/head/scarecrow
	l_pocket = /obj/item/material/knife/machete/hatchet
	r_hand = /obj/item/material/twohanded/fireaxe/scythe

/* //Come back and figure out spells later.
/datum/outfit/mummy/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.add_spell(list(/datum/technomancer/spell/blink, /spell/noclothes))
*/

/datum/outfit/animegirl
	name = "Spurned Classmate"
	uniform = /obj/item/clothing/under/schoolgirl
	shoes = /obj/item/clothing/shoes/hitops/black
	mask = /obj/item/clothing/mask/breath/medical
	head = /obj/item/clothing/head/bunny
	l_ear = /obj/item/radio/headset
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	l_pocket = /obj/item/paper/crumpled
	r_pocket = /obj/item/material/knife/machete/hatchet
	r_hand = /obj/item/material/knife/plasteel

/datum/outfit/animegirl/post_equip(var/mob/living/carbon/human/H)
	var/victim = get_mannequin(H.ckey)
	for(var/obj/item/carried_item in H.get_equipped_items(TRUE))
		carried_item.add_blood(victim)
		H.update_icon() //Same as above.
	. = ..()
