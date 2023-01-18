/obj/item/dnainjector
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	var/block=0
	var/datum/dna2/record/buf
	var/s_time = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	var/uses = 1
	var/nofail
	var/is_bullet = 0
	var/inuse = 0

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype=0
	var/value=0

/obj/item/dnainjector/Initialize(mapload)
	. = ..()
	if(datatype && block)
		buf = new
		buf.dna = new
		buf.types = datatype
		buf.dna.ResetSE()
		//testing("[name]: DNA2 SE blocks prior to SetValue: [english_list(buf.dna.SE)]")
		SetValue(src.value)
		//testing("[name]: DNA2 SE blocks after SetValue: [english_list(buf.dna.SE)]")

/obj/item/dnainjector/proc/GetRealBlock(var/selblock)
	if(selblock==0)
		return block
	else
		return selblock

/obj/item/dnainjector/proc/GetState(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/dnainjector/proc/SetState(var/on, var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/dnainjector/proc/GetValue(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/dnainjector/proc/SetValue(var/val,var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/dnainjector/proc/inject(mob/M as mob, mob/user as mob)
	if(istype(M,/mob/living))
		var/mob/living/L = M
		L.afflict_radiation(RAD_MOB_AFFLICT_DNA_INJECTOR)
		L.apply_damage(max(2,L.getCloneLoss()), CLONE)

	if (!(MUTATION_NOCLONE in M.mutations)) // prevents drained people from having their DNA changed
		if (buf.types & DNA2_BUF_UI)
			if (!block) //isolated block?
				M.UpdateAppearance(buf.dna.UI.Copy())
				if (buf.types & DNA2_BUF_UE) //unique enzymes? yes
					M.real_name = buf.dna.real_name
					M.name = buf.dna.real_name
				uses--
			else
				M.dna.SetUIValue(block,src.GetValue())
				M.UpdateAppearance()
				uses--
		if (buf.types & DNA2_BUF_SE)
			if (!block) //isolated block?
				M.dna.SE = buf.dna.SE.Copy()
				M.dna.UpdateSE()
			else
				M.dna.SetSEValue(block,src.GetValue())
			domutcheck(M, null, block!=null)
			uses--
			if(prob(5))
				trigger_side_effect(M)

	spawn(0)//this prevents the collapse of space-time continuum
		if (user)
			qdel(src)
	return uses

/obj/item/dnainjector/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = CLICKCHAIN_DO_NOT_PROPAGATE
	if(!user.IsAdvancedToolUser())
		user.action_feedback(SPAN_WARNING("You have no clue what to do with [src]."), src)
		return
	if(inuse)
		return

	user.visible_message("<span class='danger'>\The [user] is trying to inject \the [target] with \the [src]!</span>")
	inuse = 1
	s_time = world.time
	spawn(50)
		inuse = 0

	if(!do_after(user,50))
		return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	user.do_attack_animation(target)

	target.visible_message("<span class='danger'>\The [target] has been injected with \the [src] by \the [user].</span>")

	var/mob/living/carbon/human/H = target
	if(!istype(H))
		to_chat(user, "<span class='warning'>Apparently it didn't work...</span>")
		return

	// Used by admin log.
	var/injected_with_monkey = ""
	if((buf.types & DNA2_BUF_SE) && (block ? (GetState() && block == DNABLOCK_MONKEY) : GetState(DNABLOCK_MONKEY)))
		injected_with_monkey = " <span class='danger'>(MONKEY)</span>"

	add_attack_logs(user,target,"[injected_with_monkey] used the [name] on")

	// Apply the DNA shit.
	inject(target, user)
	return

/obj/item/dnainjector/hulkmut
	name = "\improper DNA injector (Hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/hulkmut/New()
	block = DNABLOCK_HULK
	..()

/obj/item/dnainjector/antihulk
	name = "\improper DNA injector (Anti-Hulk)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antihulk/New()
	block = DNABLOCK_HULK
	..()

/obj/item/dnainjector/xraymut
	name = "\improper DNA injector (Xray)"
	desc = "Finally you can see what the Facility Director does."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 8

/obj/item/dnainjector/xraymut/New()
	block = DNABLOCK_XRAY
	..()

/obj/item/dnainjector/antixray
	name = "\improper DNA injector (Anti-Xray)"
	desc = "It will make you see harder."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 8

/obj/item/dnainjector/antixray/New()
	block = DNABLOCK_XRAY
	..()

/obj/item/dnainjector/firemut
	name = "\improper DNA injector (Fire)"
	desc = "Gives you fire."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 10

/obj/item/dnainjector/firemut/New()
	block = DNABLOCK_FIRE
	..()

/obj/item/dnainjector/antifire
	name = "\improper DNA injector (Anti-Fire)"
	desc = "Cures fire."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 10

/obj/item/dnainjector/antifire/New()
	block = DNABLOCK_FIRE
	..()

/obj/item/dnainjector/telemut
	name = "\improper DNA injector (Tele.)"
	desc = "Super brain man!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 12

/obj/item/dnainjector/telemut/New()
	block = DNABLOCK_TELE
	..()

/obj/item/dnainjector/antitele
	name = "\improper DNA injector (Anti-Tele.)"
	desc = "Will make you not able to control your mind."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 12

/obj/item/dnainjector/antitele/New()
	block = DNABLOCK_TELE
	..()

/obj/item/dnainjector/nobreath
	name = "\improper DNA injector (No Breath)"
	desc = "Hold your breath and count to infinity."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/nobreath/New()
	block = DNABLOCK_NOBREATH
	..()

/obj/item/dnainjector/antinobreath
	name = "\improper DNA injector (Anti-No Breath)"
	desc = "Hold your breath and count to 100."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antinobreath/New()
	block = DNABLOCK_NOBREATH
	..()

/obj/item/dnainjector/remoteview
	name = "\improper DNA injector (Remote View)"
	desc = "Stare into the distance for a reason."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/remoteview/New()
	block = DNABLOCK_REMOTEVIEW
	..()

/obj/item/dnainjector/antiremoteview
	name = "\improper DNA injector (Anti-Remote View)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiremoteview/New()
	block = DNABLOCK_REMOTEVIEW
	..()

/obj/item/dnainjector/regenerate
	name = "\improper DNA injector (Regeneration)"
	desc = "Healthy but hungry."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/regenerate/New()
	block = DNABLOCK_REGENERATE
	..()

/obj/item/dnainjector/antiregenerate
	name = "\improper DNA injector (Anti-Regeneration)"
	desc = "Sickly but sated."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiregenerate/New()
	block = DNABLOCK_REGENERATE
	..()

/obj/item/dnainjector/runfast
	name = "\improper DNA injector (Increase Run)"
	desc = "Running Man."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/runfast/New()
	block = DNABLOCK_INCREASERUN
	..()

/obj/item/dnainjector/antirunfast
	name = "\improper DNA injector (Anti-Increase Run)"
	desc = "Walking Man."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antirunfast/New()
	block = DNABLOCK_INCREASERUN
	..()

/obj/item/dnainjector/morph
	name = "\improper DNA injector (Morph)"
	desc = "A total makeover."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/morph/New()
	block = DNABLOCK_MORPH
	..()

/obj/item/dnainjector/antimorph
	name = "\improper DNA injector (Anti-Morph)"
	desc = "Cures identity crisis."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antimorph/New()
	block = DNABLOCK_MORPH
	..()

/* No COLDBLOCK on bay
/obj/item/dnainjector/cold
	name = "\improper DNA injector (Cold)"
	desc = "Feels a bit chilly."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/cold/New()
	block = COLDBLOCK
	..()

/obj/item/dnainjector/anticold
	name = "\improper DNA injector (Anti-Cold)"
	desc = "Feels room-temperature."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/anticold/New()
	block = COLDBLOCK
	..()
*/

/obj/item/dnainjector/noprints
	name = "\improper DNA injector (No Prints)"
	desc = "Better than a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/noprints/New()
	block = DNABLOCK_NOPRINTS
	..()

/obj/item/dnainjector/antinoprints
	name = "\improper DNA injector (Anti-No Prints)"
	desc = "Not quite as good as a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antinoprints/New()
	block = DNABLOCK_NOPRINTS
	..()

/obj/item/dnainjector/insulation
	name = "\improper DNA injector (Shock Immunity)"
	desc = "Better than a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/insulation/New()
		block = DNABLOCK_NOSHOCK
		..()

/obj/item/dnainjector/antiinsulation
	name = "\improper DNA injector (Anti-Shock Immunity)"
	desc = "Not quite as good as a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antiinsulation/New()
	block = DNABLOCK_NOSHOCK
	..()

/obj/item/dnainjector/drarfism
	name = "\improper DNA injector (Small Size)"
	desc = "Makes you shrink."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/drarfism/New()
		block = DNABLOCK_DWARFISM
		..()

/obj/item/dnainjector/antidrarfism
	name = "\improper DNA injector (Anti-Small Size)"
	desc = "Makes you grow. But not too much."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antidrarfism/New()
	block = DNABLOCK_DWARFISM
	..()

/////////////////////////////////////
/obj/item/dnainjector/antiglasses
	name = "\improper DNA injector (Anti-Glasses)"
	desc = "Toss away those glasses!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 1

/obj/item/dnainjector/antiglasses/New()
	block = DNABLOCK_GLASSES
	..()

/obj/item/dnainjector/glassesmut
	name = "\improper DNA injector (Glasses)"
	desc = "Will make you need dorkish glasses."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 1

/obj/item/dnainjector/glassesmut/New()
	block = DNABLOCK_GLASSES
	..()

/obj/item/dnainjector/epimut
	name = "\improper DNA injector (Epi.)"
	desc = "Shake shake shake the room!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 3

/obj/item/dnainjector/epimut/New()
	block = DNABLOCK_HEADACHE
	..()

/obj/item/dnainjector/antiepi
	name = "\improper DNA injector (Anti-Epi.)"
	desc = "Will fix you up from shaking the room."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 3

/obj/item/dnainjector/antiepi/New()
	block = DNABLOCK_HEADACHE
	..()

/obj/item/dnainjector/anticough
	name = "\improper DNA injector (Anti-Cough)"
	desc = "Will stop that awful noise."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 5

/obj/item/dnainjector/anticough/New()
	block = DNABLOCK_COUGH
	..()

/obj/item/dnainjector/coughmut
	name = "\improper DNA injector (Cough)"
	desc = "Will bring forth a sound of horror from your throat."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 5

/obj/item/dnainjector/coughmut/New()
	block = DNABLOCK_COUGH
	..()

/obj/item/dnainjector/clumsymut
	name = "\improper DNA injector (Clumsy)"
	desc = "Makes clumsy minions."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 6

/obj/item/dnainjector/clumsymut/New()
	block = DNABLOCK_CLUMSY
	..()

/obj/item/dnainjector/anticlumsy
	name = "\improper DNA injector (Anti-Clumy)"
	desc = "Cleans up confusion."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 6

/obj/item/dnainjector/anticlumsy/New()
	block = DNABLOCK_CLUMSY
	..()

/obj/item/dnainjector/antitour
	name = "\improper DNA injector (Anti-Tour.)"
	desc = "Will cure tourrets."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 7

/obj/item/dnainjector/antitour/New()
	block = DNABLOCK_TWITCH
	..()

/obj/item/dnainjector/tourmut
	name = "\improper DNA injector (Tour.)"
	desc = "Gives you a nasty case off tourrets."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 7

/obj/item/dnainjector/tourmut/New()
	block = DNABLOCK_TWITCH
	..()

/obj/item/dnainjector/stuttmut
	name = "\improper DNA injector (Stutt.)"
	desc = "Makes you s-s-stuttterrr"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 9

/obj/item/dnainjector/stuttmut/New()
	block = DNABLOCK_NERVOUS
	..()

/obj/item/dnainjector/antistutt
	name = "\improper DNA injector (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 9

/obj/item/dnainjector/antistutt/New()
	block = DNABLOCK_NERVOUS
	..()

/obj/item/dnainjector/blindmut
	name = "\improper DNA injector (Blind)"
	desc = "Makes you not see anything."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 11

/obj/item/dnainjector/blindmut/New()
	block = DNABLOCK_BLIND
	..()

/obj/item/dnainjector/antiblind
	name = "\improper DNA injector (Anti-Blind)"
	desc = "ITS A MIRACLE!!!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 11

/obj/item/dnainjector/antiblind/New()
	block = DNABLOCK_BLIND
	..()

/obj/item/dnainjector/deafmut
	name = "\improper DNA injector (Deaf)"
	desc = "Sorry, what did you say?"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 13

/obj/item/dnainjector/deafmut/New()
	block = DNABLOCK_DEAF
	..()

/obj/item/dnainjector/antideaf
	name = "\improper DNA injector (Anti-Deaf)"
	desc = "Will make you hear once more."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 13

/obj/item/dnainjector/antideaf/New()
	block = DNABLOCK_DEAF
	..()

/obj/item/dnainjector/hallucination
	name = "\improper DNA injector (Halluctination)"
	desc = "What you see isn't always what you get."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2

/obj/item/dnainjector/hallucination/New()
	block = DNABLOCK_HALLUCINATION
	..()

/obj/item/dnainjector/antihallucination
	name = "\improper DNA injector (Anti-Hallucination)"
	desc = "What you see is what you get."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2

/obj/item/dnainjector/antihallucination/New()
	block = DNABLOCK_HALLUCINATION
	..()

/obj/item/dnainjector/h2m
	name = "\improper DNA injector (Human > Monkey)"
	desc = "Will make you a flea bag."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 14

/obj/item/dnainjector/h2m/New()
	block = DNABLOCK_MONKEY
	..()

/obj/item/dnainjector/m2h
	name = "\improper DNA injector (Monkey > Human)"
	desc = "Will make you...less hairy."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 14

/obj/item/dnainjector/m2h/New()
	block = DNABLOCK_MONKEY
	..()
