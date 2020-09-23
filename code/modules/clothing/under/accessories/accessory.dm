/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bluetie"
	item_state_slots = list(slot_r_hand_str = "", slot_l_hand_str = "")
	appearance_flags = RESET_COLOR	// Stops has_suit's color from being multiplied onto the accessory
	slot_flags = SLOT_TIE
	w_class = ITEMSIZE_SMALL
	var/slot = ACCESSORY_SLOT_DECOR
	var/obj/item/clothing/has_suit = null		// The suit the tie may be attached to
	var/image/inv_overlay = null				// Overlay used when attached to clothing.
	var/image/mob_overlay = null
	var/overlay_state = null
	var/concealed_holster = 0
	var/mob/living/carbon/human/wearer = null 	// To check if the wearer changes, so species spritesheets change properly.
	var/list/on_rolled = list()					// Used when jumpsuit sleevels are rolled ("rolled" entry) or it's rolled down ("down"). Set to "none" to hide in those states.
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/ties.dmi', //Teshari can into webbing, too!
		SPECIES_VOX = 'icons/mob/species/vox/ties.dmi')

/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()

/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
		if(icon_override)
			if("[tmp_icon_state]_tie" in icon_states(icon_override))
				tmp_icon_state = "[tmp_icon_state]_tie"
			inv_overlay = image(icon = icon_override, icon_state = tmp_icon_state, dir = SOUTH)
		else
			inv_overlay = image(icon = INV_ACCESSORIES_DEF_ICON, icon_state = tmp_icon_state, dir = SOUTH)

		inv_overlay.color = src.color
		inv_overlay.appearance_flags = appearance_flags	// Stops has_suit's color from being multiplied onto the accessory
	return inv_overlay

/obj/item/clothing/accessory/proc/get_mob_overlay()
	if(!istype(loc,/obj/item/clothing/))	//don't need special handling if it's worn as normal item.
		return ..()
	var/tmp_icon_state = "[overlay_state? "[overlay_state]" : "[icon_state]"]"
	if(ishuman(has_suit.loc))
		wearer = has_suit.loc
	else
		wearer = null

	if(istype(loc,/obj/item/clothing/under))
		var/obj/item/clothing/under/C = loc
		if(on_rolled["down"] && C.rolled_down > 0)
			tmp_icon_state = on_rolled["down"]
		else if(on_rolled["rolled"] && C.rolled_sleeves > 0)
			tmp_icon_state = on_rolled["rolled"]

	if(icon_override)
		if("[tmp_icon_state]_mob" in icon_states(icon_override))
			tmp_icon_state = "[tmp_icon_state]_mob"
		mob_overlay = image("icon" = icon_override, "icon_state" = "[tmp_icon_state]")
	else if(wearer && sprite_sheets[wearer.species.get_bodytype(wearer)]) //Teshari can finally into webbing, too!
		mob_overlay = image("icon" = sprite_sheets[wearer.species.get_bodytype(wearer)], "icon_state" = "[tmp_icon_state]")
	else
		mob_overlay = image("icon" = INV_ACCESSORIES_DEF_ICON, "icon_state" = "[tmp_icon_state]")
	if(addblends)
		var/icon/base = new/icon("icon" = mob_overlay.icon, "icon_state" = mob_overlay.icon_state)
		var/addblend_icon = new/icon("icon" = mob_overlay.icon, "icon_state" = src.addblends)
		if(color)
			base.Blend(src.color, ICON_MULTIPLY)
		base.Blend(addblend_icon, ICON_ADD)
		mob_overlay = image(base)
	else
		mob_overlay.color = src.color

	mob_overlay.appearance_flags = appearance_flags	// Stops has_suit's color from being multiplied onto the accessory
	return mob_overlay

//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	src.forceMove(S)
	has_suit.add_overlay(get_inv_overlay())

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [has_suit].</span>")
		add_fingerprint(user)

/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!has_suit)
		return
	has_suit.cut_overlay(get_inv_overlay())
	has_suit = null
	if(user)
		usr.put_in_hands(src)
		add_fingerprint(user)
	else if(get_turf(src))		//We actually exist in space
		forceMove(get_turf(src))

//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()

//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(has_suit)
		return	//we aren't an object on the ground so don't call parent
	..()

/obj/item/clothing/accessory/tie
	name = "blue tie"
	icon_state = "bluetie"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/tie/red
	name = "red tie"
	icon_state = "redtie"

/obj/item/clothing/accessory/tie/blue_clip
	name = "blue tie with a clip"
	icon_state = "bluecliptie"

/obj/item/clothing/accessory/tie/blue_long
	name = "blue long tie"
	icon_state = "bluelongtie"

/obj/item/clothing/accessory/tie/red_clip
	name = "red tie with a clip"
	icon_state = "redcliptie"

/obj/item/clothing/accessory/tie/red_long
	name = "red long tie"
	icon_state = "redlongtie"

/obj/item/clothing/accessory/tie/black
	name = "black tie"
	icon_state = "blacktie"

/obj/item/clothing/accessory/tie/darkgreen
	name = "dark green tie"
	icon_state = "dgreentie"

/obj/item/clothing/accessory/tie/yellow
	name = "yellow tie"
	icon_state = "yellowtie"

/obj/item/clothing/accessory/tie/navy
	name = "navy tie"
	icon_state = "navytie"

/obj/item/clothing/accessory/tie/white
	name = "white tie"
	icon_state = "whitetie"

/obj/item/clothing/accessory/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"

/obj/item/clothing/accessory/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/stethoscope/do_surgery(mob/living/carbon/human/M, mob/living/user)
	if(user.a_intent != INTENT_HELP) //in case it is ever used as a surgery tool
		return ..()
	attack(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/clothing/accessory/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_sel.selecting)
			if(body_part)
				var/their = "their"
				switch(M.gender)
					if(MALE)	their = "his"
					if(FEMALE)	their = "her"

				var/sound = "heartbeat"
				var/sound_strength = "cannot hear"
				var/heartbeat = 0
				var/obj/item/organ/internal/heart/heart = M.internal_organs_by_name[O_HEART]
				if(heart && !(heart.robotic >= ORGAN_ROBOT))
					heartbeat = 1
				if(M.stat == DEAD || (M.status_flags&FAKEDEATH))
					sound_strength = "cannot hear"
					sound = "anything"
				else
					switch(body_part)
						if(BP_TORSO)
							sound_strength = "hear"
							sound = "no heartbeat"
							if(heartbeat)
								if(heart.is_bruised() || M.getOxyLoss() > 50)
									sound = "[pick("odd noises in","weak")] heartbeat"
								else
									sound = "healthy heartbeat"

							var/obj/item/organ/internal/heart/L = M.internal_organs_by_name[O_LUNGS]
							if(!L || M.losebreath)
								sound += " and no respiration"
							else if(M.is_lung_ruptured() || M.getOxyLoss() > 50)
								sound += " and [pick("wheezing","gurgling")] sounds"
							else
								sound += " and healthy respiration"
						if(O_EYES,O_MOUTH)
							sound_strength = "cannot hear"
							sound = "anything"
						else
							if(heartbeat)
								sound_strength = "hear a weak"
								sound = "pulse"

				user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "You place [src] against [their] [body_part]. You [sound_strength] [sound].")
				return
	return ..(M,user)

//Medals
/obj/item/clothing/accessory/medal
	name = "bronze medal"
	desc = "A bronze medal."
	icon_state = "bronze"
	slot = ACCESSORY_SLOT_MEDAL

/obj/item/clothing/accessory/medal/conduct
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is most basic award on offer. It is often awarded by a captain to a member of their crew."

/obj/item/clothing/accessory/medal/bronze_heart
	name = "bronze heart medal"
	desc = "A bronze heart-shaped medal awarded for sacrifice. It is often awarded posthumously or for severe injury in the line of duty."
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/nobel_science
	name = "nobel sciences award"
	desc = "A bronze medal which represents significant contributions to the field of science or engineering."

/obj/item/clothing/accessory/medal/silver
	name = "silver medal"
	desc = "A silver medal."
	icon_state = "silver"

/obj/item/clothing/accessory/medal/silver/valor
	name = "medal of valor"
	desc = "A silver medal awarded for acts of exceptional valor."

/obj/item/clothing/accessory/medal/silver/security
	name = "robust security award"
	desc = "An award for distinguished combat and sacrifice in defence of corporate commercial interests. Often awarded to security staff."

/obj/item/clothing/accessory/medal/gold
	name = "gold medal"
	desc = "A prestigious golden medal."
	icon_state = "gold"

/obj/item/clothing/accessory/medal/gold/captain
	name = "medal of captaincy"
	desc = "A golden medal awarded exclusively to those promoted to the rank of captain. It signifies the codified responsibilities of a captain, and their undisputable authority over their crew."

/obj/item/clothing/accessory/medal/gold/heroism
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by high ranking officials. To recieve such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but distinguished veteran staff."

// Base type for 'medals' found in a "dungeon" submap, as a sort of trophy to celebrate the player's conquest.
/obj/item/clothing/accessory/medal/dungeon

/obj/item/clothing/accessory/medal/dungeon/alien_ufo
	name = "alien captain's medal"
	desc = "It vaguely like a star. It looks like something an alien captain might've worn. Probably."
	icon_state = "alien_medal"

//Scarves

/obj/item/clothing/accessory/scarf
	name = "green scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	icon_state = "greenscarf"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/scarf/red
	name = "red scarf"
	icon_state = "redscarf"

/obj/item/clothing/accessory/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "darkbluescarf"

/obj/item/clothing/accessory/scarf/purple
	name = "purple scarf"
	icon_state = "purplescarf"

/obj/item/clothing/accessory/scarf/yellow
	name = "yellow scarf"
	icon_state = "yellowscarf"

/obj/item/clothing/accessory/scarf/orange
	name = "orange scarf"
	icon_state = "orangescarf"

/obj/item/clothing/accessory/scarf/lightblue
	name = "light blue scarf"
	icon_state = "lightbluescarf"

/obj/item/clothing/accessory/scarf/white
	name = "white scarf"
	icon_state = "whitescarf"

/obj/item/clothing/accessory/scarf/black
	name = "black scarf"
	icon_state = "blackscarf"

/obj/item/clothing/accessory/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/accessory/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

/obj/item/clothing/accessory/scarf/stripedred
	name = "striped red scarf"
	icon_state = "stripedredscarf"

/obj/item/clothing/accessory/scarf/stripedgreen
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"

/obj/item/clothing/accessory/scarf/stripedblue
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"

/obj/item/clothing/accessory/scarf/teshari/neckscarf
	name = "small neckscarf"
	desc = "a neckscarf that is too small for a human's neck"
	icon_state = "tesh_neckscarf"
	species_restricted = list(SPECIES_TESHARI)

//bracelets

/obj/item/clothing/accessory/bracelet
	name = "bracelet"
	desc = "A simple silver bracelet with a clasp."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "bracelet"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_TIE
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/bracelet/friendship
	name = "friendship bracelet"
	desc = "A beautiful friendship bracelet in all the colors of the rainbow."
	icon_state = "friendbracelet"

/obj/item/clothing/accessory/bracelet/friendship/verb/dedicate_bracelet()
	set name = "Dedicate Bracelet"
	set category = "Object"
	set desc = "Dedicate your friendship bracelet to a special someone."
	var/mob/M = usr
	if(!M.mind)
		return 0

	var/input = sanitizeSafe(input("Who do you want to dedicate the bracelet to?", ,""), MAX_NAME_LEN)

	if(src && input && !M.stat && in_range(M,src))
		desc = "A beautiful friendship bracelet in all the colors of the rainbow. It's dedicated to [input]."
		to_chat(M, "You dedicate the bracelet to [input], remembering the times you've had together.")
		return 1


/obj/item/clothing/accessory/bracelet/material
	icon_state = "materialbracelet"

/obj/item/clothing/accessory/bracelet/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] bracelet"
	desc = "A bracelet made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/bracelet/material/get_material()
	return material

/obj/item/clothing/accessory/bracelet/material/wood/New(var/newloc)
	..(newloc, "wood")

/obj/item/clothing/accessory/bracelet/material/plastic/New(var/newloc)
	..(newloc, "plastic")

/obj/item/clothing/accessory/bracelet/material/iron/New(var/newloc)
	..(newloc, "iron")

/obj/item/clothing/accessory/bracelet/material/steel/New(var/newloc)
	..(newloc, "steel")

/obj/item/clothing/accessory/bracelet/material/silver/New(var/newloc)
	..(newloc, "silver")

/obj/item/clothing/accessory/bracelet/material/gold/New(var/newloc)
	..(newloc, "gold")

/obj/item/clothing/accessory/bracelet/material/platinum/New(var/newloc)
	..(newloc, "platinum")

/obj/item/clothing/accessory/bracelet/material/phoron/New(var/newloc)
	..(newloc, "phoron")

/obj/item/clothing/accessory/bracelet/material/glass/New(var/newloc)
	..(newloc, "glass")

	..()

/obj/item/clothing/accessory/halfcape
	name = "half cape"
	desc = "A tasteful half-cape, suitible for European nobles and retro anime protagonists."
	icon_state = "halfcape"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/fullcape
	name = "full cape"
	desc = "A gaudy full cape. You're thinking about wearing it, aren't you?"
	icon_state = "fullcape"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/sash
	name = "sash"
	desc = "A plain, unadorned sash."
	icon_state = "sash"
	slot = ACCESSORY_SLOT_OVER

/obj/item/clothing/accessory/necklace
	name = "necklace"
	desc = "Alt-click to name and add a description."
	icon_state = "locket"
	var/described = FALSE
	var/named = FALSE
	var/coloured = FALSE

/obj/item/clothing/accessory/necklace/AltClick(mob/user)
	if(!named)
		var/inputname = sanitizeSafe(input("Enter a prefix for the necklace's name.", ,""), MAX_NAME_LEN)
		if(src && inputname && in_range(user,src))
			name = "[inputname] necklace"
			to_chat(user, "You describe the [name].")
			named = TRUE
	if(!described)
		var/inputdesc = sanitizeSafe(input("Enter the new description for the necklace. 2048 character limit.", ,""), 2048) // 2048 character limit
		if(src && inputdesc && in_range(user,src))
			desc = "[inputdesc]"
			to_chat(user, "You describe the [name].")
			described = TRUE
	if(!coloured)
		var/colour_input = input(usr,"","Choose Color",color) as color|null
		if(colour_input)
			color = sanitize_hexcolor(colour_input)
			coloured = TRUE

//
// Collars and such like that
//

/obj/item/clothing/accessory/choker //A colorable, tagless choker
	name = "plain choker"
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	desc = "A simple, plain choker. Or maybe it's a collar? Use in-hand to customize it."
	icon = 'icons/obj/clothing/collars_vr.dmi'
	icon_override = 'icons/mob/ties.dmi'
	icon_state = "choker_cst"
	item_state = "choker_cst_overlay"
	overlay_state = "choker_cst_overlay"
	var/customized = 0

/obj/item/clothing/accessory/choker/attack_self(mob/user as mob)
	if(!customized)
		var/design = input(user,"Descriptor?","Pick descriptor","") in list("plain","simple","ornate","elegant","opulent")
		var/material = input(user,"Material?","Pick material","") in list("leather","velvet","lace","fabric","latex","plastic","metal","chain","silver","gold","platinum","steel","bead","ruby","sapphire","emerald","diamond")
		var/type = input(user,"Type?","Pick type","") in list("choker","collar","necklace")
		name = "[design] [material] [type]"
		desc = "A [type], made of [material]. It's rather [design]."
		customized = 1
		to_chat(usr,"<span class='notice'>[src] has now been customized.</span>")
	else
		to_chat(usr,"<span class='notice'>[src] has already been customized!</span>")

/obj/item/clothing/accessory/collar
	slot_flags = SLOT_TIE | SLOT_OCLOTHING
	icon = 'icons/obj/clothing/collars_vr.dmi'
	icon_override = 'icons/mob/ties.dmi'
	var/icon_previous_override //yw addition
	var/writtenon = 0

//ywedit start. forces different sprite sheet on equip
/obj/item/clothing/accessory/collar/New()
	..()
	icon_previous_override = icon_override

/obj/item/clothing/accessory/collar/equipped() //Solution for race-specific sprites for an accessory which is also a suit. Suit icons break if you don't use icon override which then also overrides race-specific sprites.
	..()
	setUniqueSpeciesSprite()

/obj/item/clothing/accessory/collar/proc/setUniqueSpeciesSprite()
	var/mob/living/carbon/human/H = loc
	if(!istype(H))
		if(istype(has_suit) && ishuman(has_suit.loc))
			H = has_suit.loc
	if(istype(H))
		if(H.species.name == SPECIES_TESHARI)
			icon_override = 'icons/mob/species/teshari/ties.dmi'
		update_clothing_icon()

/obj/item/clothing/accessory/collar/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	has_suit = S
	setUniqueSpeciesSprite()
	..(S, user)

/obj/item/clothing/accessory/collar/dropped()
	icon_override = icon_previous_override
//ywedit end

/obj/item/clothing/accessory/collar/silver
	name = "Silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_blk"
	item_state = "collar_blk_overlay"
	overlay_state = "collar_blk_overlay"

/obj/item/clothing/accessory/collar/gold
	name = "Golden tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_gld"
	item_state = "collar_gld_overlay"
	overlay_state = "collar_gld_overlay"

/obj/item/clothing/accessory/collar/bell
	name = "Bell collar"
	desc = "A collar with a tiny bell hanging from it, purrfect furr kitties."
	icon_state = "collar_bell"
	item_state = "collar_bell_overlay"
	overlay_state = "collar_bell_overlay"
	var/jingled = 0

/obj/item/clothing/accessory/collar/bell/verb/jinglebell()
	set name = "Jingle Bell"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(!jingled)
		usr.audible_message("[usr] jingles the [src]'s bell.")
		jingled = 1
		addtimer(CALLBACK(src, .proc/jingledreset), 50)
	return

/obj/item/clothing/accessory/collar/bell/proc/jingledreset()
		jingled = 0

/obj/item/clothing/accessory/collar/shock
	name = "Shock collar"
	desc = "A collar used to ease hungry predators."
	icon_state = "collar_shk0"
	item_state = "collar_shk_overlay"
	overlay_state = "collar_shk_overlay"
	var/on = FALSE // 0 for off, 1 for on, starts off to encourage people to set non-default frequencies and codes.
	var/frequency = 1449
	var/code = 2
	var/datum/radio_frequency/radio_connection

/obj/item/clothing/accessory/collar/shock/Initialize()
	..()
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT) // Makes it so you don't need to change the frequency off of default for it to work.

/obj/item/clothing/accessory/collar/shock/Destroy() //Clean up your toys when you're done.
	radio_controller.remove_object(src, frequency)
	radio_connection = null //Don't delete this, this is a shared object.
	return ..()

/obj/item/clothing/accessory/collar/shock/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_CHAT)

/obj/item/clothing/accessory/collar/shock/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( SSticker ) || (SSticker && SSticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_machine(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		if(href_list["tag"])
			var/str = copytext(reject_bad_text(input(usr,"Tag text?","Set tag","")),1,MAX_NAME_LEN)
			if(!str || !length(str))
				to_chat(usr,"<span class='notice'>[name]'s tag set to be blank.</span>")
				name = initial(name)
				desc = initial(desc)
			else
				to_chat(usr,"<span class='notice'>You set the [name]'s tag to '[str]'.</span>")
				name = initial(name) + " ([str])"
				desc = initial(desc) + " The tag says \"[str]\"."
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !( on )
					icon_state = "collar_shk[on]" // And apparently this works, too?!
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/clothing/accessory/collar/shock/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(on)
		var/mob/M = null
		if(ismob(loc))
			M = loc
		if(ismob(loc.loc))
			M = loc.loc // This is about as terse as I can make my solution to the whole 'collar won't work when attached as accessory' thing.
		to_chat(M,"<span class='danger'>You feel a sharp shock!</span>")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, M)
		s.start()
		M.Weaken(10)
	return

/obj/item/clothing/accessory/collar/shock/attack_self(mob/user as mob, flag1)
	if(!istype(user, /mob/living/carbon/human))
		return
	user.set_machine(src)
	var/dat = {"<TT>
			<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
			<B>Frequency/Code</B> for collar:<BR>
			Frequency:
			<A href='byond://?src=\ref[src];freq=-10'>-</A>
			<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
			<A href='byond://?src=\ref[src];freq=2'>+</A>
			<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

			Code:
			<A href='byond://?src=\ref[src];code=-5'>-</A>
			<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
			<A href='byond://?src=\ref[src];code=1'>+</A>
			<A href='byond://?src=\ref[src];code=5'>+</A><BR>

			Tag:
			<A href='?src=\ref[src];tag=1'>Set tag</A><BR>
			</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return

/obj/item/clothing/accessory/collar/spike
	name = "Spiked collar"
	desc = "A collar with spikes that look as sharp as your teeth."
	icon_state = "collar_spik"
	item_state = "collar_spik_overlay"
	overlay_state = "collar_spik_overlay"

/obj/item/clothing/accessory/collar/pink
	name = "Pink collar"
	desc = "This collar will make your pets look FA-BU-LOUS."
	icon_state = "collar_pnk"
	item_state = "collar_pnk_overlay"
	overlay_state = "collar_pnk_overlay"

/obj/item/clothing/accessory/collar/holo
	name = "Holo-collar"
	desc = "An expensive holo-collar for the modern day pet."
	icon_state = "collar_holo"
	item_state = "collar_holo_overlay"
	overlay_state = "collar_holo_overlay"
	matter = list(DEFAULT_WALL_MATERIAL = 50)

/obj/item/clothing/accessory/collar/silvercolor
	name = "Dyeable Silver tag collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_blk_colorized"
	item_state = "collar_blk_colorized_overlay"
	overlay_state = "collar_blk_colorized_overlay"

/obj/item/clothing/accessory/collar/cowbell
	name = "Cowbell collar"
	desc = "A collar for your little pets... or the big ones."
	icon_state = "collar_cowbell"
	item_state = "collar_cowbell_overlay"
	overlay_state = "collar_cowbell_overlay"

//TFF 17/6/19 - public loadout addition: Indigestible Holocollar
/obj/item/clothing/accessory/collar/holo/indigestible
	name = "Holo-collar"
	desc = "A special variety of the holo-collar that seems to be made of a very durable fabric that fits around the neck."
	icon_state = "collar_holo"
	item_state = "collar_holo_overlay"
	overlay_state = "collar_holo_overlay"
//Make indigestible
/obj/item/clothing/accessory/collar/holo/indigestible/digest_act(var/atom/movable/item_storage = null)
	return FALSE

/obj/item/clothing/accessory/collar/attack_self(mob/user as mob)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		to_chat(user,"<span class='notice'>[name]'s interface is projected onto your hand.</span>")
	else
		if(writtenon)
			to_chat(user,"<span class='notice'>You need a pen or a screwdriver to edit the tag on this collar.</span>")
			return
		to_chat(user,"<span class='notice'>You adjust the [name]'s tag.</span>")

	var/str = copytext(reject_bad_text(input(user,"Tag text?","Set tag","")),1,MAX_NAME_LEN)

	if(!str || !length(str))
		to_chat(user,"<span class='notice'>[name]'s tag set to be blank.</span>")
		name = initial(name)
		desc = initial(desc)
	else
		to_chat(user,"<span class='notice'>You set the [name]'s tag to '[str]'.</span>")
		initialize_tag(str)

/obj/item/clothing/accessory/collar/proc/initialize_tag(var/tag)
		name = initial(name) + " ([tag])"
		desc = initial(desc) + " \"[tag]\" has been engraved on the tag."
		writtenon = 1

/obj/item/clothing/accessory/collar/holo/initialize_tag(var/tag)
		..()
		desc = initial(desc) + " The tag says \"[tag]\"."

/obj/item/clothing/accessory/collar/attackby(obj/item/I, mob/user)
	if(istype(src,/obj/item/clothing/accessory/collar/holo))
		return

	if(istype(I,/obj/item/tool/screwdriver))
		update_collartag(user, I, "scratched out", "scratch out", "engraved")
		return

	if(istype(I,/obj/item/pen))
		update_collartag(user, I, "crossed out", "cross out", "written")
		return

	to_chat(user,"<span class='notice'>You need a pen or a screwdriver to edit the tag on this collar.</span>")

/obj/item/clothing/accessory/collar/proc/update_collartag(mob/user, obj/item/I, var/erasemethod, var/erasing, var/writemethod)
	if(!(istype(user.get_active_hand(),I)) || !(istype(user.get_inactive_hand(),src)) || (user.stat))
		return

	var/str = copytext(reject_bad_text(input(user,"Tag text?","Set tag","")),1,MAX_NAME_LEN)

	if(!str || !length(str))
		if(!writtenon)
			to_chat(user,"<span class='notice'>You don't write anything.</span>")
		else
			to_chat(user,"<span class='notice'>You [erasing] the words with the [I].</span>")
			name = initial(name)
			desc = initial(desc) + " The tag has had the words [erasemethod]."
	else
		if(!writtenon)
			to_chat(user,"<span class='notice'>You write '[str]' on the tag with the [I].</span>")
			name = initial(name) + " ([str])"
			desc = initial(desc) + " \"[str]\" has been [writemethod] on the tag."
			writtenon = 1
		else
			to_chat(user,"<span class='notice'>You [erasing] the words on the tag with the [I], and write '[str]'.</span>")
			name = initial(name) + " ([str])"
			desc = initial(desc) + " Something has been [erasemethod] on the tag, and it now has \"[str]\" [writemethod] on it."

//Machete Holsters
/obj/item/clothing/accessory/holster/machete
	name = "machete sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon_state = "holster_machete"
	slot = ACCESSORY_SLOT_WEAPON
	concealed_holster = 0
	can_hold = list(/obj/item/material/knife/machete)
	//sound_in = 'sound/effects/holster/sheathin.ogg'
	//sound_out = 'sound/effects/holster/sheathout.ogg'

//Medals

/obj/item/clothing/accessory/medal/silver/unity
	name = "medal of unity"
	desc = "A silver medal awarded to a group which has demonstrated exceptional teamwork to achieve a notable feat."
