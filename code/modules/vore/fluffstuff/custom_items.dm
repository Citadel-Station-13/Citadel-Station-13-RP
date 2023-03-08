/* TUTORIAL
	"icon" is the file with the HUD/ground icon for the item
	"icon_state" is the iconstate in this file for the item
	"icon_override" is the file with the on-mob icons, can be the same file (Except for glasses, shoes, and masks.)
	"item_state" is the iconstate for the on-mob icons:
		item_state_s is used for worn uniforms on mobs
		item_state_r and item_state_l are for being held in each hand

	"item_state_slots" can replace "item_state", it is a list:
		item_state_slots["slotname1"] = "item state for that slot"
		item_state_slots["slotname2"] = "item state for that slot"
*/

/* TEMPLATE
//ckey:Character Name
/obj/item/fluff/charactername
	name = ""
	desc = ""

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "myicon"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "myicon"

*/

//For general use
/obj/item/modkit_conversion
	name = "modification kit"
	desc = "A kit containing all the needed tools and parts to modify a suit and helmet."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"
	var/parts = 3
	var/from_helmet = /obj/item/clothing/head/helmet/space/void
	var/from_suit = /obj/item/clothing/suit/space/void
	var/to_helmet = /obj/item/clothing/head/cardborg
	var/to_suit = /obj/item/clothing/suit/cardborg

	//Conversion proc
/obj/item/modkit_conversion/afterattack(obj/O, mob/user as mob)
	var/flag
	var/to_type
	if(istype(O,from_helmet))
		flag = 1
		to_type = to_helmet
	else if(istype(O,from_suit))
		flag = 2
		to_type = to_suit
	else
		return
	if(!(parts & flag))
		to_chat(user, "<span class='warning'>This kit has no parts for this modification left.</span>")
		return
	if(istype(O,to_type))
		to_chat(user, "<span class='notice'>[O] is already modified.</span>")
		return
	if(!isturf(O.loc))
		to_chat(user, "<span class='warning'>[O] must be safely placed on the ground for modification.</span>")
		return
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	var/N = new to_type(O.loc)
	user.visible_message("<span class='warning'>[user] opens \the [src] and modifies \the [O] into \the [N].</span>","<span class='warning'>You open \the [src] and modify \the [O] into \the [N].</span>")
	qdel(O)
	parts &= ~flag
	if(!parts)
		qdel(src)

/*
//JoanRisu:Joan Risu
/obj/item/flame/lighter/zippo/fluff/joan
	name = "Federation Zippo Lighter"
	desc = "A red zippo lighter with the United Federation Logo on it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanzip"

//JoanRisu:Joan Risu
/obj/item/sword/fluff/joanaria
	name = "Aria"
	desc = "A beautifully crafted rapier owned by Joan Risu. It has a thin blade and is used for quick attacks."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanaria"
	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "joanariamob"
	origin_tech = "materials=7"
	force = 15
	sharp = 1
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'


/obj/item/sword/fluff/joanaria/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//joanrisu:Katarina Eine
/obj/item/material/knife/tacknife/combatknife/fluff/katarina
	name = "tactical Knife"
	desc = "A tactical knife with a small butterly engraved on the blade."
*/

/obj/item/material/knife/tacknife/combatknife/fluff/katarina/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	if(default_parry_check(user, attacker, damage_source) && prob(75))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

//For General use
/obj/item/sword/fluff/joanaria/scisword
	name = "Scissor Blade"
	desc = "A sword that can not only cut down your enemies, it can also cut fabric really neatly"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "scisword"
	origin_tech = "materials=7"

/*
//john.wayne9392:Harmony Prechtl
/obj/item/twohanded/fireaxe/fluff/mjollnir
	name = "Mjollnir"
	desc = "Large hammer that looks like it can do a great deal of damage if properly used."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmonymjollnir"
	origin_tech = "materials=7"
	attack_verb = list("attacked", "hammered", "smashed", "slammed", "crushed")

//JoanRisu:Joan Risu
/obj/item/card/id/centcom/station/fluff/joanbadge
	name = "Faded Badge"
	desc = "A faded badge, backed with leather, that reads 'NT Security Force' across the front."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "joanbadge"
	registered_name = "Joan Risu"
	assignment = "Centcom Officer"


/obj/item/card/id/centcom/station/fluff/joanbadge/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] flashes their golden security badge.\nIt reads:NT Security.</span>","<span class='warning'>You display the faded badge.\nIt reads: NT Security.</span>")

/obj/item/card/id/centcom/station/fluff/joanbadge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//JoanRisu:Joan Risu
/obj/item/pda/heads/hos/joanpda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-joan"

//Vorrarkul:Lucina Dakarim
/obj/item/pda/heads/cmo/fluff/lucinapda
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "pda-lucina"

//john.wayne9392:Harmony Prechtl
/obj/item/modkit_conversion/fluff/harmonyspace
	name = "Harmony's captain space suit modkit"
	desc = "A kit containing all the needed tools and parts to modify a Captain's hardsuit. It has green and yellow parts inside."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmony_kit"

	from_helmet = /obj/item/clothing/head/helmet/space/capspace
	from_suit = /obj/item/clothing/suit/armor/captain
	to_helmet = /obj/item/clothing/head/helmet/space/capspace/fluff/harmhelm
	to_suit = /obj/item/clothing/suit/armor/captain/fluff/harmsuit

//john.wayne9392:Harmony Prechtl
/obj/item/modkit_conversion/fluff/harmonysuit
	name = "Harmony's captain suit modkit"
	desc = "A sewing kit containing all the needed tools and fabric to modify a Captain's suit and hat. It has green and yellow fabrics inside."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "harmony_kit"

	from_helmet = /obj/item/clothing/head/caphat
	from_suit = /obj/item/clothing/under/rank/captain
	to_helmet = /obj/item/clothing/head/centhat/fluff/harmhat
	to_suit = /obj/item/clothing/under/rank/captain/fluff/harmuniform

//scree:Scree
/obj/item/modkit_conversion/fluff/screekit
	name = "Scree's hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for a specific user. This one looks like it's fitted for a winged creature."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet/space/void
	from_suit = /obj/item/clothing/suit/space/void
	to_helmet = /obj/item/clothing/head/helmet/space/void/engineering/hazmat/fluff/screehelm
	to_suit = /obj/item/clothing/suit/space/void/engineering/hazmat/fluff/screespess
*/

//General Use
/obj/item/flag
	name = "Nanotrasen Banner"
	desc = "I pledge allegiance to the flag of a megacorporation in space."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "Flag_Nanotrasen"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "Flag_Nanotrasen_mob"

/obj/item/flag/attack_self(mob/user as mob)
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] waves their Banner around!</span>","<span class='warning'>You wave your Banner around.</span>")

/obj/item/flag/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(isliving(user))
		user.visible_message("<span class='warning'>[user] invades [target]'s personal space, thrusting [src] into their face insistently.</span>","<span class='warning'>You invade [target]'s personal space, thrusting [src] into their face insistently.</span>")

/obj/item/flag/federation
	name = "Federation Banner"
	desc = "Space, The Final Frontier. Sorta. Just go with it and say the damn oath."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_federation"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_federation_mob"

/obj/item/flag/xcom
	name = "Alien Combat Command Banner"
	desc = "A banner bearing the symbol of a task force fighting an unknown alien power."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_xcom"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_xcom_mob"

/obj/item/flag/advent
	name = "ALIEN Coalition Banner"
	desc = "A banner belonging to traitors who work for an unknown alien power."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "flag_advent"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "flag_advent_mob"


//Vorrakul: Kaitlyn Fiasco
/obj/item/toy/plushie/mouse/fluff
	name = "Mouse Plushie"
	desc = "A plushie of a delightful mouse! What was once considered a vile rodent is now your very best friend."
	slot_flags = SLOT_HEAD
	icon_state = "mouse_brown"	//TFF 12/11/19 - Change sprite to not look dead. Heck you for that choice! >:C
	item_state = "mouse_brown_head"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

//zodiacshadow: ?
/obj/item/radio/headset/fluff/zodiacshadow
	name = "Nehi's 'phones"
	desc = "A pair of old-fashioned purple headphones for listening to music that also double as an NT-approved headset; they connect nicely to any standard PDA. One side is engraved with the letters NEHI, the other having an elaborate inscription of the words \"My voice is my weapon of choice\" in a fancy font. A modern polymer allows switching between modes to either allow one to hear one's surroundings or to completely block them out."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "headphones"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "headphones_mob"


// OrbisA: Richard D'angelo
/obj/item/melee/fluff/holochain
	name = "Holographic Chain"
	desc = "A High Tech solution to simple perversions. It has a red leather handle and the initials R.D. on the silver base."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "holochain"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "holochain_mob"

	atom_flags = NOBLOODY
	slot_flags = SLOT_BELT
	force = 10
	throw_force = 3
	w_class = ITEMSIZE_NORMAL
	damtype = HALLOSS
	attack_verb = list("flogged", "whipped", "lashed", "disciplined", "chastised", "flayed")

//General use
/obj/item/melee/fluff/holochain/mass
	desc = "A mass produced version of the original. It has faux leather and an aluminium base, but still stings like the original."
	force = 8
	attack_verb = list("flogged", "whipped", "lashed", "flayed")


// joey4298:Emoticon
/obj/item/fluff/id_kit_mime
	name = "Mime ID reprinter"
	desc = "Stick your ID in one end and it'll print a new ID out the other!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

/obj/item/fluff/id_kit_mime/afterattack(obj/O, mob/user as mob)
	var/new_icon = "mime"
	if(istype(O,/obj/item/card/id) && O.icon_state != new_icon)
		//O.icon = icon // just in case we're using custom sprite paths with fluff items.
		O.icon_state = new_icon // Changes the icon without changing the access.
		playsound(user.loc, 'sound/items/polaroid2.ogg', 100, 1)
		user.visible_message("<span class='warning'> [user] reprints their ID.</span>")
		qdel(src)
	else if(O.icon_state == new_icon)
		to_chat(user, "<span class='notice'>[O] already has been reprinted.</span>")
		return
	else
		to_chat(user, "<span class='warning'>This isn't even an ID card you idiot.</span>")
		return

//arokha:Aronai Sieyes - Centcom ID (Medical dept)
/obj/item/card/id/centcom/station/fluff/aronai
	registered_name = "CONFIGURE ME"
	assignment = "CC Medical"
	var/configured = 0

/obj/item/card/id/centcom/station/fluff/aronai/attack_self(mob/user as mob)
	if(configured)
		return ..()

	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

//Swat43:Fortune Bloise
/obj/item/storage/backpack/satchel/fluff/swat43bag
	name = "Coloured Satchel"
	desc = "That's a coloured satchel with red stripes, with a heart and ripley logo on each side."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "swat43-bag"

	icon_override = 'icons/vore/custom_items_vr.dmi'
	item_state = "swat43-bag_mob"

//Dhaeleena:Dhaeleena M'iar
/obj/item/clothing/accessory/medal/silver/security/fluff/dhael
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff. It's engraved with the letters S.W.A.T."

//Vorrarkul:Lucina Dakarim
/obj/item/clothing/accessory/medal/gold/fluff/lucina
	name = "Medal of Medical Excellence"
	desc = "A medal awarded to Lucina Darkarim for excellence in medical service."

//SilencedMP5A5:Serdykov Antoz
/obj/item/clothing/suit/armor/vest/wolftaur/serdy //SilencedMP5A5's specialty armor suit.
	name = "KSS-8 security armor"
	desc = "A set of armor made from pieces of many other armors. There are two orange holobadges on it, one on the chestplate, one on the steel flank plates. The holobadges appear to be russian in origin. 'Kosmicheskaya Stantsiya-8' is printed in faded white letters on one side, along the spine. It smells strongly of dog."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon = 'icons/mob/clothing/taursuits_wolf.dmi'
	icon_state = "serdy_armor"
	item_state = "serdy_armor"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS //It's a full body suit, minus hands and feet. Arms and legs should be protected, not just the torso. Retains normal security armor values still.

/obj/item/clothing/head/helmet/serdy //SilencedMP5A5's specialty helmet. Uncomment if/when they make their custom item app and are accepted.
	name = "KSS-8 security helmet"
	desc = "desc = An old production model steel-ceramic lined helmet with a white stripe and a custom orange holographic visor. It has ear holes, and smells of dog. It's been heavily modified, and fitted with a metal mask to protect the jaw."
	icon = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "serdyhelm"

	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	item_state = "serdyhelm_mob"

/*
//SilencedMP5A5:Serdykov Antoz
/obj/item/modkit_conversion/fluff/serdykit
	name = "Serdykov's armor modification kit"
	desc = "A kit containing all the needed tools and parts to modify a armor vest and helmet for a specific user. This one looks like it's fitted for a wolf-taur."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet
	from_suit = /obj/item/clothing/suit/armor/vest/wolftaur
	to_helmet = /obj/item/clothing/head/helmet/serdy
	to_suit = /obj/item/clothing/suit/armor/vest/wolftaur/serdy
*/

//Cameron653: Diana Kuznetsova
/obj/item/clothing/suit/fluff/purp_robes
	name = "purple robes"
	desc = "Heavy, royal purple robes threaded with silver lining."
	icon_state = "psyamp"
	inv_hide_flags = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER

/obj/item/clothing/head/fluff/pink_tiara
	name = "Pink Tourmaline Tiara"
	desc = "A small, steel tiara with a large, pink tourmaline gem in the center."
	icon_state = "amp"
	body_cover_flags = 0

//Lots of people are using this now.
/obj/item/clothing/accessory/collar/vmcrystal
	name = "life crystal"
	desc = "A small crystal with four little dots in it. It feels slightly warm to the touch. \
	Read manual before use! Can be worn, held, or attached to uniform. NOTE: Device contains antimatter."
	w_class = ITEMSIZE_SMALL

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_items_vr.dmi'

	icon_state = "khlife"
	item_state = "khlife_overlay"
	overlay_state = "khlife_overlay"

	slot_flags = SLOT_TIE

	var/mob/owner = null
	var/client/owner_c = null //They'll be dead when we message them probably.
	var/state = 0 //0 - New, 1 - Paired, 2 - Breaking, 3 - Broken (same as iconstates)

/obj/item/clothing/accessory/collar/vmcrystal/Initialize(mapload)
	. = ..()
	update_state(0)

/obj/item/clothing/accessory/collar/vmcrystal/Destroy() //Waitwaitwait
	if(state == 1)
		process() //Nownownow
	return ..() //Okfine

/obj/item/clothing/accessory/collar/vmcrystal/process(delta_time)
	check_owner()
	if((state > 1) || !owner)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/vmcrystal/attack_self(mob/user as mob)
	if(state > 0) //Can't re-pair, one time only, for security reasons.
		to_chat(user, "<span class='notice'>The [name] doesn't do anything.</span>")
		return 0

	owner = user	//We're paired to this guy
	owner_c = user.client	//This is his client
	update_state(1)
	to_chat(user, "<span class='notice'>The [name] glows pleasantly blue.</span>")
	START_PROCESSING(SSobj, src)

/obj/item/clothing/accessory/collar/vmcrystal/proc/check_owner()
	//He's dead, jim
	if((state == 1) && owner && (owner.stat == DEAD))
		update_state(2)
		audible_message("<span class='warning'>The [name] begins flashing red.</span>")
		sleep(30)
		visible_message("<span class='warning'>The [name] shatters into dust!</span>")
		if(owner_c)
			to_chat(owner_c, "<span class='notice'>The HAVENS system is notified of your demise via \the [name].</span>")
		update_state(3)
		name = "broken [initial(name)]"
		desc = "This seems like a necklace, but the actual pendant is missing."

/obj/item/clothing/accessory/collar/vmcrystal/proc/update_state(var/tostate)
	state = tostate
	icon_state = "[initial(icon_state)][tostate]"
	update_icon()
/*
/obj/item/paper/vmcrystal_manual
	name = "VM-LC91-1 manual"
	info = {"<h4>VM-LC91-1 Life Crystal</h4>
	<h5>Usage</h5>
	<ol>
		<li>Hold new crystal in hand.</li>
		<li>Make fist with that hand.</li>
		<li>Wait 1 second.</li>
	</ol>
	<br />
	<h5>Purpose</h5>
	<p>The VeyMed Life Crystal is a small device typically worn around the neck for the purpose of reporting your status to the HAVENS (VeyMed's High-AVailability ENgram Storage) system, so that appropriate measures can be taken in the case of your body's demise. The whole device is housed inside a pleasing-to-the-eye elongated diamond.</p>
	<p>Upon your body's desmise, the crystal will send a transmission to HAVENS. Depending on your membership level, the appropriate actions can be taken to ensure that you are back up and enjoying existence as soon as possible.</p>

	<p>Nanotrasen has negotiated a <i>FREE</i> Star membership for you in the HAVENS system, though an upgrade can be obtained depending on your citizenship and reputation level.</p>

	As a reminder, the membership levels in HAVENS are:
	<ul>
		<li><b>HAVENS Star:</b> Upon reciving a signal from a transmitter indicating body demise, HAVENS will attempt to contact the owner for 48 hours, before starting the process of resleeving the owner into a new body they selected when registering their HAVENS membership.</li>
		<li><b>HAVENS Nebula:</b> After the contact period from the Star service has expired, an agent will be alotted a HAVENS spacecraft, and will attempt to locate your remains, and any belongings you had, for up to one week. If possible, any more recent memory recordings or mindstates will be recovered before your resleeving. (Great for explorers! Don't miss out on anything you discovered!)</li>
		<li><b>HAVENS Galaxy:</b> Upon reciving the signal from the Star service, a HAVENS High-Threat Response Team will be alotted a HAVENS FTL-capable Interdictor-class spacecraft and dispatched to your last known position to locate and recover your remains, plus any belongings. You will be resleeved on-site to continue where you left off.</li>
	</ul>
	<br />
	<h5>Technical</h5>
	<p>The Life Crystal is a small 5cm long diamond containing four main components which are visible inside the translucent gem.</p>

	From tip to top, they are:
	<ol>
		<li><b>Qubit Bucket:</b> This small cube contains 200 bits worth of quantum-entangled bits for transmitting to HAVENS. QE transmission technologies cannot be jammed or interfered with, and are effectively instant over any distance.
		<li><b>Antimatter Bottle:</b> This tiny antimatter vessel is required to power the transmitter for the time it takes to transmit the signal to HAVENS. The inside of the crystal is thick enough to block any alpha or beta particles emitted when this antimatter contacts matter, however the crystal will be destroyed when activated.
		<li><b>Decay Reactor:</b> This long-term microreactor will last for around one month and provide sufficient power to power all but the transmitter. This power is required for containing the antimatter bottle.
		<li><b>Sensor Suite:</b> The sensor that tracks the owner's life-state, such that it can be transmitted back to HAVENS when necessary.
	</ol>
	<p>The diamond itself is coated in a layer of graphene, to give it a pleasant rainbow finish. This also serves as a conductor that, if broken, will discharge the antimatter bottle immediately as it is unsafe to do so any point after the crystal is broken via physical means.</p>
	<br />
	<h5>Special Notes</h5>
	<i>\[AM WARNING\]</i>
	<p>This device contains antimatter. Please consult all local regulations when travelling to ensure compliance with local laws.</p>"}
*/
/obj/item/storage/box/vmcrystal
	name = "life crystal case"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "khlifebox"
	desc = "This case can only hold the VM-LC91-1 and a manual."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syringe_kit", SLOT_ID_LEFT_HAND = "syringe_kit")
	storage_slots = 2
	can_hold = list(/obj/item/clothing/accessory/collar/vmcrystal)
	max_storage_space = ITEMSIZE_COST_SMALL * 2
	w_class = ITEMSIZE_SMALL

/obj/item/storage/box/vmcrystal/Initialize(mapload)
	. = ..()
//	new /obj/item/paper/vmcrystal_manual(src)
	new /obj/item/clothing/accessory/collar/vmcrystal(src)

/obj/item/cane/fluff
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "browncane"
	item_icons = list (SLOT_ID_RIGHT_HAND = 'icons/vore/custom_items_vr.dmi', SLOT_ID_LEFT_HAND = 'icons/vore/custom_items_vr.dmi')
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "browncanemob_r", SLOT_ID_LEFT_HAND = "browncanemob_l")
	force = 5.0
	throw_force = 7.0
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/cane/fluff/tasald
	name = "Ornate Walking Cane"
	desc = "An elaborately made custom walking stick with a dark wooding core, a crimson red gemstone on its head and a steel cover around the bottom. you'd probably hear someone using this down the hall."
	icon = 'icons/vore/custom_items_vr.dmi'

//Stobarico - Alexis Bloise
/obj/item/cane/wand
    name = "Ancient wand"
    desc = "A really old looking wand with floating parts and cyan crystals, wich seem to radiate a cyan glow. The wand has a golden plaque on the side that would say Corncobble, but it is covered by a sSSticker saying Bloise."
    icon = 'icons/vore/custom_items_vr.dmi'
    icon_state = "alexiswand"
    item_icons = list (SLOT_ID_RIGHT_HAND = 'icons/vore/custom_items_vr.dmi', SLOT_ID_LEFT_HAND = 'icons/vore/custom_items_vr.dmi')
    item_state_slots = list(SLOT_ID_RIGHT_HAND = "alexiswandmob_r", SLOT_ID_LEFT_HAND = "alexiswandmob_l")
    force = 1.0
    throw_force = 2.0
    w_class = ITEMSIZE_SMALL
    matter = list(MAT_STEEL = 50)
    attack_verb = list("sparkled", "whacked", "twinkled", "radiated", "dazzled", "zapped")
    hitsound = 'sound/weapons/sparkle.ogg'
    var/last_use = 0
    var/cooldown = 30

/obj/item/cane/wand/attack_self(mob/user)
	if(last_use + cooldown >= world.time)
		return
	playsound(src, 'sound/weapons/sparkle.ogg', 50, 1)
	user.visible_message("<span class='warning'> [user] swings their wand.</span>")
	var/datum/effect_system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()
	last_use = world.time

/obj/item/fluff/id_kit_ivy
	name = "Holo-ID reprinter"
	desc = "Stick your ID in one end and it'll print a new ID out the other!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

/obj/item/fluff/id_kit_ivy/afterattack(obj/O, mob/user as mob)
	var/new_icon_state = "ivyholoid"
	var/new_icon = 'icons/vore/custom_items_vr.dmi'
	var/new_desc = "Its a thin screen showing ID information, but it seems to be flickering."
	if(istype(O,/obj/item/card/id) && O.icon_state != new_icon)
		O.icon = new_icon
		O.icon_state = new_icon_state // Changes the icon without changing the access.
		O.desc = new_desc
		playsound(user.loc, 'sound/items/polaroid2.ogg', 100, 1)
		user.visible_message("<span class='warning'> [user] reprints their ID.</span>")
		qdel(src)
	else if(O.icon_state == new_icon)
		to_chat(user, "<span class='notice'>[O] already has been reprinted.</span>")
		return
	else
		to_chat(user, "<span class='warning'>This isn't even an ID card you idiot.</span>")
		return

/datum/looping_sound/ambulance
	mid_sounds = list('sound/items/amulanceweeoo.ogg'=1)
	mid_length = 20
	volume = 25

//Egg item
//-------------
/obj/item/reagent_containers/food/snacks/egg/roiz
	name = "lizard egg"
	desc = "It's a large lizard egg."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	filling_color = "#FDFFD1"
	volume = 12

/obj/item/reagent_containers/food/snacks/egg/roiz/Initialize(mapload)
	. = ..()
	reagents.add_reagent("egg", 9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/egg/roiz/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(user,"<span class='warning'>The egg refuses to take on this color!</span>")
			return

		to_chat(user,"<span class='notice'>You color \the [src] [clr]</span>")
		icon_state = "egg_roiz_[clr]"
		desc = "It's a large lizard egg. It has been colored [clr]!"
		if (clr == "rainbow")
			var/number = rand(1,4)
			icon_state = icon_state + num2text(number, 0)
	else
		..()

/obj/item/reagent_containers/food/snacks/friedegg/roiz
	name = "fried lizard egg"
	desc = "A large, fried lizard egg, with a touch of salt and pepper. It looks rather chewy."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "friedegg"
	volume = 12

/obj/item/reagent_containers/food/snacks/friedegg/roiz/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 9)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/boiledegg/roiz
	name = "boiled lizard egg"
	desc = "A hard boiled lizard egg. Be careful, a lizard detective may hatch!"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "egg_roiz"
	volume = 12

/obj/item/reagent_containers/food/snacks/boiledegg/roiz/Initialize(mapload)
	. = ..()
	reagents.add_reagent("protein", 6)
	bitesize = 2

/obj/item/reagent_containers/food/snacks/chocolateegg/roiz
	name = "chocolate lizard egg"
	desc = "Such huge, sweet, fattening food. You feel gluttonous just looking at it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "chocolateegg_roiz"
	filling_color = "#7D5F46"
	nutriment_amt = 3
	nutriment_desc = list("chocolate" = 5)
	volume = 18

/obj/item/reagent_containers/food/snacks/chocolateegg/roiz/Initialize(mapload)
	. = ..()
	reagents.add_reagent("sugar", 6)
	reagents.add_reagent("coco", 6)
	reagents.add_reagent("milk", 2)
	bitesize = 2

//PontifexMinimus: Lucius/Lucia Null
/obj/item/fluff/dragor_dot
	name = "supplemental battery"
	desc = "A tiny supplemental battery for powering something or someone synthetic."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "dragor_dot"
	w_class = ITEMSIZE_SMALL

/obj/item/fluff/dragor_dot/attack_self(mob/user)
	if(user.ckey == "pontifexminimus")
		add_verb(user, /mob/living/carbon/human/proc/shapeshifter_select_gender)
	else
		return

//LuminescentRing: Briana Moore
/obj/item/storage/backpack/messenger/black/fluff/briana
	name = "2561 graduation bag"
	desc = "A black leather bag with names scattered around in red embroidery, it says 'Pride State Academy' on the top. "

//DeepIndigo: Amina Dae-Kouri
/obj/item/storage/bible/fluff/amina
	name = "New Space Pioneer's Bible"
	desc = "A New Space Pioneer's Bible. This one says it was printed in 2492. The name 'Eric Hayvers' is written on the inside of the cover, crossed out. \
	Under it is written 'Kouri, Amina, Marine Unit 14, Fifth Echelon. Service number NTN-5528928522372'"

//arokha:Amaya Rahl - Custom ID (Medical dept)
/obj/item/card/id/fluff/amaya
	registered_name = "CONFIGURE ME"
	assignment = "CONFIGURE ME"
	var/configured = 0
	var/accessset = 0
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "amayarahlwahID"
	desc = "A primarily blue ID with a holographic 'WAH' etched onto its back. The letters do not obscure anything important on the card. It is shiny and it feels very bumpy."
	var/title_strings = list("Amaya Rahl's Wah-identification card", "Amaya Rahl's Wah-ID card")

/obj/item/card/id/fluff/amaya/attack_self(mob/user as mob)
	if(configured == 1)
		return ..()

	var/title = user.client.prefs.get_job_alt_title_name(SSjob.name_occupations[user.job]) || user.job
	assignment = title
	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	var/tempname = pick(title_strings)
	name = tempname + " ([title])"
	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

/obj/item/card/id/fluff/amaya/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/card/id) && !accessset)
		var/obj/item/card/id/O = I
		access |= O.access
		to_chat(user, "<span class='notice'>You copy the access from \the [I] to \the [src].</span>")
		qdel(I)
		accessset = 1
	..()

//General use, Verk felt like sharing.
/obj/item/clothing/glasses/fluff/science_proper
	name = "Aesthetic Science Goggles"
	desc = "The goggles really do nothing this time!"
	icon_state = "purple"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	clothing_flags = ALLOWINTERNALS

//General use, Verk felt like sharing.
/obj/item/clothing/glasses/fluff/spiffygogs
	name = "Orange Goggles"
	desc = "You can almost feel the raw power radiating off these strange specs."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "spiffygogs"
	slot_flags = SLOT_EYES | SLOT_EARS
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	toggleable = 1
	off_state = "spiffygogsup"

//General use
/obj/item/clothing/accessory/tronket
	name = "metal necklace"
	desc = "A shiny steel chain with a vague metallic object dangling off it."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "tronket"
	item_state = "tronket"
	overlay_state = "tronket"
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/flops
	name = "drop straps"
	desc = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "flops"
	item_state = "flops"
	overlay_state = "flops"
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

//The perfect adminboos device?
/obj/item/perfect_tele
	name = "personal translocator"
	desc = "Seems absurd, doesn't it? Yet, here we are. Generally considered dangerous contraband unless the user has permission from Central Command."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "hand_tele"
	item_flags = ITEM_NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 7)

	var/cell_type = /obj/item/cell/device/weapon
	var/obj/item/cell/power_source
	var/charge_cost = 800 // cell/device/weapon has 2400

	var/list/beacons = list()
	var/ready = 1
	var/beacons_left = 3
	var/failure_chance = 5 //Percent
	var/obj/item/perfect_tele_beacon/destination
	var/datum/effect_system/spark_spread/spk
	var/list/warned_users = list()
	var/list/logged_events = list()

/obj/item/perfect_tele/Initialize(mapload)
	. = ..()
	if(cell_type)
		power_source = new cell_type(src)
	else
		power_source = new /obj/item/cell/device(src)
	spk = new(src)
	spk.set_up(5, 0, src)
	spk.attach(src)

/obj/item/perfect_tele/Destroy()
	// Must clear the beacon's backpointer or we won't GC. Someday maybe do something nicer even.
	for(var/obj/item/perfect_tele_beacon/B in beacons)
		B.tele_hand = null
	beacons.Cut()
	QDEL_NULL(power_source)
	QDEL_NULL(spk)
	return ..()

/obj/item/perfect_tele/update_icon()
	if(!power_source)
		icon_state = "[initial(icon_state)]_o"
	else if(ready && (power_source.check_charge(charge_cost) || power_source.fully_charged()))
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_w"

	..()

/obj/item/perfect_tele/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src && power_source)
		to_chat(user,"<span class='notice'>You eject \the [power_source] from \the [src].</span>")
		user.put_in_hands(power_source)
		power_source = null
		update_icon()
	else
		return ..()

/obj/item/perfect_tele/attack_self(mob/user)
	if(!(user.ckey in warned_users))
		warned_users |= user.ckey
		alert(user,"This device can be easily used to break ERP preferences due to the nature of teleporting \
		and tele-vore. Make sure you carefully examine someone's OOC prefs before teleporting them if you are \
		going to use this device for ERP purposes. This device records all warnings given and teleport events for \
		admin review in case of pref-breaking, so just don't do it.","OOC WARNING")

	var/choice = alert(user,"What do you want to do?","[src]","Create Beacon","Cancel","Target Beacon")
	switch(choice)
		if("Create Beacon")
			if(beacons_left <= 0)
				alert("The translocator can't support any more beacons!","Error")
				return

			var/new_name = html_encode(input(user,"New beacon's name (2-20 char):","[src]") as text|null)

			if(length(new_name) > 20 || length(new_name) < 2)
				alert("Entered name length invalid (must be longer than 2, no more than than 20).","Error")
				return
			if(new_name in beacons)
				alert("No duplicate names, please. '[new_name]' exists already.","Error")
				return

			var/obj/item/perfect_tele_beacon/nb = new(get_turf(src))
			nb.tele_name = new_name
			nb.tele_hand = src
			nb.creator = user.ckey
			beacons[new_name] = nb
			beacons_left--
			if(isliving(user))
				var/mob/living/L = user
				L.put_in_hands(nb)

		if("Target Beacon")
			if(!beacons.len)
				to_chat(user,"<span class='warning'>\The [src] doesn't have any beacons!</span>")
			else
				var/target = input("Which beacon do you target?","[src]") in beacons|null
				if(target && (target in beacons))
					destination = beacons[target]
					to_chat(user,"<span class='notice'>Destination set to '[target]'.</span>")
		else
			return

/obj/item/perfect_tele/attackby(obj/W, mob/user)
	if(istype(W,cell_type) && !power_source)
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		power_source = W
		power_source.update_icon() //Why doesn't a cell do this already? :|
		to_chat(user,"<span class='notice'>You insert \the [power_source] into \the [src].</span>")
		update_icon()

	else if(istype(W,/obj/item/perfect_tele_beacon))
		var/obj/item/perfect_tele_beacon/tb = W
		if(tb.tele_name in beacons)
			if(!user.attempt_consume_item_for_construction(tb))
				return
			to_chat(user,"<span class='notice'>You re-insert \the [tb] into \the [src].</span>")
			beacons -= tb.tele_name
			beacons_left++
		else
			to_chat(user,"<span class='notice'>\The [tb] doesn't belong to \the [src].</span>")
			return
	else
		..()

/obj/item/perfect_tele/proc/teleport_checks(mob/living/target,mob/living/user)
	//Uhhuh, need that power source
	if(!power_source)
		to_chat(user,"<span class='warning'>\The [src] has no power source!</span>")
		return FALSE

	//Check for charge
	if((!power_source.check_charge(charge_cost)) && (!power_source.fully_charged()))
		to_chat(user,"<span class='warning'>\The [src] does not have enough power left!</span>")
		return FALSE

	//Only mob/living need apply.
	if(!istype(user) || !istype(target))
		return FALSE

	//No, you can't teleport buckled people.
	if(target.buckled)
		to_chat(user,"<span class='warning'>The target appears to be attached to something...</span>")
		return FALSE

	//No, you can't teleport if it's not ready yet.
	if(!ready)
		to_chat(user,"<span class='warning'>\The [src] is still recharging!</span>")
		return FALSE

	//No, you can't teleport if there's no destination.
	if(!destination)
		to_chat(user,"<span class='warning'>\The [src] doesn't have a current valid destination set!</span>")
		return FALSE

	//No, you can't teleport if there's a jammer.
	if(is_jammed(src) || is_jammed(destination))
		to_chat(user,"<span class='warning'>\The [src] refuses to teleport you, due to strong interference!</span>")
		return FALSE

	//No, you can't port to or from away missions. Stupidly complicated check.
	var/turf/uT = get_turf(user)
	var/turf/dT = get_turf(destination)
	var/list/dat = list()
	dat["z_level_detection"] = GLOB.using_map.get_map_levels(uT.z, TRUE)

	if(!uT || !dT)
		return FALSE

	if( (uT.z != dT.z) && (!(dT.z in dat["z_level_detection"])) )
		to_chat(user,"<span class='warning'>\The [src] can't teleport you that far!</span>")
		return FALSE

	if(uT.block_tele || dT.block_tele)
		to_chat(user,"<span class='warning'>Something is interfering with \the [src]!</span>")
		return FALSE

	//Seems okay to me!
	return TRUE

/obj/item/perfect_tele/afterattack(mob/living/target, mob/living/user, proximity)
	//No, you can't teleport people from over there.
	if(!proximity)
		return

	if(!teleport_checks(target,user))
		return //The checks proc can send them a message if it wants.

	ready = FALSE
	update_icon()

	//Failure chance
	if(prob(failure_chance) && (beacons.len >= 2))
		var/list/wrong_choices = beacons - destination.tele_name
		var/wrong_name = pick(wrong_choices)
		destination = beacons[wrong_name]
		if(!teleport_checks(target, user))	// no using this to bypass range checks
			to_chat(user, "<span class='warning'>[src] malfunctions and fizzles out uselessly!</span>")
			// penalty: 10 second recharge, but no using charge.
			addtimer(CALLBACK(src, .proc/recharge), 10 SECONDS)
			return
		else
			to_chat(user,"<span class='warning'>\The [src] malfunctions and sends you to the wrong beacon!</span>")

	//Bzzt.
	power_source.use(charge_cost)

	//Destination beacon vore checking
	var/turf/dT = get_turf(destination)
	var/atom/real_dest = dT

	var/atom/real_loc = destination.loc
	if(isbelly(real_loc))
		real_dest = real_loc
	if(isliving(real_loc))
		var/mob/living/L = real_loc
		if(L.vore_selected)
			real_dest = L.vore_selected
		else if(L.vore_organs.len)
			real_dest = pick(L.vore_organs)

	//Confirm televore
	var/televored = FALSE
	if(isbelly(real_dest))
		var/obj/belly/B = real_dest
		if(!target.can_be_drop_prey && B.owner != user)
			to_chat(target,"<span class='warning'>\The [src] narrowly avoids teleporting you right into \a [lowertext(real_dest.name)]!</span>")
			real_dest = dT //Nevermind!
		else
			televored = TRUE
			to_chat(target,"<span class='warning'>\The [src] teleports you right into \a [lowertext(real_dest.name)]!</span>")

	//Phase-out effect
	phase_out(target,get_turf(target))

	//Move them
	target.forceMove(real_dest)

	//Phase-in effect
	phase_in(target,get_turf(target))

	//And any friends!
	for(var/obj/item/grab/G in target.contents)
		if(G.affecting && (G.state >= GRAB_AGGRESSIVE))

			//Phase-out effect for grabbed person
			phase_out(G.affecting,get_turf(G.affecting))

			//Move them, and televore if necessary
			G.affecting.forceMove(real_dest)
			if(televored)
				to_chat(target,"<span class='warning'>\The [src] teleports you right into \a [lowertext(real_dest.name)]!</span>")

			//Phase-in effect for grabbed person
			phase_in(G.affecting,get_turf(G.affecting))

	addtimer(CALLBACK(src, .proc/recharge), 30 SECONDS)

	logged_events["[world.time]"] = "[user] teleported [target] to [real_dest] [televored ? "(Belly: [lowertext(real_dest.name)])" : null]"

/obj/item/perfect_tele/proc/recharge()
	ready = TRUE
	update_icon()

/obj/item/perfect_tele/proc/phase_out(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	spk.set_up(5, 0, M)
	spk.attach(M)
	playsound(T, "sparks", 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

/obj/item/perfect_tele/proc/phase_in(var/mob/M,var/turf/T)

	if(!M || !T)
		return

	spk.start()
	playsound(T, 'sound/effects/phasein.ogg', 25, 1)
	playsound(T, 'sound/effects/sparks2.ogg', 50, 1)
	anim(T,M,'icons/mob/mob.dmi',,"phasein",,M.dir)
	spk.set_up(5, 0, src)
	spk.attach(src)

/obj/item/perfect_tele_beacon
	name = "translocator beacon"
	desc = "That's unusual."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "motion2"
	w_class = ITEMSIZE_TINY
	item_flags = ITEM_NOBLUDGEON

	var/tele_name
	var/obj/item/perfect_tele/tele_hand
	var/creator
	var/warned_users = list()

/obj/item/perfect_tele_beacon/Destroy()
	tele_name = null
	tele_hand = null
	return ..()

/obj/item/perfect_tele_beacon/attack_hand(mob/user)
	if((user.ckey != creator) && !(user.ckey in warned_users))
		warned_users |= user.ckey
		var/choice = alert(user,"This device is a translocator beacon. Having it on your person may mean that anyone \
		who teleports to this beacon gets teleported into your selected vore-belly. If you are prey-only \
		or don't wish to potentially have a random person teleported into you, it's suggested that you \
		not carry this around.","OOC WARNING","Take It","Leave It")
		if(choice == "Leave It")
			return

	..()

/obj/item/perfect_tele_beacon/attack_self(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user
	var/confirm = alert(user, "You COULD eat the beacon...", "Eat beacon?", "Eat it!", "No, thanks.")
	if(confirm == "Eat it!")
		var/obj/belly/bellychoice = input("Which belly?","Select A Belly") as null|anything in L.vore_organs
		if(bellychoice)
			user.visible_message("<span class='warning'>[user] is trying to stuff \the [src] into [user.gender == MALE ? "his" : user.gender == FEMALE ? "her" : "their"] [bellychoice]!</span>","<span class='notice'>You begin putting \the [src] into your [bellychoice]!</span>")
			if(do_after(user,5 SECONDS,src))
				if(!user.attempt_insert_item_for_installation(src, bellychoice))
					return
				user.visible_message("<span class='warning'>[user] eats a telebeacon!</span>","You eat the the beacon!")

// A single-beacon variant for use by miners (or whatever)
/obj/item/perfect_tele/one_beacon
	name = "mini-translocator"
	desc = "A more limited translocator with a single beacon, useful for some things, like setting the mining department on fire accidentally. Legal for use in the pursuit of NanoTrasen interests, namely mining and exploration."
	icon_state = "minitrans"
	beacons_left = 1 //Just one
	cell_type = /obj/item/cell/device
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5)

/*
/obj/item/perfect_tele/one_beacon/teleport_checks(mob/living/target,mob/living/user)
	var/turf/T = get_turf(destination)
	if(T && user.z != T.z)
		to_chat(user,"<span class='warning'>\The [src] is too far away from the beacon. Try getting closer first!</span>")
		return FALSE
	return ..()
*/

/obj/item/perfect_tele/admin
	name = "alien translocator"
	desc = "This strange device allows one to teleport people and objects across large distances."

	cell_type = /obj/item/cell/device/weapon/recharge/alien
	charge_cost = 400
	beacons_left = 6
	failure_chance = 0 //Percent

/obj/item/perfect_tele/admin/teleport_checks(mob/living/target,mob/living/user)
	//Uhhuh, need that power source
	if(!power_source)
		to_chat(user,"<span class='warning'>\The [src] has no power source!</span>")
		return FALSE

	//Check for charge
	if((!power_source.check_charge(charge_cost)) && (!power_source.fully_charged()))
		to_chat(user,"<span class='warning'>\The [src] does not have enough power left!</span>")
		return FALSE

	//Only mob/living need apply.
	if(!istype(user) || !istype(target))
		return FALSE

	//No, you can't teleport buckled people.
	if(target.buckled)
		to_chat(user,"<span class='warning'>The target appears to be attached to something...</span>")
		return FALSE

	//No, you can't teleport if it's not ready yet.
	if(!ready)
		to_chat(user,"<span class='warning'>\The [src] is still recharging!</span>")
		return FALSE

	//No, you can't teleport if there's no destination.
	if(!destination)
		to_chat(user,"<span class='warning'>\The [src] doesn't have a current valid destination set!</span>")
		return FALSE

	//Seems okay to me!
	return TRUE

//InterroLouis: Ruda Lizden
/obj/item/clothing/accessory/badge/holo/detective/ruda
	name = "Hisstective's Badge"
	desc = "This is Ruda Lizden's personal Detective's badge. The polish is dull, as if it's simply been huffed upon and wiped against a coat. Labeled 'Hisstective.'"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "hisstective_badge"
	//slot_flags = SLOT_TIE | SLOT_BELT

/obj/item/clothing/accessory/badge/holo/detective/ruda/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [target]'s personal space, thrusting [src] into their face with an insistent huff.</span>","<span class='danger'>You invade [target]'s personal space, thrusting [src] into their face with an insistent huff.</span>")
		user.do_attack_animation(target)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //to prevent spam

/obj/item/clothing/accessory/badge/holo/detective/ruda/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You huff along the front of your badge, then rub your sleeve on it to polish it up.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src]. It reads: [badge_string].</span>")

/obj/item/card/id/fluff/xennith
	name = "\improper Amy Lessen's Central Command ID (Xenobiology Director)"
	desc = "This ID card identifies Dr. Amelie Lessen as the founder and director of the NanoTrasen Xenobiology Research Department, circa 2553."
	icon_state = "centcom"
	registered_name = "Amy Lessen"
	assignment = "Xenobiology Director"
	access = list(ACCESS_CENTCOM_GENERAL,ACCESS_CENTCOM_THUNDERDOME,ACCESS_CENTCOM_MEDICAL,ACCESS_CENTCOM_DORMS,ACCESS_CENTCOM_STORAGE,ACCESS_CENTCOM_TELEPORTER,ACCESS_SCIENCE_MAIN,ACCESS_SCIENCE_XENOBIO,ACCESS_ENGINEERING_MAINT,ACCESS_SCIENCE_XENOARCH,ACCESS_SCIENCE_ROBOTICS,ACCESS_SCIENCE_TOXINS,ACCESS_SCIENCE_FABRICATION) //Yes, this looks awful. I tried calling both central and resarch access but it didn't work.
	age = 39
	blood_type = "O-"
	sex = "Female"

/obj/item/fluff/injector //Injectors. Custom item used to explain wild changes in a mob's body or chemistry.
	name = "Injector"
	desc = "Some type of injector."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"

/obj/item/fluff/injector/monkey
	name = "Lesser Form Injector"
	desc = "Turn the user into their lesser, more primal form."

/obj/item/fluff/injector/monkey/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(usr == target) //Is the person using it on theirself?
		if(ishuman(target)) //If so, monkify them.
			var/mob/living/carbon/human/H = user
			H.monkeyize()
			qdel(src) //One time use.
	else //If not, do nothing.
		to_chat(user,"<span class='warning'>You are unable to inject other people.</span>")

/obj/item/fluff/injector/numb_bite
	name = "Numbing Venom Injector"
	desc = "Injects the user with a high dose of some type of chemical, causing any chemical glands they have to kick into overdrive and create the production of a numbing enzyme that is injected via bites.."

/obj/item/fluff/injector/numb_bite/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(user.a_intent == INTENT_HARM)
		return ..()
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(usr == target) //Is the person using it on theirself?
		if(ishuman(target)) //Give them numbing bites.
			var/mob/living/carbon/human/H = user
			H.species.give_numbing_bite() //This was annoying, but this is the easiest way of performing it.
			qdel(src) //One time use.
	else //If not, do nothing.
		to_chat(user,"<span class='warning'>You are unable to inject other people.</span>")

//For 2 handed fluff weapons.
/obj/item/material/twohanded/fluff //Twohanded fluff items.
	name = "fluff."
	desc = "This object is so fluffy. Just from the sight of it, you know that either something went wrong or someone spawned the incorrect item."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(
				SLOT_ID_LEFT_HAND = 'icons/vore/custom_items_left_hand_vr.dmi',
				SLOT_ID_RIGHT_HAND = 'icons/vore/custom_items_right_hand_vr.dmi',
				)

/obj/item/material/twohanded/fluff/Initialize(mapload, material_key)
	..(mapload," ") //See materials_vr_dmi for more information as to why this is a blank space.

//General use.
/obj/item/material/twohanded/fluff/riding_crop
	name = "riding crop"
	desc = "A steel rod, a little over a foot long with a widened grip and a thick, leather patch at the end. Made to smack naughty submissives."
	//force_wielded = 0.05 //Stings, but does jack shit for damage, provided you don't hit someone 100 times. 1 damage with hardness of 60.
	force_divisor = 0.05 //Required in order for the X attacks Y message to pop up.
	unwielded_force_divisor = 1 // One here, too.
	applies_material_colour = 0
	unbreakable = 1
	base_icon = "riding_crop"
	icon_state = "riding_crop0"
	attack_verb = list("cropped","spanked","swatted","smacked","peppered")
//1R1S: Malady Blanche
/obj/item/material/twohanded/fluff/riding_crop/malady
	name = "Malady's riding crop"
	desc = "An infernum made riding crop with Malady Blanche engraved in the shaft. It's a little worn from how many butts it has spanked."


//SilverTalisman: Evian
/obj/item/implant/reagent_generator/evian
	emote_descriptor = list("an egg right out of Evian's lower belly!", "into Evian' belly firmly, forcing him to lay an egg!", "Evian really tight, who promptly lays an egg!")
	var/verb_descriptor = list("squeezes", "pushes", "hugs")
	var/self_verb_descriptor = list("squeeze", "push", "hug")
	var/short_emote_descriptor = list("lays", "forces out", "pushes out")
	self_emote_descriptor = list("lay", "force out", "push out")
	random_emote = list("hisses softly with a blush on his face", "yelps in embarrassment", "grunts a little")
	assigned_proc = /mob/living/carbon/human/proc/use_reagent_implant_evian

/obj/item/implant/reagent_generator/evian/post_implant(mob/living/carbon/source)
	START_PROCESSING(SSobj, src)
	to_chat(source, "<span class='notice'>You implant [source] with \the [src].</span>")
	add_verb(source, assigned_proc)
	return 1

/obj/item/implanter/reagent_generator/evian
	implant_type = /obj/item/implant/reagent_generator/evian

/mob/living/carbon/human/proc/use_reagent_implant_evian()
	set name = "Lay Egg"
	set desc = "Force Evian to lay an egg by squeezing into his lower body! This makes the lizard extremely embarrassed, and it looks funny."
	set category = "Object"
	set src in view(1)

	//do_reagent_implant(usr)
	if(!isliving(usr) || !usr.canClick())
		return

	if(usr.incapacitated() || usr.stat > CONSCIOUS)
		return

	var/obj/item/implant/reagent_generator/evian/rimplant
	for(var/obj/item/organ/external/E in organs)
		for(var/obj/item/implant/I in E.implants)
			if(istype(I, /obj/item/implant/reagent_generator))
				rimplant = I
				break
	if (rimplant)
		if(rimplant.reagents.total_volume <= rimplant.transfer_amount)
			to_chat(src, "<span class='notice'>[pick(rimplant.empty_message)]</span>")
			return

		new /obj/item/reagent_containers/food/snacks/egg/roiz/evian(get_turf(src)) //Roiz/evian so it gets all the functionality

		var/index = rand(0,3)

		if (usr != src)
			var/emote = rimplant.emote_descriptor[index]
			var/verb_desc = rimplant.verb_descriptor[index]
			var/self_verb_desc = rimplant.self_verb_descriptor[index]
			usr.visible_message("<span class='notice'>[usr] [verb_desc] [emote]</span>",
							"<span class='notice'>You [self_verb_desc] [emote]</span>")
		else
			visible_message("<span class='notice'>[src] [pick(rimplant.short_emote_descriptor)] an egg.</span>",
								"<span class='notice'>You [pick(rimplant.self_emote_descriptor)] an egg.</span>")
		if(prob(15))
			visible_message("<span class='notice'>[src] [pick(rimplant.random_emote)].</span>") // M-mlem.

		rimplant.reagents.remove_any(rimplant.transfer_amount)

/obj/item/reagent_containers/food/snacks/egg/roiz/evian
	name = "dragon egg"
	desc = "A quite large dragon egg!"
	icon_state = "egg_roiz_yellow"


/obj/item/reagent_containers/food/snacks/egg/roiz/evian/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/pen/crayon)) //No coloring these ones!
		return
	else
		..()

//jacknoir413:Areax Third
/obj/item/melee/baton/fluff/stunstaff
	name = "Electrostaff"
	desc = "Six-foot long staff from dull, rugged metal, with two thin spikes protruding from each end. Small etching near to the middle of it reads 'Children Of Nyx Facilities: Product No. 12'."
	icon = 'icons/vore/custom_items_vr.dmi'
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/vore/custom_items_left_hand_vr.dmi', SLOT_ID_RIGHT_HAND = 'icons/vore/custom_items_right_hand_vr.dmi')
	icon_state = "stunstaff00"
	var/base_icon = "stunstaff"
	force = 5
	sharp = 0
	edge = 0
	throw_force = 7
	w_class = ITEMSIZE_HUGE
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	lightcolor = "#CC33FF"

	//Two Handed
	var/wielded = 0
	var/base_name = "stunstaff"

/obj/item/melee/baton/fluff/stunstaff/Initialize(mapload)
	. = ..()
	bcell = new/obj/item/cell/device/weapon(src)
	update_icon()
	return

/obj/item/melee/baton/fluff/stunstaff/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.is_holding(src) && !M.hands_full())
		wielded = 1
		force = 15
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		force = 8
		name = "[base_name]"
	update_icon()
	..()

/obj/item/melee/baton/fluff/stunstaff/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(30))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/melee/baton/fluff/stunstaff/update_icon()
	icon_state = "[base_icon][wielded][status]"
	item_state = icon_state
	if(status==1)
		set_light(2, 2, lightcolor)
	else
		set_light(0)

/obj/item/melee/baton/fluff/stunstaff/dropped(mob/user, flags, atom/newLoc)
	..()
	if(wielded)
		wielded = 0
		spawn(0)
			update_held_icon()

/obj/item/melee/baton/fluff/stunstaff/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
		if(status == 0)
			playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		else
			playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
	else
		status = 0
		to_chat(user, "<span class='warning'>[src] is out of charge.</span>")
	update_held_icon()
	add_fingerprint(user)

/obj/item/storage/backpack/fluff/stunstaff
	name = "Electrostaff sheath"
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "holster_stunstaff"
	desc = "A sturdy synthetic leather sheath with matching belt and rubberized interior."
	slot_flags = SLOT_BACK
	item_icons = list(SLOT_ID_BACK = 'icons/vore/custom_onmob_vr.dmi', SLOT_ID_LEFT_HAND = 'icons/vore/custom_items_left_hand_vr.dmi', SLOT_ID_RIGHT_HAND = 'icons/vore/custom_items_right_hand_vr.dmi')

	can_hold = list(/obj/item/melee/baton/fluff/stunstaff)

	w_class = ITEMSIZE_HUGE
	max_w_class = ITEMSIZE_HUGE
	max_storage_space = 16

/obj/item/storage/backpack/fluff/stunstaff/Initialize(mapload)
	. = ..()
	new /obj/item/melee/baton/fluff/stunstaff(src)


/*
 * Awoo Sword
 */
/obj/item/melee/fluffstuff
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	var/active_embed_chance = 0
	sharp = 0
	edge = 0

/obj/item/melee/fluffstuff/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	embed_chance = active_embed_chance
	force = active_force
	throw_force = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/sparkle.ogg', 50, 1)

/obj/item/melee/fluffstuff/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/sparkle.ogg', 50, 1)
	active = 0
	embed_chance = initial(embed_chance)
	force = initial(force)
	throw_force = initial(throw_force)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)

/obj/item/melee/fluffstuff/attack_self(mob/living/user as mob)
	if (active)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/melee/fluffstuff/suicide_act(mob/user)
	var/tempgender = "[user.gender == MALE ? "he's" : user.gender == FEMALE ? "she's" : "they are"]"
	if(active)
		user.visible_message(pick("<span class='danger'>\The [user] is slitting \his stomach open with \the [src]! It looks like [tempgender] trying to commit seppuku.</span>",\
			"<span class='danger'>\The [user] is falling on \the [src]! It looks like [tempgender] trying to commit suicide.</span>"))
		return (BRUTELOSS|FIRELOSS)

/obj/item/melee/fluffstuff/wolfgirlsword
	name = "Wolfgirl Sword Replica"
	desc = "A replica of a large, scimitar-like sword with a dull edge. Ceremonial... until it isn't."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "wolfgirlsword"
	slot_flags = SLOT_BACK | SLOT_OCLOTHING
	active_force = 15
	active_throwforce = 7
	active_w_class = ITEMSIZE_LARGE
	force = 1
	throw_force = 1
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 1)
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi', SLOT_ID_BACK = 'icons/vore/custom_items_vr.dmi', SLOT_ID_SUIT = 'icons/vore/custom_items_vr.dmi')
	var/active_state = "wolfgirlsword"
	allowed = list(/obj/item/shield/fluff/wolfgirlshield)
	damtype = HALLOSS

/obj/item/melee/fluffstuff/wolfgirlsword/dropped(mob/user, flags, atom/newLoc)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/melee/fluffstuff/wolfgirlsword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>The [src] is now sharpened. It will cut!</span>")

	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1
	icon_state = "[active_state]_sharp"
	damtype = BRUTE


/obj/item/melee/fluffstuff/wolfgirlsword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>The [src] grows dull!</span>")
	..()
	attack_verb = list("bapped", "thwapped", "bonked", "whacked")
	icon_state = initial(icon_state)

/*
//SilencedMP5A5 - Serdykov Antoz
/obj/item/modkit_conversion/hasd
	name = "HASD EVA modification kit"
	desc = "A kit containing all the needed tools and parts to modify a suit and helmet into something a HASD unit can use for EVA operations."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "modkit"

	from_helmet = /obj/item/clothing/head/helmet/space/void/security
	from_suit = /obj/item/clothing/suit/space/void/security
	to_helmet = /obj/item/clothing/head/helmet/space/void/security/hasd
	to_suit = /obj/item/clothing/suit/space/void/security/hasd
*/

//InterroLouis - Kai Highlands
/obj/item/borg/upgrade/modkit/chassis_mod/kai
	name = "kai chassis"
	desc = "Makes your KA green. All the fun of having a more powerful KA without actually having a more powerful KA."
	cost = 0
	denied_type = /obj/item/borg/upgrade/modkit/chassis_mod
	chassis_icon = "kineticgun_K"
	chassis_name = "Kai-netic Accelerator"
	var/chassis_desc = "A self recharging, ranged mining tool that does increased damage in low temperature. Capable of holding up to six slots worth of mod kits. It seems to have been painted an ugly green, and has a small image of a bird scratched crudely into the stock."
	var/chassis_icon_file = 'icons/vore/custom_guns_vr.dmi'

/obj/item/borg/upgrade/modkit/chassis_mod/kai/install(obj/item/gun/energy/kinetic_accelerator/KA, mob/user)
	KA.desc = chassis_desc
	KA.icon = chassis_icon_file
	..()
/obj/item/borg/upgrade/modkit/chassis_mod/kai/uninstall(obj/item/gun/energy/kinetic_accelerator/KA)
	KA.desc = initial(KA.desc)
	KA.icon = initial(KA.icon)
	..()

//ArgobargSoup:Lynn Shady
/obj/item/flashlight/pen/fluff/lynn
	name = "Lynn's penlight"
	desc = "A personalized penlight, a bit bulkier than the standard model.  Blue, with a medical cross on it, and the name Lynn Shady engraved in gold."

	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "penlightlynn"

//Knightfall5:Ashley Kifer
/obj/item/clothing/accessory/medal/nobel_science/fluff/ashley
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering, this one has Ashley Kifer engraved on it."

//lm40 - Kenzie Houser
/obj/item/reagent_containers/hypospray/vial/kenzie
	name = "gold-trimmed hypospray"
	desc = "A gold-trimmed MKII hypospray. The name 'Kenzie Houser' is engraved on the side."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "kenziehypo"

//Semaun - Viktor Solothurn
/obj/item/reagent_containers/food/drinks/flask/vacuumflask/fluff/viktor
	name = "flask of expensive alcohol"
	desc = "A standard vacuum-flask filled with good and expensive drink."

/obj/item/reagent_containers/food/drinks/flask/vacuumflask/fluff/viktor/Initialize(mapload)
	. = ..()
	reagents.add_reagent("pwine", 60)

//RadiantAurora: Tiemli Kroto
/obj/item/clothing/glasses/welding/tiemgogs
   name = "custom-fitted welding goggles"
   desc = "A pair of thick, custom-fitted goggles with LEDs above the lenses. Ruggedly engraved below the lenses is the name 'Tiemli Kroto'."

   icon = 'icons/vore/custom_items_vr.dmi'
   icon_state = "tiemgogs"

   icon_override = 'icons/vore/custom_clothes_vr.dmi'
   icon_state = "tiemgogs"

//FauxMagician
/obj/item/faketvcamera
    name = "non-functioning press camera drone"
    desc = "A long since retired EyeBuddy media streaming hovercam with it's hover functionality being the only thing left alone on this unit."
    icon = 'icons/vore/custom_items_vr.dmi'
    icon_state = "jazzcamcorder"
    item_state = "jazzcamcorder"
    w_class = ITEMSIZE_LARGE
    slot_flags = SLOT_BELT
    var/obj/machinery/camera/network/thunder/camera

/obj/item/faketvcamera/update_icon()
	..()
	if(camera.status)
		icon_state = "jazzcamcorder_on"
		item_state = "jazzcamcorder_on"
	else
		icon_state = "jazzcamcorder"
		item_state = "jazzcamcorder"
	var/mob/living/carbon/human/H = loc
	if(istype(H))
		H.update_inv_r_hand()
		H.update_inv_l_hand()
		H.update_inv_belt()
