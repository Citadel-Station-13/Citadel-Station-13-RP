//Here you find the wonderfull code for suitcyclers
//I did not write this, I just copied it to this page to take it from suit_storage_unit.dm

// TODO: UNIFY WITH SUIT STORAGE UNITS WHY ARE THESE SEPARATE
/obj/machinery/suit_cycler

	name = "suit cycler"
	desc = "An industrial machine for painting and refitting voidsuits."
	anchored = 1
	density = 1

	icon = 'icons/obj/suitstorage.dmi'
	icon_state = "suitstorage000000100"

	req_access = list(access_captain,access_heads)

	var/active = 0          // PLEASE HOLD.
	var/safeties = 1        // The cycler won't start with a living thing inside it unless safeties are off.
	var/irradiating = 0     // If this is > 0, the cycler is decontaminating whatever is inside it.
	var/radiation_level = 2 // 1 is removing germs, 2 is removing blood, 3 is removing phoron.
	var/model_text = ""     // Some flavour text for the topic box.
	var/locked = 1          // If locked, nothing can be taken from or added to the cycler.
	var/can_repair          // If set, the cycler can repair voidsuits.
	var/electrified = 0

	//Departments that the cycler can paint suits to look like.
	var/list/departments = list("Engineering","Mining","Medical","Security","Atmos","HAZMAT","Construction","Biohazard","Emergency Medical Response","Crowd Control","Director","Head of Security", "No Change")
	//Species that the suits can be configured to fit.
	var/list/species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_AKULA, SPECIES_ALRAUNE, SPECIES_NEVREAN, SPECIES_RAPALA, SPECIES_SERGAL, SPECIES_VASILISSAN, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VOX, SPECIES_AURIL, SPECIES_DREMACHIR, SPECIES_APIDAEN)

	var/target_department
	var/target_species

	var/mob/living/carbon/human/occupant = null
	var/obj/item/clothing/suit/space/void/suit = null
	var/obj/item/clothing/head/helmet/space/helmet = null

	var/datum/wires/suit_storage_unit/wires = null

/obj/machinery/suit_cycler/Initialize(mapload)
	. = ..()
	wires = new(src)
	if(!length(departments) || !length(species))
		return INITIALIZE_HINT_QDEL
	target_department = departments[1]
	target_species = species[1]

/obj/machinery/suit_cycler/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/suit_cycler/engineering
	name = "Engineering suit cycler"
	model_text = "Engineering"
	req_access = list(access_construction)
	departments = list("Engineering","Atmos","HAZMAT","Construction", "No Change")

/obj/machinery/suit_cycler/mining
	name = "Mining suit cycler"
	model_text = "Mining"
	req_access = list(access_mining)
	departments = list("Mining", "No Change")

/obj/machinery/suit_cycler/security
	name = "Security suit cycler"
	model_text = "Security"
	req_access = list(access_security)
	departments = list("Security","Crowd Control", "No Change")

/obj/machinery/suit_cycler/medical
	name = "Medical suit cycler"
	model_text = "Medical"
	req_access = list(access_medical)
	departments = list("Medical","Biohazard","Emergency Medical Response", "No Change")

/obj/machinery/suit_cycler/syndicate
	name = "Nonstandard suit cycler"
	model_text = "Nonstandard"
	req_access = list(access_syndicate)
	departments = list("Mercenary", "Charring", "No Change")
	can_repair = 1

/obj/machinery/suit_cycler/exploration
	name = "Explorer suit cycler"
	model_text = "Exploration"
	req_access = list(access_explorer) //Old Exploration needs fixing up
	departments = list("Exploration", "No Change")

/obj/machinery/suit_cycler/pathfinder
	name = "Pathfinder suit cycler"
	model_text = "Pathfinder"
	req_access = list(access_pathfinder)
	departments = list("Pathfinder", "No Change")

/obj/machinery/suit_cycler/pilot
	name = "Pilot suit cycler"
	model_text = "Pilot"
	req_access = list(access_pilot)
	departments = list("Pilot", "No Change") //Pilot Blue needs fixing up

/obj/machinery/suit_cycler/director
	name = "Director suit cycler"
	model_text = "Director"
	req_access = list(access_captain)
	departments = list("Director", "No Change")
	species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJ, SPECIES_VULPKANIN)

/obj/machinery/suit_cycler/headofsecurity
	name = "Head of Security suit cycler"
	model_text = "Head of Security"
	req_access = list(access_hos)
	departments = list("Head of Security", "No Change")
	species = list(SPECIES_HUMAN,SPECIES_UNATHI,SPECIES_TAJ, SPECIES_VULPKANIN)

/obj/machinery/suit_cycler/vintage
	name = "Vintage Crew suit cycler"
	model_text = "Vintage"
	departments = list("Vintage Crew","No Change")
	req_access = null

/obj/machinery/suit_cycler/vintage/pilot
	name = "Vintage Pilot suit cycler"
	model_text = "Vintage Pilot"
	departments = list("Vintage Pilot (Bubble Helm)","Vintage Pilot (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/medsci
	name = "Vintage MedSci suit cycler"
	model_text = "Vintage MedSci"
	departments = list("Vintage Medical (Bubble Helm)","Vintage Medical (Closed Helm)","Vintage Research (Bubble Helm)","Vintage Research (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/rugged
	name = "Vintage Ruggedized suit cycler"
	model_text = "Vintage Ruggedized"
	departments = list("Vintage Engineering","Vintage Marine","Vintage Officer","Vintage Mercenary","No Change")

/obj/machinery/suit_cycler/vintage/omni
	name = "Vintage Master suit cycler"
	model_text = "Vintage Master"
	departments = list("Vintage Crew","Vintage Engineering","Vintage Pilot (Bubble Helm)","Vintage Pilot (Closed Helm)","Vintage Medical (Bubble Helm)","Vintage Medical (Closed Helm)","Vintage Research (Bubble Helm)","Vintage Research (Closed Helm)","Vintage Marine","Vintage Officer","Vintage Mercenary","No Change")

/obj/machinery/suit_cycler/vintage/Initialize(mapload)
	species -= SPECIES_TESHARI
	return ..()

/obj/machinery/suit_cycler/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/suit_cycler/attackby(obj/item/I as obj, mob/user as mob)

	if(electrified != 0)
		if(shock(user, 100))
			return

	//Hacking init.
	if(istype(I, /obj/item/multitool) || I.is_wirecutter())
		if(panel_open)
			attack_hand(user)
		return
	//Other interface stuff.
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(!(ismob(G.affecting)))
			return

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(contents.len > 0)
			to_chat(user, "<span class='danger'>There is no room inside the cycler for [G.affecting.name].</span>")
			return

		visible_message("<span class='notice'>[user] starts putting [G.affecting.name] into the suit cycler.</span>", 3)

		if(do_after(user, 20))
			if(!G || !G.affecting)
				return
			var/mob/M = G.affecting
			M.forceMove(src)
			M.update_perspective()
			occupant = M

			add_fingerprint(user)
			qdel(G)

			updateUsrDialog()

			return
	else if(I.is_screwdriver())

		panel_open = !panel_open
		playsound(src, I.tool_sound, 50, 1)
		to_chat(user, "You [panel_open ?  "open" : "close"] the maintenance panel.")
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/head/helmet/space) && !istype(I, /obj/item/clothing/head/helmet/space/rig))

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(helmet)
			to_chat(user, "<span class='danger'>The cycler already contains a helmet.</span>")
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		if(!user.attempt_insert_item_for_installation(I, src))
			return
		to_chat(user, "You fit \the [I] into the suit cycler.")
		helmet = I

		update_icon()
		updateUsrDialog()
		return

	else if(istype(I,/obj/item/clothing/suit/space/void))

		if(locked)
			to_chat(user, "<span class='danger'>The suit cycler is locked.</span>")
			return

		if(suit)
			to_chat(user, "<span class='danger'>The cycler already contains a voidsuit.</span>")
			return

		if(I.icon_override == CUSTOM_ITEM_MOB)
			to_chat(user, "You cannot refit a customised voidsuit.")
			return

		if(!user.attempt_insert_item_for_installation(I, src))
			return
		to_chat(user, "You fit \the [I] into the suit cycler.")
		suit = I

		update_icon()
		updateUsrDialog()
		return

	..()

/obj/machinery/suit_cycler/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, "<span class='danger'>The cycler has already been subverted.</span>")
		return

	//Clear the access reqs, disable the safeties, and open up all paintjobs.
	to_chat(user, "<span class='danger'>You run the sequencer across the interface, corrupting the operating protocols.</span>")
	departments = list("Engineering","Mining","Medical","Security","Atmos","HAZMAT","Construction","Biohazard","Crowd Control","Emergency Medical Response","^%###^%$", "Charring", "No Change")
	species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_AKULA, SPECIES_ALRAUNE, SPECIES_NEVREAN, SPECIES_RAPALA, SPECIES_SERGAL, SPECIES_VASILISSAN, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_ZORREN_FLAT, SPECIES_ZORREN_HIGH, SPECIES_VOX, SPECIES_AURIL, SPECIES_DREMACHIR, SPECIES_APIDAEN)

	emagged = 1
	safeties = 0
	req_access = list()
	updateUsrDialog()
	return 1

/obj/machinery/suit_cycler/attack_hand(mob/user as mob)

	add_fingerprint(user)

	if(..() || machine_stat & (BROKEN|NOPOWER))
		return

	if(!user.IsAdvancedToolUser())
		return 0

	if(electrified != 0)
		if(shock(user, 100))
			return

	usr.set_machine(src)

	var/dat = "<HEAD><TITLE>Suit Cycler Interface</TITLE></HEAD>"

	if(active)
		dat+= "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently in use. Please wait...</b></font>"

	else if(locked)
		dat += "<br><font color='red'><B>The [model_text ? "[model_text] " : ""]suit cycler is currently locked. Please contact your system administrator.</b></font>"
		if(allowed(usr))
			dat += "<br><a href='?src=\ref[src];toggle_lock=1'>\[unlock unit\]</a>"
	else
		dat += "<h1>Suit cycler</h1>"
		dat += "<B>Welcome to the [model_text ? "[model_text] " : ""]suit cycler control panel. <a href='?src=\ref[src];toggle_lock=1'>\[lock unit\]</a></B><HR>"

		dat += "<h2>Maintenance</h2>"
		dat += "<b>Helmet: </b> [helmet ? "\the [helmet]" : "no helmet stored" ]. <A href='?src=\ref[src];eject_helmet=1'>\[eject\]</a><br/>"
		dat += "<b>Suit: </b> [suit ? "\the [suit]" : "no suit stored" ]. <A href='?src=\ref[src];eject_suit=1'>\[eject\]</a>"

		if(can_repair && suit && istype(suit))
			dat += "[(suit.damage ? " <A href='?src=\ref[src];repair_suit=1'>\[repair\]</a>" : "")]"

		dat += "<br/><b>UV decontamination systems:</b> <font color = '[emagged ? "red'>SYSTEM ERROR" : "green'>READY"]</font><br>"
		dat += "Output level: [radiation_level]<br>"
		dat += "<A href='?src=\ref[src];select_rad_level=1'>\[select power level\]</a> <A href='?src=\ref[src];begin_decontamination=1'>\[begin decontamination cycle\]</a><br><hr>"

		dat += "<h2>Customisation</h2>"
		dat += "<b>Target product:</b> <A href='?src=\ref[src];select_department=1'>[target_department]</a>, <A href='?src=\ref[src];select_species=1'>[target_species]</a>."
		dat += "<A href='?src=\ref[src];apply_paintjob=1'><br>\[apply customisation routine\]</a><br><hr>"

	if(panel_open)
		wires.Interact(user)

	user << browse(dat, "window=suit_cycler")
	onclose(user, "suit_cycler")
	return

/obj/machinery/suit_cycler/Topic(href, href_list)
	if(href_list["eject_suit"])
		if(!suit) return
		suit.loc = get_turf(src)
		suit = null
	else if(href_list["eject_helmet"])
		if(!helmet) return
		helmet.loc = get_turf(src)
		helmet = null
	else if(href_list["select_department"])
		var/choice = input("Please select the target department paintjob.","Suit cycler",null) as null|anything in departments
		if(choice) target_department = choice
	else if(href_list["select_species"])
		var/choice = input("Please select the target species configuration.","Suit cycler",null) as null|anything in species
		if(choice) target_species = choice
	else if(href_list["select_rad_level"])
		var/choices = list(1,2,3)
		if(emagged)
			choices = list(1,2,3,4,5)
		radiation_level = input("Please select the desired radiation level.","Suit cycler",null) as null|anything in choices
	else if(href_list["repair_suit"])

		if(!suit || !can_repair) return
		active = 1
		spawn(100)
			repair_suit()
			finished_job()

	else if(href_list["apply_paintjob"])

		if(!suit && !helmet) return
		active = 1
		spawn(100)
			apply_paintjob()
			finished_job()

	else if(href_list["toggle_safties"])
		safeties = !safeties

	else if(href_list["toggle_lock"])

		if(allowed(usr))
			locked = !locked
			to_chat(usr, "You [locked ? "" : "un"]lock \the [src].")
		else
			to_chat(usr, "<span class='danger'>Access denied.</span>")

	else if(href_list["begin_decontamination"])

		if(safeties && occupant)
			to_chat(usr, "<span class='danger'>The cycler has detected an occupant. Please remove the occupant before commencing the decontamination cycle.</span>")
			return

		active = 1
		irradiating = 10
		updateUsrDialog()

		sleep(10)

		if(helmet)
			if(radiation_level > 2)
				helmet.decontaminate()
			if(radiation_level > 1)
				helmet.clean_blood()

		if(suit)
			if(radiation_level > 2)
				suit.decontaminate()
			if(radiation_level > 1)
				suit.clean_blood()

	updateUsrDialog()
	return

/obj/machinery/suit_cycler/process(delta_time)

	if(electrified > 0)
		electrified--

	if(!active)
		return

	if(active && machine_stat & (BROKEN|NOPOWER))
		active = 0
		irradiating = 0
		electrified = 0
		return

	if(irradiating == 1)
		finished_job()
		irradiating = 0
		return

	irradiating--

	if(occupant)
		if(prob(radiation_level*2)) occupant.emote("scream")
		if(radiation_level > 2)
			occupant.take_organ_damage(0,radiation_level*2 + rand(1,3))
		if(radiation_level > 1)
			occupant.take_organ_damage(0,radiation_level + rand(1,3))
		occupant.apply_effect(radiation_level*10, IRRADIATE)

/obj/machinery/suit_cycler/proc/finished_job()
	var/turf/T = get_turf(src)
	T.visible_message("[icon2html(thing = src, target = world)]<span class='notice'>The [src] pings loudly.</span>")
	icon_state = initial(icon_state)
	active = 0
	playsound(src, 'sound/machines/boobeebeep.ogg', 50)
	updateUsrDialog()

/obj/machinery/suit_cycler/proc/repair_suit()
	if(!suit || !suit.damage || !suit.can_breach)
		return

	suit.breaches = list()
	suit.calc_breach_damage()

	return

/obj/machinery/suit_cycler/verb/leave()
	set name = "Eject Cycler"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return

	eject_occupant(usr)

/obj/machinery/suit_cycler/proc/eject_occupant(mob/user as mob)

	if(locked || active)
		to_chat(user, "<span class='warning'>The cycler is locked.</span>")
		return

	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.update_perspective()
	occupant = null

	add_fingerprint(usr)
	updateUsrDialog()
	update_icon()

	return

//There HAS to be a less bloated way to do this. TODO: some kind of table/icon name coding? ~Z
/obj/machinery/suit_cycler/proc/apply_paintjob()
	var/obj/item/clothing/head/helmet/parent_helmet
	var/obj/item/clothing/suit/space/parent_suit
	if(!target_species || !target_department)
		return

	if(target_species)
		if(helmet) helmet.refit_for_species(target_species)
		if(suit) suit.refit_for_species(target_species)

	switch(target_department)
		if("No Change")
			parent_helmet = helmet
			parent_suit = suit
		//Engi styles
		if("Engineering")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering
			parent_suit = /obj/item/clothing/suit/space/void/engineering
		if("HAZMAT")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/hazmat
			parent_suit = /obj/item/clothing/suit/space/void/engineering/hazmat
		if("Construction")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/construction
			parent_suit = /obj/item/clothing/suit/space/void/engineering/construction
		if("Reinforced")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt
			parent_suit = /obj/item/clothing/suit/space/void/engineering/alt
		if("Salvager")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage
			parent_suit = /obj/item/clothing/suit/space/void/engineering/salvage
		if("Atmospherics")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/atmos
			parent_suit = /obj/item/clothing/suit/space/void/atmos
		if("Heavy Duty Atmospherics")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt
			parent_suit = /obj/item/clothing/suit/space/void/atmos/alt
		//Mining styles
		if("Mining")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/mining
			parent_suit = /obj/item/clothing/suit/space/void/mining
		if("Frontier Miner")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/mining/alt
			parent_suit = /obj/item/clothing/suit/space/void/mining/alt
		//Med styles
		if("Medical")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical
			parent_suit = /obj/item/clothing/suit/space/void/medical
		if("Biohazard")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/bio
			parent_suit = /obj/item/clothing/suit/space/void/medical/bio
		if("Emergency Medical Response")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/emt
			parent_suit = /obj/item/clothing/suit/space/void/medical/emt
		if("Vey-Medical Streamlined")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/medical/alt
			parent_suit = /obj/item/clothing/suit/space/void/medical/alt
		//Sec styles
		if("Security")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security
			parent_suit = /obj/item/clothing/suit/space/void/security
		if("Crowd Control")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security/riot
			parent_suit = /obj/item/clothing/suit/space/void/security/riot
		if("Security EVA")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/security/alt
			parent_suit = /obj/item/clothing/suit/space/void/security/alt
		//Exploration styles
		if("Exploration")//now with Teshari-Sprite from royalderg#0651
			parent_helmet = /obj/item/clothing/head/helmet/space/void/exploration
			parent_suit = /obj/item/clothing/suit/space/void/exploration
		if("Old Exploration")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/exploration/alt
			parent_suit = /obj/item/clothing/suit/space/void/exploration/alt
		if("Pathfinder")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/exploration/pathfinder
			parent_suit = /obj/item/clothing/suit/space/void/exploration/pathfinder
		if("Pilot")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/pilot
			parent_suit = /obj/item/clothing/suit/space/void/pilot
		if("Pilot Blue")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/pilot/alt
			parent_suit = /obj/item/clothing/suit/space/void/pilot/alt
		//Special styles
		if("^%###^%$", "Mercenary")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/merc
			parent_suit = /obj/item/clothing/suit/space/void/merc
		if("Charring")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/merc/fire
			parent_suit = /obj/item/clothing/suit/space/void/merc/fire
		if("Gem-Encrusted", "Wizard")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/wizard
			parent_suit = /obj/item/clothing/suit/space/void/wizard
		if("Director")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/captain
			parent_suit = /obj/item/clothing/suit/space/void/captain
		if("Head of Security")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/headofsecurity
			parent_suit = /obj/item/clothing/suit/space/void/headofsecurity
		if("Manager")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/captain
			parent_suit = /obj/item/clothing/suit/space/void/captain
		if("Prototype")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/headofsecurity
			parent_suit = /obj/item/clothing/suit/space/void/headofsecurity
		if("Talon Crew")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/talon
		if("Talon Engineering")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/engineering/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/engineering/talon
		if("Talon Medical (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical/talon
		if("Talon Medical (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/medical/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/medical/talon
		if("Talon Marine")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/marine/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/marine/talon
		if("Talon Officer")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/officer/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/officer/talon
		if("Talon Pilot (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot/talon
		if("Talon Pilot (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/pilot/talon
		if("Talon Research (Bubble Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research/alt/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research/talon
		if("Talon Research (Closed Helm)")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/research/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/research/talon
		if("Talon Mercenary")
			parent_helmet = /obj/item/clothing/head/helmet/space/void/refurb/mercenary/talon
			parent_suit = /obj/item/clothing/suit/space/void/refurb/mercenary/talon
	if(target_species)
		//Only run these checks if they have a sprite sheet defined, otherwise they use human's anyways, and there is almost definitely a sprite.
		if((helmet!=null&&(target_species in helmet.sprite_sheets_obj))||(suit!=null&&(target_species in suit.sprite_sheets_obj)))
			//Making sure all of our items have the sprites to be refitted.
			var/helmet_check = ((helmet!=null && (initial(parent_helmet.icon_state) in icon_states(helmet.sprite_sheets_obj[target_species],1))) || helmet==null)
			//If the helmet exists, only return true if there's also sprites for it. If the helmet doesn't exist, return true.
			var/suit_check = ((suit!=null && (initial(parent_suit.icon_state) in icon_states(suit.sprite_sheets_obj[target_species],1))) || suit==null)
			var/suit_helmet_check = ((suit!=null && suit.helmet!=null && (initial(parent_helmet.icon_state) in icon_states(suit.helmet.sprite_sheets_obj[target_species],1))) || suit==null || suit.helmet==null)
			if(helmet_check && suit_check && suit_helmet_check)
				if(helmet)
					helmet.refit_for_species(target_species)
				if(suit)
					suit.refit_for_species(target_species)
					if(suit.helmet)
						suit.helmet.refit_for_species(target_species)
			else
				//If they don't, alert the user and stop here.
				var/turf/T = get_turf(src)
				T.visible_message("\icon(src)<span class='warning'>Unable to apply specified cosmetics with specified species. Please try again with a different species or cosmetic option selected.</span>")
				return
		else
			if(helmet)
				helmet.refit_for_species(target_species)
			if(suit)
				suit.refit_for_species(target_species)
				if(suit.helmet)
					suit.helmet.refit_for_species(target_species)
	if(helmet && target_department != "No Change")
		var/obj/item/clothing/H = new parent_helmet
		helmet.name = "refitted [initial(helmet.name)]"
		helmet.icon_state = initial(parent_helmet.icon_state)
		helmet.item_state = initial(parent_helmet.item_state)
		helmet.light_overlay = initial(parent_helmet.light_overlay)
		helmet.item_state_slots = H.item_state_slots
		qdel(H)

	if(suit && target_department != "No Change")
		var/obj/item/clothing/S = new parent_suit
		suit.name = "refitted [initial(suit.name)]"
		suit.icon_state = initial(parent_suit.icon_state)
		suit.item_state = initial(parent_suit.item_state)
		suit.item_state_slots = S.item_state_slots
		qdel(S)

		if(suit.helmet && target_department != "No Change")
			var/obj/item/clothing/AH = new parent_helmet
			suit.helmet.name = "refitted [initial(parent_helmet.name)]"
			suit.helmet.desc = initial(parent_helmet.desc)
			suit.helmet.icon_state = initial(parent_helmet.icon_state)
			suit.helmet.item_state = initial(parent_helmet.item_state)
			suit.helmet.light_overlay = initial(parent_helmet.light_overlay)
			suit.helmet.item_state_slots = AH.item_state_slots
			qdel(AH)

//TALON
/obj/machinery/suit_cycler/vintage/tcrew
	name = "Talon crew suit cycler"
	model_text = "Talon crew"
	req_access = list(access_talon)
	departments = list("Talon Crew","No Change")

/obj/machinery/suit_cycler/vintage/tpilot
	name = "Talon pilot suit cycler"
	model_text = "Talon pilot"
	req_access = list(access_talon)
	departments = list("Talon Pilot (Bubble Helm)","Talon Pilot (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/tengi
	name = "Talon engineer suit cycler"
	model_text = "Talon engineer"
	req_access = list(access_talon)
	departments = list("Talon Engineering","No Change")

/obj/machinery/suit_cycler/vintage/tguard
	name = "Talon guard suit cycler"
	model_text = "Talon guard"
	req_access = list(access_talon)
	departments = list("Talon Marine","Talon Mercenary","No Change")

/obj/machinery/suit_cycler/vintage/tmedic
	name = "Talon doctor suit cycler"
	model_text = "Talon doctor"
	req_access = list(access_talon)
	departments = list("Talon Medical (Bubble Helm)","Talon Medical (Closed Helm)","No Change")

/obj/machinery/suit_cycler/vintage/tcaptain
	name = "Talon captain suit cycler"
	model_text = "Talon captain"
	req_access = list(access_talon)
	departments = list("Talon Officer","No Change")
