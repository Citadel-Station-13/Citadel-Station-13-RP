/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/obj/item/surgical
	name = "Surgical tool"
	desc = "This shouldn't be here, ahelp it."
	icon = 'icons/obj/surgery.dmi'
	w_class = ITEMSIZE_SMALL
	item_flags = ITEM_CAREFUL_BLUDGEON
	var/helpforce = 0	//For help intent things
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'

/*
 * Retractor
 */

/obj/item/surgical/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon_state = "retractor"
	matter = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/*
 * Hemostat
 */
/obj/item/surgical/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon_state = "hemostat"
	matter = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/*
 * Cautery
 */
/obj/item/surgical/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon_state = "cautery"
	matter = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/*
 * Surgical Drill
 */
/obj/item/surgical/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon_state = "drill"
	hitsound = 'sound/weapons/circsawhit.ogg'
	matter = list(MAT_STEEL = 15000, MAT_GLASS = 10000)
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")

/obj/item/surgical/surgicaldrill/suicide_act(mob/user)
		var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
		user.visible_message(pick(
			SPAN_DANGER("\The [user] is pressing \the [src] to [TU.his] temple and activating it! It looks like [TU.hes] trying to commit suicide."),
			SPAN_DANGER("\The [user] is pressing \the [src] to [TU.his] chest and activating it! It looks like [TU.hes] trying to commit suicide."),
		))
		return (BRUTELOSS)

/*
 * Scalpel
 */
/obj/item/surgical/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon_state = "scalpel"
	force = 10.0
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throw_force = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MAT_STEEL = 10000, MAT_GLASS = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/surgical/scalpel/suicide_act(mob/user)
		var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
		user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with the [src.name]! It looks like [TU.hes] trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting [TU.his] throat with the [src.name]! It looks like [TU.hes] trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with the [src.name]! It looks like [TU.hes] trying to commit seppuku.</span>"))
		return (BRUTELOSS)

/*
 * Researchable Scalpels
 */
/obj/item/surgical/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/surgical/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/surgical/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/surgical/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/obj/item/surgical/scalpel/ripper
	name = "organ pincers"
	desc = "A horrifying bladed tool with a large metal spike in its center. The tool is used for rapidly removing organs from hopefully willing patients."
	icon_state = "organ_ripper"
	item_state = "bone_setter"
	force = 15.0
	tool_speed = 0.75
	origin_tech = list(TECH_MATERIAL = 5, TECH_BIO = 3, TECH_ILLEGAL = 2)

/*
 * Circular Saw
 */
/obj/item/surgical/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	throw_force = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(MAT_STEEL = 20000, MAT_GLASS = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1

/obj/item/surgical/circular_saw/manager
	name = "energetic bone diverter"
	desc = "For heavy duty cutting (and sealing), with science!"
	icon_state = "adv_saw"
	item_state = "saw3"
	hitsound = 'sound/weapons/emitter2.ogg'
	damtype = SEARING
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 6)
	matter = list(MAT_STEEL = 12500)
	attack_verb = list("attacked", "slashed", "seared", "cut")
	tool_speed = 0.75

//misc, formerly from code/defines/weapons.dm
/obj/item/surgical/bonegel
	name = "bone gel"
	desc = "For fixing bones."
	icon_state = "bone-gel"
	force = 0
	throw_force = 1.0

/obj/item/surgical/FixOVein
	name = "FixOVein"
	desc = "Like bone gel. For veins."
	icon_state = "fixovein"
	force = 0
	throw_force = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	var/usage_amount = 10

/obj/item/surgical/bonesetter
	name = "bone setter"
	desc = "Put them in their place."
	icon_state = "bone_setter"
	force = 8.0
	throw_force = 9.0
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

/obj/item/surgical/bone_clamp
	name = "bone clamp"
	desc = "The best way to get a bone fixed fast."
	icon_state = "bone_clamp"
	force = 8
	throw_force = 9
	throw_speed = 3
	throw_range = 5
	attack_verb = list("attacked", "hit", "bludgeoned")

/*
 * Bio Regen
 */
/obj/item/surgical/bioregen
	name="bioregenerator"
	desc="A special tool used in surgeries which can pull toxins from and restore oxygen to organic tissue as well as recreate missing biological structures to allow otherwise irreperable flesh to be mended."
	icon='icons/obj/surgery.dmi'
	icon_state="bioregen"

// Cyborg Tools

/obj/item/surgical/retractor/cyborg
	tool_speed = 0.5

/obj/item/surgical/hemostat/cyborg
	tool_speed = 0.5

/obj/item/surgical/cautery/cyborg
	tool_speed = 0.5

/obj/item/surgical/surgicaldrill/cyborg
	tool_speed = 0.5

/obj/item/surgical/scalpel/cyborg
	tool_speed = 0.5

/obj/item/surgical/circular_saw/cyborg
	tool_speed = 0.5

/obj/item/surgical/bonegel/cyborg
	tool_speed = 0.5

/obj/item/surgical/FixOVein/cyborg
	tool_speed = 0.5

/obj/item/surgical/bonesetter/cyborg
	tool_speed = 0.5


// Alien Tools
/obj/item/surgical/retractor/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/hemostat/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/cautery/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/surgicaldrill/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/scalpel/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/circular_saw/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/FixOVein/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.25

/obj/item/surgical/bone_clamp/alien
	icon = 'icons/obj/abductor.dmi'
	tool_speed = 0.75

// Primitive Items


/obj/item/surgical/retractor_primitive
	name = "primitive retractor"
	desc = "An archaic retractor fashioned out of bone and treated sinew."
	icon_state = "retractor_bone"
	matter = list("bone" = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)

/obj/item/surgical/hemostat_primitive
	name = "primitive hemostat"
	desc = "Two long bones connected by sinew, used as fine clamps."
	icon_state = "hemostat_bone"
	matter = list("bone" = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")

/obj/item/surgical/cautery_primitive
	name = "primitive cautery"
	desc = "An arcane gemstone inserted into whittled bone. It seems to be useful for stopping bleeding."
	icon_state = "cautery_bone"
	matter = list("bone" = 5000)
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")

/obj/item/surgical/scalpel_primitive
	name = "primitive scalpel"
	desc = "Finely knapped glass attached to a carved bone by sinew. It seems like it'd be good at cutting."
	icon_state = "scalpel_bone"
	force = 10.0
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	throw_force = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list("bone" = 5000, MAT_GLASS = 2500)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

/obj/item/surgical/scalpel_primitive/suicide_act(mob/user)
		var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
		user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] wrists with the [src.name]! It looks like [TU.hes] trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting [TU.his] throat with the [src.name]! It looks like [TU.hes] trying to commit suicide.</span>", \
		                      "<span class='danger'>\The [user] is slitting [TU.his] stomach open with the [src.name]! It looks like [TU.hes] trying to commit seppuku.</span>"))
		return (BRUTELOSS)

/obj/item/surgical/saw_primitive
	name = "primitive bone saw"
	desc = "An admittedly complex, yet still inferior tool, this bone saw uses knapped volcanic glass as cutting teeth."
	icon_state = "saw_bone"
	force = 15.0
	w_class = ITEMSIZE_NORMAL
	throw_force = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list("bone" = 6000, MAT_GLASS = 4000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1

/obj/item/surgical/bonesetter_primitive
	name = "primitive bone setter"
	desc = "Large leg bones whittled down and woven together with sinew. Used to set other bones."
	icon_state = "bone_setter_bone"
	matter = list("bone" = 5000)
