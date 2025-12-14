/*
Research and Development (R&D) Console

This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.

Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second method is with Technology Disks and Design Disks. Each of these disks can hold a single technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This method is a lot more secure (since it
won't update every console in existence) but it's more of a hassle to do. Also, the disks can be stolen.
*/

/obj/machinery/computer/rdconsole
	name = "R&D control console"
	desc = "Science, in a computer! Experiment results not guaranteed."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.
	var/obj/item/disk/tech_disk/t_disk = null	//Stores the technology disk.
	var/obj/item/disk/design_disk/d_disk = null	//Stores the design disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/lathe/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/lathe/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/id = 0			//ID of the computer (for server restrictions).
	var/sync = 1		//If sync = 0, it doesn't show up on Server Control Console

	req_access = list(ACCESS_SCIENCE_MAIN)	//Data and setting manipulation requires scientist access.

	var/datum/design_holder/lathe_designs = /datum/design_holder/lathe/autolathe
	var/datum/design_holder/circuit_designs = /datum/design_holder

/obj/machinery/computer/rdconsole/proc/CallMaterialName(var/ID)
	var/return_name = ID
	switch(return_name)
		if("metal")
			return_name = "Metal"
		if("glass")
			return_name = "Glass"
		if("gold")
			return_name = "Gold"
		if("silver")
			return_name = "Silver"
		if("phoron")
			return_name = "Solid Phoron"
		if("uranium")
			return_name = "Uranium"
		if("diamond")
			return_name = "Diamond"
	return return_name

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/ID)
	var/datum/reagent/R = SSchemistry.reagent_lookup["[ID]"]
	if(!R)
		return ID
	return R.name

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/destructive_analyzer/D in range(5, src)) //Originally 3, buffed to 5 - Werewolf
		if(D.linked_console != null || D.panel_open)
			continue
		if(linked_destroy == null)
			linked_destroy = D
			D.linked_console = src

	for(var/obj/machinery/lathe/r_n_d/D in range(5, src))
		if(D.linked_console != null || D.panel_open)
			continue
		else if(istype(D, /obj/machinery/lathe/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				linked_lathe.design_holder = lathe_designs
				D.linked_console = src
		else if(istype(D, /obj/machinery/lathe/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				linked_imprinter.design_holder = circuit_designs
				D.linked_console = src

/obj/machinery/computer/rdconsole/Initialize(mapload)
	. = ..()
	if(ispath(lathe_designs))
		lathe_designs = new lathe_designs(src)
		lathe_designs.design_ids = list()
	if(ispath(circuit_designs))
		circuit_designs = new circuit_designs(src)
		circuit_designs.design_ids = list()
	files = new /datum/research(src) //Setup the research data holder.
	spawn(0)
		UpdateKnownDesigns()
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in GLOB.machines)
			S.update_connections()
			break
	SyncRDevices()

/obj/machinery/computer/rdconsole/proc/UpdateKnownDesigns()
	var/list/known_designs = files.legacy_all_design_datums()
	for(var/datum/prototype/design/D in known_designs)
		if(D.lathe_type & LATHE_TYPE_CIRCUIT)
			circuit_designs.design_ids |= D.id
		else if(D.lathe_type & LATHE_TYPE_PROTOLATHE)
			lathe_designs.design_ids |= D.id
	if(linked_lathe)
		linked_lathe.ui_controller?.ui_design_update()
	if(linked_imprinter)
		linked_imprinter.ui_controller?.ui_design_update()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/D as obj, var/mob/user as mob)
	//Loading a disk into it.
	if(istype(D, /obj/item/disk))
		if(t_disk || d_disk)
			to_chat(user, "A disk is already loaded into the machine.")
			return

		if(istype(D, /obj/item/disk/tech_disk))
			t_disk = D
		else if (istype(D, /obj/item/disk/design_disk))
			d_disk = D
		else
			to_chat(user, "<span class='notice'>Machine cannot accept disks in that format.</span>")
			return
		if(!user.attempt_insert_item_for_installation(D, src))
			return
		to_chat(user, "<span class='notice'>You add \the [D] to the machine.</span>")
		SStgui.update_uis(src)
	else
		//The construction/deconstruction of the console code.
		return ..()

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src, /datum/soundbyte/sparks, 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

/obj/machinery/computer/rdconsole/proc/GetResearchLevelsInfo()
	var/list/dat = list()
	dat += "<UL>"
	for(var/datum/tech/T in files.known_tech)
		if(T.level < 1)
			continue
		dat += "<LI>"
		dat += "[T.name]"
		dat += "<UL>"
		dat +=  "<LI>Level: [T.level]"
		dat +=  "<LI>Summary: [T.desc]"
		dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/proc/GetResearchListInfo()
	var/list/dat = list()
	dat += "<UL>"
	for(var/datum/prototype/design/D in files.legacy_all_design_datums())
		if(D.build_path)
			dat += "<LI><B>[D.name]</B>: [D.desc]"
	dat += "</UL>"
	return dat.Join()

/obj/machinery/computer/rdconsole/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(machine_stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	id = 2
	req_access = list(ACCESS_SCIENCE_ROBOTICS)

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1
